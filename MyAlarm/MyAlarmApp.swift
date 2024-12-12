//
//  MyAlarmApp.swift
//  MyAlarm
//
//  Created by Raif Agovic on 20. 10. 2024..
//

import SwiftUI

@main
struct MyAlarmApp: App {
    init() {
        UIWindow.setRootBackgroundColor(.black)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.colorScheme, .dark) // Enforce dark mode globally
        }
    }
}
