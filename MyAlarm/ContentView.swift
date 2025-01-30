//
//  ContentView.swift
//  MyAlarm
//
//  Created by Raif Agovic on 20. 10. 2024..
//

import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext  // Access SwiftData's database
    @Query var alarms: [Alarm]  // Fetch all alarms from SwiftData
    
    @State private var selectedAlarm = Alarm(time: Date(), isOn: false)
    @State private var isEditing: Bool = false // Controls the presentation of the editor
    
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
                                    isEditing = true
                                }
                            )
                        }
                    }
                }
            }
            .sheet(isPresented: $isEditing) {
                AlarmEditorView(
                    selectedAlarm: Binding(
                        get: { selectedAlarm },
                        set: { updatedAlarm in
                            if let index = alarmData.alarms.firstIndex(of: selectedAlarm) {
                                alarmData.alarms[index] = updatedAlarm // Save changes to AlarmData
                            } else {
                                print("Failed to update alarm: not found in alarmData.")
                            }
                        }
                    ),
                    onDelete: {
                        alarmData.deleteAlarm(selectedAlarm) // Delete the alarm
                        isEditing = false // Close the editor
                    },
                    onCancel: {
                        isEditing = false // Close the editor without saving
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
    
    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    // Helper function to set root background color to black
    private func setRootBackgroundColor() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.backgroundColor = UIColor.black
        }
    }
}

//#Preview {
//    ContentView()
//}
