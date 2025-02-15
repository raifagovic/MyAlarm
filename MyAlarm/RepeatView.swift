//
//  RepeatView.swift
//  MyAlarm
//
//  Created by Raif Agovic on 28. 11. 2024..
//

import SwiftUI

struct RepeatView: View {
    @Binding var repeatDays: [String]
    
    var body: some View {
        Form {
            Section {
                ForEach(orderedWeekdays(), id: \.self) { day in
                    HStack {
                        Text(day)
                            .foregroundColor(Color(hex: "#F1F1F1"))
                        Spacer()
                        if repeatDays.contains(day) {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color(hex: "#FFD700"))
                                .bold()
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        toggleDaySelection(day)
                    }
                }
            }
        }
        .environment(\.colorScheme, .dark)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Repeat")
                    .foregroundColor(Color(hex: "#F1F1F1"))
                    .font(.headline)
            }
        }
        .onAppear {
            createTransparentAppearance()
        }
    }
    
    private func toggleDaySelection(_ day: String) {
        if let index = repeatDays.firstIndex(of: day) {
            repeatDays.remove(at: index)
        } else {
            repeatDays.append(day)
        }
    }
    
    // Order the weekdays based on the calendar's first weekday
    private func orderedWeekdays() -> [String] {
        let fullWeekdayNames = [
            "Every Sunday",
            "Every Monday",
            "Every Tuesday",
            "Every Wednesday",
            "Every Thursday",
            "Every Friday",
            "Every Saturday"
        ]
        let calendar = Calendar.current
        let firstWeekdayIndex = calendar.firstWeekday - 1
        let orderedWeekdays = Array(fullWeekdayNames[firstWeekdayIndex...]) + Array(fullWeekdayNames[..<firstWeekdayIndex])
        return orderedWeekdays
    }
}
