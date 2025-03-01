//
//  MyAlarmApp.swift
//  MyAlarm
//
//  Created by Raif Agovic on 20. 10. 2024..
//

import SwiftData
import SwiftUI

@main
struct MyAlarmApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Alarm.self)
    }
}
