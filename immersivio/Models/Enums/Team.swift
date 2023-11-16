//
//  Team.swift
//  immersivio
//
//  Created by Siena Tung on 2023/11/13.
//

import Foundation

enum Team: String {
    case marseille, bordeaux
    var name: String { rawValue.capitalized }
    
    var abbreviation: String {
        switch self {
        case .marseille: "OM"
        case .bordeaux: "BDX"
        }
    }
    
    var imageLogo: String {
        switch self {
        case .marseille: "OMLogo"
        case .bordeaux: "GIRLogo"
        }
    }
    
    var listPlayers: [String] {
        switch self {
        case .marseille:
            [
                "Aubameyang",
                "Vítinha",
                "Correa",
                "Veretout",
                "Rongier",
                "Sarr",
                "Renan Lodi",
                "Mbemba",
                "Gigot",
                "Clauss"
            ]
        case .bordeaux:
            [
                "Badji",
                "Livolant",
                "Weissbeck",
                "Davitashvili",
                "Pedro Díaz",
                "Ignatenko",
                "N'Simba",
                "Barbet",
                "Gregersen",
                "Michelin"
            ]
        }
    }
}
