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
    @EnvironmentObject private var heartRateManager: HeartRateManager
    @StateObject private var viewModel: CyclingActivityDetailViewModel = .init()

    @State private var showActionSheet: Bool = false

    // MARK: -
    var body: some View {
        BetterScrollView {
            HStack {
                BackButtonView()
                    .fullWidth(.leading)

                Button {
                    showActionSheet.toggle()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
            .padding(TKDesignSystem.Padding.large)
        } content: { _ in
            VStack(spacing: TKDesignSystem.Spacing.medium) {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                } else {
                    MapView(locations: viewModel.locations)
                        .frame(
                            width: viewModel.showFullMap ? UIScreen.main.bounds.width : UIScreen.main.bounds.width - 48,
                            height: viewModel.showFullMap ? UIScreen.main.bounds.height : UIScreen.main.bounds.width - 48
                        )
                        .clipShape(RoundedRectangle(cornerRadius: TKDesignSystem.Radius.small, style: .continuous))
                        .overlay(alignment: .top) {
                            MapToolbarView(showFullMap: $viewModel.showFullMap, showLegend: $viewModel.showLegend)
                        }
                }

                if !viewModel.showFullMap {
                    if let coordinate = viewModel.locations.first?.coordinate {
                        GeneralActivityDetailView(activity: activity, coordinate: coordinate)
                    }

                    DistanceAndSpeedActivityDetailView(activity: activity)

                    HeartActivityDetailView(activity: activity)

                    ActivityElevationChartView(locations: viewModel.locations)
                    ActivityHeartRateChartView(heartRates: viewModel.heartRates, zones: viewModel.zones)
                }
            }
            .padding(.horizontal, !viewModel.showFullMap ? TKDesignSystem.Padding.large : 0)
            .padding(.bottom, !viewModel.showFullMap ? TKDesignSystem.Padding.large : 0)
        }
        .background(TKDesignSystem.Colors.Background.Theme.bg50)
        .navigationBarBackButtonHidden(true)
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
            await viewModel.setupDetailView(
                activity: activity,
                healthManager: healthManager,
                heartRateManager: heartRateManager
            )
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
                    content: SharedCard(
                        activity: activity,
                        viewModel: viewModel,
                        uiImage: image,
                        isInJpegFormat: !isInPngFormat
                    )
                    .environment(\.colorScheme, colorScheme == .light ? .light : .dark)
                )
                renderer.scale = UIScreen.main.scale

                if isInPngFormat {
                    if let image = renderer.uiImage,
                       let imageData = image.pngData(),
                       let newImage = UIImage(data: imageData) {
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
