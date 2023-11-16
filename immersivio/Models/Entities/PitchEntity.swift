//
//  PitchEntity.swift
//  immersivio
//
//  Created by Siena Tung on 2023/11/16.
//

import SwiftUI
import RealityKit
import RealityKitContent

final class PitchEntity: Entity {
    var pitch: Entity = Entity()
    
    // Required init which creates a blank entity.
    @MainActor required init() {
        super.init()
    }
    
    // Custom init applying the PitchEntity configuration.
    init(configuration: Configuration) async {
        super.init()
        
        // Load concurrently pitch entity from 3D model and light image environment.
        async let pitch = Entity(named: configuration.name, in: realityKitContentBundle)
        async let environment = EnvironmentResource(named: configuration.resource)
        
        // Unwrap resources.
        guard let pitch = try? await pitch else {
            fatalError("Unable to load pitch entity.")
        }
        guard let environment = try? await environment else {
            print("Unable to load environment resource.")
            return
        }
        
        // Set initial pitch position.
        pitch.position = configuration.position
        
        // Apply an ImageBasedLightComponent since there is no light support in immersive space.
        // Without this component, the 3D pitch is too dark.
        pitch.components.set(ImageBasedLightComponent(source: .single(environment)))
        pitch.components.set(ImageBasedLightReceiverComponent(imageBasedLight: pitch))
        
        self.pitch = pitch
    }
}

extension PitchEntity {
    struct Configuration {
        let name = "Pitch"
        let resource = "Light"
        let position: SIMD3<Float> = [0, -0.28, 0]
    }
}
