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
        case ready
        case loadPuzzle
        case loadedPuzzle
        case error
        case guessed
    }

    let guessUseCase: GuessUseCase

    @State private var currentPuzzle: GuessPuzzle?
    @State private var state: GuessViewState = .ready

    var contentView: some View {
        VStack {
            HStack {
                Spacer()
                PawBox(filled: 0)
                    .frame(width: 200, height: 50)
                    .padding(10)
            }
            AsyncImage(url: currentPuzzle?.dog.url)
        }
    }

    var errorView: some View {
        VStack {
            Text("Error loading puzzle")
            Button("Retry") {
                state = .loadPuzzle
            }
        }
    }

    var body: some View {
        ZStack {
            switch state {
            case .ready:
                EmptyView()
            case .loadPuzzle:
                ProgressView()
            case .loadedPuzzle, .guessed:
                contentView
            case .error:
                errorView
            }
        }
        .task {
            state = .loadPuzzle
        }
        .task(id: state) {
            switch state {
            case .loadPuzzle:
                do {
                    currentPuzzle = try await guessUseCase.fetchMemoryPuzzle()
                    state = .loadedPuzzle
                } catch {
                    state = .error
                }
            default:
                break
            }
        }
    }
}

#Preview {
    GuessView(guessUseCase: GuessUseCaseImpl(repository: MockDogRepository()))
}
