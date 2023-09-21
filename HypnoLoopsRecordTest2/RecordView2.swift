//
//  RecordView3.swift
//  HypnoloopsSwiftUI
//
//  Created by Joey Rubin on 9/9/23.
//

import SwiftUI

enum ActiveSheet: Identifiable {
    case settings, soundScape, recordings

    var id: Int {
        hashValue
    }
}

struct RecordView2: View {
    @ObservedObject var audioManager: AudioManager
    @State private var textFieldInput: String = "Record name"
 
    @State private var activeSheet: ActiveSheet?
    @State private var settingsDetent = PresentationDetent.medium
    
//    let viewModel: AnimationTestViewModel
//
//      init(audioManager: AudioManager) {
//          self.audioManager = audioManager
//          self.viewModel = AnimationTestViewModel(audioManager: audioManager)
//          self.viewModel.currentSymbol = "mic.fill"
//      }
 
    
    var body: some View {
    
        ZStack {
            // Background Image
                      Image("oceanBG")
                          .resizable()
                          .scaledToFill()
                          .frame(maxWidth: .infinity, maxHeight: .infinity)
                          .edgesIgnoringSafeArea(.all)
            VStack {
                Image("hlLogo1")
                    .resizable()
                    .scaledToFit()
                    //.padding(5)
                    .frame(width: 300, height: 100, alignment: .center)
                
                ZStack {
                    AnimationTest(audioManager: audioManager, audioURLToPlay: nil, startSymbol: "mic.fill", stopSymbol: "mic")
                   
                    //APRView(viewModel: viewModel)
                              
                }
                
                //Circular Button
                Button(action: {
                    // insert your action here
                    if audioManager.isPlaying {
                        audioManager.stopPlaying()
                    } else {
                        // Play the latest recording 1 of 2
                        if let lastRecording = audioManager.recordings.first {
                            audioManager.startPlaying(audioURL: lastRecording)
                        }
                    }
                    print("Play button pressed!")
                }) {
                    Image(systemName: audioManager.isPlaying ? "stop.fill" : "play" )
                        .font(.largeTitle)
                        .foregroundColor(audioManager.isPlaying ? .red : .white)
                    
                        .frame(width: 100, height: 100, alignment: .center)
                        .background(Circle().fill(Color.clear))
                }
                .overlay(
                    Circle()
                        .stroke(Color("ringThirdBlue"), lineWidth: 1)
                )
                .padding(.vertical, 30)
                
                Text("Your chosen affirmation here...")
                    .foregroundColor(.white)
                    .opacity(0.8)
                
                HStack {
                    let lastRecordingName = audioManager.recordings.first?.deletingPathExtension().lastPathComponent
                    Text("Recording:")
                        .foregroundColor(.white)
                    
                    Text(lastRecordingName ?? "None")
                        .foregroundColor(.white)
                        .frame(width: 250, height: 40)
                        .padding(.leading, 3)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white, lineWidth: 1)
                                
                        )
                        .onTapGesture {
                            self.activeSheet = .recordings
                        }
                }
                    
                Spacer()
            }
        }
        .sheet(item: $activeSheet) { item in
            switch item {
            case .settings:
                EmptyView()
                    .presentationDetents(
                        [.medium, .large],
                        selection: $settingsDetent
                    )
            case .soundScape:
                EmptyView()
                    .presentationDetents(
                        [.medium, .large],
                        selection: $settingsDetent
                    )
            case .recordings:
                RecordingsView(audioManager: audioManager)
                    .presentationDetents(
                        [.medium, .large],
                        selection: $settingsDetent
                    )
            }
        }
    }
    private var fileNameInputView: some View {
        HStack {
            Text("File Name")
                .font(.subheadline)
            Spacer()
        }
        .padding(.trailing, 5)
    }
}



