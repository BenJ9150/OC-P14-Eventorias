//
//  ImageView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 02/05/2025.
//

import SwiftUI

struct ImageView: View {

    let url: String

    var body: some View {
            GeometryReader { geometry in
                AsyncImage(url: URL(string: url)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                    default:
                        Image(systemName: "photo")
                            .foregroundStyle(.gray)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
}

// MARK: - Preview

#Preview {
    ImageView(url: PreviewEventRepository().getImagePortraitUrl())
        .frame(height: 80)
        .padding()
}
