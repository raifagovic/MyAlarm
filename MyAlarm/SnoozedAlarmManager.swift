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
    weak var snoozedAlarm: Alarm? // 👈 use a weak reference to avoid retain cycles

    private init() {}

    func reset() {
        snoozedUntil = nil
        snoozedAlarm = nil
    }
}
