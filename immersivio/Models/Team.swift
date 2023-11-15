//
//  Team.swift
//  immersivio
//
//  Created by Siena Tung on 2023/11/13.
//

import Foundation

enum Team: String, Identifiable, CaseIterable {
    case marseille, bordeaux
    var id: Self { self }
    var name: String { rawValue.capitalized }
    
    var abbreviation: String {
        switch self {
        case .marseille: "OM"
        case .bordeaux: "BDX"
        }
    }
    
    var attachmentId: String {
        switch self {
        case .marseille: "MarseilleAttachment"
        case .bordeaux: "BordeauxAttachment"
        }
    }
    
    var imageLogo: String {
        switch self {
        case .marseille: "OMLogo"
        case .bordeaux: "GIRLogo"
        }
    }
    
    var originalPanelPosition: SIMD3<Float> {
        switch self {
        case .marseille: [-0.33, 0.27, 0]
        case .bordeaux: [0.33, 0.27, 0]
        }
    }
}
