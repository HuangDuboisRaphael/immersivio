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
                /// Pitch
                // Load and configure pitch entity.
                let pitch = try await Entity(named: ContentEntity.pitch.name, in: realityKitContentBundle)
                viewModel.rootEntity = pitch
                viewModel.updatePitchScale()
                pitch.position = viewModel.pitchPosition
                
                /// Ball
                // Load and configure ball entity.
                let ball = try await Entity(named: ContentEntity.ball.name, in: realityKitContentBundle)
                viewModel.ball = ball
                ball.scale *= viewModel.ballScaleMultiplier
                ball.position = viewModel.ballPosition
                pitch.addChild(ball)
                
                /// Audio
                // Create an empty entity to act as an audio source.
                let audio = Entity()
                viewModel.audio = audio
                // Configure the audio source to project channel sound.
                audio.channelAudio = ChannelAudioComponent()
                pitch.addChild(audio)
                
                /// Content
                // Add entities to RealityView content.
                content.add(pitch)
                
                /// Panels
                // Add panels attachments to RealityView content and set original position.
                viewModel.addPanelsAttachmentsToContent(from: attachments)
            } catch {
                fatalError("Unable to load entities.")
            }
        } update: { content, attachments in
            // Update the location where the attachments are looking relative to the rotation angle.
            viewModel.updatePanelsAttachmentsToContent(from: attachments)
        } attachments: {
            // Attach the SwiftUI view panels to the RealityView content.
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
