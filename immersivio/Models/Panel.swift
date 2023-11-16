//
//  PanelAttachment.swift
//  immersivio
//
//  Created by Siena Tung on 2023/11/16.
//

import Foundation

enum Panel: CaseIterable {
    case marseille, bordeaux, scorer
    
    var attachmentId: String {
        switch self {
        case .marseille: "MarseillePanelAttachment"
        case .bordeaux: "BordeauxPanelAttachment"
        case .scorer: "ScorerPanelAttachment"
        }
    }
    
    var originalPanelPosition: SIMD3<Float> {
        switch self {
        case .marseille: [-0.33, 0.27, 0]
        case .bordeaux: [0.33, 0.27, 0]
        case .scorer: [0, 0.33, 0]
        }
    }
}
