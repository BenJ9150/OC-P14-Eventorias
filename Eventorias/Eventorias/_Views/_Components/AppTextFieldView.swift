//
//  AppTextFieldView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 24/04/2025.
//

import SwiftUI

struct AppTextFieldView: View {
    let title: String
    @Binding var text: String
    let prompt: String
    @Binding var error: String
    let isSecure: Bool

    init(
        _ title: String,
        text: Binding<String>,
        prompt: String,
        error: Binding<String> = .constant(""),
        isSecure: Bool = false
    ) {
        self.title = title
        self._text = text
        self.prompt = prompt
        self._error = error
        self.isSecure = isSecure
    }

    var body: some View {
        Group {
            if isSecure {
                SecureField("", text: $text, prompt: formattedPrompt)
                    .textContentType(.password)
            } else {
                TextField("", text: $text, prompt: formattedPrompt)
            }
        }
        .textInputAutocapitalization(.never)
        .textFieldStyle(AppTextFieldStyle(title: title, error: $error))
        .onChange(of: text) { oldValue, newValue in
            if oldValue != newValue {
                error.removeAll()
            }
        }
    }

    private var formattedPrompt: Text {
        Text(prompt)
            .font(.callout)
            .foregroundStyle(Color.textLightGray)
    }
}

// MARK: Custom textfield style

fileprivate struct AppTextFieldStyle: TextFieldStyle {

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

// MARK: - Preview

#Preview {
    @Previewable @State var text = ""
    @Previewable @State var error = ""

    VStack(spacing: 0) {
        AppTextFieldView("Description", text: $text, prompt: "Tap here to enter your description", error: $error)
        AppTextFieldView("Email", text: $text, prompt: "Enter your email", error: $error)
        AppTextFieldView("Password", text: $text, prompt: "Enter your password", error: $error, isSecure: true)
        Spacer()
        Button("Test error") {
            error = "Enter valid email format!"
        }
        .buttonStyle(AppButtonPlain())
    }
    .padding()
}
