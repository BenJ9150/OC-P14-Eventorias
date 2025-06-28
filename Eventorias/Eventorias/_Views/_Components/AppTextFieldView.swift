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
        AppInputView(title: title, error: $error) {
            Group {
                if isSecure {
                    SecureField("", text: $text, prompt: formattedPrompt)
                        .textContentType(.password)
                } else {
                    TextField("", text: $text, prompt: formattedPrompt)
                }
            }
            .accessibilityIdentifier(title)
            .textInputAutocapitalization(.never)
            .dynamicTypeSize(.xSmall ... .accessibility2)
            .onChange(of: text) { oldValue, newValue in
                if oldValue != newValue {
                    error.removeAll()
                }
            }
        }
    }

    private var formattedPrompt: Text {
        Text(prompt)
            .font(.callout)
            .foregroundStyle(Color.textLightGray)
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
