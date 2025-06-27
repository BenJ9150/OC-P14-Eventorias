//
//  ErrorView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 24/04/2025.
//

import SwiftUI

struct ErrorView: View {

    private enum ErrorAnimationPhase: CaseIterable {
        case initial, lift, shakeLeft, shakRight

        var yOffset: CGFloat {
            switch self {
            case .initial: 10
            case .lift, .shakeLeft, .shakRight: 0
            }
        }
        
        var rotation: Angle {
            switch self {
            case .initial, .lift: Angle.degrees(0)
            case .shakeLeft: Angle.degrees(-20)
            case .shakRight: Angle.degrees(20)
            }
        }
    }

    private let animations = [
        ErrorAnimationPhase.initial,
        ErrorAnimationPhase.lift,
        ErrorAnimationPhase.shakeLeft,
        ErrorAnimationPhase.shakRight,
        ErrorAnimationPhase.shakeLeft,
        ErrorAnimationPhase.shakRight
    ]

    let error: String
    @State private var startAnimation = false

    var body: some View {
        VStack(spacing: 0) {
            Image("icon_error")
                .padding(.bottom, 24)
                .phaseAnimator(animations, trigger: startAnimation) { content, phase in
                    content
                        .offset(y: phase.yOffset)
                        .rotationEffect(phase.rotation, anchor: .top)
                } animation: { phase in
                    switch phase {
                    case .initial, .lift: .spring(bounce: 0.5)
                    case .shakeLeft, .shakRight: .easeInOut(duration: 0.15)
                    }
                }
                
            Text("Error")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.bottom, 5)
                .dynamicTypeSize(.xSmall ... .accessibility2)
            Text(error)
                .font(.callout)
                .multilineTextAlignment(.center)
                .dynamicTypeSize(.xSmall ... .accessibility2)
        }
        .padding(.horizontal)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Error. \(error)")
        .foregroundStyle(.white)
        .onAppear {
            /// Haptic feedback
            UIFeedbackGenerator.triggerError()
            /// Animation
            startAnimation = true
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.mainBackground
        ErrorView(error: AppError.networkError.userMessage)
    }
}
