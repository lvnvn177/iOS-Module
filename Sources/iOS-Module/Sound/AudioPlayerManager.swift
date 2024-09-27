//
//  File.swift
//  
//
//  Created by 이영호 on 9/28/24.
//

import AVFoundation

class AudioPlayerManager: NSObject {
    
    static let shared = AudioPlayerManager()
    
    var audioPlayer: AVAudioPlayer?
    
    override init() {
        super.init()
        setupAudioSession()
    }
    
    func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
            print("Audio session is set up for background playback.")
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    func playBackgroundAudio (named fileName: String, withExtension ext: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: ext) else {
            print("Audio file not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            print("Audio is playing")
        } catch {
            print("Failed to play audio: \(error)")
        }
    }
    
    func stopAudio() {
        audioPlayer?.stop()
        print("Audio stopped")
    }
}
