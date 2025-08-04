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
    
    let baseURL = "https://lightsaber-server.vercel.app/api"
    
    // MARK: - API Methods
    
    func fetchLightsabers() {
        isFetchingLightsabers = true
        errorMessage = nil
        
        guard let url = URL(string: "\(baseURL)/lightsabers") else {
            errorMessage = "Invalid URL"
            isFetchingLightsabers = false
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.isFetchingLightsabers = false
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "No data received"
                    self.isFetchingLightsabers = false
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    
                    let response = try decoder.decode(APIResponse<[Lightsaber]>.self, from: data)
                    self.lightsabers = response.data
                } catch {
                    self.errorMessage = error.localizedDescription
                }
                
                self.isFetchingLightsabers = false
            }
        }
        task.resume()
    }
    
    func createLightsaber(_ lightsaber: Lightsaber, completion: @escaping (Bool) -> Void) {
        isCreatingLightsaber = true
        errorMessage = nil
        
        guard let url = URL(string: "\(baseURL)/lightsabers") else {
            errorMessage = "Invalid URL"
            isCreatingLightsaber = false
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let jsonData = try encoder.encode(lightsaber)
            request.httpBody = jsonData
        } catch {
            errorMessage = error.localizedDescription
            isCreatingLightsaber = false
            completion(false)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.isCreatingLightsaber = false
                    completion(false)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.errorMessage = "Invalid response"
                    self.isCreatingLightsaber = false
                    completion(false)
                    return
                }
                
                if httpResponse.statusCode == 201,
                   let data = data {
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        let newLightsaber = try decoder.decode(APIResponse<Lightsaber>.self, from: data)
                        self.lightsabers.append(newLightsaber.data)
                        self.isCreatingLightsaber = false
                        completion(true)
                    } catch {
                        self.errorMessage = error.localizedDescription
                        self.isCreatingLightsaber = false
                        completion(false)
                    }
                } else {
                    self.errorMessage = "Failed to create lightsaber"
                    self.isCreatingLightsaber = false
                    completion(false)
                }
            }
        }
        
        task.resume()
        
    }
    
    func updateLightsaber(_ lightsaber: Lightsaber, completion: @escaping (Bool) -> Void) {
        isUpdatingLightsaber = true
        errorMessage = nil
        
        guard let url = URL(string: "\(baseURL)/lightsabers/\(lightsaber.id)") else {
            errorMessage = "Invalid URL"
            isUpdatingLightsaber = false
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            
            let jsonData = try encoder.encode(lightsaber)
            request.httpBody = jsonData
        } catch {
            errorMessage = error.localizedDescription
            isUpdatingLightsaber = false
            completion(false)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.isUpdatingLightsaber = false
                    completion(false)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.errorMessage = "Invalid response"
                    self.isUpdatingLightsaber = false
                    completion(false)
                    return
                }
                
                if httpResponse.statusCode == 200 {
                    if let index = self.lightsabers.firstIndex(where: { $0.id == lightsaber.id }) {
                        self.lightsabers[index] = lightsaber
                    }
                    self.isUpdatingLightsaber = false
                    completion(true)
                } else {
                    self.errorMessage = "Failed to update lightsaber"
                    self.isUpdatingLightsaber = false
                    completion(false)
                }
            }
        }
        
        task.resume()
    }
    
    func deleteLightsaber(id: String, completion: @escaping (Bool) -> Void) {
        isDeletingLightsaber = true
        errorMessage = nil
        
        guard let url = URL(string: "\(baseURL)/lightsabers/\(id)") else {
            errorMessage = "Invalid URL"
            isDeletingLightsaber = false
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.isDeletingLightsaber = false
                    completion(false)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.errorMessage = "Invalid response"
                    self.isDeletingLightsaber = false
                    completion(false)
                    return
                }
                
                if httpResponse.statusCode == 204 {
                    self.lightsabers.removeAll { $0.id == id }
                    self.isDeletingLightsaber = false
                    completion(true)
                } else {
                    self.errorMessage = "Failed to delete lightsaber"
                    self.isDeletingLightsaber = false
                    completion(false)
                }
            }
        }
        
        task.resume()
    }
}

// MARK: - API Response Model
struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let data: T
    let message: String?
}

