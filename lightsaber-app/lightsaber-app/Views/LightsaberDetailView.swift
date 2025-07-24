//
//  LightsaberDetailView.swift
//  lightsaber-app
//
//  Created by Claude on 24/07/25.
//

import SwiftUI

struct LightsaberDetailView: View {
    let lightsaber: Lightsaber
    @State private var showingEditSheet = false
    @State private var isToggling = false
    @State private var animatedIsActive: Bool
    @EnvironmentObject var service: LightsaberService
    @Environment(\.dismiss) private var dismiss
    
    init(lightsaber: Lightsaber) {
        self.lightsaber = lightsaber
        self._animatedIsActive = State(initialValue: lightsaber.isActive)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                LightsaberHeaderView(lightsaber: lightsaber, animatedIsActive: animatedIsActive)
                AnimatedLightsaberView(lightsaber: lightsaber, isActive: animatedIsActive)
                    .padding(.vertical)
                
                Divider()
                
                LightsaberDetailsSection(lightsaber: lightsaber)
                LightsaberActivateButton(
                    animatedIsActive: animatedIsActive,
                    isToggling: isToggling,
                    lightsaber: lightsaber,
                    onToggle: toggleLightsaberStatus
                )
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Lightsaber Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showingEditSheet = true
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditLightsaberView(lightsaber: lightsaber)
                .environmentObject(service)
        }
    }
    
    private func toggleLightsaberStatus() {
        isToggling = true
        
        // Animate the visual state change immediately for better UX
        withAnimation(.easeInOut(duration: 0.8)) {
            animatedIsActive.toggle()
        }
        
        // Create updated lightsaber with toggled status
        let updatedLightsaber = Lightsaber(
            id: lightsaber.id,
            name: lightsaber.name,
            color: lightsaber.color,
            creator: lightsaber.creator,
            crystalType: lightsaber.crystalType,
            hiltMaterial: lightsaber.hiltMaterial,
            createdAt: lightsaber.createdAt,
            isActive: !lightsaber.isActive
        )
        
        Task {
            let success = await service.updateLightsaber(updatedLightsaber)
            
            isToggling = false
            
            if !success {
                // Handle error - revert animation
                withAnimation(.easeInOut(duration: 0.3)) {
                    animatedIsActive = lightsaber.isActive
                }
                print("Failed to toggle lightsaber status")
            }
        }
    }
}

#Preview {
    NavigationView {
        LightsaberDetailView(lightsaber: Lightsaber.sampleData[0])
            .environmentObject(LightsaberService())
    }
}