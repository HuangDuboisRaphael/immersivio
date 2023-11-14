//
//  immersivioApp.swift
//  immersivio
//
//  Created by Siena Tung on 2023/11/9.
//

import SwiftUI

@main
struct immersivioApp: App {
    @State private var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup(id: Module.control.name) {
            ControlView(viewModel: viewModel)
        }
        .windowStyle(.plain)
        
        WindowGroup(id: Module.pitch.name) {
            PitchView(viewModel: viewModel)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 0.9, height: 0.5, depth: 0.9, in: .meters)
        
        WindowGroup(id: Module.video.name) {
            VideoView(viewModel: viewModel)
        }
        .windowStyle(.plain)
        // Reduce the default size as indicating in Apple's guidance: "Using a small window for playback, letting people resize it if they want"
        .defaultSize(CGSize(width: 750, height: 450))

        ImmersiveSpace(id: Module.stadium.name) {
            StadiumView()
        }
    }
}
