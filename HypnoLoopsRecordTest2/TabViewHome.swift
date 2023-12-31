//
//  TabView.swift
//  hypnoLoopsRecordTest
//
//  Created by Joey Rubin on 9/19/23.
//

import SwiftUI
import Combine

struct HomeTabView: View {
    @ObservedObject var audioManager: AudioManager
    @ObservedObject var viewModel: CategoryViewModel
    
    var body: some View {
        TabView {
            
            RecordView(audioManager: audioManager, viewModel: viewModel)
                //.padding(.top, 80)
                .tabItem {
                    Image(systemName: "mic")
                    Text("Record")
                }
            
            PlayView(audioManager: audioManager)
                //.padding(.top, 80)
                .tabItem {
                    Image(systemName: "play.fill")
                    Text("Play")
                }
            
            CategoryView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("Affirmations")
                }
                //.toolbar(.automatic, for: .tabBar)
                //.toolbarBackground(Color("ringDarkBlue").opacity(0.5), for: .tabBar)

            Text("Logout Screen")
                .tabItem {
                    Image(systemName: "person")
                    Text("Me")
                }
        }
        .modifier(TabBarAppearanceModifier())
        
        //.accentColor(.red)
    }
}

//struct TabView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeTabView(audioManager: AudioManager())
//    }
//}

struct TabBarAppearanceModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear(perform: {
                let appearance = UITabBarAppearance()
                
                // Configure your appearance settings here...
                appearance.stackedLayoutAppearance.normal.iconColor = UIColor.systemGray // Unselected
                appearance.stackedLayoutAppearance.selected.iconColor = UIColor.systemBlue // Selected
                
                appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.systemGray]
                appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
                
                UITabBar.appearance().standardAppearance = appearance
            })
    }
}

