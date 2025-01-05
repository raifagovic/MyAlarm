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
        .onAppear {
            createTransparentAppearance()
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
