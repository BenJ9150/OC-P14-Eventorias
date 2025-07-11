//
//  BackButtons.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 16/05/2025.
//

import SwiftUI

struct BackButtonModifier: ViewModifier {

    let dismiss: () -> Void

    func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: dismiss) {
                        Image(systemName: "arrow.backward")
                            .font(.caption)
                            .bold()
                            .frame(minWidth: 44, minHeight: 44)
                    }
                    .foregroundStyle(.white)
                    .accessibilityLabel("Return")
                }
            }
    }
}

struct BackButtonView: View {

    @Environment(\.dismiss) var dismiss
    let title: String

    var body: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "arrow.backward")
                        .font(.body)
                        .fontWeight(.semibold)
                        .padding(.leading)

                    Text(title)
                        .multilineTextAlignment(.leading)
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .frame(minWidth: 44, minHeight: 44)
                .dynamicTypeSize(.xSmall ... .accessibility2)
            }
            .foregroundStyle(.white)
            Spacer()
        }
        .padding(.bottom, isPad ? 48 : 12)
        .accessibilityLabel("Return")
    }
}

struct CloseButtonItem: ToolbarContent {

    @Environment(\.dismiss) var dismiss

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.caption)
                    .bold()
                    .frame(minWidth: 44, minHeight: 44)
            }
            .foregroundStyle(.white)
            .accessibilityLabel("Close")
        }
    }
}

extension View {
    func withBackButton(dismiss: @escaping () -> Void) -> some View {
        self.modifier(BackButtonModifier(dismiss: dismiss))
    }
}
