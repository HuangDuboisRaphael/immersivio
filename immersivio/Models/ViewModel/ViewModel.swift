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
    // MARK: - Properties
    // MARK: Control
    var videoToggleTitle: String = "Last match replay"
    var stadiumToggleTitle: String = "Immersive stadium"
    var pitchToggleTitle: String = "Show 3D pitch"
    var pitchScaleSliderTitle: String = "Scale"
    var pitchRotateSliderTitle: String = "Rotate"
    var pitchScaleSliderValue: Float = 0.75
    var pitchRotation: Angle = Angle.zero
    var isScoreButtonEnabled: Bool = true
    
    // MARK: Pitch
    /// Pitch
    var rootEntity: Entity? = nil
    var pitchPosition: SIMD3<Float> = [0, -0.28, 0]
    var isShowingPitch: Bool = false
    
    /// Ball
    var ball: Entity? = nil
    private var ballTransform: Transform? { ball?.transform }
    var ballScaleMultiplier: SIMD3<Float> = [0.08, 0.08, 0.08]
    var ballPosition: SIMD3<Float> = [0, 0.152, 0]
    
    /// Audio
    var audio: Entity? = nil
    
    /// Panels
    var marseilleScore: Int = 0
    var bordeauxScore: Int = 0
    var isDisplayingScorerName: Bool = false
    var marseillePanelAcuteTargetPosition: SIMD3<Float> {
        [Float(-0.33 + 0.0037 * pitchRotation.degrees),
         0.27,
         Float(-1 + 0.011 * pitchRotation.degrees)]
    }
    var marseillePanelObtuseTargetPosition: SIMD3<Float> {
        [Float(0 - 0.0037 * (pitchRotation.degrees - 90)),
         0.27,
         Float(0.011 * (pitchRotation.degrees - 90))]
    }
    var bordeauxPanelAcuteTargetPosition: SIMD3<Float> {
        [Float(0.33 + 0.0037 * pitchRotation.degrees),
         0.27,
         Float(-1 + 0.011 * pitchRotation.degrees)]
    }
    var bordeauxPanelObtuseTargetPosition: SIMD3<Float> {
        [Float(0.66 - 0.0037 * (pitchRotation.degrees - 90)),
         0.27,
         Float(0.011 * (pitchRotation.degrees - 90))]
    }
    
    /// Scorer
    var marseilleScorers: [Scorer] = []
    var bordeauxScorers: [Scorer] = []
    var currentScorer: Scorer?
    var scorerPanelAcuteTargetPosition: SIMD3<Float> {
        [Float(0 + 0.011 * pitchRotation.degrees),
         0.27,
         Float(-1 + 0.011 * pitchRotation.degrees)]
    }
    var scorerPanelObtuseTargetPosition: SIMD3<Float> {
        [Float(1 - 0.011 * (pitchRotation.degrees - 90)),
         0.27,
         Float(0.011 * (pitchRotation.degrees - 90))]
    }
    
    // MARK: Video
    var player: AVPlayer { AVPlayer(url: URL(string: AppConstants.Video.url)!) }
    var isDisplayingVideo: Bool = false
    
    // MARK: Immersive
    var isShowingStadium: Bool = false
    
    // MARK: - Methods
    /// Pitch
    func updatePitchScale() {
        let newScale = Float.lerp(a: 0.2, b: 1.0, t: pitchScaleSliderValue)
        rootEntity?.setScale(SIMD3<Float>(repeating: newScale), relativeTo: nil)
    }
    
    func addPanelsAttachmentsToContent(from attachments: RealityViewAttachments) {
        for panel in Panel.allCases {
            if let entity = attachments.entity(for: panel.attachmentId) {
                rootEntity?.addChild(entity)
                entity.setPosition(panel.originalPanelPosition, relativeTo: rootEntity)
            }
        }
    }
    
    func updatePanelsAttachmentsToContent(from attachments: RealityViewAttachments) {
        for panel in Panel.allCases {
            if let entity = attachments.entity(for: panel.attachmentId) {
                transformPanelsPosition(for: entity, ofType: panel)
            }
        }
    }
    
    /// Scorer
    func performGoalAnimation(for team: Team) {
        guard let scale = ball?.scale else { return }
        // To display the scorer in panel scorer and add it in respective array.
        generateRandomScorer(for: team)
        
        // Disabled score buttons to wait for the animation to finish.
        isScoreButtonEnabled = false
        
        performTranslations(for: team)
        resetToOriginalConfiguration(with: scale)
    }
    
    func removeLastScorer(for team: Team) {
        if team == .marseille {
            marseilleScorers.removeLast()
        } else {
            bordeauxScorers.removeLast()
        }
    }
}

