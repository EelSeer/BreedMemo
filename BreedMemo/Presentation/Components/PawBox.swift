//
//  PawBox.swift
//  BreedMemo
//
//  Created by Thomas Rees-Lee on 1/9/2025.
//

import SwiftUI

struct PawBox: View {
    let total = 5
    @State var filled: Int

    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: .init(width: 20.0, height: 20.0))
                .fill(.cyan)
            HStack {
                ForEach(0 ..< filled, id: \.self) { _ in
                    Image(systemName: "pawprint.fill")
                }
                ForEach(0 ..< total - filled, id: \.self) { _ in
                    Image(systemName: "pawprint")
                }
            }
        }
    }
}

#Preview {
    PawBox(filled: 0).frame(width: 200, height: 50)
    PawBox(filled: 3).frame(width: 200, height: 50)
    PawBox(filled: 5).frame(width: 200, height: 50)
}
