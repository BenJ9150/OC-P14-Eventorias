//
//  EventDetailView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 16/05/2025.
//

import SwiftUI
import MapKit

struct EventDetailView: View {

    @Environment(\.dynamicTypeSize) var dynamicSize
    @Environment(\.verticalSizeClass) var verticalSize
    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var eventsViewModel: EventsViewModel
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var coordinate: CLLocationCoordinate2D?
    @State private var region: MKCoordinateRegion?
    @State private var eventImage: Image?

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
                bannerItem(title: "Date", image: "icon_calendar", text: event.date.toMonthDayYear())
                bannerItem(title: "Hour", image: "icon_clock", text: event.date.toHourMinuteAMPM())
            }
            ImageView(url: event.avatar, isAvatar: true)
                .frame(width: 60, height: 60)
                .mask(Circle())
        }
        .foregroundStyle(.white)
    }

    func bannerItem(title: String, image: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(image)
            Text(text)
                .font(.subheadline)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .dynamicTypeSize(.xSmall ... .accessibility2)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(title): \(text)")
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
            .dynamicTypeSize(.xSmall ... .accessibility3)
    }
}

// MARK: Address and map

private extension EventDetailView {

    var adressAndMap: some View {
        VStack {
            if dynamicSize.isAccessibilitySize {
                address
                map
            } else {
                HStack(spacing: 12) {
                    address
                    map
                }
            }
            toggleParticipate
        }
    }

    var address: some View {
        Text(event.address)
            .font(.subheadline)
            .fontWeight(.medium)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.white)
            .fixedSize(horizontal: false, vertical: true)
            .dynamicTypeSize(.xSmall ... .accessibility2)
            .accessibilityLabel("Address: \(event.address)")
    }
}

// MARK: Map

private extension EventDetailView {

    private struct MapItem: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }

    @ViewBuilder var map: some View {
        if let coordinate, let region {
            mapView(for: coordinate, region: region)
                .frame(width: dynamicSize.isAccessibilitySize ? nil : 150, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .allowsHitTesting(false)
                .accessibilityHidden(true)
        } else {
            ProgressView()
                .frame(width: 150, height: 72)
                .onAppear {
                    Task { await geocodeAddress() }
                }
        }
    }

    @ViewBuilder func mapView(for coordinate: CLLocationCoordinate2D, region: MKCoordinateRegion) -> some View {
        if #available(iOS 17.0, *) {
            Map(initialPosition: .region(region)) {
                Marker(coordinate: coordinate) {
                    Image(systemName: "mappin")
                }
            }
        } else {
            // Fallback on earlier versions
            Map(coordinateRegion: .constant(region), annotationItems: [MapItem(coordinate: coordinate)]) { item in
                MapAnnotation(coordinate: item.coordinate) {
                    Image(systemName: "mappin")
                        .foregroundColor(.red)
                        .font(.title)
                }
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
            ImageView(url: event.photoURL, image: $eventImage)
            shareButton
        }
    }

    @ViewBuilder var shareButton: some View {
        if let shareURL = event.shareURL, let image = eventImage {
            ShareLink(
                item: URL(string: event.photoURL) ?? shareURL,
                subject: Text("Événement : \(event.title)"),
                message: Text("\(shareURL)\n---\nRegarde cet événement : \(event.title)"),
                preview: SharePreview(event.title, image: image)
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
            .accessibilityLabel("Share")
        }
    }
}

// MARK: Participate button

private extension EventDetailView {

    var toggleParticipate: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                ToggleView(
                    title: "Participate",
                    description: "I participate",
                    isOn: eventsViewModel.toggleParticipate
                ) { newValue in
                    await eventsViewModel.toggleParticipation(
                        to: newValue,
                        event: event,
                        user: authViewModel.currentUser
                    )
                }
                if eventsViewModel.updatingParticipant {
                    AppProgressView()
                        .scaleEffect(0.4)
                }
                Spacer()
            }
            if !eventsViewModel.toggleParticipateError.isEmpty {
                Text("* \(eventsViewModel.toggleParticipateError)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.footnote.bold())
                    .foregroundStyle(Color.textRed)
                    .accessibilityLabel("Participate error: \(eventsViewModel.toggleParticipateError)")
            }
        }
        .frame(minHeight: 48)
        .dynamicTypeSize(.xSmall ... .accessibility4)
        .onAppear {
            eventsViewModel.setParticipation(to: event, user: authViewModel.currentUser)
        }
    }
}

// MARK: - Preview

@available(iOS 18.0, *)
#Preview(traits: .withViewModels()) {
    let event = PreviewEventRepository().previewEvents().first!
    EventDetailView(event: event)
}
