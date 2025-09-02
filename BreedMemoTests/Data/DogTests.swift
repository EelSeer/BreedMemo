//
//  DogTests.swift
//  BreedMemo
//
//  Created by Thomas Rees-Lee on 2/9/2025.
//

@testable import BreedMemo
import Foundation
import Testing

@Suite(.serialized) class DogTests {
    @Test func breedName() async throws {
        let noSubbreed = Dog(url: URL(string: "https://images.dog.ceo/breeds/schipperke/n02104365_7768.jpg")!)
        let subbreed = Dog(url: URL(string: "https://images.dog.ceo/breeds/australian-kelpie/n02104365_7768.jpg")!)

        #expect(noSubbreed.breed == "Schipperke")
        #expect(subbreed.breed == "Australian Kelpie")
    }
}
