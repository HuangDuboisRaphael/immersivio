//
//  VideoView.swift
//  immersivio
//
//  Created by Siena Tung on 2023/11/14.
//

import SwiftUI
import AVKit

struct VideoView: View {
    @Environment(ViewModel.self) private var viewModel
    
    var body: some View {
        VideoPlayer(player: viewModel.player)
    }
}
