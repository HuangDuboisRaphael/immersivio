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
    @State private var stadiumImmersionStyle: ImmersionStyle = .full
    
    var body: some Scene {
        WindowGroup(id: Module.control.name) {
            ControlView()
                .environment(viewModel)
        }
        .windowStyle(.plain)
        
        WindowGroup(id: Module.pitch.name) {
            PitchView()
                .environment(viewModel)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 0.96, height: 0.4, depth: 0.96, in: .meters)
        
        WindowGroup(id: Module.video.name) {
            VideoView()
                .environment(viewModel)
        }
        .windowStyle(.plain)
        // Reduce the default size as indicating in Apple's guidance: "Using a small window for playback, letting people resize it if they want".
        .defaultSize(CGSize(width: 750, height: 450))

        ImmersiveSpace(id: Module.stadium.name) {
            StadiumView()
                .environment(viewModel)
        }
        .immersionStyle(selection: $stadiumImmersionStyle, in: .full)
    }
}
