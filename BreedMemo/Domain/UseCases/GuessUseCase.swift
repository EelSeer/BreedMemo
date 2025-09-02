//
//  GuessUseCase.swift
//  BreedMemo
//
//  Created by Thomas Rees-Lee on 2/9/2025.
//

/// Model representing a single memory puzzle, containing
/// a set of possible and a single dog entity.
struct GuessPuzzle {
    let dog: Dog
    let breedChoices: [String]
}

/// Fetches relevant content to compose
/// a puzzle object
protocol GuessUseCase {
    func fetchMemoryPuzzle() async throws -> GuessPuzzle
}

/// Concrete implementation fetches data from remote
/// repository and throws an error if the request fails or
/// is malformed
class GuessUseCaseImpl: GuessUseCase {
    private let repository: DogRepository
    private var breedList: [String] = []

    init(repository: DogRepository) {
        self.repository = repository
    }

    func fetchMemoryPuzzle() async throws -> GuessPuzzle {
        // Fetch breed list if unavailable
        if breedList.isEmpty {
            do {
                breedList = try await repository.fetchBreedList().flatMap { key, value in
                    if value.isEmpty { return [key] }
                    return value.map {
                        key.capitalizedFirst + " " + $0.capitalizedFirst
                    }
                }
            } catch {
                throw GuessUseCaseError.network
            }
        }

        // Breed list must be of sufficient size for a multiple choice quiz to function
        if breedList.count < 4 {
            throw GuessUseCaseError.breedListSize
        }

        // Get a random dog
        let randomDog: Dog
        do {
            randomDog = try await repository.fetchRandomDog()
        } catch {
            throw GuessUseCaseError.network
        }

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

enum GuessUseCaseError: Error {
    case badDog
    case breedListSize
    case network
}
