//
//  RecordingsView.swift
//  HypnoLoopsRecordTest2
//
//  Created by Joey Rubin on 9/19/23.
//

import SwiftUI

struct RecordingsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var audioManager: AudioManager
    var showSelectButton: Bool = false
    var onSelect: ((URL) -> Void)?

    func selectRecording(_ url: URL) {
        onSelect?(url)
    }
    
    @State private var recordingBeingEdited: URL? = nil
    @State private var editedName: String = ""
    @State private var isShowingEditAlert: Bool = false

    //Accept AudioManager instance
    init(audioManager: AudioManager, showSelectButton: Bool = false, onSelect: ((URL) -> Void)? = nil) {
            self.audioManager = audioManager
            self.showSelectButton = showSelectButton
            self.onSelect = onSelect
        }
    
    var body: some View {
        
        List {
            
            Section("Most Recent Recording:") {
                ForEach(audioManager.recordings, id: \.self) { recording in

                    HStack {
                        
                        if showSelectButton {
                            Button(action: {
                                self.selectRecording(recording)
                                dismiss()
                            }) {
                                Image(systemName: "arrow.right.circle")
                            }
                            .foregroundColor(.blue)
                            .padding(.trailing, 10)
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        // Button for playback
                        Button(action: {
                            audioManager.playRecording(url: recording)
                        }) {
                            HStack {if audioManager.currentlyPlayingURL == recording {
                                Image(systemName: "play.circle.fill")
                                    .foregroundColor(.blue)
                            }
                                Text(recording.deletingPathExtension().lastPathComponent)
                                Spacer()
                            }
                        }
                        .buttonStyle(PlainButtonStyle())  //allows buttons to work independently

                        // Button for editing the recording name
                        Button(action: {
                            self.recordingBeingEdited = recording
                            self.editedName = recording.deletingPathExtension().lastPathComponent
                            self.isShowingEditAlert.toggle()
                        }) {
                            Image(systemName: "pencil")
                        }
                        .contextMenu {
                            Button(action: {
                                self.recordingBeingEdited = recording
                                self.editedName = recording.deletingPathExtension().lastPathComponent
                                self.isShowingEditAlert.toggle()
                            }) {
                                Text("Edit")
                                Image(systemName: "pencil")
                            }
                        }
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let fileURL = audioManager.recordings[index]
                        try? FileManager.default.removeItem(at: fileURL)
                        audioManager.recordings.remove(at: index)
                    }
                }
            }
        }
        
        .sheet(isPresented: $isShowingEditAlert) {
            VStack(spacing: 20) {
                Text("Rename Recording")
                    .font(.headline)
                TextField("Enter new name", text: $editedName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                HStack(spacing: 10) {
                    Button("Cancel") {
                        isShowingEditAlert = false
                    }
                    .padding()

                    Button("Save") {
                        if !self.editedName.isEmpty && self.recordingBeingEdited != nil {
                            let success = audioManager.renameRecording(from: self.recordingBeingEdited!, to: self.editedName)
                            if !success {
                                print("Failed to rename \(String(describing: self.recordingBeingEdited)) to \(self.editedName)")
                            }
                        }
                        isShowingEditAlert = false
                    }
                    .padding()
                }
            }
            .padding()
        }
    }
}

//struct RecordingsView_Previews: PreviewProvider {
//   
//    static var previews: some View {
//        RecordingsView(audioManager: audioManager)
//    }
//}
