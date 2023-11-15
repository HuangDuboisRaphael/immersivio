//
//  ViewModel.swift
//  immersivio
//
//  Created by Siena Tung on 2023/11/10.
//

import SwiftUI
import RealityKit
import AVKit

@Observable
final class ViewModel {
    
    // MARK: - Control
    var videoToggleTitle: String = "Last match replay"
    var stadiumToggleTitle: String = "Immersive stadium"
    var pitchToggleTitle: String = "Show 3D pitch"
    var pitchScaleSliderTitle: String = "Scale"
    var pitchRotateSliderTitle: String = "Rotate"
    var pitchScaleSliderValue: Float = 0.75
    var pitchRotation: Angle = Angle.zero
    
    // MARK: - Pitch
    var rootEntity: Entity? = nil
    var isShowingPitch: Bool = false
    var pitchPosition: SIMD3<Float> = [0, -0.28, 0]
    var bordeauxScore: Int = 0
    var marseilleScore: Int = 0
    
    // Target positions
    var marseilleAcuteTargetPosition: SIMD3<Float> {
        [Float(-0.33 + 0.0037 * pitchRotation.degrees),
         0.27,
         Float(-1 + 0.011 * pitchRotation.degrees)]
    }
    var marseilleObtuseTargetPosition: SIMD3<Float> {
        [Float(0 - 0.0037 * (pitchRotation.degrees - 90)),
         0.27,
         Float(0.011 * (pitchRotation.degrees - 90))]
    }
    var bordeauxAcuteTargetPosition: SIMD3<Float> {
        [Float(0.33 + 0.0037 * pitchRotation.degrees),
         0.27,
         Float(-1 + 0.011 * pitchRotation.degrees)]
    }
    var bordeauxObtuseTargetPosition: SIMD3<Float> {
        [Float(0.66 - 0.0037 * (pitchRotation.degrees - 90)),
         0.27,
         Float(0.011 * (pitchRotation.degrees - 90))]
    }
    
    // Methods
    func updateScale() {
        let newScale = Float.lerp(a: 0.2, b: 1.0, t: pitchScaleSliderValue)
        rootEntity?.setScale(SIMD3<Float>(repeating: newScale), relativeTo: nil)
    }
    
    func transformPanelPosition(_ entity: Entity, for team: Team) {
        if pitchRotation.degrees <= 90 {
            entity.look(
                at: team == . marseille ? marseilleAcuteTargetPosition : bordeauxAcuteTargetPosition,
                from: team == . marseille ? Team.marseille.originalPanelPosition : Team.bordeaux.originalPanelPosition,
                relativeTo: rootEntity
            )
        } else {
            entity.look(
                at: team == . marseille ? marseilleObtuseTargetPosition : bordeauxObtuseTargetPosition,
                from: team == . marseille ? Team.marseille.originalPanelPosition : Team.bordeaux.originalPanelPosition,
                relativeTo: rootEntity
            )
        }
    }
    
    // MARK: - Video
    var player: AVPlayer { AVPlayer(url: URL(string: AppConstants.Video.url)!) }
    var isDisplayingVideo: Bool = false
    
    // MARK: - Immersive
    var isShowingStadium: Bool = false
}
