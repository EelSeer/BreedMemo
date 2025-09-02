//
//  DataDI.swift
//  BreedMemo
//
//  Created by Thomas Rees-Lee on 2/9/2025.
//

import Foundation

class DataDI {
    let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    lazy var dogRepository: DogRepository = DogRepositoryImpl(session: session)
}
