//
//  StadiumEntity.swift
//  immersivio
//
//  Created by Siena Tung on 2023/11/16.
//

import SwiftUI
import RealityKit
import RealityKitContent

final class StadiumEntity: Entity {
    var stadium = Entity()
        
    // Required init which creates a blank entity.
    @MainActor required init() {
        super.init()
    }
    
    // Custom init applying the StadiumEntity configuration.
    init(configuration: Configuration) async {
        super.init()
        
        // Load stadium texture from image png.
        guard let resource = try? await TextureResource(named: configuration.name) else {
            fatalError("Unable to load ball entity.")
        }
        
        // Create a material which doesn't respond to light.
        var material = UnlitMaterial()
        material.color = .init(texture: .init(resource))

        // Attach the material to a large sphere.
        let stadium = Entity()
        stadium.components.set(ModelComponent(
            mesh: .generateSphere(radius: 1000),
            materials: [material]
        ))

        // Ensure the texture image points inward and immerse the user in a 360° skybox in a stadium.
        stadium.scale *= configuration.stadiumScaleMultiplier
        stadium.position = configuration.position
        
        self.stadium = stadium
    }
}

extension StadiumEntity {
    struct Configuration {
        let name = "Stadium"
        let stadiumScaleMultiplier: SIMD3<Float> = [1, 1, -1]
        let position: SIMD3<Float> = [0, -300, -950]
    }
}
