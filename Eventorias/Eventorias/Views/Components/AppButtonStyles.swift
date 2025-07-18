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
    }
}

struct AppButtonSquare: ButtonStyle {
    let small: Bool
    let white: Bool

    init(small: Bool = false) {
        self.small = small
        self.white = false
    }

    init(white: Bool) {
        self.small = true
        self.white = white
    }

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.title2)
            .fontWeight(.medium)
            .foregroundStyle(white ? Color.itemBackground : .white)
            .padding(.all, 8)
            .frame(
                minWidth: small ? 52 : 56,
                minHeight: small ? 52 : 56
            )
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(white ? .white : Color.accentColor)
            )
    }
}

// MARK: - Preview

#Preview {
    VStack {
        Spacer()
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
        .padding(.horizontal, 74)

        Button("Forgot password?") {
            print("button tapped")
        }
        .buttonStyle(AppButtonBorderless())
        .padding()

        HStack {
            Button {
                print("button tapped")
            } label: {
                Image(systemName: "plus")
            }
            .buttonStyle(AppButtonSquare(small: false))
            
            Button {
                print("button tapped")
            } label: {
                Image(systemName: "plus")
            }
            .buttonStyle(AppButtonSquare(small: true))

            Button {
                print("button tapped")
            } label: {
                Image(systemName: "plus")
            }
            .buttonStyle(AppButtonSquare(white: true))
        }
        Spacer()
    }
    .background(Color.mainBackground)
}
