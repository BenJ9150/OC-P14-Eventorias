//
//  ErrorView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 24/04/2025.
//

import SwiftUI

struct ErrorView: View {
    let error: String
    @State private var appear = false
    @State private var animation = false

    var body: some View {
        VStack(spacing: 0) {
            Image("icon_error")
                .padding(.bottom, 24)
                .scaleEffect(appear ? 1 : 0)
                .offset(y: animation ? 0 : 10)
                
            Text("Error")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.bottom, 5)
            Text(error)
                .font(.callout)
                .multilineTextAlignment(.center)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Error. \(error)")
        .foregroundStyle(.white)
        .animation(
            .interactiveSpring(duration: 0.5, extraBounce: 0.5).repeatCount(3, autoreverses: false),
            value: animation
        )
        .onAppear {
            /// Haptic feedback
            UIFeedbackGenerator.triggerError()
            /// Animation
            withAnimation {
                appear = true
            }
            animation = true
        }
    }
}

// MARK: - Preview

#Preview {
    ErrorView(error: AppError.networkError.userMessage)
        .preferredColorScheme(.dark)
        .padding(.horizontal, 48)
}
