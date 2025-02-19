//
//  SnoozeSelectionView.swift
//  MyAlarm
//
//  Created by Raif Agovic on 24. 12. 2024..
//

import SwiftUI

struct SnoozeView: View {
    @Binding var snoozeDuration: Int
   
    let snoozeOptions = [0, 5, 10, 15, 20, 25, 30]
    
    var body: some View {
        Form {
            Section {
                ForEach(snoozeOptions, id: \.self) { option in
                    HStack {
                        Text(option == 0 ? "No Snooze" : "\(option) minutes")
                            .foregroundColor(Color(hex: "#F1F1F1"))
                        Spacer()
                        if option == snoozeDuration {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color(hex: "#FFD700"))
                                .bold()
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        snoozeDuration = option
                    }
                }
            }
        }
        .environment(\.colorScheme, .dark)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Snooze")
                    .foregroundColor(Color(hex: "#F1F1F1"))
                    .font(.headline)
            }
        }
        .onAppear {
            createTransparentAppearance()
        }

    }
}
