//
//  AlarmSoundPlayer.swift
//  MyAlarm
//
//  Created by Raif Agovic on 11. 6. 2025..
//

import AVFoundation

var audioPlayer: AVAudioPlayer?

func startAlarmSound() {
    guard let url = Bundle.main.url(forResource: "alarm", withExtension: "mp3") else {
        print("Alarm sound file not found.")
        return
    }

    do {
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try AVAudioSession.sharedInstance().setActive(true)

        audioPlayer = try AVAudioPlayer(contentsOf: url)
        audioPlayer?.numberOfLoops = -1 // Infinite loop
        audioPlayer?.play()
    } catch {
        print("Failed to play sound: \(error)")
    }
}

func stopAlarmSound() {
    audioPlayer?.stop()
    audioPlayer = nil
}
