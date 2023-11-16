//
//  Constans.swift
//  immersivio
//
//  Created by Siena Tung on 2023/11/14.
//

import Foundation

struct AppConstants {
    struct Video {
        static let url = "https://storage.googleapis.com/images-arise-staging/OM_Bdx_480p.mp4"
    }
    
    struct Audio {
        static var goalUrl: URL? { Bundle.main.url(forResource: "Goal_Sounds", withExtension: "mp3") }
        static var stadiumUrl: URL? { Bundle.main.url(forResource: "Stadium_Sounds", withExtension: "mp3") }
    }
}
