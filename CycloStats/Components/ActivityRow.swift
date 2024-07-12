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
        VStack(spacing: 24) {
            HStack {
                CyclingStatsRow(
                    icon: "timer",
                    title: "Durée",
                    value: activity.durationInMin.asHoursAndMinutes
                )
                
                CyclingStatsRow(
                    icon: "point.bottomleft.forward.to.point.topright.scurvepath.fill",
                    title: "Distance",
                    value: activity.distanceInKm.formatWith(num: 2) + " km"
                )
            }
            
            HStack {
                CyclingStatsRow(
                    icon: "figure.outdoor.cycle",
                    title: "Vitesse moyenne",
                    value: activity.averageSpeedInKMH.formatWith(num: 2) + " km/h"
                )

                CyclingStatsRow(
                    icon: "mountain.2.fill",
                    title: "Dénivelé",
                    value: activity.elevationAscendedInM.formatWith(num: 2) + " m"
                )
            }
        }
        .backgroundComponent()
        .onTapGesture {
            router.pushDetail(activity: activity)
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    ActivityRow(activity: .preview)
        .padding()
}