// To store private methods.
private extension ViewModel {
    /// Pitch
    // To make all the RealityView panels follow the user's sight when rotating.
    func transformPanelsPosition(for entity: Entity, ofType panel: Panel) {
        switch panel {
        case .marseille:
            entity.look(
                at: pitchRotation.degrees <= 90 ? marseillePanelAcuteTargetPosition : marseillePanelObtuseTargetPosition,
                from: Panel.marseille.originalPanelPosition,
                relativeTo: rootEntity
            )
        case .bordeaux:
            entity.look(
                at: pitchRotation.degrees <= 90 ? bordeauxPanelAcuteTargetPosition : bordeauxPanelObtuseTargetPosition,
                from: Panel.bordeaux.originalPanelPosition,
                relativeTo: rootEntity
            )
        case .scorer:
            entity.look(
                at: pitchRotation.degrees <= 90 ? scorerPanelAcuteTargetPosition : scorerPanelObtuseTargetPosition,
                from: Panel.scorer.originalPanelPosition,
                relativeTo: rootEntity
            )
        }
    }
    
    /// Scorer
    func generateRandomScorer(for team: Team) {
        if team == .marseille {
            let scorer = Scorer(name: Team.marseille.listPlayers.randomElement() ?? "")
            currentScorer = scorer
            marseilleScorers.append(scorer)
        } else {
            let scorer = Scorer(name: Team.bordeaux.listPlayers.randomElement() ?? "")
            currentScorer = scorer
            bordeauxScorers.append(scorer)
        }
    }
    
    func performTranslations(for team: Team) {
        performFirstTranslation(for: team)
        performSecondTranslation(for: team)
    }
    
    func performFirstTranslation(for team: Team) {
        guard var transform = ballTransform else { return }
        transform.translation = team == .marseille ? [-0.15, 0.2, 0] : [0.15, 0.2, 0]
        ball?.move(to: transform, relativeTo: rootEntity, duration: 0.6)
    }
    
    func performSecondTranslation(for team: Team) {
        guard var transform = ballTransform else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            guard let self = self else { return }
            transform.translation = team == .marseille ? [-0.33, 0.15, 0] : [0.33, 0.15, 0]
            self.ball?.move(to: transform, relativeTo: self.rootEntity, duration: 0.6)
            
            // Launch the goal audio and display random scorer.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.manageGoalAudio(isPlaying: true)
                self.isDisplayingScorerName = true
            }
        }
    }
    
    func resetToOriginalConfiguration(with scale: SIMD3<Float>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.6) { [weak self] in
            guard let self = self else { return }
            // Reset to original scale otherwise transforms alters ball entity's scale.
            self.ball?.scale = scale
            self.ball?.position = ballPosition
            self.isDisplayingScorerName = false
            self.manageGoalAudio(isPlaying: false)
            self.isScoreButtonEnabled = true
        }
    }
    
    // To play or stop the goal audio asynchronously.
    func manageGoalAudio(isPlaying: Bool) {
        Task {
            guard let url = AppConstants.Audio.goalUrl else { return }
            if let audioFile = try? await AudioFileResource(contentsOf: url) {
                if isPlaying {
                    await audio?.playAudio(audioFile)
                } else {
                    await audio?.stopAllAudio()
                }
            }
        }
    }
}
