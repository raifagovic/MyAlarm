//
//  ContentView.swift
//  MyAlarm
//
//  Created by Raif Agovic on 20. 10. 2024..
//

import SwiftUI

struct Alarm: Identifiable, Hashable {
    let id = UUID()
    var time: String
}

struct AlarmView: View {
    @Binding var alarms: [Alarm]
    var alarm: Alarm
    @State private var isAlarmOn = false
    @State private var showDelete = false
    
    var onEdit: () -> Void // Callback to trigger editing
    
    var body: some View {
        ZStack {
            // Background showing delete button when swiped
            if showDelete {
                HStack {
                    Spacer()
                    Button(action: {
                        // Action to delete the alarm
                        if let index = alarms.firstIndex(of: alarm) {
                            alarms.remove(at: index)
                        }
                    }) {
                        Text("Delete")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                    .padding(.trailing)
                }
            }
            
            // Main alarm view
            HStack {
                VStack(alignment: .leading) {
                    Text(alarm.time)
                        .font(.largeTitle)
                        .foregroundColor(Color(hex: "#E8E8E8"))
                        .bold()
                    Text("Label")
                        .foregroundColor(.gray)
                    HStack {
                        ForEach(orderedDayLetters(), id: \.self) { letter in
                            Text(letter)
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                }
                Spacer()
                Toggle(isOn: $isAlarmOn) {
                }
                .labelsHidden()
                .tint(Color(hex: "#FFD700"))
            }
            .padding()
            .background(Color(hex: "#2C2C2E"))
            .cornerRadius(10)
            .offset(x: showDelete ? -150 : 0) // Add an offset when swiped
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width < -100 { // Swipe left to show delete
                            withAnimation {
                                showDelete = true
                            }
                        } else if value.translation.width > 100 { // Swipe right to hide delete
                            withAnimation {
                                showDelete = false
                            }
                        }
                    }
            )
            .frame(maxWidth: .infinity, maxHeight: 100)
            .padding()
            .onTapGesture {
                onEdit() // Notify parent view (ContentView) to start editing
            }
        }
    }
    
    // Function to get ordered first letters of days
    private func orderedDayLetters() -> [String] {
        let dayAbbreviations = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        let calendar = Calendar.current
        let firstWeekdayIndex = calendar.firstWeekday - 1 // `firstWeekday` is 1-based
        let orderedDays = Array(dayAbbreviations[firstWeekdayIndex...]) + Array(dayAbbreviations[..<firstWeekdayIndex])
        return orderedDays.map { String($0.prefix(1)) }
    }
}

struct ContentView: View {
    @State private var alarms = [Alarm(time: "00:50")]
    @State private var isEditing = false
    @State private var selectedAlarm: Alarm?
    
    var body: some View {
        ZStack {
            Color(hex: "#1C1C1E")
                .edgesIgnoringSafeArea(.all) // Extend to edges
            
            // Display all alarms with "Rings in ..." message at the top
            VStack(alignment: .leading) {
                Text("Rings in ...")
                    .font(.headline)
                    .foregroundColor(Color(hex: "#FFD700"))
                    .padding(.top)
                    .padding(.leading)
                
                ForEach(alarms) { alarm in
                    AlarmView(
                        alarms: $alarms,
                        alarm: alarm,
                        onEdit: {
                            selectedAlarm = alarm
                            isEditing = true
                        }
                    )
                }
                Spacer()
            }
            
            // Plus button at the bottom-right corner
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        alarms.append(Alarm(time: "00:50")) // Add a new unique identifier
                    }) {
                        Image(systemName: "plus")
                            .padding()
                            .background(Color(hex: "#FFD700"))
                            .foregroundColor(Color(hex: "#1C1C1E"))
                            .clipShape(Rectangle())
                            .cornerRadius(15)
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            if let alarmToEdit = selectedAlarm {
                AlarmEditorView(
                    isPresented: $isEditing,
                    selectedAlarm: alarmToEdit, // Pass the selected alarm
                    onDelete: {
                        if let index = alarms.firstIndex(where: { $0.id == alarmToEdit.id }) {
                            alarms.remove(at: index)
                        }
                        selectedAlarm = nil // Clear the selected alarm
                    }
                )
            }
        }
    }
}

struct RepeatView: View {
    @Binding var selectedDays: [String]

    var body: some View {
        List {
            ForEach(orderedWeekdays(), id: \.self) { day in
                HStack {
                    Text(day)
                    Spacer()
                    if selectedDays.contains(day) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle()) // Make the whole row tappable
                .onTapGesture {
                    if let index = selectedDays.firstIndex(of: day) {
                        selectedDays.remove(at: index) // Deselect if already selected
                    } else {
                        selectedDays.append(day) // Select if not already selected
                    }
                }
            }
        }
        .navigationTitle("Repeat")
    }
    
    // Function to order weekdays based on locale
    private func orderedWeekdays() -> [String] {
        // Mapping weekdays to their full names
        let fullWeekdayNames = [
            "Every Sunday",
            "Every Monday",
            "Every Tuesday",
            "Every Wednesday",
            "Every Thursday",
            "Every Friday",
            "Every Saturday"
        ]
        
        // Get the first weekday index from the current calendar
        let calendar = Calendar.current
        let firstWeekdayIndex = calendar.firstWeekday - 1 // 1-based index, so subtract 1
        
        // Reorder the weekdays to start from the localized first day
        let orderedWeekdays = Array(fullWeekdayNames[firstWeekdayIndex...]) + Array(fullWeekdayNames[..<firstWeekdayIndex])
        return orderedWeekdays
    }
}

struct AlarmEditorView: View {
    @Binding var isPresented: Bool
    @State private var selectedTime = Date()
    @State private var selectedDays: [String] = []
    @State private var labelText: String = ""
    
    var selectedAlarm: Alarm // Receive the alarm to edit
    // Callback to handle deletion
    var onDelete: (() -> Void)?
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker("Select Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                
                Text(remainingTimeMessage())
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.top, 3)
                
                // Standard alarm settings area
                Form {
                    Section {
                        // Repeat row with NavigationLink
                        NavigationLink(destination: RepeatView(selectedDays: $selectedDays)) {
                            HStack {
                                Text("Repeat")
                                    .padding(.trailing, 0)
                                Spacer()
                                Text(getAbbreviatedDays())
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                                    .font(.system(size: selectedDays.count >= 6 ? 16.5 : UIFont.preferredFont(forTextStyle: .body).pointSize)) // Dynamic font size
                                    .padding(.leading, -4)
                            }
                        }
                        
                        // Label row with editable text
                        HStack {
                            Text("Label")
                            Spacer()
                            HStack() {
                                TextField("Alarm", text: $labelText)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.trailing)
                                
                                if !labelText.isEmpty {
                                    Button(action: {
                                        labelText = "" // Clear the text
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        
                        // Sound row
                        HStack {
                            Text("Sound")
                            Spacer()
                            Text("Radar")
                                .foregroundColor(.gray)
                        }
                        
                        // Snooze toggle
                        Toggle("Snooze", isOn: .constant(true))
                    }
                }
                .frame(height: 250)
                .padding(.top, 10)
                
                // Delete Alarm button (always visible)
                Button(action: {
                    onDelete?() // Call onDelete if it's set
                    isPresented = false // Dismiss the editor after deletion
                }) {
                    Text("Delete Alarm")
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                }
                .padding(.top, 5)
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
            return "Rings in \(nextDayHours) h \(nextDayMinutes) min"
        }
        
        return "Rings in \(hours) h \(minutes) min"
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

#Preview {
    ContentView()
}
