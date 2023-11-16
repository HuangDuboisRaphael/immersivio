//
//  StadiumView.swift
//  immersivio
//
//  Created by Siena Tung on 2023/11/16.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct StadiumView: View {
    @Environment(ViewModel.self) private var viewModel
    
    var body: some View {
        RealityView { content in
            // Create a material with the stadium on it.
            let stadium = await StadiumEntity(configuration: viewModel.stadiumConfiguration).stadium
            content.add(stadium)
            
            // Create an empty entity to act as an audio source.
            let audioSource = Entity()

            // Configure the audio source to project channel sound.
            audioSource.channelAudio = ChannelAudioComponent()

            // Add the audio source to the stadium entity and play a looping sound on it.
            guard let url = AppConstants.Audio.stadiumUrl else { return }
            if let audio = try? await AudioFileResource(contentsOf: url, configuration: .init(shouldLoop: true)) {
                stadium.addChild(audioSource)
                audioSource.playAudio(audio)
            }
        }
    }
}
