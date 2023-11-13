//
//  ControlView.swift
//  immersivio
//
//  Created by Siena Tung on 2023/11/10.
//

import SwiftUI
import RealityKit

struct ControlView: View {
    let viewModel: ViewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        VStack {
            Spacer()
            Grid(verticalSpacing: 30) {
                PitchToggle(viewModel: viewModel)
                GridRowSliders(viewModel: viewModel)
                
                if viewModel.showVolumetricPitch {
                    Divider()
                    EditScores(viewModel: viewModel)
                }
            }
            .frame(width: 500)
            .padding(30)
            .glassBackgroundEffect()
        }
    }
}

struct PitchToggle: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    
    let viewModel: ViewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        Toggle(isOn: $viewModel.showVolumetricPitch) {
            Text(viewModel.togglePitchTitle)
        }
        .onChange(of: viewModel.showVolumetricPitch) {
            if viewModel.showVolumetricPitch {
                openWindow(id: Module.pitch.name)
            } else {
                dismissWindow(id: Module.pitch.name)
            }
        }
    }
}

struct GridRowSliders: View {
    let viewModel: ViewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        GridRowSlider(
            title: viewModel.sliderScaleTitle,
            value: $viewModel.pitchScaleSliderValue,
            range: 0...1,
            showVolumetricPitch: viewModel.showVolumetricPitch)
            .onChange(of: viewModel.pitchScaleSliderValue) {
                viewModel.updateScale()
            }
        
        GridRowSlider(
            title: viewModel.sliderRotateTitle,
            value: $viewModel.pitchRotation.degrees,
            range: 0...180,
            showVolumetricPitch: viewModel.showVolumetricPitch)
            .onChange(of: viewModel.pitchRotation) {
                viewModel.pitchRotation.degrees += 1
            }
    }
}

struct GridRowSlider<T>: View where T: BinaryFloatingPoint, T.Stride: BinaryFloatingPoint {
    var title: String
    var value: Binding<T>
    var range: ClosedRange<T>
    var showVolumetricPitch: Bool
    
    var body: some View {
        GridRow {
            Text(title)
            Slider(value: value, in: range)
        }
        .disabled(!showVolumetricPitch)
        .opacity(showVolumetricPitch ? 1 : 0.5)
    }
}

struct EditScores: View {
    let viewModel: ViewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        HStack {
            EditScore(score: $viewModel.marseilleScore, team: .marseille)
            Spacer()
            EditScore(score: $viewModel.bordeauxScore, team: .bordeaux)
        }
    }
}

struct EditScore: View {
    @Binding var score: Int
    let team: Team
    
    var body: some View {
        HStack(spacing: 10) {
            Button {
                if score > 0 {
                    score -= 1
                }
            } label: {
                Text("-")
                    .font(.system(size: 32))
            }
            .disabled(score == 0 ? true : false)
            
            Text(team.name)
                .font(.system(size: 22))
                .bold()
            
            Button {
                score += 1
            } label: {
                Text("+")
                    .font(.system(size: 32))
            }
        }
    }
}
