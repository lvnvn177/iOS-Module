//
//  File.swift
//  
//
//  Created by 이영호 on 9/28/24.
//

import AVFoundation

public class AudioPlayerManager: NSObject {
    
    public static let shared = AudioPlayerManager()
    
    public var audioPlayer: AVAudioPlayer?
    
    private override init() {
        super.init()
        setupAudioSession()
    }
    
    public func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
            print("Audio session is set up for background playback.")
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    public func playBackgroundAudio (named fileName: String, withExtension ext: String) {
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
    
    public func stopAudio() {
        audioPlayer?.stop()
        print("Audio stopped")
    }
}
