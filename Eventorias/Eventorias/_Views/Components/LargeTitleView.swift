//
//  LargeTitleView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 25/04/2025.
//

import SwiftUI

struct LargeTitleView: View {

    let title: String

    var body: some View {
        Text(title)
            .font(.largeTitle)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 24)
            .accessibilityHidden(true)
    }
}

// MARK: - Preview

#Preview {
    LargeTitleView(title: "Large title")
        .preferredColorScheme(.dark)
}
