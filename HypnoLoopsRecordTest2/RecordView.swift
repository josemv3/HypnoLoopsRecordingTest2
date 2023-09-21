// RecorderView.swift

import SwiftUI

struct RecordView: View {
    
    @ObservedObject var audioManager: AudioManager
   // @State private var recordingBeingEdited: URL? = nil
    //@State private var editedName: String = ""
    //@State private var isShowingEditAlert: Bool = false
    
    @State private var activeSheet: ActiveSheet?
    @State private var settingsDetent = PresentationDetent.medium

    enum ActiveSheet: Identifiable {
        case settings, soundScape, recordings

        var id: Int {
            hashValue
        }
    }
    
    var body: some View {
        VStack {
            // Recording Controls
            HStack {
                Button(action: {
                    if audioManager.isRecording {
                        audioManager.stopRecording()
                    } else {
                        audioManager.startRecording()
                    }
                }) {
                    Text(audioManager.isRecording ? "Stop Recording" : "Start Recording")
                }
                
                Button(action: {
                    if audioManager.isPlaying {
                        audioManager.stopPlaying()
                    } else {
                        // Play the latest recording 1 of 2
                        if let lastRecording = audioManager.recordings.first {
                            audioManager.startPlaying(audioURL: lastRecording)
                        }
                    }
                }) {
                    Text(audioManager.isPlaying ? "Stop Playing" : "Play Last Recording")
                }
            }
            // Somewhere within your RecordView body
           
            HStack{
                //play last 2 of 2
                let lastRecordingName = audioManager.recordings.first?.deletingPathExtension().lastPathComponent
                Text("Recording:")
                Text(lastRecordingName ?? "None")
                    .foregroundColor(.cyan)
            
            }
            .padding()
            Text("Show List")
            VStack {
                HStack {
                    Button(action: {
                        self.activeSheet = .recordings
                    }) {
                        HStack {
                            Text("Edit Recordings")
                            Image(systemName: "record.circle")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.cyan)
                        .cornerRadius(8)
                    }
                    .buttonStyle(.plain)

                    Text("Edit here")
                        .font(.subheadline)
                    Spacer()
                }
                
            }
            .padding(.horizontal, 10)

            // makes Text only show if it has value
            if let lastRecordingURL = audioManager.recordings.last {
                Text(lastRecordingURL.deletingPathExtension().lastPathComponent)
                    .padding()
            }
        
             //List of recordings

            
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
}

struct RecorderView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView(audioManager: AudioManager())
    }
}

extension URL: Identifiable {
    public var id: String {
        self.absoluteString
    }
}
