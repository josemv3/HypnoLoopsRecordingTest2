//
//  PlayView.swift
//  HypnoLoopsRecordTest2
//
//  Created by Joey Rubin on 9/19/23.
//

import SwiftUI

struct PlayView: View {
    @ObservedObject var audioManager: AudioManager
    
    @State private var selectedRecording: URL?
   // @State private var currentRecording: URL?
    @State private var activeSheet: ActiveSheet?
    @State private var settingsDetent = PresentationDetent.medium
    //audioManager.recordings.first.deletingPathExtension().lastPathComponent
    
    var body: some View {
        VStack {
            
            if let recording = selectedRecording {
                // Show your player UI here with the selected recording
                Text("Now Playing: \(recording.lastPathComponent)")
                
                // ... other controls for playback, etc.
            } else {
                Text("No recording selected")
            }
        
            Text("HERE")
                .onTapGesture {
                    self.activeSheet = .recordings
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
                RecordingsView(audioManager: audioManager, showSelectButton: true) { url in
                    self.selectedRecording = url
                    //self.currentRecording = url
                    //print("SELECTED!", self.currentRecording)
                }
                .presentationDetents(
                    [.medium, .large],
                    selection: $settingsDetent
                )
            }
        }
        .onAppear {
//            if let lastRecording =  audioManager.recordings.first {
//                currentRecording = lastRecording
//                print("Current Recording", currentRecording ?? URL(fileURLWithPath: "Sample.mp4"))
//            }
            if let recording = audioManager.recordings.first {
                selectedRecording = recording
            }
        }
    }
}


struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView(audioManager: AudioManager())
    }
}
