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
    @State private var remainingTimeMessage: String = ""
    @State private var timer: Timer?
    
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
                                    updateRemainingTime()
                                },
                                onDelete: {
                                    deleteAlarm(alarm)
                                    updateRemainingTime()
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
                    if !remainingTimeMessage.isEmpty {
                        Text(remainingTimeMessage)
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
                updateRemainingTime()
                startTimer()
            }
            .onDisappear {
                stopTimer()
            }
        }
    }

    private func addAlarm() {
        let newAlarm = Alarm(time: Date(), repeatDays: [], label: "", selectedSound: "casio", snoozeDuration: 10, isOn: false)
        modelContext.insert(newAlarm)
        selectedAlarm = newAlarm
        updateRemainingTime()
    }
    
    private func deleteAlarm(_ alarm: Alarm) {
        modelContext.delete(alarm)
        updateRemainingTime()
    }
    
    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    private func updateRemainingTime() {
        let now = Date()
        let calendar = Calendar.current
        
        // Get alarms that are turned on
        let activeAlarms = alarms.filter { $0.isOn }
        
        // Find the next alarm that is later than or equal to the current time
        if let nextAlarm = activeAlarms.min(by: {
            let alarmTime1 = calendar.date(bySettingHour: calendar.component(.hour, from: $0.time),
                                           minute: calendar.component(.minute, from: $0.time),
                                           second: 0, of: now)!
            let alarmTime2 = calendar.date(bySettingHour: calendar.component(.hour, from: $1.time),
                                           minute: calendar.component(.minute, from: $1.time),
                                           second: 0, of: now)!
            return alarmTime1 < alarmTime2
        }) {
            remainingTimeMessage = AlarmUtils.remainingTimeMessage(for: nextAlarm.time)
        } else {
            remainingTimeMessage = ""
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            updateRemainingTime()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // Helper function to set root background color to black
    private func setRootBackgroundColor() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.backgroundColor = UIColor.black
        }
    }
}
