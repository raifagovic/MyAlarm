//
//  SnoozeSelectionView.swift
//  MyAlarm
//
//  Created by Raif Agovic on 24. 12. 2024..
//

//import SwiftUI
//
//struct SnoozeView: View {
//    @Binding var selectedSnooze: Int
//    
//    let snoozeOptions = [5, 10, 15, 20, 25, 30]
//    
//    var body: some View {
//        List(snoozeOptions, id: \.self) { option in
//            HStack {
//                Text("\(option) minutes")
//                    .foregroundColor(.white)
//                Spacer()
//                if option == selectedSnooze {
//                    Image(systemName: "checkmark")
//                        .foregroundColor(Color(hex: "#FFD700"))
//                }
//            }
//            .contentShape(Rectangle()) // Makes the entire row tappable
//            .onTapGesture {
//                selectedSnooze = option // Update the selected snooze duration
//            }
//            .listRowBackground(Color(hex: "#2C2C2E")) // Set row background color
//        }
//        .scrollContentBackground(.hidden)
//        .background(Color(hex: "#1C1C1E"))
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .principal) {
//                Text("Snooze")
//                    .foregroundColor(Color(hex: "#F1F1F1"))
//                    .font(.headline)
//            }
//        }
//    }
//}


import SwiftUI

struct SnoozeView: View {
    @Binding var selectedSnooze: Int

    let snoozeOptions = [5, 10, 15, 20, 25, 30]

    var body: some View {
        NavigationStack {
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
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedSnooze = option
                }
                .listRowBackground(Color(hex: "#2C2C2E"))
            }
            .scrollContentBackground(.hidden)
            .background(Color(hex: "#1C1C1E"))
            .navigationTitle("Snooze")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationBarTitleDisplayMode(.inline)
        .modifier(NavigationBarModifier(
            backgroundColor: Color(Color(hex: "#1C1C1E")),
            foregroundColor: UIColor.white
        ))    }
}
