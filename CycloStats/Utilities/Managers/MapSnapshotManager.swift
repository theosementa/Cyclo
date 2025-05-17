//
//  MapSnapshotManager.swift
//  CycloStats
//
//  Created by Theo Sementa on 01/01/2025.
//

import MapKit
import UIKit

class MapSnapshotManager {
    // Gardons une référence forte au snapshotter
    private static var activeSnapshotter: MKMapSnapshotter?

    static func generateSnapshot(
        for locations: [CLLocation],
        size: CGSize,
        completion: @escaping (UIImage?) -> Void
    ) {
        guard !locations.isEmpty else {
            print("No locations provided")
            completion(nil)
            return
        }

        // Annuler tout snapshot précédent en cours
        activeSnapshotter?.cancel()

        let options = MKMapSnapshotter.Options()
        options.size = size

        // Calculer la région pour montrer toutes les locations
        let latitudes = locations.map { $0.coordinate.latitude }
        let longitudes = locations.map { $0.coordinate.longitude }

        let maxLat = latitudes.max()!
        let minLat = latitudes.min()!
        let maxLong = longitudes.max()!
        let minLong = longitudes.min()!

        let center = CLLocationCoordinate2D(
            latitude: (maxLat + minLat) / 2,
            longitude: (maxLong + minLong) / 2
        )

        // Ajouter une marge pour s'assurer que tous les points sont visibles
        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 1.5,  // Augmenté de 1.1 à 1.5
            longitudeDelta: (maxLong - minLong) * 1.5
        )

        options.region = MKCoordinateRegion(center: center, span: span)
        options.mapType = .standard
        options.showsBuildings = true

        // Créer et garder une référence au snapshotter
        activeSnapshotter = MKMapSnapshotter(options: options)

        print("Starting snapshot generation")
        activeSnapshotter?.start { snapshot, error in
            // Vérifier les erreurs
            if let error = error {
                print("Snapshot error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let snapshot = snapshot else {
                print("No snapshot generated")
                completion(nil)
                return
            }

            print("Snapshot generated successfully")

            let image = UIGraphicsImageRenderer(size: options.size).image { context in
                // Dessiner la carte
                snapshot.image.draw(at: .zero)

                let context = context.cgContext
                context.setLineWidth(4)
                context.setLineCap(.round)
                context.setLineJoin(.round)

                // Dessiner les lignes entre les locations
                if locations.count > 1 {
                    for index in 0..<(locations.count - 1) {
                        let start = locations[index]
                        let end = locations[index + 1]

                        let startPoint = snapshot.point(for: start.coordinate)
                        let endPoint = snapshot.point(for: end.coordinate)

                        let speed = calculateSpeed(start: start, end: end)
                        let color = colorForSpeed(speed)
                        context.setStrokeColor(color.cgColor)

                        context.move(to: startPoint)
                        context.addLine(to: endPoint)
                        context.strokePath()
                    }
                }
            }

            completion(image)
        }
    }

    private static func calculateSpeed(start: CLLocation, end: CLLocation) -> Double {
        let distance = end.distance(from: start)
        let time = end.timestamp.timeIntervalSince(start.timestamp)
        let speedMPS = distance / time
        return speedMPS * 3.6 // Convert to km/h
    }

    private static func colorForSpeed(_ speed: Double) -> UIColor {
        switch speed {
        case SpeedZone.zone1.range: return UIColor(SpeedZone.zone1.color)
        case SpeedZone.zone2.range: return UIColor(SpeedZone.zone2.color)
        case SpeedZone.zone3.range: return UIColor(SpeedZone.zone3.color)
        case SpeedZone.zone4.range: return UIColor(SpeedZone.zone4.color)
        case SpeedZone.zone5.range: return UIColor(SpeedZone.zone5.color)
        case SpeedZone.zone6.range: return UIColor(SpeedZone.zone6.color)
        default: return .black
        }
    }
}
