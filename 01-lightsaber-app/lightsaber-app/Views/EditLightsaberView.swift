//
//  EditLightsaberView.swift
//  lightsaber-app
//
//  Created by Claude on 24/07/25.
//

import SwiftUI

struct EditLightsaberView: View {
    let lightsaber: Lightsaber
    @EnvironmentObject var service: LightsaberService
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String
    @State private var selectedColor: String
    @State private var creator: String
    @State private var selectedCrystal: String
    @State private var selectedMaterial: String
    @State private var isActive: Bool
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    init(lightsaber: Lightsaber) {
        self.lightsaber = lightsaber
        self._name = State(initialValue: lightsaber.name)
        self._selectedColor = State(initialValue: lightsaber.color)
        self._creator = State(initialValue: lightsaber.creator)
        self._selectedCrystal = State(initialValue: lightsaber.crystalType)
        self._selectedMaterial = State(initialValue: lightsaber.hiltMaterial)
        self._isActive = State(initialValue: lightsaber.isActive)
    }
    
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
                
                Section("Metadata") {
                    HStack {
                        Text("ID")
                        Spacer()
                        Text(lightsaber.id)
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                    
                    HStack {
                        Text("Created")
                        Spacer()
                        Text(DateFormatter.detailFormatter.string(from: lightsaber.createdAt))
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Edit Lightsaber")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        updateLightsaber()
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
    
    private func updateLightsaber() {
        let updatedLightsaber = Lightsaber(
            id: lightsaber.id,
            name: name,
            color: selectedColor,
            creator: creator,
            crystalType: selectedCrystal,
            hiltMaterial: selectedMaterial,
            createdAt: lightsaber.createdAt,
            isActive: isActive
        )
        
        Task {
            let success = await service.updateLightsaber(updatedLightsaber)
            if success {
                dismiss()
            } else {
                alertMessage = service.errorMessage ?? "Failed to update lightsaber"
                showingAlert = true
            }
        }
    }
    
    private func colorForLightsaber(_ color: String) -> Color {
        ColorUtils.colorForLightsaber(color)
    }
}

#Preview {
    EditLightsaberView(lightsaber: Lightsaber.sampleData[0])
        .environmentObject(LightsaberService())
}