//
//  TabView.swift
//  hypnoLoopsRecordTest
//
//  Created by Joey Rubin on 9/19/23.
//

import SwiftUI

struct HomeTabView: View {
    @ObservedObject var audioManager: AudioManager
    
    var body: some View {
        TabView {
            PlayView2(audioManager: audioManager)
                //.padding(.top, 80)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                

            RecordView2(audioManager: audioManager)
                //.padding(.top, 80)
                .tabItem {
                    Image(systemName: "mic")
                    Text("Record")
                }

            AudioLoopView(audioManager: audioManager)
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("Affirmations")
                }

            SoundScapeView()
                .tabItem {
                    Image(systemName: "heart")
                    Text("Likes")
                }

            RecordView(audioManager: audioManager)
                .tabItem {
                    Image(systemName: "person")
                    Text("Me")
                }
        }
        //.accentColor(.red)
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView(audioManager: AudioManager())
    }
}
