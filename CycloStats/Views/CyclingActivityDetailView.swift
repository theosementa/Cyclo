//
//  CyclingActivityDetailView.swift
//  CycloStats
//
//  Created by KaayZenn on 12/07/2024.
//

import SwiftUI
import MapKit

struct CyclingActivityDetailView: View {
    
    // Builder
    @ObservedObject var activity: CyclingActivity
    
    
    @EnvironmentObject private var healthManager: HealthManager
    
    @State private var locations: [CLLocation] = []
    
    // MARK: -
    var body: some View {
        ScrollView {
            MapView(locations: locations)
                .frame(height: 400)
            
            VStack(spacing: 24) {
                HStack {
                    CyclingStatsRow(
                        icon: "calendar",
                        title: "Date",
                        value: activity.date.formatted(date: .numeric, time: .omitted)
                    )
                    
                    CyclingStatsRow(
                        icon: "timer",
                        title: "Durée",
                        value: activity.durationInMin.asHoursAndMinutes
                    )
                }
                
                HStack {
                    CyclingStatsRow(
                        icon: "point.bottomleft.forward.to.point.topright.scurvepath.fill",
                        title: "Distance",
                        value: activity.distanceInKm.formatWith(num: 2) + " km"
                    )
                    
                    CyclingStatsRow(
                        icon: "mountain.2.fill",
                        title: "Dénivelé",
                        value: activity.elevationAscendedInM.formatWith(num: 2) + " m"
                    )
                }
                
                HStack {
                    CyclingStatsRow(
                        icon: "figure.outdoor.cycle",
                        title: "Vitesse moyenne",
                        value: activity.averageSpeedInKMH.formatWith(num: 2) + " km/h"
                    )
                    
                    CyclingStatsRow(
                        icon: "gauge.with.dots.needle.67percent",
                        title: "Vitesse max",
                        value: activity.maxSpeedInKMH.formatWith(num: 2) + " km/h"
                    )
                }
                
                HStack {
                    CyclingStatsRow(
                        icon: "heart",
                        title: "BPM moyen",
                        value: activity.averageHeartRate.formatted() + " bpm"
                    )
                    
                    CyclingStatsRow(
                        icon: "bolt.heart",
                        title: "BPM max",
                        value: activity.maxHeartRate.formatted() + " bpm"
                    )
                }
            }
            .padding()
        }
        .scrollIndicators(.hidden)
        .task {
            if let workout = activity.originalWorkout {
                if let routes = await healthManager.getWorkoutRoute(workout: workout) {
                    for route in routes {
                        let location = await healthManager.getLocationDataForRoute(givenRoute: route)
                        if activity.maxSpeedInKMH == 0 {
                            let maxSpeed = await healthManager.fetchMaxSpeed(givenRoute: route)
                            activity.maxSpeedInKMH = maxSpeed
                        }
                        DispatchQueue.main.async {
                            self.locations.append(contentsOf: location)
                        }
                    }
                }
            }
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    CyclingActivityDetailView(activity: .preview)
        .environmentObject(HealthManager())
}
