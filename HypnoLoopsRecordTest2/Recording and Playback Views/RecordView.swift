//
//  RecordView3.swift
//  HypnoloopsSwiftUI
//
//  Created by Joey Rubin on 9/9/23.
//

import SwiftUI

enum ActiveSheet: Identifiable {
    case settings, soundScape, recordings, affirmation

    var id: Int {
        hashValue
    }
}

struct RecordView: View {
    @ObservedObject var audioManager: AudioManager
    @ObservedObject var viewModel: CategoryViewModel
    @State private var textFieldInput: String = "Record name"
 
    @State private var activeSheet: ActiveSheet?
    @State private var settingsDetent = PresentationDetent.medium
    
    @State private var selectedAffirmation: String?
    @State private var showAlert: Bool = false


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
                    MainButtonAnimationView(audioManager: audioManager, startSymbol: "stop", stopSymbol: "mic")
                }
                
                //Spacer()
                //Circular Button
                Button(action: {
                    // insert your action here
                    if audioManager.recordings.isEmpty {
                          showAlert = true
                      } else {
                          if audioManager.isPlaying {
                              audioManager.stopPlaying()
                          } else {
                              if let lastRecording = audioManager.recordings.first {
                                  audioManager.startPlaying(audioURL: lastRecording)
                              }
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
                
                Text(selectedAffirmation ?? "No Affirmation Selected")

                    .onTapGesture {
                        self.activeSheet = .affirmation
                    }
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
            case .affirmation:
                LikedAffirmationView(viewModel: viewModel, selectedAffirmation: $selectedAffirmation)
                    .padding(.top, 10)
                    .presentationDetents(
                        [.large],
                        selection: $settingsDetent
                    )
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("No Recordings"), message: Text("Please record an affirmation."), dismissButton: .default(Text("OK")))
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



