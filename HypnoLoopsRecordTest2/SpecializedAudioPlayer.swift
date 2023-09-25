////
////  SpecializedAudioPlayer.swift
////  HypnoLoopsRecordTest2
////
////  Created by Joey Rubin on 9/21/23.
////
//
//import Foundation
//import SwiftUI
//import AVFoundation
//
//class SpecializedAudioPlayer: NSObject, ObservableObject {
//    private var audioManager: AudioManager
//    private var audioEngine: AVAudioEngine!
//    private var audioPlayerNode: AVAudioPlayerNode!
//    private var reverbEffect: AVAudioUnitReverb!
//    
//    //private var audioRecorder: AVAudioRecorder?
//    private var audioPlayer: AVAudioPlayer?
//    private var audioPlayerSecond: AVAudioPlayer?
//
//    
//    //@Published var recordings: [URL] = []
//    //@Published var isRecording = false
//    @Published var isPlaying = false
//    
//    @Published var currentlyPlayingURL: URL?
//    
//    var isPlayingSecondAudio = false
//
//    
//    init(audioManager: AudioManager) {
//        self.audioManager = audioManager
//    }
//    
//    deinit {
//        print("SpecializedAudioPlayer deinitialized!")
//    }
//    
//    func setupAudioEngine(withFile url: URL) {
//        audioEngine = AVAudioEngine()
//        audioPlayerNode = AVAudioPlayerNode()
//        reverbEffect = AVAudioUnitReverb()
//
//        reverbEffect.loadFactoryPreset(.cathedral)
//        reverbEffect.wetDryMix = 100.0 // Adjust to taste
//
//        audioEngine.attach(audioPlayerNode)
//        audioEngine.attach(reverbEffect)
//
//        let audioFile = try! AVAudioFile(forReading: url)
//        audioEngine.connect(audioPlayerNode, to: reverbEffect, format: audioFile.processingFormat)
//        audioEngine.connect(reverbEffect, to: audioEngine.mainMixerNode, format: audioFile.processingFormat)
//
//        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
//    }
//
//    
////    func playRecordingWithReverbAndOverlap(url: URL) {
////        // ... Same code as previously described for reverb and overlapped playback
////    }
//    
//    func playRecordingWithReverbAndOverlap(url: URL) {
//        print("PLayRecordingWithVerb")
//        do {
//            if isPlaying {
//                audioPlayer?.stop()
//                audioPlayerSecond?.stop()
//                isPlaying = false
//                currentlyPlayingURL = nil
//                isPlayingSecondAudio = false // Reset this here
//                return
//            }
//            
//            audioPlayer = try AVAudioPlayer(contentsOf: url)
//            audioPlayer?.delegate = self
//            audioPlayer?.play()
//            isPlaying = true
//            currentlyPlayingURL = url
//            
//            isPlayingSecondAudio = false // Ensure it is false when starting playback
//            
//            // Schedule the second audio to play when the first one is halfway finished
//            //let delay = audioPlayer?.duration ?? 0 - (1/200)
//            let delay = (audioPlayer?.duration ?? 0) * 0.5
//            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
//                print("Scheduling second audio playback")  // Log
//                self.playSecondVersionOfAudio(url: url)
//            }
//
//        } catch {
//            print("Failed to play recording: \(error)")
//            isPlaying = false
//            currentlyPlayingURL = nil
//        }
//    }
//
//    
//    func playSecondVersionOfAudio(url: URL) {
//        print("playsecondVersionOFAudio")
//        do {
//            self.audioPlayerSecond = try AVAudioPlayer(contentsOf: url)
//            self.audioPlayerSecond?.delegate = self
//            self.audioPlayerSecond?.volume = 0.5 // 50% reduced volume
//            self.audioPlayerSecond?.play()
//            self.isPlayingSecondAudio = true // Now playing the second audio
//        } catch {
//            print("Failed to play second audio: \(error)")
//        }
//    }
//    
//    func stopPlaying() {
//        audioPlayer?.stop()
//        audioPlayerNode.stop()
//        audioEngine.stop()
//        audioEngine.reset()
//        isPlaying = false
//        currentlyPlayingURL = nil
//    }
//
//
//    
//    // ... Other specialized functions can go here
//}
//
//extension SpecializedAudioPlayer: AVAudioPlayerDelegate {
//    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        if player == audioPlayer {
//            print("SpecializedAudioPlayer: First audio finished playing")
//        } else if player == audioPlayerSecond {
//            print("SpecializedAudioPlayer: Second audio finished playing")
//            isPlaying = false
//            currentlyPlayingURL = nil
//            isPlayingSecondAudio = false
//        } else {
//            print("SpecializedAudioPlayer: Unknown player finished playing")
//        }
//    }
//}
//
