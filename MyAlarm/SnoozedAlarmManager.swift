//
//  SnoozedAlarmManager.swift
//  MyAlarm
//
//  Created by Raif Agovic on 16. 4. 2025..
//

import Foundation

class SnoozedAlarmManager {
    static let shared = SnoozedAlarmManager()
    
    var snoozedUntil: Date?
    var snoozedAlarm: Alarm?

    private init() {}

    func reset() {
        snoozedUntil = nil
        snoozedAlarm = nil
    }
}
