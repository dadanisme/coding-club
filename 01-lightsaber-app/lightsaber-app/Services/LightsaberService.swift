//
//  LightsaberService.swift
//  lightsaber-app
//
//  Created by Claude on 24/07/25.
//

import Foundation
import Combine

@MainActor
class LightsaberService: ObservableObject {
    @Published var lightsabers: [Lightsaber] = []
    @Published var errorMessage: String?
    
    // Specific loading states for each endpoint
    @Published var isFetchingLightsabers = false
    @Published var isCreatingLightsaber = false
    @Published var isUpdatingLightsaber = false
    @Published var isDeletingLightsaber = false
    
    let baseURL = "http://localhost:3000/api"
    
    init() {
        // TODO: Initialize service - no sample data loaded
        // Students should implement fetchLightsabers() to load data
    }
    
    // MARK: - API Methods (TODO: Implement actual API calls)
    
    func fetchLightsabers() async {
        isFetchingLightsabers = true
        errorMessage = nil
        
        // TODO: Implement GET /api/lightsabers
        // Fetch lightsabers from the API and update the lightsabers array
        // Handle errors by setting errorMessage
        // Set isFetchingLightsabers = false when done
        
        isFetchingLightsabers = false
        
        /*
        TODO: Replace with actual API implementation:
        
        guard let url = URL(string: "\(baseURL)/lightsabers") else {
            errorMessage = "Invalid URL"
            isFetchingLightsabers = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(APIResponse<[Lightsaber]>.self, from: data)
            lightsabers = response.data
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isFetchingLightsabers = false
        */
    }
    
    func createLightsaber(_ lightsaber: Lightsaber) async -> Bool {
        isCreatingLightsaber = true
        errorMessage = nil
        
        // TODO: Implement POST /api/lightsabers
        // Send lightsaber data to API, handle response
        // Add created lightsaber to lightsabers array on success
        // Handle errors by setting errorMessage
        // Set isCreatingLightsaber = false when done
        // Return true on success, false on failure
        
        isCreatingLightsaber = false
        return false
        
        /*
        TODO: Replace with actual API implementation:
        
        guard let url = URL(string: "\(baseURL)/lightsabers") else {
            errorMessage = "Invalid URL"
            isCreatingLightsaber = false
            return false
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(lightsaber)
            request.httpBody = jsonData
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 201 {
                let newLightsaber = try JSONDecoder().decode(Lightsaber.self, from: data)
                lightsabers.append(newLightsaber)
                isCreatingLightsaber = false
                return true
            } else {
                errorMessage = "Failed to create lightsaber"
                isCreatingLightsaber = false
                return false
            }
        } catch {
            errorMessage = error.localizedDescription
            isCreatingLightsaber = false
            return false
        }
        */
    }
    
    func updateLightsaber(_ lightsaber: Lightsaber) async -> Bool {
        isUpdatingLightsaber = true
        errorMessage = nil
        
        // TODO: Implement PATCH /api/lightsabers/:id
        // Send updated lightsaber data to API
        // Update lightsaber in lightsabers array on success
        // Handle errors by setting errorMessage
        // Set isUpdatingLightsaber = false when done
        // Return true on success, false on failure
        
        isUpdatingLightsaber = false
        return false
        
        /*
        TODO: Replace with actual API implementation:
        
        guard let url = URL(string: "\(baseURL)/lightsabers/\(lightsaber.id)") else {
            errorMessage = "Invalid URL"
            isUpdatingLightsaber = false
            return false
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(lightsaber)
            request.httpBody = jsonData
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200 {
                if let index = lightsabers.firstIndex(where: { $0.id == lightsaber.id }) {
                    lightsabers[index] = lightsaber
                }
                isUpdatingLightsaber = false
                return true
            } else {
                errorMessage = "Failed to update lightsaber"
                isUpdatingLightsaber = false
                return false
            }
        } catch {
            errorMessage = error.localizedDescription
            isUpdatingLightsaber = false
            return false
        }
        */
    }
    
    func deleteLightsaber(id: String) async -> Bool {
        isDeletingLightsaber = true
        errorMessage = nil
        
        // TODO: Implement DELETE /api/lightsabers/:id
        // Send delete request to API with lightsaber ID
        // Remove lightsaber from lightsabers array on success
        // Handle errors by setting errorMessage
        // Set isDeletingLightsaber = false when done
        // Return true on success, false on failure
        
        isDeletingLightsaber = false
        return false
        
        /*
        TODO: Replace with actual API implementation:
        
        guard let url = URL(string: "\(baseURL)/lightsabers/\(id)") else {
            errorMessage = "Invalid URL"
            isDeletingLightsaber = false
            return false
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200 {
                lightsabers.removeAll { $0.id == id }
                isDeletingLightsaber = false
                return true
            } else {
                errorMessage = "Failed to delete lightsaber"
                isDeletingLightsaber = false
                return false
            }
        } catch {
            errorMessage = error.localizedDescription
            isDeletingLightsaber = false
            return false
        }
        */
    }
}

// MARK: - API Response Model
struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let data: T
    let message: String?
}
