//
//  FloatingPoint+Extensions.swift
//  immersivio
//
//  Created by Siena Tung on 2023/11/11.
//

import Foundation

public extension FloatingPoint {
    static func lerp(a: Self, b: Self, t: Self) -> Self {
        let one = Self(1)
        let oneMinusT = one - t
        let aTimesOneMinusT = a * oneMinusT
        let bTimesT = b * t
        return aTimesOneMinusT + bTimesT
    }
}
