//
//  AlarmView.swift
//  MyAlarm
//
//  Created by Raif Agovic on 28. 11. 2024..
//

import SwiftUI

struct AlarmView: View {
    @Binding var alarms: [Alarm]
    var alarm: Alarm
    @State private var isAlarmOn = false
    @State private var showDelete = false
    
    var onEdit: () -> Void // Callback to trigger editing
    
    var body: some View {
        ZStack {
            // Background showing delete button when swiped
            if showDelete {
                HStack {
                    Spacer()
                    Button(action: {
                        // Action to delete the alarm
                        if let index = alarms.firstIndex(of: alarm) {
                            alarms.remove(at: index)
                        }
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
                    // Time at the top
                    Text(alarm.time)
                        .font(.system(size: 64, weight: .light, design: .default))
                        .foregroundColor(isAlarmOn ? Color(hex: "#F1F1F1") : Color(hex: "#A1A1A6"))
                        .bold()
                    
                    // Row below time: Symbol • Label • Weekdays
                    HStack {
                        Text("Label,") // Label
                            .foregroundColor(isAlarmOn ? Color(hex: "#F1F1F1") : Color(hex: "#A1A1A6"))
                        
                        Text("weekdays") // Weekdays
                            .font(.subheadline)
                            .foregroundColor(isAlarmOn ? Color(hex: "#F1F1F1") : Color(hex: "#A1A1A6"))
                    }
                }
                
                Spacer()
                
                // Toggle with custom design
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isAlarmOn ? Color.clear : Color(hex: "#A1A1A6")) // Gray when off, clear when on
                        .frame(width: 51, height: 31) // Matches the default size of the Toggle background
                    
                    Toggle(isOn: $isAlarmOn) {
                    }
                    .labelsHidden()
                    .onTapGesture {}
                    .tint(Color(hex: "#FFD700"))
                }
            }
            .padding()
            .background(Color(hex: "#2C2C2E"))
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
            .onTapGesture {
                onEdit() // Notify parent view (ContentView) to start editing
            }
        }
    }
}
