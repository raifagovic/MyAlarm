//
//  AlarmViewEditor.swift
//  MyAlarm
//
//  Created by Raif Agovic on 28. 11. 2024..
//

import SwiftUI

struct AlarmEditorView: View {
    @Binding var isPresented: Bool
    @State private var selectedTime = Date()
    @State private var selectedDays: [String] = []
    @State private var labelText: String = ""
    @State private var isNavigating = false
    @State private var showRepeatView = false
    
    var selectedAlarm: Alarm // Receive the alarm to edit
    // Callback to handle deletion
    var onDelete: (() -> Void)?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#2C2C2E")
                    .edgesIgnoringSafeArea(.all) // Extend background color to cover entire view
                
                VStack {
                    // DatePicker with aligned width
                    VStack {
                        DatePicker("Select Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .frame(maxWidth: .infinity) // Ensures alignment with other elements
                            .background(Color.clear) // No added layers, purely default
                            .environment(\.colorScheme, .dark) // Enforces dark mode styling
                            .padding(.horizontal, -16)
                           
                        Text(remainingTimeMessage())
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.top, 3)
                            .frame(maxWidth: .infinity)
                    }
                    
                    // Standard alarm settings area
                    Form {
                        Section {
                            // Repeat row
                            NavigationLink(destination: RepeatView(selectedDays: $selectedDays)) {
                                HStack {
                                    Text("Repeat")
                                        .foregroundColor(Color.primary)
                                    Spacer()
                                    Text(getAbbreviatedDays())
                                        .foregroundColor(Color.secondary)
                                        .lineLimit(1)
                                        .font(.system(size: selectedDays.count >= 6 ? 16.5 : UIFont.preferredFont(forTextStyle: .body).pointSize))
                                }
                            }

                            // Label row
                            HStack {
                                Text("Label")
                                    .foregroundColor(Color.primary)
                                Spacer()
                                HStack {
                                    TextField("Alarm", text: $labelText)
                                        .foregroundColor(Color.secondary)
                                        .multilineTextAlignment(.trailing)
                                    
                                    if !labelText.isEmpty {
                                        Button(action: {
                                            labelText = ""
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(Color.secondary)
                                        }
                                    }
                                }
                            }
                            
                            // Sound row
                            HStack {
                                Text("Sound")
                                    .foregroundColor(Color(hex: "#E5E5E7"))
                                Spacer()
                                Text("Radar")
                                    .foregroundColor(Color(hex: "#8E8E93"))
                            }
                            
                            // Snooze toggle
                            Toggle(isOn: .constant(true)) {
                                Text("Snooze")
                                    .foregroundColor(Color(hex: "#E5E5E7"))
                            }
                        }
                        .listRowBackground(Color.clear)
                        
                        // Delete Alarm Button
                        Section {
                            Button(action: {
                                onDelete?() // Call onDelete if it's set
                                isPresented = false // Dismiss the editor after deletion
                            }) {
                                Text("Delete Alarm")
                                    .fontWeight(.bold)
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity, alignment: .center) // Center-align the text
                            }
                        }
                        .listRowBackground(Color(hex: "#39393D"))
                    }
                    .scrollContentBackground(.hidden)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 10)
                    .background(Color.clear)
                    .environment(\.colorScheme, .dark)
                }
                .navigationBarItems(
                    leading: Button("Cancel") {
                        isPresented = false
                    },
                    trailing: Button("Save") {
                        isPresented = false
                        // Add save functionality here
                    }
                )
                .navigationBarTitle("Edit Alarm", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Edit Alarm")
                            .font(.headline)
                            .foregroundColor(Color(hex: "#F1F1F1")) // Change color here
                    }
                }
            }
        }
    }
    
    //    Calculate the remaining time and return a formatted string
    private func remainingTimeMessage() -> String {
        let calendar = Calendar.current
        
        // Get the current time in Sarajevo
        let now = Date()
        let currentTimeInSarajevo = now
        
        // Calculate the difference
        let selectedComponents = calendar.dateComponents([.hour, .minute], from: selectedTime)
        
        // Create a new Date with today's date and selected time
        var combinedComponents = DateComponents()
        combinedComponents.year = calendar.component(.year, from: now)
        combinedComponents.month = calendar.component(.month, from: now)
        combinedComponents.day = calendar.component(.day, from: now)
        combinedComponents.hour = selectedComponents.hour
        combinedComponents.minute = selectedComponents.minute
        
        let selectedDate = calendar.date(from: combinedComponents)!
        
        let differenceInSeconds = selectedDate.timeIntervalSince(currentTimeInSarajevo)
        let hours = Int(differenceInSeconds) / 3600
        let minutes = (Int(differenceInSeconds) % 3600) / 60
        
        if differenceInSeconds < 0 {
            // If the selected time has already passed, show time for the next day
            let nextDayDate = calendar.date(byAdding: .day, value: 1, to: selectedDate)!
            let nextDayDifference = nextDayDate.timeIntervalSince(currentTimeInSarajevo)
            let nextDayHours = Int(nextDayDifference) / 3600
            let nextDayMinutes = (Int(nextDayDifference) % 3600) / 60
            return "In \(nextDayHours) h \(nextDayMinutes) min"
        }
        
        return "In \(hours) h \(minutes) min"
    }
    
    private func getAbbreviatedDays() -> String {
        let dayAbbreviations: [String: String] = [
            
            "Every Monday": "Mon",
            "Every Tuesday": "Tue",
            "Every Wednesday": "Wed",
            "Every Thursday": "Thu",
            "Every Friday": "Fri",
            "Every Saturday": "Sat",
            "Every Sunday": "Sun",
        ]
        
        let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        let sortedDays = selectedDays
            .compactMap { dayAbbreviations[$0] }
            .sorted { daysOfWeek.firstIndex(of: $0)! < daysOfWeek.firstIndex(of: $1)! }
        
        // If no days are selected, return "Never"
        if sortedDays.isEmpty {
            return "Never"
        }
        
        // If all days are selected, return "Every"
        if sortedDays.count == daysOfWeek.count {
            return "Every day"
        }
        
        // If only one day is selected, return the abbreviation for that day
        if sortedDays.count == 1 {
            return sortedDays.first!
        }
        
        if sortedDays == ["Mon", "Tue", "Wed", "Thu", "Fri"] {
            return "Weekdays"
        }
        
        // Check if weekends are selected
        if sortedDays == ["Sat", "Sun"] {
            return "Weekends"
        }
        
        // For multiple selected days, format as "Mon, Tue and Wed"
        let allButLast = sortedDays.dropLast()
        let lastDay = sortedDays.last!
        return "\(allButLast.joined(separator: ", ")) and \(lastDay)"
    }
}

