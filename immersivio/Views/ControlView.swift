//
//  ControlView.swift
//  immersivio
//
//  Created by Siena Tung on 2023/11/10.
//

import SwiftUI
import RealityKit

struct ControlView: View {
    @Environment(ViewModel.self) private var viewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        VStack {
            Spacer()
            Grid(verticalSpacing: 30) {
                VideoToggle()
                StadiumToggle()
                Divider()
                PitchToggle()
                GridRowSliders()
                
                if viewModel.isShowingPitch {
                    Divider()
                    EditScores()
                }
            }
            .frame(width: 500)
            .padding(30)
            .glassBackgroundEffect()
        }
    }
}

struct VideoToggle: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(ViewModel.self) private var viewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        HStack {
            Text(viewModel.videoToggleTitle)
                .font(.system(size: 22))
                .bold()
            Spacer()
            Button {
                viewModel.isDisplayingVideo.toggle()
            } label: {
                Image(systemName: viewModel.isDisplayingVideo ? "stop.fill" : "play.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
            }
        }.onChange(of: viewModel.isDisplayingVideo) {
            if viewModel.isDisplayingVideo {
                openWindow(id: Module.video.name)
            } else {
                dismissWindow(id: Module.video.name)
            }
        }
    }
}

struct StadiumToggle: View {
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    @Environment(ViewModel.self) private var viewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        Toggle(isOn: $viewModel.isShowingStadium) {
            Text(viewModel.stadiumToggleTitle)
                .font(.system(size: 22))
                .bold()
        }
        .onChange(of: viewModel.isShowingStadium) {
            Task {
                if viewModel.isShowingStadium {
                    await openImmersiveSpace(id: Module.stadium.name)
                } else {
                    await dismissImmersiveSpace()
                }
            }
        }
        
    }
}

struct PitchToggle: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(ViewModel.self) private var viewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        Toggle(isOn: $viewModel.isShowingPitch) {
            Text(viewModel.pitchToggleTitle)
                .font(.system(size: 22))
                .bold()
        }
        .onChange(of: viewModel.isShowingPitch) {
            if viewModel.isShowingPitch {
                openWindow(id: Module.pitch.name)
            } else {
                dismissWindow(id: Module.pitch.name)
            }
        }
    }
}

struct GridRowSliders: View {
    @Environment(ViewModel.self) private var viewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        GridRowSlider(
            title: viewModel.pitchScaleSliderTitle,
            value: $viewModel.pitchScaleSliderValue,
            range: 0.45...1,
            showVolumetricPitch: viewModel.isShowingPitch)
            .onChange(of: viewModel.pitchScaleSliderValue) {
                viewModel.updateScale()
            }
        
        GridRowSlider(
            title: viewModel.pitchRotateSliderTitle,
            value: $viewModel.pitchRotation.degrees,
            range: 0...180,
            showVolumetricPitch: viewModel.isShowingPitch)
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
    @Environment(ViewModel.self) private var viewModel
    
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
                .font(.system(size: 21))
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
