//
//  LightsaberDetailsSection.swift
//  lightsaber-app
//
//  Created by Claude on 24/07/25.
//

import SwiftUI

struct LightsaberDetailsSection: View {
    let lightsaber: Lightsaber
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            DetailRow(
                title: "Blade Color", 
                value: lightsaber.displayColor, 
                color: ColorUtils.colorForLightsaber(lightsaber.color)
            )
            DetailRow(title: "Crystal Type", value: lightsaber.crystalType)
            DetailRow(title: "Hilt Material", value: lightsaber.hiltMaterial)
            DetailRow(
                title: "Status", 
                value: lightsaber.isActive ? "Active" : "Inactive",
                color: lightsaber.isActive ? .green : .red
            )
            DetailRow(
                title: "Created", 
                value: DateFormatter.detailFormatter.string(from: lightsaber.createdAt)
            )
        }
    }
}

#Preview {
    LightsaberDetailsSection(lightsaber: Lightsaber.sampleData[0])
        .padding()
}