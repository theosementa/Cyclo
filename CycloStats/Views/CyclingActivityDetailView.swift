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
                .frame(height: viewModel.showFullMap ? UIScreen.main.bounds.height : 400)
                .overlay(alignment: .topTrailing) {
                    CustomButton(animation: .smooth) { viewModel.showFullMap.toggle() } label: {
                        Image(systemName: viewModel.showFullMap ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right")
                            .foregroundStyle(Color.white)
                            .rotationEffect(.degrees(90))
                            .padding(8)
                            .background {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(Color.black)
                            }
                    }
                    .padding()
                }  
                        
            if !viewModel.showFullMap {
                LazyVGrid(columns: [GridItem(spacing: 16), GridItem(spacing: 16)], spacing: 16) {
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
                        icon: "timer",
                        title: "Départ",
                        value: activity.startDate.formatted(date: .omitted, time: .shortened),
                        withBackground: true
                    )
                    CyclingStatsRow(
                        icon: "timer",
                        title: "Arrivée",
                        value: activity.endDate.formatted(date: .omitted, time: .shortened),
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
                
                VStack(spacing: 12) {
                    Text("Graphiques")
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    VStack(spacing: 16) {
                        ActivityElevationChart(locations: viewModel.locations)
                    }
                }
                .padding()
            }
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
