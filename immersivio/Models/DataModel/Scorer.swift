//
//  Scorer.swift
//  immersivio
//
//  Created by Siena Tung on 2023/11/16.
//

import Foundation

// Create a Scorer structure to allow duplicate values in ForEach's ExtendedPanel by implementing a unique uuid.
struct Scorer: Identifiable {
    let id = UUID()
    let name: String
}
