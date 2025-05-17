//
//  BackButtonModifier.swift
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
                }
            }
    }
}

extension View {
    func withBackButton(dismiss: @escaping () -> Void) -> some View {
        self.modifier(BackButtonModifier(dismiss: dismiss))
    }
}
