//
//  ClippedMap.swift
//  ScalingHeaderScrollViewExample
//

import SwiftUI
import MapKit

// MKMapView doesn't respect SwiftUI clipping for hit testing — its gesture recognizers
// fire across the full UIKit frame regardless of what SwiftUI clips visually, because the
// container is actually laid out at the full maxHeight (so headerAlignment-based cropping
// keeps working) while only the rendering is clipped down to the visible headerHeight.
// point(inside:) rejects touches below the currently visible height, so those touches fall
// through to the scroll view's content instead of panning the map.
// This assumes the header is top-aligned (MapScalingHeader sets .headerAlignment(.top)): with
// top alignment the visible crop window starts at container-local y 0, matching this check.
// Any other alignment (e.g. the library's default .center) centers the full maxHeight-tall
// container inside the shrunk crop window, so the visible window would start at an offset > 0
// and this simple y <= visibleHeight check would wrongly reject touches on the lower part of
// the visibly-shown map.
// MKMapView is pinned top+sides with a fixed maxHeight so the map content stays stable
// while the clip window shrinks/grows during scroll.
class ClippedMapContainerView: UIView {
    var visibleHeight: CGFloat = .greatestFiniteMagnitude

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard point.y <= visibleHeight else { return false }
        return super.point(inside: point, with: event)
    }
}

struct ClippedMap: UIViewRepresentable {

    @Binding var region: MKCoordinateRegion
    var headerHeight: CGFloat
    var maxHeight: CGFloat

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> ClippedMapContainerView {
        let container = ClippedMapContainerView()
        container.clipsToBounds = true

        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = context.coordinator
        container.addSubview(mapView)

        NSLayoutConstraint.activate([
            mapView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            mapView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            mapView.heightAnchor.constraint(equalToConstant: maxHeight)
        ])

        context.coordinator.mapView = mapView
        mapView.setRegion(region, animated: false)
        return container
    }

    func updateUIView(_ uiView: ClippedMapContainerView, context: Context) {
        uiView.visibleHeight = headerHeight

        guard let mapView = context.coordinator.mapView else { return }

        let current = mapView.region.center
        let sameCenter = abs(current.latitude - region.center.latitude) < 0.00001 &&
                         abs(current.longitude - region.center.longitude) < 0.00001
        if !sameCenter {
            mapView.setRegion(region, animated: true)
        }
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: ClippedMap
        weak var mapView: MKMapView?

        init(_ parent: ClippedMap) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            let newRegion = mapView.region
            DispatchQueue.main.async {
                self.parent.region = newRegion
            }
        }
    }
}
