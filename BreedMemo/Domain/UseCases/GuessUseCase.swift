//
//  GuessUseCase.swift
//  BreedMemo
//
//  Created by Thomas Rees-Lee on 2/9/2025.
//

struct GuessPuzzle {
    let dog: Dog
    let breedChoices: [String]
}

enum GuessUseCaseError: Error {
    case badDog
    case breedListSize
}

protocol GuessUseCase {
    func fetchMemoryPuzzle() async throws -> GuessPuzzle
}

class GuessUseCaseImpl: GuessUseCase {
    private let repository: DogRepository
    private var breedList: [String] = []

    init(repository: DogRepository) {
        self.repository = repository
    }

    func fetchMemoryPuzzle() async throws -> GuessPuzzle {
        // Fetch breed list if unavailable
        if breedList.isEmpty {
            breedList = try await repository.fetchBreedList().flatMap { key, value in
                if value.isEmpty { return [key] }
                return value.map {
                    key.capitalizedFirst + " " + $0.capitalizedFirst
                }
            }
        }

        // Breed list must be of sufficient size for a multiple choice quiz to function
        if breedList.count < 4 {
            throw GuessUseCaseError.breedListSize
        }

        // Get a random dog
        let randomDog = try await repository.fetchRandomDog()
        guard let breed = randomDog.breed else {
            throw GuessUseCaseError.badDog
        }

        // Create set of choices
        var breedChoices = Set<String>()
        breedChoices.insert(breed)

        while breedChoices.count < 3 {
            if let randomBreed = breedList.randomElement() {
                breedChoices.insert(randomBreed)
            }
        }

        return .init(dog: randomDog, breedChoices: breedChoices.shuffled())
    }
}
