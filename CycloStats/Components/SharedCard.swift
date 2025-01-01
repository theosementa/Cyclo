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
                LazyVGrid(columns: [GridItem(spacing: 16), GridItem(spacing: 16)], spacing: 16) {
                    CyclingStatsRow(
                        icon: "calendar",
                        title: Word.date,
                        value: activity.date.formatted(date: .numeric, time: .omitted),
                        withBackground: true
                    )
                    
                    CyclingStatsRow(
                        icon: "timer",
                        title: Word.duration,
                        value: activity.durationInMin.asHoursMinutesAndSeconds,
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
                }
                
                CyclingStatsRow(
                    icon: "gauge.with.dots.needle.67percent",
                    title: Word.maxSpeed,
                    value: activity.maxSpeedInKMH.formatWith(num: 2) + " km/h",
                    withBackground: true
                )
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
