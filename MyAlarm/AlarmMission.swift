//
//  AlarmMission.swift
//  MyAlarm
//
//  Created by Raif Agovic on 17. 4. 2025..
//

import Foundation

enum AlarmMission: String, CaseIterable, Identifiable {
    case none
    case lemon
    case toothbrush
    case spoon
    case mug

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .none: return "No Mission"
        case .lemon: return "Recognize Lemon"
        case .toothbrush: return "Recognize Toothbrush"
        case .spoon: return "Recognize Spoon"
        case .mug: return "Recognize Mug"
        }
    }
}
