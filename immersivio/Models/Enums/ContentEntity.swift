//
//  ContentEntity.swift
//  immersivio
//
//  Created by Siena Tung on 2023/11/16.
//

import Foundation

enum ContentEntity: String {
    case pitch, ball, stadium
    var name: String { rawValue.capitalized }
}
