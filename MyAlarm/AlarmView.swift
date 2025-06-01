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
                        onDelete()
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
                        let hasLabel = !alarm.label.isEmpty
                        let hasRepeatDays = !alarm.repeatDays.isEmpty
                        let repeatMessage = hasRepeatDays ? AlarmUtils.getAbbreviatedDays(from: alarm.repeatDays) : ""
                        
                        if hasLabel {
                            Text(alarm.label + (hasRepeatDays ? "," : ""))
                                .foregroundColor(alarm.isOn ? Color(hex: "#F1F1F1") : Color(hex: "#A1A1A6"))
                                .fontWeight(.medium)
                        }
                        
                        if hasRepeatDays {
                            let formattedMessage = (repeatMessage == "Weekdays" || repeatMessage == "Weekends" || repeatMessage.hasPrefix("Every")) ? repeatMessage.prefix(1).lowercased() + repeatMessage.dropFirst() : repeatMessage
                            
                            Text(formattedMessage)
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
                        .frame(width: 51, height: 31)
                    
                    Toggle(isOn: Binding(
                        get: { alarm.isOn },
                        set: { newValue in
                            onToggle(newValue)
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
            .offset(x: showDelete ? -150 : 0)
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width < -100 {
                            withAnimation {
                                showDelete = true
                            }
                        } else if value.translation.width > 100 {
                            withAnimation {
                                showDelete = false
                            }
                        }
                    }
            )
            .frame(maxWidth: .infinity)
            .padding([.leading, .trailing])
            .onTapGesture {
                onEdit()
            }
        }
    }
}

