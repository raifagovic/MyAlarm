//
//  ContentView.swift
//  MyAlarm
//
//  Created by Raif Agovic on 20. 10. 2024..
//

import SwiftUI

struct ContentView: View {
    @State private var alarms = [Alarm(time: "00:50")]
    @State private var isEditing = false
    @State private var selectedAlarm: Alarm?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                // List of alarms
                if alarms.isEmpty {
                    Spacer()
                    Text("No alarms set")
                        .font(.headline)
                        .foregroundColor(Color(hex: "#A1A1A6"))
                    Spacer()
                } else {
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
                Spacer()
            }
            .background(Color(hex: "#1C1C1E"))
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
                .darkSheetBackground()
            }
            .onAppear {
                setRootBackgroundColor()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(alarms.isEmpty ? "No alarms set" : "Alarms Active")
                        .font(.headline)
                        .foregroundColor(Color(hex: "#A1A1A6"))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        alarms.append(Alarm(time: "00:50"))
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(Color(hex: "#F1F1F1"))
                    }
                }
            }
            .toolbarBackground(Color.clear, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
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
