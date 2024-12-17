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
        ZStack {
            Color(hex: "#1C1C1E")
                .edgesIgnoringSafeArea(.all) // Extend to edges
            
            // Main content
            VStack(alignment: .leading) {
                // Top row with text and plus button
                HStack {
                    Text("No alarms set")
                        .padding(.leading, 10)
                        .font(.headline)
                        .foregroundColor(Color(hex: "#A1A1A6"))
//                        .foregroundColor(Color(hex: "#FFD700"))
                    Spacer()
                    Button(action: {
                        alarms.append(Alarm(time: "00:50")) // Add a new unique identifier
                    }) {
                        Image(systemName: "plus")
                            .padding(.trailing, 10)
                            .foregroundColor(Color(hex: "#F1F1F1"))
                    }
                }
                .padding(.top)
                .padding(.horizontal) // Horizontal padding for both text and button
                
                // List of alarms
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
                Spacer()
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
                    selectedAlarm = nil // Clear the selected alarm
                }
            )
            .darkSheetBackground()
        }
        .onAppear {
            setRootBackgroundColor()
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
