//
//  RepeatView.swift
//  MyAlarm
//
//  Created by Raif Agovic on 28. 11. 2024..
//

import SwiftUI

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
                .listRowBackground(Color(hex: "#2C2C2E")) // Set row background color
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color(hex: "#1C1C1E"))
        .navigationTitle("Repeat")
        .navigationBarTitleDisplayMode(.inline)
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
