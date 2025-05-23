//
//  CLGeocoder+Coordinate.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 23/05/2025.
//

import MapKit

extension CLGeocoder {

    func coordinate(for address: String) async throws -> (coordinate: CLLocationCoordinate2D, region: MKCoordinateRegion) {
        let placemarks = try await geocodeAddressString(address)
        guard let coordinate = placemarks.first?.location?.coordinate else {
            throw CLError(.locationUnknown)
        }
        let region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
        )
        return (coordinate, region)
    }
}
