//
//  HiltComponents.swift
//  lightsaber-app
//
//  Created by Claude on 24/07/25.
//

import SwiftUI

struct PommelView: View {
    let material: String
    
    var body: some View {
        Circle()
            .fill(ColorUtils.hiltColorForMaterial(material).opacity(0.9))
            .frame(width: 16, height: 16)
            .overlay(
                Circle()
                    .stroke(Color.black.opacity(0.3), lineWidth: 0.5)
            )
    }
}

struct LowerGripView: View {
    let material: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(
                LinearGradient(
                    colors: [
                        ColorUtils.hiltColorForMaterial(material).opacity(0.8),
                        ColorUtils.hiltColorForMaterial(material),
                        ColorUtils.hiltColorForMaterial(material).opacity(0.8)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: 32, height: 14)
            .overlay(
                // Grip texture (horizontal lines)
                HStack(spacing: 1) {
                    ForEach(0..<5, id: \.self) { _ in
                        Rectangle()
                            .fill(Color.black.opacity(0.2))
                            .frame(width: 0.5, height: 10)
                    }
                }
            )
    }
}

struct CrystalChamberView: View {
    let crystalType: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(ColorUtils.crystalColorForType(crystalType))
            .frame(width: 20, height: 12)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(ColorUtils.crystalColorForType(crystalType).opacity(0.5), lineWidth: 0.5)
            )
            .shadow(color: ColorUtils.crystalColorForType(crystalType), radius: 3)
            .shadow(color: ColorUtils.crystalColorForType(crystalType).opacity(0.6), radius: 6)
    }
}

struct UpperGripView: View {
    let material: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(
                LinearGradient(
                    colors: [
                        ColorUtils.hiltColorForMaterial(material).opacity(0.8),
                        ColorUtils.hiltColorForMaterial(material),
                        ColorUtils.hiltColorForMaterial(material).opacity(0.8)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: 28, height: 14)
            .overlay(
                // Grip details (horizontal lines)
                HStack(spacing: 1) {
                    ForEach(0..<4, id: \.self) { _ in
                        Rectangle()
                            .fill(Color.black.opacity(0.3))
                            .frame(width: 0.5, height: 10)
                    }
                }
            )
    }
}

struct EmitterView: View {
    let material: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(ColorUtils.hiltColorForMaterial(material))
            .frame(width: 8, height: 12)
    }
}

#Preview {
    HStack(spacing: 2) {
        PommelView(material: "Durasteel")
        LowerGripView(material: "Durasteel")
        CrystalChamberView(crystalType: "Kyber")
        UpperGripView(material: "Durasteel")
        EmitterView(material: "Durasteel")
    }
    .padding()
}