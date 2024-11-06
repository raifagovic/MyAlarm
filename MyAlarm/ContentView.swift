//
//  ContentView.swift
//  MyAlarm
//
//  Created by Raif Agovic on 20. 10. 2024..
//

import SwiftUI

struct AlarmView: View {
    @State private var isAlarmOn = false
    @State private var showDelete = false

    var body: some View {
        ZStack {
            // Background showing delete button when swiped
            if showDelete {
                HStack {
                    Spacer()
                    Button(action: {
                        // Action to delete the alarm
                        print("Alarm deleted")
                    }) {
                        Text("Delete")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                    .padding(.trailing)
                }
            }
            
            // Main alarm view
            HStack {
                VStack(alignment: .leading) {
                    Text("00:50")
                        .font(.largeTitle)
                        .bold()
                    Text("Label")
                    HStack {
                        ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                            Text(day)
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                }
                Spacer()
                Toggle(isOn: $isAlarmOn) {
                }
                .labelsHidden()
            }
            .padding()
            .background(Color(.systemGray5))
            .cornerRadius(10)
            .offset(x: showDelete ? -150 : 0) // Add an offset when swiped
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width < -100 { // Swipe left to show delete
                            withAnimation {
                                showDelete = true
                            }
                        } else if value.translation.width > 100 { // Swipe right to hide delete
                            withAnimation {
                                showDelete = false
                            }
                        }
                    }
            )
            .frame(maxWidth: .infinity, maxHeight: 100)
            .padding()
        }
    }
}

struct ContentView: View {
    @State private var alarms = [UUID()] // Array to store unique identifiers for each AlarmView
    
    var body: some View {
        ZStack {
            VStack {
                AlarmView()
                Spacer()
            }

            // Plus button at the bottom-right corner
            VStack {
                Spacer() // Push the button to the bottom
                HStack {
                    Spacer() // Push the button to the right
                    Button(action: {
                        // Action to add a new alarm
                        print("Add new alarm")
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.blue)
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
