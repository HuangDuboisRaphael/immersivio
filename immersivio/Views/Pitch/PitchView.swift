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
    let viewModel: ViewModel
        
    var body: some View {
        
        RealityView { content, attachments in
            do {
                // Load pitch from usd file and save it in view model
                let entity = try await Entity(named: "Pitch", in: realityKitContentBundle)
                viewModel.rootEntity = entity
                
                // Add the entity to RealityView content and allow user to update its scale
                content.add(entity)
                viewModel.updateScale()
                
                // Offset the scene so it appears on user's field of view
                entity.position = viewModel.pitchPosition
                
                // Add panel attachments to RealityView content and set original position
                if let marseillePanelEntity = attachments.entity(for: Team.marseille.attachmentId) {
                    viewModel.rootEntity?.addChild(marseillePanelEntity)
                    marseillePanelEntity.setPosition(Team.marseille.originalPanelPosition, relativeTo: viewModel.rootEntity)
                }
                if let bordeauxPanelEntity = attachments.entity(for: Team.bordeaux.attachmentId) {
                    viewModel.rootEntity?.addChild(bordeauxPanelEntity)
                    bordeauxPanelEntity.setPosition(Team.bordeaux.originalPanelPosition, relativeTo: viewModel.rootEntity)
                }
            } catch {
                print(error.localizedDescription)
            }
        } update: { content, attachments in
            // To make the panels following user's field of view when rotating
            if let marseillePanelEntity = attachments.entity(for: Team.marseille.attachmentId) {
                viewModel.transformPanelPosition(marseillePanelEntity, for: .marseille)
            }
            if let bordeauxPanelEntity = attachments.entity(for: Team.bordeaux.attachmentId) {
                viewModel.transformPanelPosition(bordeauxPanelEntity, for: .bordeaux)
            }
        } attachments: {
            // Create the SwiftUI view panels attaching to the RealityView content
            ForEach(Team.allCases) { team in
                Attachment(id: team.attachmentId) {
                    PanelView(viewModel: viewModel, team: team)
                }
            }
        }
    }
}
