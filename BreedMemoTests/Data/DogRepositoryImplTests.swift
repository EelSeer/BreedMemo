//
//  DogRepositoryImplTests.swift
//  BreedMemo
//
//  Created by Thomas Rees-Lee on 1/9/2025.
//

@testable import BreedMemo
import Foundation
import Testing

/// Testing the concrete implementation of DogRepository
/// Tests are currently seralized since using the MockURLProtocol method
/// of intercepting requests causes multiple tests running to fail. A better method
/// of mocking requests should be found.

@Suite(.serialized) class DogRepositoryImplTests {
    private let repository: DogRepositoryImpl

    init() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        repository = DogRepositoryImpl(session: urlSession)
    }

    deinit {
        MockURLProtocol.requestHandler = nil
        MockURLProtocol.error = nil
    }

    @Test func fetchListSuccess() async throws {
        MockURLProtocol.requestHandler = { _ in
            let json = """
            {
                "message": {
                        "akita": [],
                        "australian": [
                            "kelpie",
                            "shepherd"
                        ]
                },
                "status": "success"
            }
            """

            let data = json.data(using: .utf8)
            let response = HTTPURLResponse(
                url: URL(string: "https://dog.ceo/api/breeds/list/all")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, data)
        }

        let list = await repository.fetchBreedList()
        switch list {
        case let .success(list):
            #expect(list.count == 2)
            #expect(list["akita"] == [])
            #expect(list["australian"] == ["kelpie", "shepherd"])
        case .failure:
            #expect(Bool(false))
        }
    }

    @Test func fetchListFailure() async throws {
        MockURLProtocol.error = URLError(.unknown)
        let list = await repository.fetchBreedList()
        switch list {
        case .success:
            #expect(Bool(false))
        case .failure:
            #expect(Bool(true))
        }
    }

    @Test func fetchRandomImageSuccess() async throws {
        MockURLProtocol.requestHandler = { _ in
            let json = """
            {
                "message": "https://images.dog.ceo/breeds/schipperke/n02104365_7768.jpg",
                "status": "success"
            }
            """
            let data = json.data(using: .utf8)
            let response = HTTPURLResponse(
                url: URL(string: "https://dog.ceo/api/breeds/image/random")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, data)
        }

        let list = await repository.fetchRandomDog()
        switch list {
        case let .success(imagePath):
            #expect(imagePath == "https://images.dog.ceo/breeds/schipperke/n02104365_7768.jpg")
        case .failure:
            #expect(Bool(false))
        }
    }

    @Test func fetchRandomImageFailure() async throws {
        MockURLProtocol.error = URLError(.unknown)
        let list = await repository.fetchRandomDog()
        switch list {
        case .success:
            #expect(Bool(false))
        case .failure:
            #expect(Bool(true))
        }
    }
}
