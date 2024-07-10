//
//  ActivitiesProgressView.swift
//  CycloStats
//
//  Created by KaayZenn on 10/07/2024.
//

import SwiftUI

struct ActivitiesProgressView: View {
    
    // MARK: -
    var body: some View {
        NavigationStack {
            List(ActivityTarget.allCases, id: \.self) { target in
                CyclingTargetView(target: target)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(.init(top: 6, leading: 12, bottom: 6, trailing: 12))
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Progrès")
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                }
            }
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    ActivitiesProgressView()
}
