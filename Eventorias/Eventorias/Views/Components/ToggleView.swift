//
//  ToggleView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 29/06/2025.
//

import SwiftUI

struct ToggleView: View {

    let title: String
    let description: String
    let isOn: Bool
    let action: (Bool) async -> Void

    init(title: String, description: String = "", isOn: Bool, action: @escaping (Bool) async -> Void) {
        self.title = title
        self.description = description
        self.isOn = isOn
        self.action = action
    }

    var body: some View {
        HStack(spacing: 12) {
            Toggle(title, isOn:
                    Binding(
                        get: { isOn },
                        set: { newValue in
                            Task { await action(newValue) }
                        }
                    )
            )
            .labelsHidden()
            .tint(.accent)

            Text(description.isEmpty ? title : description)
                .font(.callout)
                .foregroundStyle(.white)
                .accessibilityHidden(true)
        }
    }
}
