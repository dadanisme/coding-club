//
//  LightsaberActivateButton.swift
//  lightsaber-app
//
//  Created by Claude on 24/07/25.
//

import SwiftUI

struct LightsaberActivateButton: View {
    let animatedIsActive: Bool
    let isToggling: Bool
    let lightsaber: Lightsaber
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack {
                if isToggling {
                    ProgressView()
                        .scaleEffect(0.8)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Image(systemName: animatedIsActive ? "power" : "bolt.fill")
                }
                
                Text(animatedIsActive ? "Deactivate" : "Activate")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                animatedIsActive 
                    ? Color.red.gradient 
                    : ColorUtils.colorForLightsaber(lightsaber.color).gradient
            )
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(
                color: animatedIsActive 
                    ? .red.opacity(0.3) 
                    : ColorUtils.colorForLightsaber(lightsaber.color).opacity(0.3), 
                radius: 8
            )
        }
        .disabled(isToggling)
        .padding(.top)
    }
}

#Preview {
    VStack {
        LightsaberActivateButton(
            animatedIsActive: true,
            isToggling: false,
            lightsaber: Lightsaber.sampleData[0],
            onToggle: {}
        )
        
        LightsaberActivateButton(
            animatedIsActive: false,
            isToggling: true,
            lightsaber: Lightsaber.sampleData[1],
            onToggle: {}
        )
    }
    .padding()
}