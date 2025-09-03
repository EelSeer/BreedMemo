//
//  GuessView.swift
//  BreedMemo
//
//  Created by Thomas Rees-Lee on 1/9/2025.
//

import SwiftData
import SwiftUI

struct GuessView: View {
    enum GuessViewState {
        case loading // Initial state
        case promptGuess // Enable guess prompt
        case incorrectGuess // User guessed incorrectly
        case correctGuess // User guessed correctly
        case error // Show error & retry state
    }

    let guessUseCase: GuessUseCase

    @State private var currentPuzzle: GuessPuzzle?
    @State private var state: GuessViewState = .loading
    @State private var streakCount = 0
    @State private var loadNewPuzzle = false

    var contentView: some View {
        ZStack {
            VStack {
                HStack {
                    PawBox(filled: streakCount)
                        .frame(width: 200, height: 50, alignment: .center)
                        .padding(10)
                }

                if let announceText {
                    Text(announceText)
                }

                if let currentPuzzle {
                    AsyncImage(url: currentPuzzle.dog.url) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Color.gray
                    }
                } else {
                    ProgressView()
                }

                VStack {
                    if let breedNames = currentPuzzle?.breedChoices {
                        ForEach(breedNames, id: \.self) { name in
                            Button(name) {
                                state = (name == currentPuzzle?.dog.breed) ? .correctGuess : .incorrectGuess
                            }
                            .buttonStyle(.bordered)
                            .disabled(state != .promptGuess)
                        }
                    }
                }
                Spacer()
            }
        }
        .padding(.horizontal, 10)
        .frame(alignment: .top)
    }

    var announceText: String? {
        switch state {
        case .promptGuess:
            "Guess that dog!"
        case .incorrectGuess:
            "Incorrect... it was a \(currentPuzzle?.dog.breed ?? "unknown")"
        case .correctGuess:
            "Correct! It was a \(currentPuzzle?.dog.breed ?? "unknown")"
        default:
            nil
        }
    }

    var errorView: some View {
        VStack {
            Text("Error loading puzzle")
            Button("Retry") {
                state = .loading
            }
        }
    }

    var body: some View {
        ZStack {
            switch state {
            case .loading:
                ProgressView()
            case .promptGuess, .incorrectGuess, .correctGuess:
                contentView
            case .error:
                errorView
            }
        }
        .task(id: loadNewPuzzle) {
            if loadNewPuzzle {
                do {
                    currentPuzzle = try await guessUseCase.fetchMemoryPuzzle()
                    state = .promptGuess
                    loadNewPuzzle = false
                } catch {
                    state = .error
                    loadNewPuzzle = false
                }
            }
        }
        .task(id: state) {
            switch state {
            case .loading:
                loadNewPuzzle = true
            case .correctGuess:
                streakCount += 1
                try? await Task.sleep(nanoseconds: 500_000_000)
                loadNewPuzzle = true
            case .incorrectGuess:
                streakCount = 0
                try? await Task.sleep(nanoseconds: 500_000_000)
                loadNewPuzzle = true
            default:
                break
            }
        }
    }
}

#Preview {
    GuessView(guessUseCase: GuessUseCaseImpl(repository: MockDogRepository()))
}
