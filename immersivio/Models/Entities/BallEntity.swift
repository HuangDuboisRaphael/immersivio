//
//  BallEntity.swift
//  immersivio
//
//  Created by Siena Tung on 2023/11/16.
//

import SwiftUI
import RealityKit
import RealityKitContent

final class BallEntity: Entity {
    var ball = Entity()
        
    // Required init which creates a blank entity.
    @MainActor required init() {
        super.init()
    }
    
    // Custom init applying the BallEntity configuration.
    init(configuration: Configuration) async {
        super.init()
        
        // Load ball entity from 3D model.
        guard let ball = try? await Entity(named: configuration.name, in: realityKitContentBundle) else {
            fatalError("Unable to load ball entity.")
        }
        
        // Set initial scale and position.
        ball.scale *= configuration.ballScaleMultiplier
        ball.position = configuration.position
        
        self.ball = ball
    }
}

extension BallEntity {
    struct Configuration {
        let name = "Ball"
        let ballScaleMultiplier: SIMD3<Float> = [0.08, 0.08, 0.08]
        let position: SIMD3<Float> = [0, 0.152, 0]
    }
}
