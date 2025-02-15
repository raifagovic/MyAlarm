//
//  AlarmViewEditor.swift
//  MyAlarm
//
//  Created by Raif Agovic on 28. 11. 2024..
//

import SwiftUI

struct AlarmEditorView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var time: Date
    @State private var repeatDays: [String]
    @State private var label: String
    @State private var snoozeDuration: Int
    
    @FocusState private var isLabelFocused: Bool
    
    var alarm: Alarm
    
    init(alarm: Alarm) {
        self.alarm = alarm
        _time = State(initialValue: alarm.time)
        _repeatDays = State(initialValue: alarm.repeatDays)
        _label = State(initialValue: alarm.label)
        _snoozeDuration = State(initialValue: alarm.snoozeDuration)
    }
    
    var body: some View {
        NavigationStack {
            Form{
                // Time Picker
                Section{
                    CustomDatePicker(selectedDate: $time)
                        .frame(height: 200)
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                
                // Other Settings
                Section {
                    // Repeat row
                    NavigationLink(destination: RepeatView(repeatDays: $repeatDays)) {
                        HStack {
                            Text("Repeat")
                                .foregroundColor(Color(hex: "#F1F1F1"))
                            Spacer()
                            Text(getAbbreviatedDays(from: repeatDays))
                                .foregroundColor(Color(hex: "#A1A1A6"))
                                .lineLimit(1)
                                .font(.system(size: repeatDays.count >= 6 ? 16.5 : UIFont.preferredFont(forTextStyle: .body).pointSize))
                        }
                    }
                    // Label row
                    HStack {
                        Text("Label")
                            .foregroundColor(Color(hex: "#F1F1F1"))
                        Spacer()
                        HStack {
                            TextField("Alarm", text: $label)
                                .foregroundColor(Color(hex: "#A1A1A6"))
                                .multilineTextAlignment(.trailing)
                                .focused($isLabelFocused)
                            
                            if isLabelFocused && !label.isEmpty {
                                Button(action: {
                                    label = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(Color(uiColor: .placeholderText))
                                }
                            }
                        }
                    }
                    // Sound row
                    HStack {
                        Text("Sound")
                            .foregroundColor(Color(hex: "#F1F1F1"))
                        Spacer()
                        Text("Radar")
                            .foregroundColor(Color(hex: "#A1A1A6"))
                    }
                    // Snooze row
                    NavigationLink(destination: SnoozeView(snoozeDuration: $snoozeDuration)) {
                        HStack {
                            Text("Snooze")
                                .foregroundColor(Color(hex: "#F1F1F1"))
                            Spacer()
                            Text(snoozeDuration == 0 ? "Off" : "\(snoozeDuration) min")
                                .foregroundColor(Color(hex: "#A1A1A6"))
                        }
                    }
                }
                // Delete Button
                Section {
                    Button("Delete Alarm", role: .destructive) {
                        deleteAlarm()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .environment(\.colorScheme, .dark)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Edit Alarm")
                        .foregroundColor(Color(hex: "#F1F1F1"))
                        .font(.headline)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveAlarm()
                    }
                    .bold()
                }
            }
            .onAppear {
                createTransparentAppearance()
            }
        }
        .tint(Color(hex: "#FFD700"))

    }
    private func saveAlarm() {
        alarm.time = time
        alarm.repeatDays = repeatDays
        alarm.label = label
        alarm.snoozeDuration = snoozeDuration
        try? modelContext.save()
        dismiss()
    }
    private func deleteAlarm() {
        modelContext.delete(alarm)
        try? modelContext.save()
        dismiss()
    }
}

