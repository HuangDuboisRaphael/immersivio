//
//  immersivioApp.swift
//  immersivio
//
//  Created by Siena Tung on 2023/11/9.
//

import SwiftUI

@main
struct immersivioApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.windowStyle(.volumetric)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
