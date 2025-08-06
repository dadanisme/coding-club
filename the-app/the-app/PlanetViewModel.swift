//
//  PlanetViewModel.swift
//  the-app
//
//  Created by Ramdan on 05/08/25.
//

import Foundation
internal import Combine

class PlanetViewModel: ObservableObject {
    @Published var planets: [Planet] = []
    @Published var errorMessage: String?
    
    func loadPlanets() {
        PlanetService.fetchPlanets { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let planets):
                    self?.planets = planets
                case .failure(let error):
                    self?.errorMessage = self?.mapError(error)
                }
            }
        }
    }
    
    private func mapError(_ error: APIError) -> String {
        switch error {
        case .decodingError:
            return "Failed to decode data"
        case .invalidURL:
            return "Invalid URL"
        case .requestFailed:
            return "Request failed"
        }
    }
    
}
