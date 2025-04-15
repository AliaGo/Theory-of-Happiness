//
//  MapView.swift
//  TOH
//
//  Created by Alia on 2025/2/17.
//

import Foundation
import SwiftUI
import MapKit

struct MapView: View {
    var coordinate: CLLocationCoordinate2D
    var markerName: String

    var body: some View {
        Map(position: .constant(.region(region))){
            Marker(markerName, coordinate: coordinate)
        }
    }

    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 3000, longitudinalMeters: 3000
        )
    }
}

#Preview {
    MapView(coordinate: CLLocationCoordinate2D(latitude: 34.011286, longitude: -116.166868), markerName:"五陵郭")
}
