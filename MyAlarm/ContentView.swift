//
//  ContentView.swift
//  MyAlarm
//
//  Created by Raif Agovic on 20. 10. 2024..
//

import SwiftUI

struct Alarm: Identifiable, Hashable {
    let id = UUID()
    var time: String
}

struct AlarmView: View {
    @Binding var alarms: [Alarm]
    var alarm: Alarm
    @State private var isAlarmOn = false
    @State private var showDelete = false
    @State private var showEditor = false

    var body: some View {
        ZStack {
            // Background showing delete button when swiped
            if showDelete {
                HStack {
                    Spacer()
                    Button(action: {
                        // Action to delete the alarm
                        if let index = alarms.firstIndex(of: alarm) {
                            alarms.remove(at: index)
                        }
                    }) {
                        Text("Delete")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                    .padding(.trailing)
                }
            }
            
            // Main alarm view
            HStack {
                VStack(alignment: .leading) {
                    Text(alarm.time)
                        .font(.largeTitle)
                        .bold()
                    Text("Label")
                    HStack {
                        ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                            Text(day)
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                }
                Spacer()
                Toggle(isOn: $isAlarmOn) {
                }
                .labelsHidden()
            }
            .padding()
            .background(Color(.systemGray5))
            .cornerRadius(10)
            .offset(x: showDelete ? -150 : 0) // Add an offset when swiped
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width < -100 { // Swipe left to show delete
                            withAnimation {
                                showDelete = true
                            }
                        } else if value.translation.width > 100 { // Swipe right to hide delete
                            withAnimation {
                                showDelete = false
                            }
                        }
                    }
            )
            .frame(maxWidth: .infinity, maxHeight: 100)
            .padding()
            .onTapGesture {
                showEditor = true  // Show the alarm editor when tapped
            }
            .sheet(isPresented: $showEditor) {
                AlarmEditorView(isPresented: $showEditor)
            }
        }
    }
}

struct ContentView: View {
    @State private var alarms = [Alarm(time: "00:50")]
    
    var body: some View {
        ZStack {
            // Display all alarms with "Rings in ..." message at the top
            VStack(alignment: .leading) {
                Text("Rings in ...")
                    .font(.headline)
                    .padding(.top)
                    .padding(.leading)
                
                ForEach(alarms) { alarm in
                    AlarmView(alarms: $alarms, alarm: alarm)
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
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    .padding()
                }
            }
        }
    }
}

// New view for the alarm editor
struct AlarmEditorView: View {
    @Binding var isPresented: Bool
    @State private var selectedTime = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker("Select Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()  // Hide the default "Select Time" label
                    .padding()
                
                Spacer()
            }
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                },
                trailing: Button("Save") {
                    isPresented = false
                    // Add save functionality here
                }
            )
            .navigationBarTitle("Edit Alarm", displayMode: .inline)
        }
    }
}

#Preview {
    ContentView()
}
