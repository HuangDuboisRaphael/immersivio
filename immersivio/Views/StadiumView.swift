//
//  StadiumView.swift
//  immersivio
//
//  Created by Siena Tung on 2023/11/9.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct StadiumView: View {
    @Environment(ViewModel.self) private var viewModel
    
    var body: some View {
        RealityView { content in
            // Create a material with the stadium on it.
            guard let resource = try? await TextureResource(named: "Stadium") else {
                // If the asset isn't available, something is wrong with the app.
                fatalError("Unable to load stadium texture.")
            }
            var material = UnlitMaterial()
            material.color = .init(texture: .init(resource))

            // Attach the material to a large sphere.
            let entity = Entity()
            entity.components.set(ModelComponent(
                mesh: .generateSphere(radius: 1000),
                materials: [material]
            ))
            
            // Ensure the texture image points inward and immerse the user in a 360° skybox in a stadium.
            entity.scale *= .init(x: 1, y: 1, z: -1)
            entity.position = [0, -300, -950]
            
            content.add(entity)
        }
    }
}
