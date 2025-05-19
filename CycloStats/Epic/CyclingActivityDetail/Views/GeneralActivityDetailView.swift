//
//  GeneralActivityDetailView.swift
//  CycloStats
//
//  Created by Theo Sementa on 19/05/2025.
//

import SwiftUI
import TheoKit
import CoreLocation

struct GeneralActivityDetailView: View {

    // MARK: Dependencies
    var activity: CyclingActivity
    var coordinate: CLLocationCoordinate2D?

    @StateObject private var weatherManager: WeatherManager = .init()

    // MARK: - View
    var body: some View {
        VStack(spacing: TKDesignSystem.Spacing.standard) {
            Text("Général") // TODO: TBL
                .fontWithLineHeight(Fonts.Title.medium)
                .fullWidth(.leading)

            VStack(spacing: TKDesignSystem.Spacing.medium) {
                HStack(spacing: TKDesignSystem.Spacing.small) {
                    StatsRowView(title: Word.date, value: activity.date.formatted(date: .complete, time: .omitted).capitalized)
                        .fullWidth(.leading)

                    if let dayWeather = weatherManager.dayWeather {
                        StatsRowView(title: Word.temperature, value: dayWeather.highTemperature.value.formatWith(num: 2) + " °C")
                            .fullWidth(.leading)
                    }
                }

                HStack(spacing: TKDesignSystem.Spacing.small) {
                    StatsRowView(title: Word.duration, value: activity.durationInMin.asHoursMinutes)
                        .fullWidth(.leading)

                    StatsRowView(title: Word.pause, value: activity.pauseTime.asHoursMinutes)
                        .fullWidth(.leading)
                }

                HStack(spacing: TKDesignSystem.Spacing.small) {
                    StatsRowView(title: Word.departure, value: activity.startDate.formatted(date: .omitted, time: .shortened))
                        .fullWidth(.leading)

                    StatsRowView(title: Word.arrival, value: activity.endDate.formatted(date: .omitted, time: .shortened))
                        .fullWidth(.leading)
                }
            }
        }
        .padding(TKDesignSystem.Padding.medium)
        .roundedRectangleBorder(
            TKDesignSystem.Colors.Background.Theme.bg100,
            radius: TKDesignSystem.Radius.small
        )
        .task {
            if let coordinate {
                await weatherManager.getWeather(
                    lat: coordinate.latitude,
                    long: coordinate.longitude,
                    date: activity.startDate
                )
            }
        }
    }
}

// MARK: - Preview
#Preview {
    GeneralActivityDetailView(activity: .preview)
}
