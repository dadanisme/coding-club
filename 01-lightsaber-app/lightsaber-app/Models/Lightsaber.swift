//
//  Lightsaber.swift
//  lightsaber-app
//
//  Created by Claude on 24/07/25.
//

import Foundation

struct Lightsaber: Identifiable, Codable {
    let id: String
    let name: String
    let color: String
    let creator: String
    let crystalType: String
    let hiltMaterial: String
    let createdAt: Date
    let isActive: Bool
    
    init(id: String = UUID().uuidString, name: String, color: String, creator: String, crystalType: String, hiltMaterial: String, createdAt: Date = Date(), isActive: Bool = true) {
        self.id = id
        self.name = name
        self.color = color
        self.creator = creator
        self.crystalType = crystalType
        self.hiltMaterial = hiltMaterial
        self.createdAt = createdAt
        self.isActive = isActive
    }
}

// MARK: - Sample Data
extension Lightsaber {
    static let sampleData: [Lightsaber] = [
        Lightsaber(
            name: "Luke's Lightsaber",
            color: "blue",
            creator: "Luke Skywalker",
            crystalType: "Kyber",
            hiltMaterial: "Durasteel"
        ),
        Lightsaber(
            name: "Darth Vader's Lightsaber",
            color: "red",
            creator: "Darth Vader",
            crystalType: "Synthetic",
            hiltMaterial: "Durasteel",
            isActive: false
        ),
        Lightsaber(
            name: "Mace Windu's Lightsaber",
            color: "purple",
            creator: "Mace Windu",
            crystalType: "Kyber",
            hiltMaterial: "Electrum"
        )
    ]
}

// MARK: - Color Extensions
extension Lightsaber {
    var displayColor: String {
        color.capitalized
    }
    
    static let availableColors = ["blue", "green", "red", "purple", "yellow", "white", "orange"]
    static let availableCrystals = ["Kyber", "Synthetic", "Adegan", "Barab", "Dragite"]
    static let availableMaterials = ["Durasteel", "Electrum", "Phrik", "Cortosis", "Beskar"]
}