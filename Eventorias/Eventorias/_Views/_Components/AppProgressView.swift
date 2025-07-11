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
    @State private var otherAnimation = false

    var body: some View {
        ZStack {
            if UIAccessibility.isReduceMotionEnabled {
                ProgressView()
                    .tint(.white)
                    .controlSize(.large)
            } else if #available(iOS 17.0, *) {
                Image("circular_progress_view")
                    .phaseAnimator(ProgressAnimationPhase.allCases) { content, phase in
                        content
                            .scaleEffect(phase.scale)
                            .rotationEffect(phase.rotation)
                    } animation: { phase in
                        switch phase {
                        case .initial: onAppearAnimation ? .spring(bounce: 0.5) : nil
                        case .normal, .fast, .slow: onAppearAnimation ? .easeInOut(duration: 1) : nil
                        }
                    }
            } else {
                Image("circular_progress_view")
                    .scaleEffect(onAppearAnimation ? 1 : 0)
                    .rotationEffect(.degrees(otherAnimation ? 0 : 360), anchor: .center)
                    .onAppear {
                        withAnimation(.linear(duration: 0.8).repeatForever(autoreverses: false)) {
                            otherAnimation = true
                        }
                    }
            }
        }
        .opacity(onAppearAnimation ? 1 : 0)
        .onAppear {
            withAnimation { onAppearAnimation = true }
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.itemBackground
            .ignoresSafeArea()
        AppProgressView()
    }
}
