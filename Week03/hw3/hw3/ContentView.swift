//
//  PresentsView.swift
//  hw3
//
//  Created by Oleksandr A. on 25/09/2025.
//

import SwiftUI

struct SpawnedEmoji: Identifiable {
    let id = UUID()
    let char: String
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
}

struct PresentsView: View {
    @State private var presents = ["🎁","🧸","🍫","🧦","🎈","🧩","🪀","🍪","🪁","🧃","🪙"].shuffled()
    @State private var spawned: [SpawnedEmoji] = []

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // all spawned emojis
                ForEach(spawned) { e in
                    Text(e.char)
                        .font(.system(size: e.size))
                        .position(x: e.x, y: e.y)
                        .transition(.scale.combined(with: .opacity))
                }

                // centered box + label
                VStack(spacing: 10) {
                    Spacer()

                    Button {
                        openPresent(in: geo.size) // place emoji in random place on screen
                    } label: {
                        Text("📦")
                            .font(.system(size: 140))
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .disabled(presents.isEmpty)

                    Text(presents.isEmpty ? "all out of presents" : "click to open presents")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            }
            .animation(.default, value: presents.isEmpty)
        }
    }

    private func openPresent(in size: CGSize) {
        guard let next = presents.popLast() else { return }

        let margin: CGFloat = 60           // keep away from edges
        let x = CGFloat.random(in: margin...(size.width - margin))
        let y = CGFloat.random(in: margin...(size.height - margin*4))
        let s = CGFloat.random(in: 40...120)

        let new = SpawnedEmoji(char: next, x: x, y: y, size: s)
        withAnimation {
            spawned.append(new)
        }
    }
}

#Preview {
    PresentsView()
}
