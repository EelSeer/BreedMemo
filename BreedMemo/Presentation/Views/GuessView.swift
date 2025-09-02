//
//  GuessView.swift
//  BreedMemo
//
//  Created by Thomas Rees-Lee on 1/9/2025.
//

import SwiftData
import SwiftUI

struct GuessView: View {
    let guessUseCase: GuessUseCase

    @State private var currentPuzzle: GuessPuzzle?

    @State private var loading = true
    @State private var showError = false

    var body: some View {
        VStack {
            HStack {
                Spacer()
                PawBox(filled: 0)
                    .frame(width: 200, height: 50)
                    .padding(10)
            }
            Grid {
                GridRow {
                    Button("Guess") {}
                    Button("Guess") {}
                }
                GridRow {
                    Button("Guess") {}
                    Button("Guess") {}
                }
            }
        }.task {
            do {
                currentPuzzle = try await guessUseCase.fetchMemoryPuzzle()
                loading = false
            } catch {
                loading = false
                showError = true
            }
        }
    }
}

#Preview {
    GuessView(guessUseCase: GuessUseCaseImpl(repository: MockDogRepository()))
}
