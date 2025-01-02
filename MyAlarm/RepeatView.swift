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
        Form {
            Section {
                ForEach(orderedWeekdays(), id: \.self) { day in
                    HStack {
                        Text(day)
                            .foregroundColor(Color(hex: "#F1F1F1"))
                        Spacer()
                        if selectedDays.contains(day) {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color(hex: "#FFD700"))
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if let index = selectedDays.firstIndex(of: day) {
                            selectedDays.remove(at: index)
                        } else {
                            selectedDays.append(day)
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .listRowBackground(Color(hex: "#2C2C2E"))
        .environment(\.colorScheme, .dark)
        .background(Color(hex: "#1C1C1E"))
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Repeat")
                    .foregroundColor(Color(hex: "#F1F1F1"))
                    .font(.headline)
            }
        }
        .toolbarBackground(Color.clear, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
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
