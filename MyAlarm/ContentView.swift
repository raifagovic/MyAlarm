//
//  ContentView.swift
//  MyAlarm
//
//  Created by Raif Agovic on 20. 10. 2024..
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var alarms: [Alarm]
    
    @State var selectedAlarm: Alarm?
    
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
                                }
                            )
                        }
                    }
                }
            }
            .sheet(item: $selectedAlarm) { alarm in
                AlarmEditorView(alarm: alarm)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if let nextAlarm = alarms.filter({ $0.isOn }).min(by: { $0.time < $1.time }) {
                        Text(remainingTimeMessage(for: nextAlarm.time))
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
        let newAlarm = Alarm(time: Date(), repeatDays: [], label: "", selectedSound: "casio", snoozeDuration: 10, isOn: false)
        modelContext.insert(newAlarm)
        selectedAlarm = newAlarm
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
