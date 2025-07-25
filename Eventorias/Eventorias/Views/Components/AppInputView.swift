//
//  AppInputView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 23/05/2025.
//

import SwiftUI

struct AppInputView<Content: View>: View {

    let title: String
    @Binding var error: String
    let content: Content

    init(title: String, error: Binding<String> = .constant(""), @ViewBuilder content: () -> Content) {
        self.title = title
        self._error = error
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(spacing: 0) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(Color.textGray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 8)
                    .accessibilityHidden(true)
                    .zIndex(1)
                content
                    .font(.callout)
                    .foregroundStyle(.white)
                    .padding(.bottom, 10)
            }
            .padding(.horizontal, 18)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.itemBackground)
            )
            Text(error.isEmpty ? "" : "* \(error)")
                .font(.footnote.bold())
                .foregroundStyle(Color.textRed)
                .scaleEffect(error.isEmpty ? 0.8 : 1)
                .opacity(error.isEmpty ? 0 : 1)
                .frame(minHeight: 24)
                .accessibilityIdentifier(error.isEmpty ? "" : error)
                .accessibilityLabel("\(title) error. \(error)")
        }
        .animation(
            UIAccessibility.isReduceMotionEnabled ? .easeInOut : .interactiveSpring(duration: 0.3, extraBounce: 0.5),
            value: error
        )
        .onChange(of: error) { newValue in
            if newValue.isEmpty { return }
            /// Haptic feedback
            UIFeedbackGenerator.triggerError()
            /// Voice Over alert
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UIAccessibility.post(
                    notification: .announcement,
                    argument: "\(title) error. \(error)"
                )
            }
        }
    }
}

// MARK: - Preview

#Preview {
    AppInputView(title: "Title") {
        Text("Content")
    }
    .padding()
}
