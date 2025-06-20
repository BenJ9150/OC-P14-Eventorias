//
//  EventDetailView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 16/05/2025.
//

import SwiftUI
import MapKit

struct EventDetailView: View {

    @Environment(\.verticalSizeClass) var verticalSize
    @Environment(\.dismiss) var dismiss

    @State private var coordinate: CLLocationCoordinate2D?
    @State private var region: MKCoordinateRegion?

    let event: Event

    var body: some View {
        ZStack(alignment: .top) {
            Color.mainBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                BackButtonView(title: event.title)
                if verticalSize == .compact {
                    HStack(spacing: 16) {
                        imageAndShareButton
                        ScrollView {
                            VStack(alignment: .leading, spacing: 16) {
                                dateAndAuthor
                                description
                                adressAndMap
                            }
                            .frame(minWidth: 400)
                        }
                        .scrollIndicators(.hidden)
                    }
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 22) {
                            imageAndShareButton
                                .frame(height: 364)
                            dateAndAuthor
                            description
                        }
                        .padding(.horizontal)
                    }
                    .scrollIndicators(.hidden)
                    adressAndMap
                        .padding()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: Date and author

private extension EventDetailView {

    var dateAndAuthor: some View {
        HStack {
            VStack(spacing: 12) {
                bannerItem(image: "icon_calendar", text: event.date.toMonthDayYear())
                bannerItem(image: "icon_clock", text: event.date.toHourMinuteAMPM())
            }
            ImageView(url: event.avatar, isAvatar: true)
                .frame(width: 60, height: 60)
                .mask(Circle())
        }
        .foregroundStyle(.white)
    }

    func bannerItem(image: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(image)
            Text(text)
                .font(.subheadline)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: Description

private extension EventDetailView {

    var description: some View {
        Text(event.description)
            .font(.footnote)
            .multilineTextAlignment(.leading)
            .foregroundStyle(.white)
            .padding(.bottom, 48)
    }
}

// MARK: Address and map

private extension EventDetailView {

    var adressAndMap: some View {
        HStack(spacing: 12) {
            address
            map
        }
    }

    var address: some View {
        Text(event.address)
            .font(.subheadline)
            .fontWeight(.medium)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.white)
            .dynamicTypeSize(.xSmall ... .accessibility1)
    }
}

// MARK: Map

private extension EventDetailView {

    @ViewBuilder var map: some View {
        if let coordinate, let region {
            Map(initialPosition: .region(region)) {
                Marker(coordinate: coordinate) {
                    Image(systemName: "mappin")
                }
            }
            .frame(width: 150, height: 72)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        } else {
            ProgressView()
                .frame(width: 150, height: 72)
                .onAppear {
                    Task { await geocodeAddress() }
                }
        }
    }

    func geocodeAddress() async {
        do {
            let result = try await CLGeocoder().coordinate(for: event.address)
            coordinate = result.coordinate
            region = result.region
        } catch {}
    }
}

// MARK: Image and share button

private extension EventDetailView {

    var imageAndShareButton: some View {
        ZStack(alignment: .topTrailing) {
            ImageView(url: event.photoURL)
            shareButton
        }
    }
    @ViewBuilder var shareButton: some View {
        if let shareURL = event.shareURL {
            ShareLink(
                item: shareURL.absoluteString,
                message: Text("\n---\nRegarde ça !"),
                preview: SharePreview(event.title)
            ) {
                Image(systemName: "square.and.arrow.up")
                    .foregroundStyle(Color.itemBackground)
                    .font(.caption.bold())
                    .padding(.all, 8)
                    .padding(.bottom, 3)
                    .background(Circle().fill(Color.white))
                    .frame(minWidth: 44, minHeight: 44)
            }
            .padding(.all, 5)
        }
    }
}

// MARK: - Preview

#Preview {
    EventDetailView(event: PreviewEventRepository().previewEvents().first!)
}
