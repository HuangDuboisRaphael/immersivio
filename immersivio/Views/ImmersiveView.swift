//
//  ImmersiveView.swift
//  immersivio
//
//  Created by Siena Tung on 2023/11/9.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct StadiumView: View {
    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) {
                content.add(scene)
            }
        }
    }
}

#Preview {
    StadiumView()
        .previewLayout(.sizeThatFits)
}
