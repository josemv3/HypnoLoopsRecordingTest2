//
//  SoundScapeView.swift
//  HypnoLoopsRecordTest2
//
//  Created by Joey Rubin on 9/21/23.
//

import SwiftUI

struct SoundScapeView: View {
    @Environment(\.dismiss) var dismiss
    let mp3Files = ["chopin", "ocean_waves", "sound_bowls_nature", "ocean15"] // The names of your mp3 files
    //@State private var selectedScape: String?
    @ObservedObject var audioManager = AudioManager()
    var onSelect: ((URL) -> Void)?

    func selectScape(_ url: URL) {
        onSelect?(url)
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    dismiss()
                    print("cancel")
                } label: {
                    Text("Cancel")
                }
                .padding(.top, 10)
            }
            .padding(.horizontal, 20)
            
            List {
                Section("Select a Sound Scape:") {
                    ForEach(mp3Files, id: \.self) { item in
                        //let newItem = item.replacingOccurrences(of: "_", with: " ")
                        HStack {
                            
                            // Button for playback
                            Button(action: {
                                if audioManager.isPlayingMusic {
                                    
                                              audioManager.stopMusic()
                                           } else {
                                               audioManager.startMusic(url: makeURL(name: item)!) 
                                           }
                            }) {
                                HStack {
                                    if audioManager.currentlyPlayingMusicURL == makeURL(name: item) {
                                        Image(systemName: audioManager.isPlayingMusic ? "play.circle.fill" : "stop.fill")
                                        .foregroundColor(.blue)
                                    }
                                    Text(makeSongName(name: item))
                                    Spacer()
                                }
                            }
                            .buttonStyle(PlainButtonStyle())  //allows buttons to work independently
                        
                            Spacer()
                            
                            Button(action: {
                                
                                selectScape(makeURL(name: item)!)
                                //self.selectedScape = item
                                //print(self.selectedScape)
                                //self.showSheet.toggle()
                                dismiss()
                            }) {
                                Image(systemName: "arrow.left.circle")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func makeURL(name: String) -> URL? {
        let musicURL = Bundle.main.url(forResource: name, withExtension: "mp3")
        return musicURL
    }
    
    func makeSongName(name: String) -> String {
        let newItem = name.replacingOccurrences(of: "_", with: " ").capitalized
        return newItem
    }
    
}

struct SoundScapeView_Previews: PreviewProvider {
    static var previews: some View {
        SoundScapeView(audioManager: AudioManager())
    }
}
