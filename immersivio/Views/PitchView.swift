//
//  PitchView.swift
//  immersivio
//
//  Created by Siena Tung on 2023/11/10.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct PitchView: View {
    @Environment(ViewModel.self) private var viewModel
    
    var body: some View {
        
        RealityView { content, attachments in
            do {
                // Load pitch from usd file
                let entity = try await Entity(named: "Pitch", in: realityKitContentBundle)
                viewModel.rootEntity = entity
                content.add(entity)
                viewModel.updateScale()
                
                // Offset the scene so it appears in front of the user eyes.
                entity.position = SIMD3<Float>(0, -0.28, 0)
            } catch {
                if let errorEntity = attachments.entity(for: "error") {
                    content.add(errorEntity)
                }
            }
        } update: { content, attachments in
            //            if let textEntity = attachments.entity(for: "hi") {
            //                content.add(textEntity)
            //            }
        } attachments: {
            Attachment(id: "error") {
                ZStack {
                    Text("Error in downloading 3D file")
                        .font(.system(size: 42, weight: .bold))
                    //                        .foregroundStyle(.secondary)
                }
                .frame(width: 700, height: 850)
                .glassBackgroundEffect()
            }
        }
        .rotation3DEffect(viewModel.pitchRotation, axis: .y)
    }

}
