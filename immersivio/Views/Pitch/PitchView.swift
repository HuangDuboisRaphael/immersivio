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
            // Load and configure pitch entity.
            let pitch = await PitchEntity(configuration: viewModel.pitchConfiguration).pitch
            viewModel.rootEntity = pitch
            viewModel.updatePitchScale()
            
            // Load and configure ball entity.
            let ball = await BallEntity(configuration: viewModel.ballConfiguration).ball
            viewModel.ball = ball
            pitch.addChild(ball)
            
            // Create an empty entity to act as an audio source and keep a reference of it.
            let audio = Entity()
            viewModel.audio = audio
            
            // Configure the audio source to project channel sound.
            audio.channelAudio = ChannelAudioComponent()
            pitch.addChild(audio)
            
            // Add entities to RealityView content.
            content.add(pitch)
            
            // Add panels attachments to RealityView content and set original position.
            viewModel.addPanelsAttachmentsToContent(from: attachments)
        } update: { _, attachments in
            // Update the attachments panels' location relative to the rotation angle.
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
        // Add rotation effect.
        .rotation3DEffect(viewModel.pitchRotation, axis: .y)
        
        // Switch pitch toggle to off if the user manually exits the window.
        .onDisappear {
            viewModel.isShowingPitch = false
        }
    }
}
