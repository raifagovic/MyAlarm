//
//  AlarmRingingView.swift
//  MyAlarm
//
//  Created by Raif Agovic on 24. 3. 2025..
//

import SwiftUI

struct AlarmRingingView: View {
    @Binding var isAlarmRinging: Bool
    var stopAlarm: () -> Void
    var snoozeAlarm: () -> Void

    var body: some View {
        VStack {
            Text("Alarm Ringing!")
                .font(.largeTitle)
                .padding()

            Text("Time to wake up!")
                .font(.title2)

            Spacer()

            HStack {
                Button(action: snoozeAlarm) {
                    Text("Snooze")
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: stopAlarm) {
                    Text("Stop")
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .background(Color.black.opacity(0.9))
        .foregroundColor(.white)
        .edgesIgnoringSafeArea(.all)
    }
}
