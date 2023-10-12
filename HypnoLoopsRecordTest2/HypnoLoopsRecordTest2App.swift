//
//  HypnoLoopsRecordTest2App.swift
//  HypnoLoopsRecordTest2
//
//  Created by Joey Rubin on 9/19/23.
//

import SwiftUI

@main
struct HypnoLoopsRecordTest2App: App {
    @StateObject private var audioManager = AudioManager()
    @ObservedObject var viewModel = CategoryViewModel()
    //Instance of AudioManager created in the root app, and only created when the app is running.
    //THis will feed all the child views that need AudioManager
    
    var body: some Scene {
        WindowGroup {
            HomeTabView(audioManager: audioManager, viewModel: viewModel)
        }
    }
}
