//
//  MapScalingHeader.swift
//  Example
//
//  Created by Daniil Manin on 28.09.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI
import ScalingHeaderScrollView
import MapKit

struct MapScalingHeader: View {

    private let maxHeight: CGFloat = UIScreen.main.bounds.height - 150

    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
        span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
    )

    var body: some View {
        ScalingHeaderScrollView(minHeight: 150.0, maxHeight: maxHeight) { headerHeight, _ in
            ClippedMap(region: $mapRegion, headerHeight: headerHeight, maxHeight: maxHeight)
        } content: {
            Text(defaultDescription)
                .padding()
        }
        .headerAlignment(.top)
        .headerSnappingPositions(snapPositions: [0, 0.5, 1])
        .initialSnapPosition(initialSnapPosition: 0.5)
        .toolbarBackground(.hidden, for: .navigationBar)
    }

    // MARK: - Private

    private func updateRegion() {
        mapRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: Double.random(in: -90...90),
                longitude: Double.random(in: -180...180)
            ),
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        )
    }
}
