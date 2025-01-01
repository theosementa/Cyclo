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
    
    @Environment(\.displayScale) var displayScale
    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject private var healthManager: HealthManager
    @StateObject private var viewModel: CyclingActivityDetailViewModel = .init()
    @StateObject private var weatherManager: WeatherManager = .init()
        
    // MARK: -
    var body: some View {
        ScrollView {
            MapView(locations: viewModel.locations)
                .frame(height: viewModel.showFullMap ? UIScreen.main.bounds.height : 400)
                .overlay(alignment: .top) {
                    HStack(spacing: 16) {
                        if viewModel.showLegend {
                            SpeedLegendsRow()
                                .frame(maxWidth: .infinity)
                        }
                        
                        VStack(spacing: 16) {
                            CustomButton(animation: .smooth) { viewModel.showFullMap.toggle() } label: {
                                Image(systemName: viewModel.showFullMap ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right")
                                    .foregroundStyle(Color.white)
                                    .rotationEffect(.degrees(90))
                                    .padding(12)
                                    .background {
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(Color.black)
                                    }
                            }
                            
                            CustomButton(animation: .smooth) { viewModel.showLegend.toggle() } label: {
                                Image(systemName: "doc.plaintext")
                                    .foregroundStyle(Color.white)
                                    .padding(12)
                                    .background {
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(Color.black)
                                    }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding()
                }
            
            if !viewModel.showFullMap {
                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        CyclingStatsRow(
                            icon: "calendar",
                            title: Word.date,
                            value: activity.date.formatted(date: .numeric, time: .omitted),
                            withBackground: true
                        )
                        
                        if let dayWeather = weatherManager.dayWeather {
                            CyclingStatsRow(
                                icon: dayWeather.symbolName,
                                title: Word.temperature,
                                value: dayWeather.highTemperature.value.formatWith(num: 2) + " °C",
                                withBackground: true
                            )
                        }
                    }
                    
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
                        ActivityHeartRateChart(heartRates: viewModel.heartRates, zones: viewModel.zones)
                    }
                }
                .padding()
            }
        } // End ScrollView
        .scrollIndicators(.hidden)
        .background(Color.Apple.background.ignoresSafeArea())
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    let size = CGSize(
                        width: UIScreen.main.bounds.width - 48,
                        height: UIScreen.main.bounds.width - 48
                    )
                    
                    MapSnapshotManager.generateSnapshot(
                        for: viewModel.locations,
                        size: size
                    ) { image in
                        if let image = image {
                            let renderer = ImageRenderer(
                                content: SharedCard(activity: activity, viewModel: viewModel, uiImage: image)
                                    .environment(\.colorScheme, colorScheme == .light ? .light : .dark)
                            )
                            renderer.scale = displayScale
                            
//                            if let image = renderer.uiImage, let imageData = image.pngData(), let newImage = UIImage(data: imageData) {
//                                UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil)
//                            }
                            
                            if let image = renderer.uiImage {
                                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                            }
                        }
                    }
                    
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .task {
            await viewModel.setupDetailView(activity: activity, healthManager: healthManager)
            if let firstLocation = viewModel.locations.first {
                await weatherManager.getWeather(
                    lat: firstLocation.coordinate.latitude,
                    long: firstLocation.coordinate.longitude,
                    date: activity.startDate
                )
            }
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    CyclingActivityDetailView(activity: .preview)
        .environmentObject(HealthManager())
}
