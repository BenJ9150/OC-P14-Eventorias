//
//  AppProgressView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 24/04/2025.
//

import SwiftUI

struct AppProgressView: View {
    private let duration = 0.9
    @State private var isAnimating = false
    @State private var angle: Angle = .degrees(0)

    var body: some View {
        ZStack {
            Image("circular_progress_view")
                .rotationEffect(angle)
                .animation(.easeInOut(duration: duration), value: angle)
                .onAppear {
                    spin()
                }
        }
        .rotationEffect(.degrees(isAnimating ? 360 : 0))
        .animation(.linear(duration: 2.0).repeatForever(autoreverses: false), value: isAnimating)
        .onAppear {
            isAnimating = true
        }
    }

    private func spin() {
        angle += .degrees(Double.random(in: 90...360))
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            spin()
        }
    }
}

// MARK: - Preview

#Preview {
    AppProgressView()
}
