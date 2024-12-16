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
            // Set the UIWindow background color to black
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.backgroundColor = UIColor.black
                }
            }
        }
    
    var body: some Scene {
        WindowGroup {
            ContentView() // A placeholder because the app's window is managed by AppDelegate
        }
    }
}
