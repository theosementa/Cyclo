//
//  FilterByPeriodView.swift
//  MasteringChartsInSwiftUI
//
//  Created by Theo Sementa on 11/07/2024.
//

import SwiftUI

struct FilterByPeriodView: View {
    
    // Builder
    var selectedPeriod: Period
    
    @EnvironmentObject private var healthManager: HealthManager
    
    // MARK: -
    var body: some View {
        HStack {
            Button { changePeriodDate(inPast: true) } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.white)
                    .padding(8)
                    .background {
                        Circle()
                            .fill(Color.Apple.componentInComponent)
                    }
            }

            Spacer()
            
            dateDisplay()
                .contentTransition(.numericText())
            
            Spacer()
            
            Button { changePeriodDate(inPast: false) } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.white)
                    .padding(8)
                    .background {
                        Circle()
                            .fill(Color.Apple.componentInComponent)
                    }
            }
        }
        .padding()
        .clipShape(Capsule())
        .background {
            Capsule()
                .fill(Color.Apple.backgroundComponent)
        }
    } // End body
    
    @ViewBuilder
    func dateDisplay() -> some View {
        Group {
            switch selectedPeriod {
            case .week:
                HStack(spacing: 8) {
                    Text(healthManager.startDatePeriod.dayMonthNumeric)
                    Text("au")
                    Text(healthManager.endDatePeriod.dayMonthNumeric)
                }
            case .month:
                Text(healthManager.startDatePeriod.monthYearFull)
            case .year:
                Text(String(healthManager.startDatePeriod.year))
            case .total:
                EmptyView()
            }
        }
        .fontWeight(.semibold)
    }
    
    func changePeriodDate(inPast: Bool) {
        if inPast {
            withAnimation(.smooth) {
                healthManager.startDatePeriod = healthManager.startDatePeriod.newDateByPeriodInPast(selectedPeriod, .start)
                healthManager.endDatePeriod = healthManager.endDatePeriod.newDateByPeriodInPast(selectedPeriod, .end)
            }
        } else {
            withAnimation(.smooth) {
                healthManager.startDatePeriod = healthManager.startDatePeriod.newDateByPeriodInFuture(selectedPeriod, .start)
                healthManager.endDatePeriod = healthManager.endDatePeriod.newDateByPeriodInFuture(selectedPeriod, .end)
            }
        }
        
        Task { await healthManager.filterActivities() }
    }

} // End struct

// MARK: - Preview
#Preview {
    FilterByPeriodView(selectedPeriod: .month)
}



