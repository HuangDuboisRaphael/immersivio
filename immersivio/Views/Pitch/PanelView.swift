//
//  PanelView.swift
//  immersivio
//
//  Created by Siena Tung on 2023/11/13.
//

import SwiftUI

struct PanelView: View {
    @State private var showExtendingPanel = false
    
    let viewModel: ViewModel
    let team: Team
    
    var body: some View {
        ReducedPanel(
            isShowingExtendingPanel: $showExtendingPanel,
            team: team,
            viewModel: viewModel)
        
        if showExtendingPanel {
            ZStack(alignment: .topLeading) {
                ExtendedPanel(viewModel: viewModel, team: team)
                ExitButton(showExtendingPanel: $showExtendingPanel)
            }
            .padding(.bottom, 330)
            .transition(.scale)
        }
    }
}

struct ReducedPanel: View {
    @Binding var isShowingExtendingPanel: Bool
    let team: Team
    let viewModel: ViewModel
    
    var body: some View {
        Button {
            withAnimation {
                isShowingExtendingPanel.toggle()
            }
        } label: {
            VStack(spacing: 24) {
                Text(team.abbreviation)
                    .font(.custom(CustomFonts.arial.rawValue, size: 20))
                    .padding(.top, 16)
                
                Text(String(team == .marseille ?
                            viewModel.marseilleScore : viewModel.bordeauxScore))
                    .foregroundStyle(.primary)
                    .font(.custom(CustomFonts.academy.rawValue, size: 50))
            }
        }
        .buttonStyle(TeamPanelButtonStyle())
        .opacity(isShowingExtendingPanel ? 0 : 1)
    }
}

struct ExtendedPanel: View {
    let viewModel: ViewModel
    let team: Team
    
    var scorers: [String] = ["D.Payet", "T.Henry", "O.Giroud", "A.Griezmann"]
    
    var body: some View {
        VStack(alignment: .center, spacing: 1) {
            Image(team.imageLogo)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
            
            Text(team.name)
                .font(.custom(CustomFonts.copperplate.rawValue, size: 21))
                .foregroundStyle(.black)
            
            Text(String(team == .marseille ?
                        viewModel.marseilleScore : viewModel.bordeauxScore))
                .foregroundStyle(.black)
                .font(.custom(CustomFonts.academy.rawValue, size: 105))
                .padding(.top, 15)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(scorers, id: \.self) {
                        Text("⚽ \($0) ")
                            .font(.system(size: 16))
                            .foregroundStyle(.black)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, -35)
            Spacer()
        }
        .frame(maxWidth: 185)
        .background(.white.opacity(0.5), in: .rect(cornerRadius: 20))
    }
}

struct ExitButton: View {
    @Binding var showExtendingPanel: Bool
    
    var body: some View {
        Button {
            withAnimation {
                showExtendingPanel.toggle()
            }
        } label: {
            Image(systemName: "xmark")
                .resizable()
                .scaledToFill()
                .frame(width: 15, height: 15)
                .foregroundStyle(.black)
        }
        .padding()
        .buttonStyle(ExitButtonStyle())
    }
}
