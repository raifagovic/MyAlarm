//
//  ViewExtensions.swift
//  MyAlarm
//
//  Created by Raif Agovic on 11. 12. 2024..
//

import SwiftUI

extension View {
    func appBackground(color: Color) -> some View {
            self.background(
                color
                    .ignoresSafeArea() // Ensures the background extends to the safe area
            )
        }
}
