//
//  AlarmSoundPlayer.swift
//  MyAlarm
//
//  Created by Raif Agovic on 11. 6. 2025..
//

import AVFoundation

var audioPlayer: AVAudioPlayer?

func startAlarmSound(named sound: String) {
    guard let url = Bundle.main.url(forResource: sound, withExtension: "mp3") else {
        print("Alarm sound file not found: \(sound)")
        return
    }

    do {
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try AVAudioSession.sharedInstance().setActive(true)

        audioPlayer = try AVAudioPlayer(contentsOf: url)
        audioPlayer?.numberOfLoops = -1
        audioPlayer?.play()
    } catch {
        print("Failed to play sound: \(error)")
    }
}

func stopAlarmSound() {
    audioPlayer?.stop()
    audioPlayer = nil
}
