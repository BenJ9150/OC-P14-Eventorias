//
//  ImageView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 02/05/2025.
//

import SwiftUI

struct ImageView: View {

    let url: String

    @ViewBuilder
    var body: some View {
        if url.isEmpty {
            EmptyView()
        } else {
            GeometryReader { geometry in
                AsyncImage(url: URL(string: url)) { phase in
                    switch phase {
                    case .empty:
                        AppProgressView()
                            .scaleEffect(0.6)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    default:
                        Image(systemName: "photo.badge.exclamationmark")
                            .foregroundStyle(.gray)
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ImageView(url: PreviewEventRepository().getImagePortraitUrl())
        .frame(height: 80)
        .padding()
}
