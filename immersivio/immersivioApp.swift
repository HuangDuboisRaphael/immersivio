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

        ImmersiveSpace(id: Module.stadium.name) {
            StadiumView()
        }
    }
}
