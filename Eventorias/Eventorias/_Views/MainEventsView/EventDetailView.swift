//
//  EventDetailView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 16/05/2025.
//

import SwiftUI
import MapKit

struct EventDetailView: View {

    @Environment(\.dismiss) var dismiss

    @State private var coordinate: CLLocationCoordinate2D?
    @State private var region: MKCoordinateRegion?

    let event: Event

    var body: some View {
        ZStack(alignment: .top) {
            Color.mainBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                bannerTitle
                
                ScrollView {
                    VStack(spacing: 22) {
                        ImageView(url: event.photoURL)
                            .frame(height: 364)
                        dateAndAuthor
                        description
                    }
                    .padding(.horizontal)
                }
                .scrollIndicators(.hidden)
                address
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: Banner title

private extension EventDetailView {

    var bannerTitle: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "arrow.backward")
                        .font(.body)
                        .fontWeight(.semibold)
                        .padding(.leading)

                    if !event.title.isEmpty {
                        Text(event.title)
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                }
                .frame(minWidth: 44, minHeight: 44)
            }
            .foregroundStyle(.white)
            Spacer()
        }
        .padding(.bottom, 12)
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
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 60, height: 60)
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

// MARK: Address

private extension EventDetailView {

    var address: some View {
        HStack(spacing: 12) {
            Text(event.address)
                .font(.subheadline)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.white)
                .dynamicTypeSize(.xSmall ... .accessibility1)

            if let coordinate, let region {
                Map(initialPosition: .region(region)) {
                    Marker(coordinate: coordinate) {
                        Image(systemName: "mappin")
                    }
                }
                .frame(width: 150, height: 72)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                ProgressView()
                    .frame(width: 150, height: 72)
                    .onAppear {
                        geocodeAddress()
                    }
            }
        }
        .padding()
        .background(Color.mainBackground)
    }

    private func geocodeAddress() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(event.address) { placemarks, error in
            guard let coordinate = placemarks?.first?.location?.coordinate else { return }

            DispatchQueue.main.async {
                self.coordinate = coordinate
                self.region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
                )
            }
        }
    }
}


// MARK: - Preview

#Preview {
    EventDetailView(event: PreviewEventRepository().previewEvents().first!)
}
