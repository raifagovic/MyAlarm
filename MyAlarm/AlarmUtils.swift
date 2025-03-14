//
//  AlarmUtils.swift
//  MyAlarm
//
//  Created by Raif Agovic on 11. 2. 2025..
//

import Foundation

enum AlarmUtils {
     
    static func nextAlarm(time: Date, calendar: Calendar, now: Date = Date(), repeatDays: [String]) -> Date {
        let dayMappings: [String: Int] = [
            "Every Sunday": 1, "Every Monday": 2, "Every Tuesday": 3, "Every Wednesday": 4,
            "Every Thursday": 5, "Every Friday": 6, "Every Saturday": 7
        ]
        
        let repeatDaysInt = Set(repeatDays.compactMap { dayMappings[$0] })
        let todayWeekday = calendar.component(.weekday, from: now)
        
        // Extract hour and minute from the alarm time
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        
        // Set the alarm time for today
        if let todayAlarm = calendar.date(bySettingHour: timeComponents.hour!, minute: timeComponents.minute!, second: 0, of: now),
           todayAlarm > now, repeatDaysInt.contains(todayWeekday) {
            return todayAlarm // Alarm rings later today
        }
        
        // Find the next available alarm day
        for offset in 1...7 {
            let nextDayIndex = (todayWeekday + offset - 1) % 7 + 1
            if repeatDaysInt.contains(nextDayIndex),
               let nextAlarmDate = calendar.date(byAdding: .day, value: offset, to: now) {
                return calendar.date(bySettingHour: timeComponents.hour!, minute: timeComponents.minute!, second: 0, of: nextAlarmDate)!
            }
        }
        
        return now // Fallback, should never reach here
    }
    
    static func remainingTimeMessage(for time: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        // Extract hours and minutes from the selected time
        let selectedComponents = calendar.dateComponents([.hour, .minute], from: time)
        
        // Create a new Date with today's date and selected time
        var combinedComponents = DateComponents()
        combinedComponents.year = calendar.component(.year, from: now)
        combinedComponents.month = calendar.component(.month, from: now)
        combinedComponents.day = calendar.component(.day, from: now)
        combinedComponents.hour = selectedComponents.hour
        combinedComponents.minute = selectedComponents.minute
        
        var selectedDate = calendar.date(from: combinedComponents)!
        
        var differenceInSeconds = selectedDate.timeIntervalSince(now)
        
        // If the selected time has already passed, adjust for the next day
        if differenceInSeconds < 0 {
            selectedDate = calendar.date(byAdding: .day, value: 1, to: selectedDate)!
            differenceInSeconds = selectedDate.timeIntervalSince(now)
        }
        
        var hours = Int(differenceInSeconds) / 3600
        var minutes = (Int(differenceInSeconds) % 3600) / 60
        let seconds = Int(differenceInSeconds) % 60
        
        // If less than a minute remains, show a special message
        if hours == 0 && minutes == 0 {
            return "Alarm will go off soon"
        }
        
        // Round up minutes if seconds exist
        if seconds > 0 {
            if minutes > 0 {
                minutes += 1
            } else if hours > 0 {
                // If hours exist and minutes are zero, round up to 1 minute
                minutes = 1
            }
        }
        
        if minutes == 60 {
            minutes = 0
            hours += 1
        }
        
        if hours == 0 {
            return "Alarm in \(minutes) min"
        } else if minutes == 0 {
            return "Alarm in \(hours) h"
        }
        
        return "Alarm in \(hours) h \(minutes) min"
    }
    
    static func getAbbreviatedDays(from repeatDays: [String]) -> String {
        let dayMappings: [String: (full: String, short: String)] = [
            "Every Monday": ("Monday", "Mon"),
            "Every Tuesday": ("Tuesday", "Tue"),
            "Every Wednesday": ("Wednesday", "Wed"),
            "Every Thursday": ("Thursday", "Thu"),
            "Every Friday": ("Friday", "Fri"),
            "Every Saturday": ("Saturday", "Sat"),
            "Every Sunday": ("Sunday", "Sun"),
        ]
        
        let daysOfWeekFull = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        let daysOfWeekShort = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        
        // Extract full and short names for selected days
        let selectedDays = repeatDays.compactMap { dayMappings[$0] }
        
        // If no days are selected, return "Never"
        if selectedDays.isEmpty {
            return "Never"
        }
        
        // If all days are selected, return "Every day"
        if selectedDays.count == daysOfWeekFull.count {
            return "Every day"
        }
        
        // If only one day is selected, return "Every Monday" (or the selected day)
        if selectedDays.count == 1 {
            return "Every \(selectedDays.first!.full)"
        }
        
        // Sort days based on the order in daysOfWeekFull
        let sortedDays = selectedDays
            .map { $0.short }
            .sorted { daysOfWeekShort.firstIndex(of: $0)! < daysOfWeekShort.firstIndex(of: $1)! }
        
        // If weekdays (Monday-Friday) are selected, return "Weekdays"
        if sortedDays == ["Mon", "Tue", "Wed", "Thu", "Fri"] {
            return "Weekdays"
        }
        
        // If weekends (Saturday and Sunday) are selected, return "Weekends"
        if sortedDays == ["Sat", "Sun"] {
            return "Weekends"
        }
        
        // For multiple selected days, use abbreviations: "Every Mon, Tue and Wed"
        let allButLast = sortedDays.dropLast()
        let lastDay = sortedDays.last!
        return "\(allButLast.joined(separator: ", ")) and \(lastDay)"
    }
}
