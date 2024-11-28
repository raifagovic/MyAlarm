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
            
            // Display all alarms with "Rings in ..." message at the top
            VStack(alignment: .leading) {
                Text("No alarms set")
                    .font(.headline)
//                    .foregroundColor(Color(hex: "#FFD700"))
//                    .foregroundColor(Color(hex: "#F1F1F1"))
                    .foregroundColor(Color.gray)
//                    .foregroundColor(Color(UIColor.systemOrange))
                    .padding(.top)
                    .padding(.leading)
                
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
            
            // Plus button at the bottom-right corner
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        alarms.append(Alarm(time: "00:50")) // Add a new unique identifier
                    }) {
                        Image(systemName: "plus")
                            .padding()
                            .background(Color(hex: "#FFD700"))
                            .foregroundColor(Color(hex: "#1C1C1E"))
//                            .background(Color(UIColor.systemOrange))
                            .clipShape(Rectangle())
                            .cornerRadius(15)
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            if let alarmToEdit = selectedAlarm {
                AlarmEditorView(
                    isPresented: $isEditing,
                    selectedAlarm: alarmToEdit, // Pass the selected alarm
                    onDelete: {
                        if let index = alarms.firstIndex(where: { $0.id == alarmToEdit.id }) {
                            alarms.remove(at: index)
                        }
                        selectedAlarm = nil // Clear the selected alarm
                    }
                )
            }
        }
    }
}

#Preview {
    ContentView()
}
