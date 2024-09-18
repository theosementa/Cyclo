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
        
        guard locations.count > 1 else {
            // If there are 0 or 1 locations, we can't draw any lines
            if let singleLocation = locations.first {
                let region = MKCoordinateRegion(center: singleLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                uiView.setRegion(region, animated: true)
            }
            return
        }
        
        var polylines: [MKPolyline] = []
        
        for i in 0..<locations.count - 1 {
            let start = locations[i]
            let end = locations[i + 1]
            
            let coordinates = [start.coordinate, end.coordinate]
            let polyline = MKPolyline(coordinates: coordinates, count: 2)
            
            let speed = calculateSpeed(start: start, end: end)
            polyline.title = String(speed)
            
            polylines.append(polyline)
        }
        
        uiView.addOverlays(polylines)
        
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
                if let speedString = polyline.title, let speed = Double(speedString) {
                    switch speed {
                    case SpeedZone.zone1.range: renderer.strokeColor = UIColor(SpeedZone.zone1.color)
                    case SpeedZone.zone2.range: renderer.strokeColor = UIColor(SpeedZone.zone2.color)
                    case SpeedZone.zone3.range: renderer.strokeColor = UIColor(SpeedZone.zone3.color)
                    case SpeedZone.zone4.range: renderer.strokeColor = UIColor(SpeedZone.zone4.color)
                    case SpeedZone.zone5.range: renderer.strokeColor = UIColor(SpeedZone.zone5.color)
                    case SpeedZone.zone6.range: renderer.strokeColor = UIColor(SpeedZone.zone6.color)
                    default: renderer.strokeColor = .black
                    }
                } else {
                    renderer.strokeColor = .black  // Default color if speed can't be determined
                }
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
    
    func calculateSpeed(start: CLLocation, end: CLLocation) -> Double {
        let distance = end.distance(from: start)
        let time = end.timestamp.timeIntervalSince(start.timestamp)
        let speedMPS = distance / time
        let speedKMH = speedMPS * 3.6
        return speedKMH
    }
}
