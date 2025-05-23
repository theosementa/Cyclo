//
//  SharedCard.swift
//  CycloStats
//
//  Created by Theo Sementa on 01/01/2025.
//

import SwiftUI

struct SharedCard: View {

    // builder
    var activity: CyclingActivity
    var viewModel: CyclingActivityDetailViewModel
    var uiImage: UIImage?
    var isInJpegFormat: Bool = true

    // MARK: -
    var body: some View {
        VStack(spacing: 16) {
            if let image = uiImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(
                        width: UIScreen.main.bounds.width - 48,
                        height: UIScreen.main.bounds.width - 48
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }

            VStack(spacing: 16) {
                StatsRowView(
                    title: Word.date,
                    value: activity.date.formatted(date: .complete, time: .omitted).capitalized,
                    alignment: .center
                )

                LazyVGrid(columns: [GridItem(spacing: 16), GridItem(spacing: 16)], spacing: 16) {

                    StatsRowView(
                        title: Word.duration,
                        value: activity.durationInMin.asHoursMinutes,
                        alignment: .center
                    )

                    StatsRowView(
                        title: Word.distance,
                        value: activity.distanceInKm.toString() + " km",
                        alignment: .center
                    )

                    StatsRowView(
                        title: Word.elevation,
                        value: activity.elevationAscendedInM.toString() + " m",
                        alignment: .center
                    )

                    StatsRowView(
                        title: Word.maxSpeed,
                        value: activity.maxSpeedInKMH.toString() + " km/h",
                        alignment: .center
                    )
                }
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.Apple.background)
        }
        .if(isInJpegFormat, transform: { view in
            view
                .padding(56)
                .background(Color.green)
        })
    } // body
} // struct

// MARK: - Preview
#Preview {
    SharedCard(activity: .preview, viewModel: CyclingActivityDetailViewModel())
}
