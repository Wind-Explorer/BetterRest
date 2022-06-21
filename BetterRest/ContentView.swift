//
//  ContentView.swift
//  BetterRest
//
//  Created by Adam Chen JingFan on 2022/6/6.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 30
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var body: some View {
        
        NavigationView {
            ZStack {
                VStack {
                    Form {
                        Section {
                            VStack(alignment: .leading, spacing: 0) {
                                Spacer()
                                
                                Text("⏰")
                                    .font(.largeTitle)
                                Text("When do you want to wake up?")
                                    .font(.headline)
                                
                                Spacer()
                                
                                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                
                                Spacer()
                            }
                        }
                        
                        Section {
                            VStack(alignment: .leading, spacing: 0) {
                                Spacer()
                                
                                Text("🛌")
                                    .font(.largeTitle)
                                Text("Desired amount of sleep")
                                    .font(.headline)
                                
                                Spacer()

                                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)

                                Spacer()
                            }
                        }
                        
                        Section {
                            VStack(alignment: .leading, spacing: 0) {
                                Spacer()
                                
                                Text("☕️")
                                    .font(.largeTitle)
                                Text("Daily coffee intake")
                                    .font(.headline)
                                
                                Spacer()
                                
                                Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 0...20)
                                
                                Spacer()
                            }
                        }
                        
                        Section {
                            VStack(alignment: .leading, spacing: 0) {
                                Spacer()
                                
                                Text("🕰")
                                    .font(.largeTitle)
                                
                                Text("Your sleep time should be")
                                    .font(.headline)
                                
                                Spacer()
                                
                                Text(sleepTime)
                                    .font(.largeTitle.bold())
                                
                                Spacer()
                                
                            }
                        }
                        
                        Section {
                            HStack(alignment: .center, spacing: 0) {
                                Spacer()
                                //Spacer()
                                VStack(alignment: .center, spacing: 10) {
                                    Spacer()
                                    Text("Designed by Adam C")
                                    Text("Written on MacBook Pro (2021)")
                                    Text("Built in Xcode Version 13.4.1")
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationTitle("💤 BetterRest")
        }
    }
    
    var sleepTime: String {
        do {
            let model = try SleepCalculator(configuration: MLModelConfiguration())
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime1 = (wakeUp - prediction.actualSleep).formatted(date: .omitted, time: .shortened)
            
            return sleepTime1
        } catch {
            alertTitle = "an error occured ;-;"
            return alertTitle
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
