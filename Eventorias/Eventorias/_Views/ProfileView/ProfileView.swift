//
//  ProfileView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 02/05/2025.
//

import SwiftUI

struct ProfileView: View {

    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Button("Sign out") {
                viewModel.signOut()
            }
            .buttonStyle(AppButtonPlain(small: true))
            .padding()
        }
    }
}

// MARK: - Preview

@available(iOS 18.0, *)
#Preview(traits: .withAuthViewModel()) {
    ZStack {
        Color.mainBackground
            .ignoresSafeArea()
        ProfileView()
    }
}
