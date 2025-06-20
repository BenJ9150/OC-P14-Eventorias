//
//  ImageView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 02/05/2025.
//

import SwiftUI

struct ImageView: View {

    let url: String
    let isAvatar: Bool

    init(url: String, isAvatar: Bool = false) {
        self.url = url
        self.isAvatar = isAvatar
    }

    @ViewBuilder
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if url.isEmpty {
                    if isAvatar {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.black)
                    } else {
                        placeHolder(imageName: "photo.fill")
                    }
                } else {
                    AsyncImage(url: URL(string: url)) { phase in
                        switch phase {
                        case .empty:
                            AppProgressView()
                                .scaleEffect(isAvatar ? 0.4 : 0.6)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        default:
                            placeHolder(imageName: "photo.badge.exclamationmark")
                        }
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    func placeHolder(imageName: String) -> some View {
        ZStack {
            Color.white.opacity(0.1)
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 30)
                .foregroundStyle(.black.opacity(0.4))
        }
    }
}

// MARK: - Preview

#Preview {
    VStack {
        Spacer()
        ImageView(url: PreviewEventRepository().getImagePortraitUrl())
            .frame(height: 80)
            .padding()

        ImageView(url: "")
            .frame(height: 80)
            .padding()
        
        HStack {
            ImageView(url: PreviewUser().avatarURL?.absoluteString ?? "", isAvatar: true)
                .frame(width: 48, height: 48)
                .mask(Circle())
            
            ImageView(url: "", isAvatar: true)
                .frame(width: 48, height: 48)
                .mask(Circle())
        }
        Spacer()
    }
    .background(Color.itemBackground)
}
