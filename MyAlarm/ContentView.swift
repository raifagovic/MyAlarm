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
                                alarms: $alarms,
                                alarm: alarm,
                                onEdit: {
                                    selectedAlarm = alarm
                                    isEditing = true
                                }
                            )
                        }
                    }
                }
            }
            .sheet(item: $selectedAlarm) { alarmToEdit in
                AlarmEditorView(
                    isPresented: $isEditing,
                    selectedAlarm: alarmToEdit,
                    onDelete: {
                        if let index = alarms.firstIndex(where: { $0.id == alarmToEdit.id }) {
                            alarms.remove(at: index)
                        }
                        selectedAlarm = nil // Clear the selected alarm when the sheet is dismissed
                    },
                    onCancel: {
                        selectedAlarm = nil // Dismiss the sheet when cancel is pressed
                    }
                )
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if alarms.contains(where: { $0.isOn }) {
                        Text("Alarm is active")
                            .foregroundColor(Color(hex: "#FFD700"))
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
