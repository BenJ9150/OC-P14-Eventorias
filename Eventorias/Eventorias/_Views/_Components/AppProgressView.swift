//
//  AppProgressView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 24/04/2025.
//

import SwiftUI

struct AppProgressView: View {

    private enum ProgressAnimationPhase: CaseIterable {
        case initial, normal, fast, slow

        var scale: CGFloat {
            switch self {
            case .initial: 0.5
            case .normal, .fast, .slow: 1
            }
        }
        var rotation: Angle {
            switch self {
            case .initial: Angle.degrees(0)
            case .normal: Angle.degrees(360 * 2)
            case .fast: Angle.degrees(360 * 3)
            case .slow: Angle.degrees(360)
            }
        }
    }

    @State private var onAppearAnimation = false

    var body: some View {
        Image("circular_progress_view")
            .opacity(onAppearAnimation ? 1 : 0)
            .phaseAnimator(ProgressAnimationPhase.allCases) { content, phase in
                content
                    .scaleEffect(phase.scale)
                    .rotationEffect(phase.rotation)
            } animation: { phase in
                switch phase {
                case .initial: .spring(bounce: 0.5)
                case .normal, .fast, .slow: .easeInOut(duration: 1)
                }
            }
            .onAppear {
                withAnimation { onAppearAnimation = true }
            }
    }
}

// MARK: - Preview

#Preview {
    AppProgressView()
}
