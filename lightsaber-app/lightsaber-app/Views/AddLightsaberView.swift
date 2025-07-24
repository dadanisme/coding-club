//
//  AddLightsaberView.swift
//  lightsaber-app
//
//  Created by Claude on 24/07/25.
//

import SwiftUI

struct AddLightsaberView: View {
    @EnvironmentObject var service: LightsaberService
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var selectedColor = "blue"
    @State private var creator = ""
    @State private var selectedCrystal = "Kyber"
    @State private var selectedMaterial = "Durasteel"
    @State private var isActive = true
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Basic Information") {
                    TextField("Lightsaber Name", text: $name)
                    TextField("Creator", text: $creator)
                }
                
                Section("Specifications") {
                    Picker("Blade Color", selection: $selectedColor) {
                        ForEach(Lightsaber.availableColors, id: \.self) { color in
                            HStack {
                                Circle()
                                    .fill(colorForLightsaber(color))
                                    .frame(width: 16, height: 16)
                                Text(color.capitalized)
                            }
                            .tag(color)
                        }
                    }
                    
                    Picker("Crystal Type", selection: $selectedCrystal) {
                        ForEach(Lightsaber.availableCrystals, id: \.self) { crystal in
                            Text(crystal).tag(crystal)
                        }
                    }
                    
                    Picker("Hilt Material", selection: $selectedMaterial) {
                        ForEach(Lightsaber.availableMaterials, id: \.self) { material in
                            Text(material).tag(material)
                        }
                    }
                }
                
                Section("Status") {
                    Toggle("Active", isOn: $isActive)
                }
            }
            .navigationTitle("Add Lightsaber")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveLightsaber()
                    }
                    .disabled(name.isEmpty || creator.isEmpty)
                }
            }
            .alert("Error", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func saveLightsaber() {
        let newLightsaber = Lightsaber(
            name: name,
            color: selectedColor,
            creator: creator,
            crystalType: selectedCrystal,
            hiltMaterial: selectedMaterial,
            isActive: isActive
        )
        
        Task {
            let success = await service.createLightsaber(newLightsaber)
            if success {
                dismiss()
            } else {
                alertMessage = service.errorMessage ?? "Failed to create lightsaber"
                showingAlert = true
            }
        }
    }
    
    private func colorForLightsaber(_ color: String) -> Color {
        ColorUtils.colorForLightsaber(color)
    }
}

#Preview {
    AddLightsaberView()
        .environmentObject(LightsaberService())
}