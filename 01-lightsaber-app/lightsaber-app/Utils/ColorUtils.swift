//
//  ColorUtils.swift
//  lightsaber-app
//
//  Created by Claude on 24/07/25.
//

import SwiftUI

struct ColorUtils {
    static func colorForLightsaber(_ color: String) -> Color {
        switch color.lowercased() {
        case "blue": return .blue
        case "green": return .green
        case "red": return .red
        case "purple": return .purple
        case "yellow": return .yellow
        case "orange": return .orange
        case "white": return .white
        default: return .gray
        }
    }
    
    static func hiltColorForMaterial(_ material: String) -> Color {
        switch material.lowercased() {
        case "durasteel": return Color.gray
        case "electrum": return Color.yellow.opacity(0.8)
        case "phrik": return Color.gray.opacity(0.9)
        case "cortosis": return Color.black.opacity(0.8)
        case "beskar": return Color.gray.opacity(0.7)
        default: return Color.gray
        }
    }
    
    static func crystalColorForType(_ crystal: String) -> Color {
        switch crystal.lowercased() {
        case "kyber": return Color.cyan.opacity(0.6)
        case "synthetic": return Color.red.opacity(0.4)
        case "adegan": return Color.blue.opacity(0.4)
        case "barab": return Color.green.opacity(0.4)
        case "dragite": return Color.orange.opacity(0.4)
        default: return Color.cyan.opacity(0.4)
        }
    }
}