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
    
    @State private var dragOffset: CGSize = .zero
    
    // MARK: -
    var body: some View {
        HStack {
            CustomButton(animation: .smooth) { changePeriodDate(inPast: true) } label: {
                Image(systemName: "chevron.left")
                    .frame(width: 14, height: 14)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.green)
                    .padding(8)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color.Apple.componentInComponent)
                    }
            }

            Spacer()
            
            dateDisplay()
                .contentTransition(.numericText())
            
            Spacer()
            
            CustomButton(animation: .smooth) { changePeriodDate(inPast: false) } label: {
                Image(systemName: "chevron.right")
                    .frame(width: 14, height: 14)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.green)
                    .padding(8)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color.Apple.componentInComponent)
                    }
            }
        }
        .padding(8)
        .clipShape(Capsule())
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.Apple.backgroundComponent)
        }
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    dragOffset = gesture.translation
                }
                .onEnded { gesture in
                    if gesture.translation.width > 80 {
                        withAnimation(.smooth) { changePeriodDate(inPast: true) }
                    } else if gesture.translation.width < -80 {
                        withAnimation(.smooth) { changePeriodDate(inPast: false) }
                    }
                    dragOffset = .zero
                }
        )
    } // End body
    
    @ViewBuilder
    func dateDisplay() -> some View {
        Group {
            switch selectedPeriod {
            case .week:
                HStack(spacing: 8) {
                    Text(healthManager.startDatePeriod.formatted(date: .numeric, time: .omitted))
                    Text("word_to".localized)
                    Text(healthManager.endDatePeriod.formatted(date: .numeric, time: .omitted))
                }
            case .month:
                Text(healthManager.startDatePeriod.formatted(Date.FormatStyle().month(.wide).year()).capitalized)
            case .year:
                Text(healthManager.startDatePeriod.formatted(Date.FormatStyle().year()))
            case .total:
                EmptyView()
            }
        }
        .fontWeight(.semibold)
    }
    
    func changePeriodDate(inPast: Bool) {
        if inPast {
            healthManager.startDatePeriod = healthManager.startDatePeriod.newDateByPeriodInPast(selectedPeriod, .start)
            healthManager.endDatePeriod = healthManager.endDatePeriod.newDateByPeriodInPast(selectedPeriod, .end)
        } else {
            healthManager.startDatePeriod = healthManager.startDatePeriod.newDateByPeriodInFuture(selectedPeriod, .start)
            healthManager.endDatePeriod = healthManager.endDatePeriod.newDateByPeriodInFuture(selectedPeriod, .end)
        }        
    }

} // End struct

// MARK: - Preview
#Preview {
    FilterByPeriodView(selectedPeriod: .month)
}
