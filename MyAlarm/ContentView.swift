//
//  ContentView.swift
//  MyAlarm
//
//  Created by Raif Agovic on 20. 10. 2024..
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var alarmData: AlarmData
    @State private var selectedAlarm: Alarm?
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                Color(hex: "#1C1C1E").ignoresSafeArea()
                
                // List of alarms or empty state
                if !alarmData.alarms.isEmpty {
                    ScrollView {
                        ForEach(alarmData.alarms) { alarm in
                            AlarmView(
                                alarm: alarm,
                                onToggle: { isOn in
                                    if let index = alarmData.alarms.firstIndex(of: alarm) {
                                        alarmData.alarms[index].isOn = isOn
                                    }
                                },
                                onDelete: {
                                    alarmData.deleteAlarm(alarm)
                                },
                                onEdit: {
                                    selectedAlarm = alarm
                                }
                            )
                        }
                    }
                }
            }
            .sheet(item: $selectedAlarm) { alarmToEdit in
                AlarmEditorView(
                    selectedAlarm: Binding(get: { alarmToEdit }, set: { updatedAlarm in
                        if let index = alarmData.alarms.firstIndex(where: { $0.id == updatedAlarm.id }) {
                            alarmData.alarms[index] = updatedAlarm // Update the alarm in the list
                        }
                    }),
                    onDelete: {
                        if let index = alarmData.alarms.firstIndex(where: { $0.id == alarmToEdit.id }) {
                            alarmData.alarms.remove(at: index) // Remove the alarm
                        }
                        selectedAlarm = nil // Clear selection after delete
                    },
                    onCancel: {
                        selectedAlarm = nil // Clear selection after cancel
                    }
                )
                .environmentObject(alarmData) // Ensure AlarmEditorView gets AlarmData
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if alarmData.alarms.contains(where: { $0.isOn }) {
                        Text("Alarm is active")
                            .foregroundColor(Color(hex: "#FFD700"))
                            .bold()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        alarmData.alarms.append(Alarm(time: Date(), isOn: false))
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(Color(hex: "#FFD700"))
                    }
                }
            }
            .onAppear {
                setRootBackgroundColor()
                createTransparentAppearance()
            }
        }
    }
    
    // Helper function to set root background color to black
    private func setRootBackgroundColor() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.backgroundColor = UIColor.black
        }
    }
}

#Preview {
    ContentView()
}
