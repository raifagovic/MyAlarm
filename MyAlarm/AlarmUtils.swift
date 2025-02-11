//
//  AlarmUtils.swift
//  MyAlarm
//
//  Created by Raif Agovic on 11. 2. 2025..
//

import Foundation

private func remainingTimeMessage() -> String {
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
    let dayAbbreviations: [String: String] = [
        "Every Monday": "Mon",
        "Every Tuesday": "Tue",
        "Every Wednesday": "Wed",
        "Every Thursday": "Thu",
        "Every Friday": "Fri",
        "Every Saturday": "Sat",
        "Every Sunday": "Sun",
    ]
    
    let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    let sortedDays = repeatDays
        .compactMap { dayAbbreviations[$0] }
        .sorted { daysOfWeek.firstIndex(of: $0)! < daysOfWeek.firstIndex(of: $1)! }
    
    // If no days are selected, return "Never"
    if sortedDays.isEmpty {
        return "Never"
    }
    
    // If all days are selected, return "Every"
    if sortedDays.count == daysOfWeek.count {
        return "Every day"
    }
    
    // If only one day is selected, return the abbreviation for that day
    if sortedDays.count == 1 {
        return sortedDays.first!
    }
    
    if sortedDays == ["Mon", "Tue", "Wed", "Thu", "Fri"] {
        return "Weekdays"
    }
    
    // Check if weekends are selected
    if sortedDays == ["Sat", "Sun"] {
        return "Weekends"
    }
    
    // For multiple selected days, format as "Mon, Tue and Wed"
    let allButLast = sortedDays.dropLast()
    let lastDay = sortedDays.last!
    return "\(allButLast.joined(separator: ", ")) and \(lastDay)"
}
