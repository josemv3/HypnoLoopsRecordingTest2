//
//  AnimationTest.swift
//  HypnoloopsSwiftUI
//
//  Created by Joey Rubin on 9/9/23.
//

import SwiftUI
import Combine


struct MainButtonAnimationView: View {
    @ObservedObject var audioManager: AudioManager
    
    
    @State private var scale1: CGFloat = 1.0
    @State private var scale2: CGFloat = 1.0
    @State private var scale3: CGFloat = 1.0
    @State private var animate: Bool = false
    @State private var pulseSmallCircle: Bool = true
    
    var audioURLToPlay: URL?  // New property for the specific URL
    var musicURLToPlay: URL?
    var startSymbol: String
    var stopSymbol: String
    
    @State private var isLooping: Bool = false
    let loopDuration: Double = 30.0 // seconds
    @State private var isPlayingFirstAudio: Bool = true
    
    var body: some View {
        
        ZStack {
            Circle()
                .fill(Color("ringThirdBlue"))
                .scaleEffect(scale1)
                .frame(width: 320, height: 320)
                .opacity(0.20)
            
            Circle()
                .fill(Color("ringThirdBlue"))
                .scaleEffect(scale2)
                .frame(width: 260, height: 260)
                .opacity(0.60)
                .shadow(color: .black.opacity(0.07), radius: 5, x: 5, y: 5)
            
            Circle()
                .fill(Color("ringSecondBlue"))
                .scaleEffect(scale3)
                .frame(width: 190, height: 190)
                .shadow(radius: 5)
            
            Circle()
                .fill(Color("ringDarkBlue"))
            //.scaleEffect(pulseSmallCircle ? 1.2 : 1.0)
                .frame(width: 140, height: 140)
                .shadow(color: .black.opacity(0.39), radius: 3, x: 5, y: 5)
            
            Button(action: {
                
                handleAudioControl()
                toggleVisualAnimation()
            }) {
                Image(systemName: animate ? startSymbol : stopSymbol)
                    .font(Font.system(size: 50))  // Adjust the font size as needed
                    .foregroundColor(animate ? .red : .white)
            }
        }
        .onChange(of: audioManager.isPlayingMusic) { isPlaying in
            if !isPlaying {
                
                self.animate = false
                print("onChange", animate)
                toggleVisualAnimation()
                stopAudio()
            }
        }
        .onChange(of: animate) { newValue in
            print(newValue)
        }
    }
    
    // Rename this function since it primarily controls the audio state.
    func handleAudioControl() {
        if startSymbol == "mic.fill" {
            if audioManager.isRecording {
                audioManager.stopRecording()
                animate = false
            } else {
                audioManager.startRecording()
                animate = true
            }
        } else if startSymbol == "stop.fill" {
            if audioManager.isPlayingMusic {
                stopAudio()
                animate = false
                
            } else {
                startAudio()
                animate = true
                print("MUSIC URL", musicURLToPlay)
            }
        }
    }
    
    func startAudio() {
        isLooping = true
        if isLooping {
            startLooping()
            if let musicURL = musicURLToPlay {
                // Use musicURL here
                audioManager.startMusic(url: musicURL)
            }
        }
    }
    
    func stopAudio() {
        isLooping = false
        audioManager.stopMusic()
        audioManager.stopPlaying()
        audioManager.onLoopShouldRestart = nil
        audioManager.audioPlayerSecond = nil
        audioManager.audioPlayer = nil
        
    }
    
    func startLooping() {
        guard !audioManager.recordings.isEmpty else { return }
        let defaultLoop =  audioManager.recordings.first!
        let loopAudioURL = audioURLToPlay ?? defaultLoop
        
        audioManager.onLoopShouldRestart = {
            self.startLooping()
        }
        
        audioManager.playRecordingSpecial(url: loopAudioURL)
    }
    
    
    
    // This function will handle the visual animations.
    func toggleVisualAnimation() {
        if !animate {
            // Stop the animation
            withAnimation(Animation.default) {
                scale1 = 1.0
                scale2 = 1.0
                scale3 = 1.0
            }
        } else {
            // Start the animation
            withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true).delay(0.2)) {
                scale1 = 1.2
            }
            
            withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true).delay(0.4)) {
                scale2 = 1.2
            }
            
            withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true).delay(0.6)) {
                scale3 = 1.2
            }
        }
    }
}
