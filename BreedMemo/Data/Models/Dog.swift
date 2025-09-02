//
//  Dog.swift
//  BreedMemo
//
//  Created by Thomas Rees-Lee on 1/9/2025.
//

import Foundation

struct Dog {
    let url: URL

    // Having to dig details out of the url should require
    // us to validate that the URL conforms to the expected type
    // and that it's not some random image. Currently though,
    // if we get a valid URL with a strange path all we can do
    // is return the given breed/subbreed. We could do some client
    // validation but actually we should just get a proper body back
    // instead with the appropriate parameters.
    var breed: String? {
        guard url.pathComponents.count > 2 else { return nil }
        let components = url.pathComponents[2].components(separatedBy: "-").map { name in
            name.capitalizedFirst
        }
        return components.joined(separator: " ")
    }
}
