//
//  ContentView.swift
//  MyAlarm
//
//  Created by Raif Agovic on 20. 10. 2024..
//

import SwiftUI

struct ContentView: View {
    @State private var alarms = [Alarm(time: "00:50", isOn: false)]
    @State private var isEditing = false
    @State private var selectedAlarm: Alarm?
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                Color(hex: "#1C1C1E").ignoresSafeArea()
                
                // List of alarms or empty state
                if !alarms.isEmpty {
                    ScrollView {
                        ForEach(alarms) { alarm in
                            AlarmView(
                                alarm: alarm,
                                onToggle: { isOn in
                                    if let index = alarms.firstIndex(of: alarm) {
                                        alarms[index].isOn = isOn
                                    }
                                },
                                onDelete: {
                                    if let index = alarms.firstIndex(of: alarm) {
                                        alarms.remove(at: index)
                                    }
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
                    alarm: alarmToEdit, // This works because `alarmToEdit` is non-optional
                    isPresented: $isEditing, // Optional: Control dismissal
                    onSave: { updatedAlarm in
                        if let index = alarms.firstIndex(where: { $0.id == updatedAlarm.id }) {
                            alarms[index] = updatedAlarm // Update the alarm in the list
                        }
                        selectedAlarm = nil // Clear selection after save
                    },
                    onDelete: {
                        if let index = alarms.firstIndex(where: { $0.id == alarmToEdit.id }) {
                            alarms.remove(at: index) // Remove the alarm
                        }
                        selectedAlarm = nil // Clear selection after delete
                    },
                    onCancel: {
                        selectedAlarm = nil // Clear selection after cancel
                    }
                )
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if alarms.contains(where: { $0.isOn }) {
                        Text("Alarm is active")
                            .foregroundColor(Color(hex: "#FFD700"))
                            .bold()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        alarms.append(Alarm(time: "00:50", isOn: false))
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
