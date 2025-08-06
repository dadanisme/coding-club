//
//  PlanetService.swift
//  the-app
//
//  Created by Ramdan on 05/08/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case decodingError
    case requestFailed
}

class PlanetService {
    static func fetchPlanets(completion: @escaping (Result<[Planet], APIError>) -> Void) {
        guard let url = URL(string: "https://swapi.info/api/planets") else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(.failure(.requestFailed))
                return
            }
            
            guard let data = data else {
                completion(.failure(.requestFailed))
                return
            }
            
            do {
                let planets = try JSONDecoder().decode([Planet].self, from: data)
                completion(.success(planets))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
    
    static func fetchPlanet(planetId: String, completion: @escaping (Result<Planet, APIError>) -> Void) {
        guard let url = URL(string: "https://swapi.info/api/planets/\(planetId)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(.failure(.requestFailed))
                return
            }
            
            guard let data = data else {
                completion(.failure(.requestFailed))
                return
            }
            
            do {
                let planet = try JSONDecoder().decode(Planet.self, from: data)
                completion(.success(planet))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
}
