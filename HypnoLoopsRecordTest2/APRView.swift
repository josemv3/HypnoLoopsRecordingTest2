//
//  APRView.swift
//  HypnoLoopsRecordTest2
//
//  Created by Joey Rubin on 9/20/23.
//  Animation Play and Record

import SwiftUI

class AnimationTestViewModel: ObservableObject {
    @Published var isAnimating: Bool = false
    @Published var currentSymbol: String = "play.fill"
    var audioManager: AudioManager
    
    @Binding var audioURLToPlay: URL?
    
    init(audioManager: AudioManager, audioURLToPlay: Binding<URL?>) {
        self.audioManager = audioManager
        _audioURLToPlay = audioURLToPlay
    }
    
    func toggleAnimationAndAudio() {
        if currentSymbol == "mic.fill" {
            if audioManager.isRecording {
                audioManager.stopRecording()
            } else {
                audioManager.startRecording()
            }
        } else if currentSymbol == "play.fill" {
            if audioManager.isPlaying {
                audioManager.stopPlaying()
            } else {
                let playbackURL = audioURLToPlay ?? audioManager.recordings.last
                if let url = playbackURL {
                    audioManager.startPlaying(audioURL: url)
                }
            }
        }
        toggleAnimation()
    }
    
    private func toggleAnimation() {
        isAnimating.toggle()
    }
}


struct APRView: View {
    @ObservedObject var viewModel: AnimationTestViewModel

       @State private var scale1: CGFloat = 1.0
       @State private var scale2: CGFloat = 1.0
       @State private var scale3: CGFloat = 1.0
       
       var body: some View {
           ZStack {
               // ... all your circles here ...
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

               Button(action: viewModel.toggleAnimationAndAudio) {
                   Image(systemName: viewModel.isAnimating ? viewModel.currentSymbol : "play")
                       .font(Font.system(size: 50))
                       .foregroundColor(viewModel.isAnimating ? .red : .white)
               }
           }
           .onChange(of: viewModel.isAnimating) { newValue in
               if newValue {
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
               } else {
                   // Stop the animation
                   withAnimation(Animation.default) {
                       scale1 = 1.0
                       scale2 = 1.0
                       scale3 = 1.0
                   }
               }
           }
       }
   }





struct APRView_Previews: PreviewProvider {
    @State static var selectedRecordingPreview: URL? = AudioManager().recordings.first

    static var previews: some View {
        APRView(viewModel: AnimationTestViewModel(audioManager: AudioManager(), audioURLToPlay: $selectedRecordingPreview))
        //AnimationTest(viewModel: AnimationTestViewModel(audioManager: AudioManager()))
      
    }
}
