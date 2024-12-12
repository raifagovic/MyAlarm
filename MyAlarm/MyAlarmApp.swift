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
        // Set the app-wide window background color
        if let window = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            window.windows.forEach { $0.backgroundColor = UIColor.black }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .appBackground(color: Color.black)
                .environment(\.colorScheme, .dark) // Enforce dark mode globally
        }
    }
}
