//
//  AlarmMission.swift
//  MyAlarm
//
//  Created by Raif Agovic on 17. 4. 2025..
//

import Foundation

enum AlarmMission: String, Codable, CaseIterable {
    case none
    case recognizeLemon
    case recognizeToothbrush
    case recognizeSpoon
    case recognizeMug

    var displayName: String {
        switch self {
        case .none: return "No Mission"
        case .recognizeLemon: return "Recognize Lemon"
        case .recognizeToothbrush: return "Recognize Toothbrush"
        case .recognizeSpoon: return "Recognize Spoon"
        case .recognizeMug: return "Recognize Mug"
        }
    }
}
