//
//  SnoozeSelectionView.swift
//  MyAlarm
//
//  Created by Raif Agovic on 24. 12. 2024..
//

import SwiftUI

struct SnoozeView: View {
    var snoozeDuration: Int
    var onUpdate: (Int) -> Void  
    
    @State private var localSnoozeDuration: Int
    
    init(snoozeDuration: Int, onUpdate: @escaping (Int) -> Void) {
        self.snoozeDuration = snoozeDuration
        self.onUpdate = onUpdate
        _localSnoozeDuration = State(initialValue: snoozeDuration)
    }
    
    let snoozeOptions = [5, 10, 15, 20, 25, 30]
    
    var body: some View {
        Form {
            Section {
                ForEach(snoozeOptions, id: \.self) { option in
                    HStack {
                        Text("\(option) minutes")
                            .foregroundColor(Color(hex: "#F1F1F1"))
                        Spacer()
                        if option == localSnoozeDuration {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color(hex: "#FFD700"))
                                .bold()
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        localSnoozeDuration = option
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
        .onDisappear {
            onUpdate(localSnoozeDuration)
        }
    }
}
