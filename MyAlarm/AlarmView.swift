//
//  AlarmView.swift
//  MyAlarm
//
//  Created by Raif Agovic on 28. 11. 2024..
//

import SwiftUI

struct AlarmView: View {
    var alarm: Alarm
    @State private var showDelete = false
    
    var onToggle: (Bool) -> Void
    var onDelete: () -> Void
    var onEdit: () -> Void
    
    var body: some View {
        ZStack {
            // Background showing delete button when swiped
            if showDelete {
                HStack {
                    Spacer()
                    Button(action: {
                        onDelete() // Trigger parent-provided delete action
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
                    // Alarm Time
                    Text(DateFormatter.localizedString(from: alarm.time, dateStyle: .none, timeStyle: .short))
                        .font(.system(size: 48, weight: .semibold, design: .rounded))
                        .kerning(-1)
                        .foregroundColor(alarm.isOn ? Color(hex: "#F1F1F1") : Color(hex: "#A1A1A6"))
                    
                    // Label and repeat days
                    HStack {
                        Text(alarm.label)
                            .foregroundColor(alarm.isOn ? Color(hex: "#F1F1F1") : Color(hex: "#A1A1A6"))
                            .fontWeight(.medium)
                        
                        if !alarm.repeatDays.isEmpty {
                            Text(getAbbreviatedDays(from: alarm.repeatDays))
                                    .foregroundColor(alarm.isOn ? Color(hex: "#F1F1F1") : Color(hex: "#A1A1A6"))
                                    .fontWeight(.medium)
                        }
                    }
                }
                
                Spacer()
                
                // Toggle with custom design
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(alarm.isOn ? Color.clear : Color(hex: "#A1A1A6"))
                        .frame(width: 51, height: 31) // Matches the default size of the Toggle background
                    
                    Toggle(isOn: Binding(
                        get: { alarm.isOn },
                        set: { newValue in
                            onToggle(newValue) // Notify parent of toggle change
                        }
                    )) {
                    }
                    .labelsHidden()
                    .tint(Color(hex: "#FFD700"))
                    .onTapGesture { }
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
            .padding([.leading, .trailing])
            .padding([.top, .bottom], 4)
            .onTapGesture {
                onEdit() // Notify parent view (ContentView) to start editing
            }
        }
    }
}
