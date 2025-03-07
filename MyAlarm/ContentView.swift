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
        
        let activeAlarms = alarms.filter { $0.isOn }
        
        func mapRepeatDaysToIntegers(_ repeatDays: [String]) -> Set<Int> {
            let weekdayMapping: [String: Int] = [
                "Sunday": 1,
                "Monday": 2,
                "Tuesday": 3,
                "Wednesday": 4,
                "Thursday": 5,
                "Friday": 6,
                "Saturday": 7
            ]
            
            let mappedDays = repeatDays.compactMap { weekdayMapping[$0] }
            return Set(mappedDays)
        }
        
        if let nextAlarm = activeAlarms.min(by: { alarm1, alarm2 in
            let repeatDays1 = mapRepeatDaysToIntegers(alarm1.repeatDays)
            let repeatDays2 = mapRepeatDaysToIntegers(alarm2.repeatDays)
            
            let nextTime1 = AlarmUtils.nextOccurrence(of: alarm1.time, calendar: calendar, now: now, repeatDays: repeatDays1)
            let nextTime2 = AlarmUtils.nextOccurrence(of: alarm2.time, calendar: calendar, now: now, repeatDays: repeatDays2)
            
            return nextTime1 < nextTime2
        }) {
            let repeatDays = mapRepeatDaysToIntegers(nextAlarm.repeatDays)
            let nextOccurrence = AlarmUtils.nextOccurrence(of: nextAlarm.time, calendar: calendar, now: now, repeatDays: repeatDays)
            remainingTimeMessage = AlarmUtils.remainingTimeMessage(for: nextOccurrence)
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
