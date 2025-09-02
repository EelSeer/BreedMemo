//
//  MockDogRepository.swift
//  BreedMemo
//
//  Created by Thomas Rees-Lee on 1/9/2025.
//

import Foundation

class MockDogRepository: DogRepository {
    func fetchBreedList() async throws -> [String: [String]] {
        return [
            "affenpinscher": [],
            "african": [],
            "airedale": [],
            "akita": [],
            "appenzeller": [],
            "australian": ["kelpie", "shepherd"],
        ]
    }

    func fetchRandomDog() async throws -> Dog {
        return Dog(url: URL(string: "https://images.dog.ceo/breeds/spaniel-japanese/n02085782_1890.jpg")!)
    }
}
