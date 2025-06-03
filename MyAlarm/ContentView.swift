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
    @State private var isAlarmRinging = false
    @State private var ringingAlarm: Alarm?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#1C1C1E").ignoresSafeArea()
                
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
                                    
                                    if !isOn {
                                        // If the alarm is turned off, clear snooze if it's the same alarm
                                        if SnoozedAlarmManager.shared.snoozedAlarm?.id == alarm.id {
                                            SnoozedAlarmManager.shared.snoozedAlarm = nil
                                            SnoozedAlarmManager.shared.snoozedUntil = nil
                                            NotificationManager.shared.cancelAllNotifications()
                                        }
                                        
                                        // Also reset ringing alarm if it’s the one turned off
                                        if ringingAlarm?.id == alarm.id {
                                            ringingAlarm = nil
                                        }
                                    }
                                    
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
                // Show small banner instead of full screen when unlocked
                if ringingAlarm != nil {
                    AlarmRingingView(alarm: ringingAlarm!, onStop: {
                        ringingAlarm = nil // Hide the banner when alarm stops
                    })
                    .transition(.move(edge: .top))
                    .zIndex(1)
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
        let newAlarm = Alarm(
            time: Date(),
            repeatDays: [], label: "",
            selectedSound: "casio",
            snoozeDuration: 10,
            isOn: false,
            selectedMission: "none"
        )
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
        let activeAlarms = alarms.filter { $0.isOn }
        
        // Check for a snoozed alarm
        if let snoozedAlarm = SnoozedAlarmManager.shared.snoozedAlarm,
           let snoozedUntil = SnoozedAlarmManager.shared.snoozedUntil,
           snoozedUntil > now {
            
            // Use snoozed alarm time for remaining time message
            remainingTimeMessage = AlarmUtils.remainingTimeMessage(for: snoozedUntil)
            
            // Optional: trigger ringing if snoozed time is here
            if snoozedUntil.timeIntervalSince(now) <= 1 {
                ringingAlarm = snoozedAlarm
                // Clear snooze state after ringing
                SnoozedAlarmManager.shared.snoozedAlarm = nil
                SnoozedAlarmManager.shared.snoozedUntil = nil
            }
            
            return
        }
        
        if let nextAlarm = activeAlarms.min(by: { alarm1, alarm2 in
            let nextTime1 = AlarmUtils.nextAlarm(time: alarm1.time, calendar: calendar, now: now, repeatDays: alarm1.repeatDays)
            let nextTime2 = AlarmUtils.nextAlarm(time: alarm2.time, calendar: calendar, now: now, repeatDays: alarm2.repeatDays)
            return nextTime1 < nextTime2
        }) {
            let nextTime = AlarmUtils.nextAlarm(time: nextAlarm.time, calendar: calendar, now: now, repeatDays: nextAlarm.repeatDays)
            remainingTimeMessage = AlarmUtils.remainingTimeMessage(for: nextTime)
            
            if nextTime.timeIntervalSince(now) <= 1 {
                ringingAlarm = nextAlarm
            } else {
                NotificationManager.shared.scheduleAlarmNotification(at: nextTime)            }
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
    
    private func setRootBackgroundColor() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.backgroundColor = UIColor.black
        }
    }
}

