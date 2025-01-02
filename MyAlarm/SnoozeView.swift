//
//  SnoozeSelectionView.swift
//  MyAlarm
//
//  Created by Raif Agovic on 24. 12. 2024..
//

import SwiftUI

struct SnoozeView: View {
    @Binding var selectedSnooze: Int
    let snoozeOptions = [5, 10, 15, 20, 25, 30]
    
    var body: some View {
        Form {
            Section {
                ForEach(snoozeOptions, id: \.self) { option in
                    HStack {
                        Text("\(option) minutes")
                            .foregroundColor(Color(hex: "#F1F1F1"))
                        Spacer()
                        if option == selectedSnooze {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color(hex: "#FFD700"))
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedSnooze = option
                    }
                }
            }
        }
        .listRowBackground(Color(hex: "#2C2C2E"))
        .environment(\.colorScheme, .dark)
        .background(Color(hex: "#1C1C1E").edgesIgnoringSafeArea(.all))
        .padding(.top, 5) // Adjust this value as needed
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Snooze")
                    .foregroundColor(Color(hex: "#F1F1F1"))
                    .font(.headline)
            }
        }
        .toolbarBackground(Color.clear, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}
