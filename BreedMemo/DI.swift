//
//  DI.swift
//  BreedMemo
//
//  Created by Thomas Rees-Lee on 2/9/2025.
//

import Foundation

class DI {
    let data: DataDI
    let domain: DomainDI

    init() {
        data = DataDI(session: URLSession.shared)
        domain = DomainDI(data: data)
    }
}
