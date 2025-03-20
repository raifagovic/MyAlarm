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
    
//    static func remainingTimeMessage(for time: Date) -> String {
//        let now = Date()
//        let calendar = Calendar.current
//        
//        // Ensure 'time' is a future date
//        guard time > now else { return "Alarm will go off soon" }
//        
//        let differenceInSeconds = time.timeIntervalSince(now)
//        let totalHours = Int(differenceInSeconds) / 3600
//        let totalDays = totalHours / 24
//        
//        // If there is at least 1 full day, return "Alarm in X days"
//        if totalDays > 0 {
//            return "Alarm in \(totalDays) day" + (totalDays > 1 ? "s" : "")
//        }
//        
//        var hours = totalHours
//        var minutes = (Int(differenceInSeconds) % 3600) / 60
//        let seconds = Int(differenceInSeconds) % 60
//        
//        // If less than a minute remains
//        if hours == 0 && minutes == 0 {
//            return "Alarm will go off soon"
//        }
//        
//        // Round up minutes if there are remaining seconds
//        if seconds > 0 {
//            minutes += 1
//            if minutes == 60 {
//                minutes = 0
//                hours += 1
//            }
//        }
//        
//        if hours == 0 {
//            return "Alarm in \(minutes) min"
//        } else if minutes == 0 {
//            return "Alarm in \(hours) h"
//        }
//        
//        return "Alarm in \(hours) h \(minutes) min"
//    }
    
    static func remainingTimeMessage(for time: Date) -> String {
        let now = Date()
        let calendar = Calendar.current

        // Ensure 'time' is in the future
        guard time > now else { return "Alarm will go off soon" }

        let differenceInSeconds = time.timeIntervalSince(now)
        var totalMinutes = Int(differenceInSeconds) / 60
        let seconds = Int(differenceInSeconds) % 60

        // Round up minutes if there are remaining seconds
        if seconds > 0 && totalMinutes > 0 {
            totalMinutes += 1
        }

        let totalHours = totalMinutes / 60
        let minutes = totalMinutes % 60
        
        // If no remaining hours or minutes, show "Alarm will go off soon"
        if totalHours == 0 && minutes == 0 {
            return "Alarm will go off soon"
        }

        // If remaining time is less than 24 hours, show precise time
        if totalHours < 24 {
            if totalHours == 0 {
                return "Alarm in \(minutes) min"
            } else if minutes == 0 {
                return "Alarm in \(totalHours) h"
            }
            return "Alarm in \(totalHours) h \(minutes) min"
        }

        // Get the calendar day difference
        let startOfToday = calendar.startOfDay(for: now)
        let startOfAlarmDay = calendar.startOfDay(for: time)
        let daysDifference = calendar.dateComponents([.day], from: startOfToday, to: startOfAlarmDay).day ?? 0

        // If exactly 24 hours remain, show "Alarm in 24 hours"
        if totalHours == 24 && minutes == 0 {
            return "Alarm in 24 hours"
        }

        // Otherwise, show calendar-based days
        return "Alarm in \(daysDifference) day" + (daysDifference > 1 ? "s" : "")
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
