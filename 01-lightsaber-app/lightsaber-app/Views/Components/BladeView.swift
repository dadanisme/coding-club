//
//  BladeView.swift
//  lightsaber-app
//
//  Created by Claude on 24/07/25.
//

import SwiftUI

struct BladeView: View {
    let lightsaber: Lightsaber
    let isActive: Bool
    let isGlowing: Bool
    let geometry: GeometryProxy
    
    var body: some View {
        if isActive {
            ActiveBladeView(lightsaber: lightsaber, isActive: isActive, isGlowing: isGlowing)
        } else {
            InactiveBladeView(isActive: isActive)
        }
    }
}

struct ActiveBladeView: View {
    let lightsaber: Lightsaber
    let isActive: Bool
    let isGlowing: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(
                LinearGradient(
                    colors: [
                        ColorUtils.colorForLightsaber(lightsaber.color),
                        ColorUtils.colorForLightsaber(lightsaber.color).opacity(0.9),
                        ColorUtils.colorForLightsaber(lightsaber.color),
                        ColorUtils.colorForLightsaber(lightsaber.color).opacity(0.7)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(height: 8)
            .shadow(
                color: ColorUtils.colorForLightsaber(lightsaber.color),
                radius: isGlowing ? 12 : 6
            )
            .shadow(
                color: ColorUtils.colorForLightsaber(lightsaber.color).opacity(0.8),
                radius: isGlowing ? 20 : 12
            )
            .shadow(
                color: ColorUtils.colorForLightsaber(lightsaber.color).opacity(0.4),
                radius: isGlowing ? 30 : 20
            )
            .scaleEffect(y: isGlowing ? 1.3 : 1.0)
            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isGlowing)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct InactiveBladeView: View {
    let isActive: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 1)
            .fill(Color.gray.opacity(0.3))
            .frame(width: 12, height: 6)
            .scaleEffect(x: isActive ? 1.0 : 1.0, y: 1.0)
            .animation(.spring(response: 0.8, dampingFraction: 0.6), value: isActive)
    }
}

#Preview {
    GeometryReader { geometry in
        HStack {
            BladeView(
                lightsaber: Lightsaber.sampleData[0], 
                isActive: true, 
                isGlowing: true, 
                geometry: geometry
            )
            BladeView(
                lightsaber: Lightsaber.sampleData[1], 
                isActive: false, 
                isGlowing: false, 
                geometry: geometry
            )
        }
    }
    .frame(height: 50)
    .padding()
}
