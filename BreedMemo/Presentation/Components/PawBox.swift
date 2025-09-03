//
//  PawBox.swift
//  BreedMemo
//
//  Created by Thomas Rees-Lee on 1/9/2025.
//

import SwiftUI

struct PawBox: View {
    let total = 5
    var filled: Int

    var body: some View {
        ZStack {
            HStack {
                ForEach(0 ..< filled, id: \.self) { _ in
                    Image(systemName: "pawprint.fill")
                        .resizable()
                }
                ForEach(0 ..< total - filled, id: \.self) { _ in
                    Image(systemName: "pawprint")
                        .resizable()
                }
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 20.0)
                .fill(Color.cyan)
            )
        }
        .fixedSize()
    }
}

#Preview {
    PawBox(filled: 0)
    PawBox(filled: 3)
    PawBox(filled: 5)
}
