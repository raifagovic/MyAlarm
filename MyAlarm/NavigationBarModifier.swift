//
//  NavigationBarModifier.swift
//  MyAlarm
//
//  Created by Raif Agovic on 30. 12. 2024..
//

import SwiftUI

struct NavigationBarModifier: ViewModifier {
    var backgroundColor: UIColor
    var foregroundColor: UIColor

    init(backgroundColor: Color, foregroundColor: UIColor) {
        self.backgroundColor = UIColor(backgroundColor)
        self.foregroundColor = foregroundColor

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = self.backgroundColor
        appearance.titleTextAttributes = [.foregroundColor: self.foregroundColor]
        appearance.largeTitleTextAttributes = [.foregroundColor: self.foregroundColor]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance

        // Force dark mode for the navigation bar
        UINavigationBar.appearance().overrideUserInterfaceStyle = .dark
    }

    func body(content: Content) -> some View {
        content
    }
}
