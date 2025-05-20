//
//  MapToolbarView.swift
//  CycloStats
//
//  Created by Theo Sementa on 20/05/2025.
//

import SwiftUI

struct MapToolbarView: View {

    // MARK: Dependencies
    @Binding var showFullMap: Bool
    @Binding var showLegend: Bool

    // MARK: - View
    var body: some View {
        HStack(spacing: 16) {
            if showLegend {
                SpeedLegendsRowView()
                    .fullWidth()
            }

            VStack(spacing: 16) {
                CustomButtonView(animation: .smooth) { showFullMap.toggle() } label: {
                    Image(systemName: showFullMap ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right")
                        .foregroundStyle(Color.white)
                        .rotationEffect(.degrees(90))
                        .padding(12)
                        .background {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color.black)
                        }
                }

                CustomButtonView(animation: .smooth) { showLegend.toggle() } label: {
                    Image(systemName: "doc.plaintext")
                        .foregroundStyle(Color.white)
                        .padding(12)
                        .background {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color.black)
                        }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding()
    }
}
