//
//  CyclingActivityDetailView.swift
//  CycloStats
//
//  Created by KaayZenn on 12/07/2024.
//

import SwiftUI

struct CyclingActivityDetailView: View {
    
    // Builder
    @ObservedObject var activity: CyclingActivity
    
    @EnvironmentObject private var healthManager: HealthManager
    
    @StateObject private var viewModel: CyclingActivityDetailViewModel = .init()
    
    // MARK: -
    var body: some View {
        ScrollView {
            MapView(locations: viewModel.locations)
                .frame(height: 400)
            
            LazyVGrid(columns: [GridItem(), GridItem()]) {
                CyclingStatsRow(
                    icon: "calendar",
                    title: "Date",
                    value: activity.date.formatted(date: .numeric, time: .omitted),
                    withBackground: true
                )
                CyclingStatsRow(
                    icon: "timer",
                    title: "Durée",
                    value: activity.durationInMin.asHoursAndMinutes,
                    withBackground: true
                )
                
                CyclingStatsRow(
                    icon: "point.bottomleft.forward.to.point.topright.scurvepath.fill",
                    title: "Distance",
                    value: activity.distanceInKm.formatWith(num: 2) + " km",
                    withBackground: true
                )
                CyclingStatsRow(
                    icon: "mountain.2.fill",
                    title: "Dénivelé",
                    value: activity.elevationAscendedInM.formatWith(num: 2) + " m",
                    withBackground: true
                )
                
                CyclingStatsRow(
                    icon: "figure.outdoor.cycle",
                    title: "Vitesse moyenne",
                    value: activity.averageSpeedInKMH.formatWith(num: 2) + " km/h",
                    withBackground: true
                )
                CyclingStatsRow(
                    icon: "gauge.with.dots.needle.67percent",
                    title: "Vitesse max",
                    value: activity.maxSpeedInKMH.formatWith(num: 2) + " km/h",
                    withBackground: true
                )
                
                CyclingStatsRow(
                    icon: "heart",
                    title: "BPM moyen",
                    value: activity.averageHeartRate.formatted() + " bpm",
                    withBackground: true
                )
                CyclingStatsRow(
                    icon: "bolt.heart",
                    title: "BPM max",
                    value: activity.maxHeartRate.formatted() + " bpm",
                    withBackground: true
                )
            }
            .padding()
        } // End ScrollView
        .scrollIndicators(.hidden)
        .background(Color.Apple.background.ignoresSafeArea())
        .task {
            await viewModel.setupDetailView(activity: activity, healthManager: healthManager)
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    CyclingActivityDetailView(activity: .preview)
        .environmentObject(HealthManager())
}
