//
//  AnimatedLightsaberView.swift
//  lightsaber-app
//
//  Created by Claude on 24/07/25.
//

import SwiftUI

struct AnimatedLightsaberView: View {
    let lightsaber: Lightsaber
    let isActive: Bool
    @State private var isGlowing = false
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                // Hilt (left side) - Made smaller
                HStack(spacing: 1) {
                    PommelView(material: lightsaber.hiltMaterial)
                    LowerGripView(material: lightsaber.hiltMaterial)
                    CrystalChamberView(crystalType: lightsaber.crystalType)
                    UpperGripView(material: lightsaber.hiltMaterial)
                    EmitterView(material: lightsaber.hiltMaterial)
                }
                
                // Animated Blade (right side)
                BladeView(
                    lightsaber: lightsaber,
                    isActive: isActive,
                    isGlowing: isGlowing,
                    geometry: geometry
                )
                .onAppear {
                    isGlowing = true
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    AnimatedLightsaberView(lightsaber: Lightsaber.sampleData[0], isActive: true)
        .frame(height: 100)
        .padding()
}