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
                if alarms.isEmpty {
                    Text("No alarms set")
                        .foregroundColor(.gray)
                        .font(.title2)
                } else {
                    ScrollView {
                        ForEach(alarms) { alarm in
                            AlarmView(
                                alarm: alarm,
                                onToggle: { isOn in
                                    alarm.isOn = isOn
                                    saveContext()
                                },
                                onDelete: {
                                    deleteAlarm(alarm)
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
            .sheet(item: $selectedAlarm) { alarm in
                AlarmEditorView(
                    selectedAlarm: alarm,
                    onDelete: {
                        deleteAlarm(alarm)
                        isEditing = false
                    },
                    onCancel: {
                        isEditing = false
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
                    Button(action: addAlarm) {
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
    
    private func addAlarm() {
        let newAlarm = Alarm(time: Date(), isOn: false)
        modelContext.insert(newAlarm)
    }
    
    private func deleteAlarm(_ alarm: Alarm) {
        modelContext.delete(alarm)
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
