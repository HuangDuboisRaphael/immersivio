//
//  ViewModel.swift
//  immersivio
//
//  Created by Siena Tung on 2023/11/10.
//

import SwiftUI
import RealityKit

@Observable
final class ViewModel {
    var pitchScaleSliderValue: Float = 0.7
    var pitchRotation: Angle = Angle.zero
    
    var rootEntity: Entity? = nil
    var showVolumetricPitch: Bool = false
    
    var showImmersiveStadium: Bool = false
    
    func updateScale() {
        let newScale = Float.lerp(a: 0.2, b: 1.0, t: pitchScaleSliderValue)
        rootEntity?.setScale(SIMD3<Float>(repeating: newScale), relativeTo: nil)
    }
}
