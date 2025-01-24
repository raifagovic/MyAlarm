//
//  MyAlarmApp.swift
//  MyAlarm
//
//  Created by Raif Agovic on 20. 10. 2024..
//

import SwiftUI

@main
struct MyAlarmApp: App {
    @StateObject private var alarmData = AlarmData() // Instantiate AlarmData
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(alarmData)
        }
    }
}
