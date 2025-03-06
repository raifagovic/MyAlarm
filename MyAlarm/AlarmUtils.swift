//
//  AlarmUtils.swift
//  MyAlarm
//
//  Created by Raif Agovic on 11. 2. 2025..
//

import Foundation

enum AlarmUtils {
    
    static func weekdayName(from weekday: Int) -> String? {
        let daysOfWeekFull = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        guard (1...7).contains(weekday) else { return nil }
        return daysOfWeekFull[weekday - 1]
    }
    
    static func findNextValidDay(from date: Date, calendar: Calendar, now: Date, repeatDays: [Int]) -> Date {
        let todayIndex = calendar.component(.weekday, from: now) // 1 = Sunday, 2 = Monday, ..., 7 = Saturday
        
        for offset in 0..<7 {
            let nextDayIndex = (todayIndex + offset - 1) % 7 + 1  // Keep it within 1-7 range
            if repeatDays.contains(nextDayIndex) {
                return calendar.date(byAdding: .day, value: offset, to: now)!
            }
        }
        
        return date // Fallback, should never reach here
    }
    
    

    
    static func nextOccurrence(of time: Date, calendar: Calendar, now: Date = Date(), repeatDays: Set<Int>) -> Date {
            let nowComponents = calendar.dateComponents([.hour, .minute, .second], from: now)
            let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
            
            var nextDateComponents = calendar.dateComponents([.year, .month, .day], from: now)
            nextDateComponents.hour = timeComponents.hour
            nextDateComponents.minute = timeComponents.minute
            nextDateComponents.second = timeComponents.second
            
            if let nextDate = calendar.date(from: nextDateComponents), nextDate > now {
                // If the alarm time is later today and today is in repeatDays, return it
                let todayWeekday = calendar.component(.weekday, from: now)
                if repeatDays.contains(todayWeekday) {
                    return nextDate
                }
            }
            
            // Find the next valid repeat day
            let todayWeekday = calendar.component(.weekday, from: now)
            let sortedRepeatDays = repeatDays.sorted()
            
            if let nextDay = sortedRepeatDays.first(where: { $0 > todayWeekday }) {
                return nextDateByAddingDays(nextDay - todayWeekday, to: nextDateComponents, calendar: calendar)
            }
            
            // If no future day is found, wrap around to the earliest repeat day in the next week
            if let firstRepeatDay = sortedRepeatDays.first {
                return nextDateByAddingDays((7 - todayWeekday) + firstRepeatDay, to: nextDateComponents, calendar: calendar)
            }
            
            // If no repeat days are set, default to the next day
            return nextDateByAddingDays(1, to: nextDateComponents, calendar: calendar)
        }
    
    private static func nextDateByAddingDays(_ days: Int, to components: DateComponents, calendar: Calendar) -> Date {
            if let date = calendar.date(from: components) {
                return calendar.date(byAdding: .day, value: days, to: date) ?? date
            }
            return Date()
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
