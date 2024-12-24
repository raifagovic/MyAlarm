//
//  SnoozeSelectionView.swift
//  MyAlarm
//
//  Created by Raif Agovic on 24. 12. 2024..
//

import SwiftUI

struct SnoozeSelectionView: View {
    @Binding var selectedSnooze: Int
    @Environment(\.presentationMode) var presentationMode // For dismissing the view
    
    let snoozeOptions = [5, 10, 15, 20, 25, 30]
    
    var body: some View {
        List(snoozeOptions, id: \.self) { option in
            HStack {
                Text("\(option) minutes")
                Spacer()
                if option == selectedSnooze {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
            .contentShape(Rectangle()) // Makes the entire row tappable
            .onTapGesture {
                selectedSnooze = option
                presentationMode.wrappedValue.dismiss() // Dismiss when tapped
            }
        }
        .navigationTitle("Snooze Duration")
        .navigationBarTitleDisplayMode(.inline)
    }
}
