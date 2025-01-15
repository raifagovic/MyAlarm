//
//  Models.swift
//  MyAlarm
//
//  Created by Raif Agovic on 28. 11. 2024..
//

import SwiftUI

struct Alarm: Identifiable, Hashable {
    let id = UUID()
    var time: String
    var isOn: Bool
}

