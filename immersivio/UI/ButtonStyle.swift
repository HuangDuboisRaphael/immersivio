//
//  ButtonStyle.swift
//  immersivio
//
//  Created by Siena Tung on 2023/11/13.
//

import SwiftUI

struct TeamPanelButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: 90)
            .glassBackgroundEffect(in: .rect(cornerRadius: 20))
            .hoverEffect()
            .scaleEffect(configuration.isPressed ? 0.90 : 1)
    }
}

struct ExitButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .hoverEffect()
            .background(.clear)
    }
}
