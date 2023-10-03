//
//  PlayView2.swift
//  HypnoLoopsRecordTest2
//
//  Created by Joey Rubin on 9/19/23.
//

import SwiftUI

struct PlayView2: View {
    @ObservedObject var audioManager: AudioManager
    @State private var textFieldInput: String = "Record name"
    
  //  @Binding var selectedRecording: URL?

    @State var selectedRecording: URL?
    @State var selectedSoundScape: URL?
    
    @State private var activeSheet: ActiveSheet?
    @State private var settingsDetent = PresentationDetent.medium
    
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
                    .frame(width: 300, height: 100, alignment: .center)
                    .padding(5)
                
                ZStack {
                    AnimationTest(audioManager: audioManager, audioURLToPlay: selectedRecording, musicURLToPlay: selectedSoundScape,  startSymbol: "stop.fill", stopSymbol: "play" )
                }
                
                HStack {
                    Button(action: {
                       self.activeSheet = .settings
                       print("Settings pressed!")
                   }) {
                       Image(systemName: "slider.horizontal.3")
                   }
                   .font(.title)
                   .padding(5)
                   
                   Spacer()
                    
                    Text(audioManager.timeRemaining.stringFromTimeInterval())
                    Text("/")
                    Text(audioManager.musicDuration.stringFromTimeInterval())
                    
                    Spacer()
                    
                    Button(action: {
                        
                        print("Repeat pressed!")
                    }) {
                        Image(systemName: "repeat")
                    }
                    .font(.title)
                    .padding(5)
                }
                .foregroundColor(.white)
                .frame(width: 300, height: 50)
                
                VStack(spacing: 10) {
                    //Soundscape Button
                    HStack {
                        Text("Sounds: \(selectedSoundScape?.deletingPathExtension().lastPathComponent ?? "None")" )
                            .foregroundColor(.white)
                            .frame(width: 300, height: 40)
                            .padding(.leading, 3)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white, lineWidth: 1)
                                    
                            )
                            .onTapGesture {
                                self.activeSheet = .soundScape
                            }
                    }
                    
                    
                    // Recording Button
                    HStack {
//                        Text("Recording:")
//                            .foregroundColor(.white)
                        
                        Text("Recording: \(selectedRecording?.deletingPathExtension().lastPathComponent ?? "None")")
                            .foregroundColor(.white)
                            .frame(width: 300, height: 40)
                            .padding(.leading, 3)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white, lineWidth: 1)
                                    
                            )
                            .onTapGesture {
                                self.activeSheet = .recordings
                            }
                    }
                }
                Spacer()
            }
        }
        .sheet(item: $activeSheet) { item in
            switch item {
            case .settings:
                PlaySettingsView(audioManager: audioManager)
                    .presentationDetents(
                        [.medium, .large],
                        selection: $settingsDetent
                    )
            case .soundScape:
                SoundScapeView() { url in
                    self.selectedSoundScape = url
                    //audioManager.musicURLToPlay = url
                }
                    .presentationDetents(
                        [.medium, .large],
                        selection: $settingsDetent
                    )
            case .recordings:
                RecordingsView(audioManager: audioManager, showSelectButton: true) { url in
                    self.selectedRecording = url
                    //audioManager.audioURLToPlay = url
                }
                .presentationDetents(
                    [.medium, .large],
                    selection: $settingsDetent
                )
            }
        }
        
        .onAppear {
            if selectedRecording == nil {
                if let recording = audioManager.recordings.first {
                    selectedRecording = recording
                }
            }
            if selectedSoundScape == nil {
                let musicURL = Bundle.main.url(forResource: "ocean_waves", withExtension: "mp3")
                selectedSoundScape = musicURL
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

struct PlayView2_Previews: PreviewProvider {
    //@State static var selectedRecordingPreview: URL? = AudioManager().recordings.first

      static var previews: some View {
          //PlayView2(audioManager: AudioManager(), selectedRecording: $selectedRecordingPreview)
          PlayView2(audioManager: AudioManager())
      }
}

extension TimeInterval {
    func stringFromTimeInterval() -> String {
        let time = NSInteger(self)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }
}
