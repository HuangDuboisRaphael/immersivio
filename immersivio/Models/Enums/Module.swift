//
//  Scene.swift
//  immersivio
//
//  Created by Siena Tung on 2023/11/10.
//

import Foundation

enum Module: String {
    case control, pitch, video, stadium
    var name: String { rawValue.capitalized }
}
