//
//  AudioLoopView.swift
//  HypnoLoopsRecordTest2
//
//  Created by Joey Rubin on 9/21/23.
//

import SwiftUI

struct AudioLoopView: View {
    @ObservedObject var audioManager: AudioManager
    @State private var isLooping: Bool = false
    //let loopDuration: Double = 30.0 // seconds

    // Assuming each loop consists of playing two recordings
     //@State private var isPlayingFirstAudio: Bool = true
    
    var body: some View {
        Button(action: togglePlayback) {
            Text(isLooping ? "Stop Loop" : "Start Loop")
        }
    }

    func togglePlayback() {
        isLooping.toggle()
        if isLooping {
            startLooping()
            if let musicURL = Bundle.main.url(forResource: "ocean15", withExtension: "mp3") {
                audioManager.startMusic(url: musicURL)
            }
        } else {
            stopLooping()
        }
    }

    func stopLooping() {
        audioManager.stopMusic()
        audioManager.stopPlaying()
        audioManager.onLoopShouldRestart = nil
        audioManager.audioPlayer = nil
        audioManager.audioPlayerSecond = nil
    }



    func startLooping() {
        guard !audioManager.recordings.isEmpty else { return }
        let loopAudioURL = audioManager.recordings.first!
        
        audioManager.onLoopShouldRestart = {
            self.startLooping()
        }
        
        audioManager.playRecordingSpecial(url: loopAudioURL)
    }

    
//    func playNextAudio() {
//        let audioURL = isPlayingFirstAudio ? audioManager.recordings[0] : audioManager.recordings[1]
//
//        if !isPlayingFirstAudio {
//            // If we are playing the second audio, we want to restart the loop when it's halfway done
//            let secondAudioDuration = audioManager.getDuration(of: audioURL)
//            Timer.scheduledTimer(withTimeInterval: secondAudioDuration / 2, repeats: false) { _ in
//                if self.isLooping {
//                    self.isPlayingFirstAudio = true
//                    self.playNextAudio()
//                }
//            }
//        }
//
//        audioManager.playRecordingSpecial(url: audioURL)
//
//        // Flip the flag
//        isPlayingFirstAudio.toggle()
//    }


//    func playLoopedAudio(for duration: Double, url: URL) {
//        let playbackEndTime = Date().addingTimeInterval(duration)
//        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
//            if !isLooping || Date() > playbackEndTime {
//                timer.invalidate()
//                audioManager.stopPlaying()
//            } else if !audioManager.isPlaying {
//                audioManager.playRecordingSpecial(url: url)
//            }
//        }
//    }
}

struct AudioLoopView_Previews: PreviewProvider {
    static var previews: some View {
        AudioLoopView(audioManager: AudioManager())
    }
}
