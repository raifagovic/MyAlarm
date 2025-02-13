//
//  AlarmUtils.swift
//  MyAlarm
//
//  Created by Raif Agovic on 11. 2. 2025..
//

import Foundation

 func remainingTimeMessage(for time: Date) -> String {
    let calendar = Calendar.current
    
    // Get the current time in Sarajevo
    let now = Date()
    let currentTimeInSarajevo = now
    
    // Calculate the difference
    let selectedComponents = calendar.dateComponents([.hour, .minute], from: time)
    
    // Create a new Date with today's date and selected time
    var combinedComponents = DateComponents()
    combinedComponents.year = calendar.component(.year, from: now)
    combinedComponents.month = calendar.component(.month, from: now)
    combinedComponents.day = calendar.component(.day, from: now)
    combinedComponents.hour = selectedComponents.hour
    combinedComponents.minute = selectedComponents.minute
    
    let selectedDate = calendar.date(from: combinedComponents)!
    
    let differenceInSeconds = selectedDate.timeIntervalSince(currentTimeInSarajevo)
    let hours = Int(differenceInSeconds) / 3600
    let minutes = (Int(differenceInSeconds) % 3600) / 60
    
    if differenceInSeconds < 0 {
        // If the selected time has already passed, show time for the next day
        let nextDayDate = calendar.date(byAdding: .day, value: 1, to: selectedDate)!
        let nextDayDifference = nextDayDate.timeIntervalSince(currentTimeInSarajevo)
        let nextDayHours = Int(nextDayDifference) / 3600
        let nextDayMinutes = (Int(nextDayDifference) % 3600) / 60
        return "Rings  in \(nextDayHours) h \(nextDayMinutes) min"
    }
    
    return "Rings  in \(hours) h \(minutes) min"
}

func getAbbreviatedDays(from repeatDays: [String]) -> String {
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
