//
//  LightsaberHeaderView.swift
//  lightsaber-app
//
//  Created by Claude on 24/07/25.
//

import SwiftUI

struct LightsaberHeaderView: View {
    let lightsaber: Lightsaber
    let animatedIsActive: Bool
    
    var body: some View {
        HStack {
            Circle()
                .fill(ColorUtils.colorForLightsaber(lightsaber.color))
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading) {
                Text(lightsaber.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Created by \(lightsaber.creator)")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if !animatedIsActive {
                Text("Inactive")
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.red.opacity(0.2))
                    .foregroundColor(.red)
                    .cornerRadius(12)
            }
        }
    }
}

#Preview {
    VStack {
        LightsaberHeaderView(lightsaber: Lightsaber.sampleData[0], animatedIsActive: true)
        LightsaberHeaderView(lightsaber: Lightsaber.sampleData[1], animatedIsActive: false)
    }
    .padding()
}