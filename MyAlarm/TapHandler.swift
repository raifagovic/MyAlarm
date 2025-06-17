//
//  TapHandler.swift
//  MyAlarm
//
//  Created by Raif Agovic on 17. 6. 2025..
//

import Foundation

class TapHandler {
    static let shared = TapHandler()

    // This closure will be called when the user taps the notification
    var onTap: ((Alarm) -> Void)?

    private init() {}
}
