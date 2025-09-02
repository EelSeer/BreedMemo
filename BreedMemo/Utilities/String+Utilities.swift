//
//  String+Utilities.swift
//  BreedMemo
//
//  Created by Thomas Rees-Lee on 2/9/2025.
//

extension String {
    var capitalizedFirst: String {
        prefix(1).capitalized + dropFirst()
    }
}
