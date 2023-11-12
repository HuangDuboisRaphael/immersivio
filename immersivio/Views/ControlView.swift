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
    
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        VStack {
            Spacer()
            Grid(alignment: .leading, verticalSpacing: 30) {
                Toggle(isOn: $viewModel.showVolumetricPitch) {
                    Text("Show 3D pitch")
                }
                .onChange(of: viewModel.showVolumetricPitch) {
                    if viewModel.showVolumetricPitch {
                        openWindow(id: Module.pitch.name)
                    } else {
                        dismissWindow(id: Module.pitch.name)
                    }
                }

                GridRow {
                    Text("Scale")
                    Slider(value: $viewModel.pitchScaleSliderValue)
                        .onChange(of: viewModel.pitchScaleSliderValue) {
                            viewModel.updateScale()
                        }
                }
                .disabled(!viewModel.showVolumetricPitch)
                .opacity(viewModel.showVolumetricPitch ? 1 : 0.5)
                
                GridRow {
                    Text("Rotate")
                    Slider(value: $viewModel.pitchRotation.degrees, in: 0...180)
                        .onChange(of: viewModel.pitchRotation) {
                            viewModel.pitchRotation.degrees += 1
                        }
                }
                .disabled(!viewModel.showVolumetricPitch)
                .opacity(viewModel.showVolumetricPitch ? 1 : 0.5)
            }
            .frame(width: 500)
            .padding(30)
            .glassBackgroundEffect()
        }
    }
}
