//
//  AppTextFieldStyle.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 24/04/2025.
//

import SwiftUI

struct AppTextFieldStyle: TextFieldStyle {

    let title: String
    @Binding var error: String

    init(title: String, error: Binding<String> = .constant("")) {
        self.title = title
        self._error = error
    }

    func _body(configuration: TextField<Self._Label>) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(spacing: 0) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(Color.textGray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 8)
                    .accessibilityHidden(true)
                configuration
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
                .foregroundStyle(Color.textError)
                .scaleEffect(error.isEmpty ? 0.8 : 1)
                .opacity(error.isEmpty ? 0 : 1)
                .frame(minHeight: 24)
                .accessibilityHidden(true)
        }
        .animation(.interactiveSpring(duration: 0.3, extraBounce: 0.5), value: error)
        .onChange(of: error) { _, newValue in
            if newValue.isEmpty { return }
            /// Haptic feedback
            UIFeedbackGenerator.triggerError()
            /// Voice Over alert
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UIAccessibility.post(
                    notification: .announcement,
                    argument: "\(title) textfield error. \(error)"
                )
            }
        }
    }
}

extension TextField where Label == Text {
    init(appPrompt: String, text: Binding<String>) {
        self.init(
            "",
            text: text,
            prompt: Text(appPrompt)
                .font(.callout)
                .foregroundStyle(Color.textLightGray)
        )
    }
}

extension SecureField where Label == Text {
    init(appPrompt: String, text: Binding<String>) {
        self.init(
            "",
            text: text,
            prompt: Text(appPrompt)
                .font(.callout)
                .foregroundStyle(Color.textLightGray)
        )
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var error = ""
    VStack(spacing: 0) {
        TextField(appPrompt: "Tap here to enter your description", text: .constant(""))
            .textFieldStyle(AppTextFieldStyle(title: "Description"))

        TextField(appPrompt: "Enter your email", text: .constant("test.com"))
            .textFieldStyle(AppTextFieldStyle(title: "Email", error: $error))
            .padding(.bottom)

        SecureField(appPrompt: "Enter your password", text: .constant(""))
            .textFieldStyle(AppTextFieldStyle(title: "Password"))

        Spacer()
        Button("Test error") {
            error = "Enter valid email format!"
        }
        .buttonStyle(AppButtonPlain())
    }
    .padding()
}
