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
                VStack(spacing: 16) {
                    CyclingStatsRow(
                        icon: "calendar",
                        title: Word.date,
                        value: activity.date.formatted(date: .numeric, time: .omitted),
                        withBackground: true
                    )
                    
                    LazyVGrid(columns: [GridItem(spacing: 16), GridItem(spacing: 16)], spacing: 16) {
                        CyclingStatsRow(
                            icon: "timer",
                            title: Word.duration,
                            value: activity.durationInMin.asHoursMinutesAndSeconds,
                            withBackground: true
                        )
                        
                        CyclingStatsRow(
                            icon: "playpause.fill",
                            title: Word.pause,
                            value: activity.pauseTime.asHoursMinutesAndSeconds,
                            withBackground: true
                        )
                        
                        CyclingStatsRow(
                            icon: "play.fill",
                            title: Word.departure,
                            value: activity.startDate.formatted(date: .omitted, time: .shortened),
                            withBackground: true
                        )
                        CyclingStatsRow(
                            icon: "flag.checkered",
                            title: Word.arrival,
                            value: activity.endDate.formatted(date: .omitted, time: .shortened),
                            withBackground: true
                        )
                        
                        CyclingStatsRow(
                            icon: "point.bottomleft.forward.to.point.topright.scurvepath.fill",
                            title: Word.distance,
                            value: activity.distanceInKm.formatWith(num: 2) + " km",
                            withBackground: true
                        )
                        CyclingStatsRow(
                            icon: "mountain.2.fill",
                            title: Word.elevation,
                            value: activity.elevationAscendedInM.formatWith(num: 2) + " m",
                            withBackground: true
                        )
                        
                        CyclingStatsRow(
                            icon: "figure.outdoor.cycle",
                            title: Word.averageSpeed,
                            value: activity.averageSpeedInKMH.formatWith(num: 2) + " km/h",
                            withBackground: true
                        )
                        CyclingStatsRow(
                            icon: "gauge.with.dots.needle.67percent",
                            title: Word.maxSpeed,
                            value: activity.maxSpeedInKMH.formatWith(num: 2) + " km/h",
                            withBackground: true
                        )
                        
                        CyclingStatsRow(
                            icon: "heart",
                            title: Word.averageBPM,
                            value: activity.averageHeartRate.formatted() + " bpm",
                            withBackground: true
                        )
                        CyclingStatsRow(
                            icon: "bolt.heart",
                            title: Word.maxBPM,
                            value: activity.maxHeartRate.formatted() + " bpm",
                            withBackground: true
                        )
                    }
                }
                .padding()
                
                VStack(spacing: 12) {
                    Text(Word.charts)
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    VStack(spacing: 16) {
                        ActivityElevationChart(locations: viewModel.locations)
                        ActivityHeartRateChart(heartRates: viewModel.heartRates)
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
