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
                // Load and configure pitch entity.
                let pitch = try await Entity(named: "Pitch", in: realityKitContentBundle)
                viewModel.rootEntity = pitch
                viewModel.updatePitchScale()
                pitch.position = viewModel.pitchPosition
                
                // Loand and configure ball entity.
                let ball = try await Entity(named: "Ball", in: realityKitContentBundle)
                viewModel.ball = ball
                ball.scale *= viewModel.ballScaleMultiplier
                ball.position = viewModel.ballPosition
                pitch.addChild(ball)
                
                // Add entities to RealityView content and allow user to update its scale.
                content.add(pitch)
                
                // Add panel attachments to RealityView content and set original position.
                viewModel.addPanelsAttachmentsToContent(from: attachments)
            } catch {
                print(error.localizedDescription)
            }
        } update: { content, attachments in
            // Update the location where the attachments are looking relative to the rotation angle.
            viewModel.updatePanelsAttachmentsToContent(from: attachments)
        } attachments: {
            // Create the SwiftUI view panels attaching to the RealityView content.
            ForEach(Panel.allCases, id: \.self) { panel in
                if panel == .scorer {
                    Attachment(id: panel.attachmentId) {
                        ScorerView()
                    }
                } else {
                    Attachment(id: panel.attachmentId) {
                        PanelView(team: panel == .marseille ? .marseille : .bordeaux)
                    }
                }
            }
        }
        .rotation3DEffect(viewModel.pitchRotation, axis: .y)
    }
}
