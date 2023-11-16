//
//  ScorerView.swift
//  immersivio
//
//  Created by Siena Tung on 2023/11/15.
//

import SwiftUI

struct ScorerView: View {
    @Environment(ViewModel.self) private var viewModel
    
    var body: some View {
        Text("⚽ \(viewModel.currentScorer?.name.uppercased() ?? "") GOALS! ⚽")
            .foregroundStyle(.black)
            .font(.extraLargeTitle)
            .padding()
            .background(.white.opacity(0.7), in: .rect(cornerRadius: 20))
            .opacity(viewModel.isDisplayingScorerName ? 1 : 0)
    }
}
