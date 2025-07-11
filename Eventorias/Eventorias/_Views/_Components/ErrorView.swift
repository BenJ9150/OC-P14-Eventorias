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
    @AccessibilityFocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            if UIAccessibility.isReduceMotionEnabled {
                Image("icon_error")
                    .padding(.bottom, 24)
            } else if #available(iOS 17.0, *) {
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
            } else {
                // Fallback on earlier versions
                Image("icon_error")
                    .padding(.bottom, 24)
                    .rotationEffect(.degrees(startAnimation ? 0 : 45), anchor: .top)
                    .animation(.spring(response: 0.6, dampingFraction: 0.2), value: startAnimation)
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
        .accessibilityFocused($isFocused)
        .foregroundStyle(.white)
        .onAppear {
            /// Haptic feedback
            UIFeedbackGenerator.triggerError()
            /// Animation
            startAnimation = true
            /// Voice Over alert
            isFocused = true
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
