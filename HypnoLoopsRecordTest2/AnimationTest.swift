//
//  AnimationTest.swift
//  HypnoloopsSwiftUI
//
//  Created by Joey Rubin on 9/9/23.
//

import SwiftUI
import Combine


struct AnimationTest: View {
    @ObservedObject var audioManager: AudioManager
    
    
    @State private var scale1: CGFloat = 1.0
    @State private var scale2: CGFloat = 1.0
    @State private var scale3: CGFloat = 1.0
    @State private var animate: Bool = false
    @State private var pulseSmallCircle: Bool = true
    
    var audioURLToPlay: URL?  // New property for the specific URL
    var startSymbol: String
    var stopSymbol: String
    
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
                //toggleAnimation()
                handleAudioControl()
                toggleVisualAnimation()
            }) {
                Image(systemName: animate ? startSymbol : stopSymbol)
                    .font(Font.system(size: 50))  // Adjust the font size as needed
                    .foregroundColor(animate ? .red : .white)
            }
        }
        .onChange(of: audioManager.isPlaying) { isPlaying in
            if !isPlaying {
                
                self.animate = false
                print("onChange", animate)
                toggleVisualAnimation()
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
            if audioManager.isPlaying {
                audioManager.stopPlaying()
                animate = false
            } else {
                let playbackURL = audioURLToPlay ?? audioManager.recordings.last
                if let url = playbackURL {
                    audioManager.startPlaying(audioURL: url)
                    animate = true
                }
            }
        }
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

    
    
    
    
    
    
    
    
    
    
    
    
//og toggle:
//        func toggleAnimation() {
////            if animate == true {
////                animate = false
////            }
//            // Check if it's the "mic" symbol and handle audio recording.
//             if startSymbol == "mic.fill" {
//                 //pulseSmallCircle = false
//
//                 if audioManager.isRecording {
//                     audioManager.stopRecording()
//                     animate = false
//
//                 } else {
//                     audioManager.startRecording()
//                     animate = true
//                 }
//             }
//             // Check if it's the "play" symbol and handle audio playing.
//            else if startSymbol == "stop.fill" {
//                if audioManager.isPlaying {
//                    audioManager.stopPlaying()
//                    animate = false
//                    //toggleAnimation()
//                } else {
//                    // Use the specific URL if available, otherwise fallback to the last recording.
//                    let playbackURL = audioURLToPlay ?? audioManager.recordings.last
//                    if let url = playbackURL {
//                        audioManager.startPlaying(audioURL: url)
//                        animate = true
//                    }
//                }
//            }
//
//            if !animate {
//                // Stop the animation
//                withAnimation(Animation.default) {
//                    scale1 = 1.0
//                    scale2 = 1.0
//                    scale3 = 1.0
//                }
//            } else {
//                // Start the animation
//                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true).delay(0.2)) {
//                    scale1 = 1.2
//                }
//
//                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true).delay(0.4)) {
//                    scale2 = 1.2
//                }
//
//                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true).delay(0.6)) {
//                    scale3 = 1.2
//                }
//            }
//            //animate.toggle()
//        }
}



//struct AnimationTest_Previews: PreviewProvider {
//    static var previews: some View {
//        AnimationTest(startSymbol: "play.fill", stopSymbol: "play")
//    }
//}
