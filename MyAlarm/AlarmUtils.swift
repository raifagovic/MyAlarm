//
//  AlarmUtils.swift
//  MyAlarm
//
//  Created by Raif Agovic on 11. 2. 2025..
//

import Foundation

enum AlarmUtils {
    
    static func convertRepeatDaysToInt(_ repeatDays: [String]) -> Set<Int> {
        let dayMappings: [String: Int] = [
            "Every Sunday": 1,
            "Every Monday": 2,
            "Every Tuesday": 3,
            "Every Wednesday": 4,
            "Every Thursday": 5,
            "Every Friday": 6,
            "Every Saturday": 7
        ]
        
        return Set(repeatDays.compactMap { dayMappings[$0] })
    }
    
    static func findNextValidDay(calendar: Calendar, now: Date, repeatDays: [String]) -> Date {
        let todayIndex = calendar.component(.weekday, from: now) // 1 = Sunday, 2 = Monday, ..., 7 = Saturday
        let repeatDaysInt = convertRepeatDaysToInt(repeatDays)  // Convert to Int set
        
        for offset in 0..<7 {
            let nextDayIndex = (todayIndex + offset - 1) % 7 + 1  // Keep within 1-7 range
            if repeatDaysInt.contains(nextDayIndex) {
                return calendar.date(byAdding: .day, value: offset, to: now)!
            }
        }
        return now // Fallback, should never reach here
    }
    
    static func nextOccurrence(of time: Date, calendar: Calendar, now: Date = Date(), repeatDays: [String]) -> Date {
        let todayWeekday = calendar.component(.weekday, from: now) // 1 = Sunday, ..., 7 = Saturday
        
        // Convert repeatDays from [String] to Set<Int>
        let repeatDaysInt = convertRepeatDaysToInt(repeatDays)
        
        // Extract time components from the alarm
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        // Set the next alarm time today
        var nextDateComponents = calendar.dateComponents([.year, .month, .day], from: now)
        nextDateComponents.hour = timeComponents.hour
        nextDateComponents.minute = timeComponents.minute
        nextDateComponents.second = timeComponents.second
        
        if let nextDate = calendar.date(from: nextDateComponents), nextDate > now, repeatDaysInt.contains(todayWeekday) {
            return nextDate // Alarm rings later today
        }
        
        // Find the next valid repeat day
        let nextValidDay = findNextValidDay(calendar: calendar, now: now, repeatDays: repeatDays)
        
        return calendar.date(bySettingHour: timeComponents.hour!, minute: timeComponents.minute!, second: timeComponents.second!, of: nextValidDay)!
    }
    
    static func remainingTimeMessage(for time: Date, repeatDays: [String] = []) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        // Get the next valid alarm time
        let selectedDate = nextOccurrence(of: time, calendar: calendar, now: now, repeatDays: repeatDays)
        
        // Calculate the difference in seconds
        let differenceInSeconds = selectedDate.timeIntervalSince(now)
        
        let hours = Int(differenceInSeconds) / 3600
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
                minutes = 1
            }
        }
        
        if minutes == 60 {
            minutes = 0
            return "Alarm in \(hours + 1) h"
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
