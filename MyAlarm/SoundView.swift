//
//  SoundView.swift
//  MyAlarm
//
//  Created by Raif Agovic on 18. 2. 2025..
//

import SwiftUI
import AVFoundation

struct SoundView: View {
    @Binding var selectedSound: String
    @State private var audioPlayer: AVAudioPlayer?

    let sounds = ["beep", "bell", "casio", "centaurus", "digital", "threat", "warning"] 

    var body: some View {
        Form {
            Section {
                ForEach(sounds, id: \.self) { sound in
                    HStack {
                        Text(sound.capitalized)
                            .foregroundColor(Color(hex: "#F1F1F1"))
                        Spacer()
                        if sound == selectedSound {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color(hex: "#FFD700"))
                                .bold()
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectSound(sound)
                    }
                }
            }
        }
        .environment(\.colorScheme, .dark)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Select Sound")
                    .foregroundColor(Color(hex: "#F1F1F1"))
                    .font(.headline)
            }
        }
    }

    private func selectSound(_ sound: String) {
        selectedSound = sound
        playSound(named: sound)
    }

    private func playSound(named sound: String) {
        guard let url = Bundle.main.url(forResource: sound, withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}
