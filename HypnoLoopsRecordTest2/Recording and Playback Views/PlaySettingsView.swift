//
//  PlaySettingsView.swift
//  hypnoLoops
//
//  Created by Joey Rubin on 8/1/23.
//

import SwiftUI

struct PlaySettingsView: View {
    @ObservedObject var audioManager: AudioManager
    @Environment(\.dismiss) var dismiss
    @State private var reverbValue: Double = 0
    @State private var volumeMainValue: Double = 0
    @State private var volumeSecondValue: Double = 0
    
    
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
                Section("Playback Settings") {

                    //Section("Loop Speed") {
                    HStack {
                        Text("Inner Loop: \(audioManager.delayFactor2 * 218, specifier: "%.0f")")
                            .font(.subheadline)
                            .padding()
                            .foregroundColor(.black)
                        Slider(value: $audioManager.delayFactor2, in: 0.02...0.46, step: 0.02) {
                            Text("")
                        }
                        .onChange(of: audioManager.delayFactor2) { newValue in
                                            audioManager.adjustRestartDelay(newValue)
                                        }
                    }
                    
                    HStack {
                        Text("Outer Loop: \(audioManager.delayFactor * 218, specifier: "%.0f")")
                            .font(.subheadline)
                            .padding()
                            .foregroundColor(.black)
                        Slider(value: $audioManager.delayFactor, in: 0.02...0.46, step: 0.02) {
                            Text("")
                        }
                        .onChange(of: audioManager.delayFactor) { newValue in
                            audioManager.adjustDelay(newValue) // This method should handle rescheduling the DispatchWorkItem with the new delay
                        }
                    }

                }
                
                Section("Loop Volume") {
                    HStack {
                        Text("Music: \(Int(audioManager.musicVolume * 100))%")
                            .font(.subheadline)
                            .padding()
                            .foregroundColor(.black)
                        Slider(value: $audioManager.musicVolume, in: 0...1)
                                        .onChange(of: audioManager.musicVolume) { newValue in
                                            audioManager.musicPlayer?.volume = newValue
                                        }
                        
                    }
                    HStack {
                        Text("Loop: \(Int(audioManager.mainVocalsAudio * 100))%")
                            .font(.subheadline)
                            .padding()
                            .foregroundColor(.black)
                        Slider(value: $audioManager.mainVocalsAudio, in: 0.0 ... 1.0, step: 0.1) {
                            Text("")
                        }
                        .onChange(of: audioManager.mainVocalsAudio) { newValue in
                            audioManager.audioPlayer?.volume = newValue
                        }
                        
                    }
                }
                
                   
                
              
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            //.environment(\.defaultMinListHeaderHeight, 0)
        }
    }
}

struct PlaySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PlaySettingsView(audioManager: AudioManager())
    }
}
