//
//  SelectPeriodButtons.swift
//  CycloStats
//
//  Created by KaayZenn on 08/07/2024.
//

import SwiftUI

struct SelectPeriodButtons: View {
    
    // Builder
    @Binding var period: Period
    
    // MARK: -
    var body: some View {
        HStack {
            Button { period = .week } label: {
                Text("Week")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(period == .week ? .green : Color(uiColor: .label).opacity(0.3))
                    }
            }
            
            Button { period = .month } label: {
                Text("Month")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(period == .month ? .green : Color(uiColor: .label).opacity(0.3))
                    }
            }
            
            Button { period = .year } label: {
                Text("Year")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(period == .year ? .green : Color(uiColor: .label).opacity(0.3))
                    }
            }
        }
        .padding()
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    SelectPeriodButtons(period: .constant(.month))
}
