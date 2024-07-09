//
//  CyclingTargetView.swift
//  CycloStats
//
//  Created by KaayZenn on 08/07/2024.
//

import SwiftUI

struct CyclingTargetView: View {
    
    // Builder
    var target: ActivityTarget
    
    @EnvironmentObject private var healthManager: HealthManager
    
    // MARK: -
    var body: some View {
        let numberOfTime = target.numberOfTime(distance: healthManager.totalDistance)
        VStack(spacing: 16) {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text(target.title)
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                    Spacer()
                    Text(target.value.formatWith(num: 2) + "km")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                }
                
                Text("Parcouru \(numberOfTime.time) fois")
                    .italic()
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color(uiColor: .label).opacity(0.7))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 8) {
                Capsule()
                    .frame(height: 30)
                    .overlay(alignment: .leading) {
                        GeometryReader { geo in
                            Capsule()
                                .fill(.green)
                                .frame(width: geo.size.width * numberOfTime.progress)
                                .overlay(alignment: .leading) {
                                    if numberOfTime.progress >= 0.20 {
                                        Text((numberOfTime.progress * 100).formatWith(num: 1) + "%")
                                            .font(.system(size: 16, weight: .semibold))
                                            .padding(.leading)
                                    }
                                }
                        }
                    }
                    .clipShape(Capsule())
                    .overlay(alignment: .trailing) {
                        if numberOfTime.progress < 0.20 {
                            Text((numberOfTime.progress * 100).formatWith(num: 1) + "%")
                                .font(.system(size: 16, weight: .semibold))
                                .padding(.trailing)
                                .foregroundStyle(Color.green)
                        }
                    }
                
                let progressAlreadyDoInKm = numberOfTime.progress * target.value
                let progressRemainingInKm = target.value - (numberOfTime.progress * target.value)
                HStack {
                    Text("Parcouru \(progressAlreadyDoInKm.formatWith(num: 2)) km")
                    Spacer()
                    Text("Encore \(progressRemainingInKm.formatWith(num: 2)) km")
                }
                .font(.system(size: 16, weight: .semibold, design: .rounded))
            }
        }
        .backgroundComponent()
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    CyclingTargetView(target: .montVentoux)
        .padding()
        .environmentObject(HealthManager())
}
