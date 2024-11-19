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
    @State private var showEditor = false

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
                        .bold()
                    Text("Label")
                    HStack {
                        ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                            Text(day)
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                }
                Spacer()
                Toggle(isOn: $isAlarmOn) {
                }
                .labelsHidden()
            }
            .padding()
            .background(Color(.systemGray5))
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
                showEditor = true  // Show the alarm editor when tapped
            }
            .sheet(isPresented: $showEditor) {
                AlarmEditorView(isPresented: $showEditor)
            }
        }
    }
}

struct ContentView: View {
    @State private var alarms = [Alarm(time: "00:50")]
    
    var body: some View {
        ZStack {
            // Display all alarms with "Rings in ..." message at the top
            VStack(alignment: .leading) {
                Text("Rings in ...")
                    .font(.headline)
                    .padding(.top)
                    .padding(.leading)
                
                ForEach(alarms) { alarm in
                    AlarmView(alarms: $alarms, alarm: alarm)
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
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    .padding()
                }
            }
        }
    }
}

struct RepeatView: View {
    @Binding var selectedDays: [String]
    let weekdays = ["Every Monday", "Every Tuesday", "Every Wednesday", "Every Thursday", "Every Friday", "Every Saturday", "Every Sunday"]
    
    var body: some View {
        List {
            ForEach(weekdays, id: \.self) { day in
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
}

struct AlarmEditorView: View {
    @Binding var isPresented: Bool
    @State private var selectedTime = Date()
    @State private var selectedDays: [String] = []
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker("Select Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                
                Text("Rings in ...")
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
                                    .font(.system(size: 16.5))
                                    .padding(.leading, -4)
                            }
                        }
                        
                        // Label row
                        HStack {
                            Text("Label")
                            Spacer()
                            Text("Alarm")
                                .foregroundColor(.gray)
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
                
                Spacer()
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
        
        // Check if weekends are selected
        if sortedDays.contains("Sat") && sortedDays.contains("Sun") && sortedDays.count == 2 {
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
