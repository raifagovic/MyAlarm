//
//  AppDelegate.swift
//  MyAlarm
//
//  Created by Raif Agovic on 13. 12. 2024..
//

import SwiftUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let rootView = ContentView()
        let hostingController = CustomHostingController(rootView: rootView)
        window.rootViewController = hostingController
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}
