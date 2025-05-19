//
//  CyclingActivityDetailScreen.swift
//  CycloStats
//
//  Created by KaayZenn on 12/07/2024.
//

import SwiftUI
import TheoKit

struct CyclingActivityDetailScreen: View {

    // Builder
    @ObservedObject var activity: CyclingActivity

    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject private var healthManager: HealthManager
    @StateObject private var viewModel: CyclingActivityDetailViewModel = .init()

    @State private var showActionSheet: Bool = false

    // MARK: -
    var body: some View {
        ScrollView {
            VStack(spacing: TKDesignSystem.Spacing.medium) {
                MapView(locations: viewModel.locations)
                    .frame(
                        width: viewModel.showFullMap ? UIScreen.main.bounds.width : UIScreen.main.bounds.width - 48,
                        height: viewModel.showFullMap ? UIScreen.main.bounds.height : UIScreen.main.bounds.width - 48
                    )
                    .clipShape(RoundedRectangle(cornerRadius: TKDesignSystem.Radius.small, style: .continuous))
                    .overlay(alignment: .top) {
                        HStack(spacing: 16) {
                            if viewModel.showLegend {
                                SpeedLegendsRowView()
                                    .fullWidth()
                            }

                            VStack(spacing: 16) {
                                CustomButtonView(animation: .smooth) { viewModel.showFullMap.toggle() } label: {
                                    Image(systemName: viewModel.showFullMap ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right")
                                        .foregroundStyle(Color.white)
                                        .rotationEffect(.degrees(90))
                                        .padding(12)
                                        .background {
                                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                .fill(Color.black)
                                        }
                                }

                                CustomButtonView(animation: .smooth) { viewModel.showLegend.toggle() } label: {
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

                if !viewModel.showFullMap {

                    // TODO: Better itégration
                    if let coordinate = viewModel.locations.first?.coordinate {
                        GeneralActivityDetailView(activity: activity, coordinate: coordinate)
                    }

                    DistanceAndSpeedActivityDetailView(activity: activity)

                    HeartActivityDetailView(activity: activity)

                    ActivityElevationChartView(locations: viewModel.locations)
                    ActivityHeartRateChartView(heartRates: viewModel.heartRates, zones: viewModel.zones)

                }
            }
            .padding(viewModel.showFullMap ? 0 : TKDesignSystem.Padding.large)
        } // End ScrollView
        .scrollIndicators(.hidden)
        .background(TKDesignSystem.Colors.Background.Theme.bg50)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showActionSheet.toggle()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .confirmationDialog(
            "Télécharger",
            isPresented: $showActionSheet,
            actions: {
                Button { saveSharedCard(isInPngFormat: false) } label: {
                    Text("Enregistrer en JPEG")
                }

                Button { saveSharedCard(isInPngFormat: true) } label: {
                    Text("Enregistrer en PNG")
                }
            }
        )
        .task {
            await viewModel.setupDetailView(activity: activity, healthManager: healthManager)
        }
    } // body

    private func saveSharedCard(isInPngFormat: Bool) {
        let size = CGSize(
            width: UIScreen.main.bounds.width - 48,
            height: UIScreen.main.bounds.width - 48
        )

        MapSnapshotManager.generateSnapshot(
            for: viewModel.locations,
            size: size
        ) { image in
            if let image = image {
                let renderer = ImageRenderer(
                    content: SharedCard(activity: activity, viewModel: viewModel, uiImage: image, isInJpegFormat: !isInPngFormat)
                        .environment(\.colorScheme, colorScheme == .light ? .light : .dark)
                )
                renderer.scale = UIScreen.main.scale

                if isInPngFormat {
                    if let image = renderer.uiImage, let imageData = image.pngData(), let newImage = UIImage(data: imageData) {
                        UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil)
                    }
                } else {
                    if let image = renderer.uiImage {
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    }
                }
            }
        }
    }

} // struct

// MARK: - Preview
#Preview {
    CyclingActivityDetailScreen(activity: .preview)
        .environmentObject(HealthManager())
}
