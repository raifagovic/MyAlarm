//
//  SnoozeSelectionView.swift
//  MyAlarm
//
//  Created by Raif Agovic on 24. 12. 2024..
//

import SwiftUI

struct SnoozeView: View {
    @Binding var selectedSnooze: Int // Tracks the selected snooze duration
    
    let snoozeOptions = [5, 10, 15, 20, 25, 30]
    
    var body: some View {
        List(snoozeOptions, id: \.self) { option in
            HStack {
                Text("\(option) minutes")
                    .foregroundColor(.white)
                Spacer()
                if option == selectedSnooze {
                    Image(systemName: "checkmark")
                        .foregroundColor(Color(hex: "#FFD700"))
                }
            }
            .contentShape(Rectangle()) // Makes the entire row tappable
            .onTapGesture {
                selectedSnooze = option // Update the selected snooze duration
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color(hex: "#1C1C1E")) // Matches dark mode style
        .navigationTitle("Snooze Duration")
        .navigationBarTitleDisplayMode(.inline)
    }
}
