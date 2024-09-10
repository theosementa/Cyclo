//
//  ActivityRow.swift
//  CycloStats
//
//  Created by KaayZenn on 09/07/2024.
//

import SwiftUI

struct ActivityRow: View {
    
    // Builder
    @ObservedObject var activity: CyclingActivity
    @EnvironmentObject private var router: NavigationManager

    // MARK: -
    var body: some View {
        Button(action: { router.pushDetail(activity: activity) }, label: {
            VStack(spacing: 24) {
                HStack {
                    CyclingStatsRow(
                        icon: "calendar",
                        title: Word.date,
                        value: activity.date.dayMonthAbbreviated
                    )
                    
                    CyclingStatsRow(
                        icon: "timer",
                        title: Word.duration,
                        value: activity.durationInMin.asHoursMinutesAndSeconds
                    )
                }
                
                HStack {
                    CyclingStatsRow(
                        icon: "point.bottomleft.forward.to.point.topright.scurvepath.fill",
                        title: Word.distance,
                        value: activity.distanceInKm.formatWith(num: 2) + " km"
                    )

                    CyclingStatsRow(
                        icon: "mountain.2.fill",
                        title: Word.elevation,
                        value: activity.elevationAscendedInM.formatWith(num: 2) + " m"
                    )
                }
            }
            .backgroundComponent()
        })
        .tappableStyle()
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    ActivityRow(activity: .preview)
        .padding()
}
