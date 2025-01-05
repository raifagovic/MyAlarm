//
//  NavigationBarHelper.swift
//  MyAlarm
//
//  Created by Raif Agovic on 5. 1. 2025..
//

import UIKit

func createTransparentAppearance() {
    let navigationBarAppearance = UINavigationBarAppearance()
    navigationBarAppearance.configureWithTransparentBackground()
    
    // Add a semi-transparent background for a frosted glass effect
    navigationBarAppearance.backgroundEffect = UIBlurEffect(style: .systemMaterialDark)
    navigationBarAppearance.backgroundColor = UIColor.clear.withAlphaComponent(0.3) // Adjust transparency level
    
    UINavigationBar.appearance().standardAppearance = navigationBarAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
}
