//
//  DomainDI.swift
//  BreedMemo
//
//  Created by Thomas Rees-Lee on 2/9/2025.
//

class DomainDI {
    let data: DataDI

    init(data: DataDI) {
        self.data = data
    }

    func guessUseCase() -> GuessUseCase {
        return GuessUseCaseImpl(repository: data.dogRepository)
    }
}
