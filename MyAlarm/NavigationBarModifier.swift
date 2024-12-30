//
//  NavigationBarModifier.swift
//  MyAlarm
//
//  Created by Raif Agovic on 30. 12. 2024..
//

import SwiftUI

struct NavigationBarModifier: ViewModifier {
    var backgroundColor: Color
    var foregroundColor: Color

    init(backgroundColor: Color, foregroundColor: Color) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(backgroundColor)
        appearance.titleTextAttributes = [.foregroundColor: UIColor(foregroundColor)]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(foregroundColor)]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().tintColor = UIColor(foregroundColor)
    }

    func body(content: Content) -> some View {
        content
    }
}
