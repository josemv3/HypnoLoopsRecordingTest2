//
//  PlaySettingsView.swift
//  hypnoLoops
//
//  Created by Joey Rubin on 8/1/23.
//

import SwiftUI

struct PlaySettingsView: View {
    @State private var reverbValue: Double = 0
    @State private var volumeMainValue: Double = 0
    @State private var volumeSecondValue: Double = 0
    @State private var loopSpeedValue: Double = 0
    
    var body: some View {
        List {
            Section("Playback Settings") {
                HStack {
                    Text("Reverb")
                        .font(.subheadline)
                        .padding()
                        .foregroundColor(.black)
                    Slider(value: $reverbValue, in: 0 ... 50, step: 5) {
                        Text("")
                    }
                    
                }
                //Section("Loop Speed") {
                    
                    HStack {
                        Text("Speed")
                            .font(.subheadline)
                            .padding()
                            .foregroundColor(.black)
                        Slider(value: $loopSpeedValue, in: 0 ... 50, step: 5) {
                            Text("")
                        }
                        
                    }
//                }
//                .font(.caption)
//                .padding(.leading, 5)
                
            
            }
            
            Section("Loop Volume") {
                HStack {
                    Text("Volume 1")
                        .font(.subheadline)
                        .padding()
                        .foregroundColor(.black)
                    Slider(value: $volumeMainValue, in: 0 ... 50, step: 5) {
                        Text("")
                    }
                    
                }
                HStack {
                    Text("Volume 2")
                        .font(.subheadline)
                        .padding()
                        .foregroundColor(.black)
                    Slider(value: $volumeSecondValue, in: 0 ... 50, step: 5) {
                        Text("")
                    }
                    
                }
            }
            
               
            
          
        }
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        //.environment(\.defaultMinListHeaderHeight, 0)
    }
}

struct PlaySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PlaySettingsView()
    }
}
