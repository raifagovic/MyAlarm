//
//  MissionView.swift
//  MyAlarm
//
//  Created by Raif Agovic on 17. 4. 2025..
//

import SwiftUI

struct MissionView: View {
    @Binding var selectedMission: String

    // List of available missions as simple strings
    let allMissions = ["none", "lemon", "toothbrush", "spoon", "mug"]

    var body: some View {
        Form {
            Section {
                ForEach(allMissions, id: \.self) { mission in
                    HStack {
                        Text(mission.capitalized)
                            .foregroundColor(Color(hex: "#F1F1F1"))
                        Spacer()
                        if mission == selectedMission {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color(hex: "#FFD700"))
                                .bold()
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedMission = mission
                    }
                }
            }
        }
        .environment(\.colorScheme, .dark)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Mission")
                    .foregroundColor(Color(hex: "#F1F1F1"))
                    .font(.headline)
            }
        }
        .onAppear {
            createTransparentAppearance()
        }
    }
}
