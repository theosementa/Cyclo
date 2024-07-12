//
//  MapView.swift
//  CycloStats
//
//  Created by KaayZenn on 12/07/2024.
//

import Foundation
import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    var locations: [CLLocation]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeOverlays(uiView.overlays)
        
        var coordinates = locations.map { $0.coordinate }
        
        let polyline = MKPolyline(coordinates: &coordinates, count: coordinates.count)
        uiView.addOverlay(polyline)
        
        if let region = calculateRegion(locations: locations) {
            uiView.setRegion(region, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .green
                renderer.lineWidth = 4
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    
    func calculateRegion(locations: [CLLocation]) -> MKCoordinateRegion? {
        guard !locations.isEmpty else { return nil }
        
        let latitudes = locations.map { $0.coordinate.latitude }
        let longitudes = locations.map { $0.coordinate.longitude }
        
        let maxLat = latitudes.max()!
        let minLat = latitudes.min()!
        let maxLong = longitudes.max()!
        let minLong = longitudes.min()!
        
        let center = CLLocationCoordinate2D(latitude: (maxLat + minLat) / 2, longitude: (maxLong + minLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.1, longitudeDelta: (maxLong - minLong) * 1.1)
        
        return MKCoordinateRegion(center: center, span: span)
    }
}
