//
//  DogRepository.swift
//  BreedMemo
//
//  Created by Thomas Rees-Lee on 1/9/2025.
//

import Foundation

/// Protocol for fetching information on dogs.
protocol DogRepository {
    /// - Returns: Dictionary of dog breeds with subbreeds in stored
    /// array.
    func fetchBreedList() async throws -> [String: [String]]

    /// - Returns: Image URL for a random dog.
    func fetchRandomDog() async throws -> Dog
}

/// Concrete implementation of DogRepository, fetching from remote service.
class DogRepositoryImpl: DogRepository {
    struct BreedListResponse: Codable {
        let message: [String: [String]]
        let status: String
    }

    struct RandomImageResponse: Codable {
        let message: String
        let status: String
    }

    let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func fetchBreedList() async throws -> [String: [String]] {
        do {
            let url = URL(string: "https://dog.ceo/api/breeds/list/all")
            let (data, _) = try await session.data(from: url!)
            let decoder = JSONDecoder()
            let list = try decoder.decode(BreedListResponse.self, from: data)
            return list.message
        }
    }

    func fetchRandomDog() async throws -> Dog {
        do {
            let url = URL(string: "https://dog.ceo/api/breeds/image/random")
            let (data, _) = try await session.data(from: url!)
            let decoder = JSONDecoder()
            let response = try decoder.decode(RandomImageResponse.self, from: data)

            if let url = URL(string: response.message) {
                return Dog(url: url)
            }
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
    }
}
