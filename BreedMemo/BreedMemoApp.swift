//
//  BreedMemoApp.swift
//  BreedMemo
//
//  Created by Thomas Rees-Lee on 1/9/2025.
//

import SwiftData
import SwiftUI

@main
struct BreedMemoApp: App {
    let di = DI()

    var body: some Scene {
        WindowGroup {
            GuessView(guessUseCase: di.domain.guessUseCase())
        }
    }
}
