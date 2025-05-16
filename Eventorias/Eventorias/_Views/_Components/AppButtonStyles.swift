//
//  AppButtonStyles.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 24/04/2025.
//

import SwiftUI

struct AppButtonPlain: ButtonStyle {
    let small: Bool

    init(small: Bool = false) {
        self.small = small
    }

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .foregroundStyle(.white)
            .font(.callout)
            .fontWeight(.semibold)
            .frame(
                minWidth: small ? 160 : 242,
                minHeight: small ? 40 : 52
            )
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.accentColor)
            )
            .fixedSize(horizontal: false, vertical: true)
            .dynamicTypeSize(.xSmall ... .accessibility4)
            .simultaneousGesture(
                TapGesture().onEnded {
                    UIFeedbackGenerator.triggerTap()
                }
            )
    }
}

struct AppButtonBorderless: ButtonStyle {

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.callout)
            .fontWeight(.semibold)
            .underline()
            .baselineOffset(2)
            .foregroundStyle(.white)
            .frame(minHeight: 44)
            .multilineTextAlignment(.center)
            .simultaneousGesture(
                TapGesture().onEnded {
                    UIFeedbackGenerator.triggerTap()
                }
            )
    }
}

// MARK: - Preview

#Preview {
    VStack {
        Button {
            print("button tapped")
        } label: {
            HStack(spacing: 16) {
                Image(systemName: "envelope.fill")
                Text("Sign in with email")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .buttonStyle(AppButtonPlain(small: false))
        .frame(maxWidth: 440)
        .padding(.horizontal, 74)

        Button("Forgot password?") {
            print("button tapped")
        }
        .buttonStyle(AppButtonBorderless())
        .padding()
    }
}
