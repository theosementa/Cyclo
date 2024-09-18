//
//  MapFullScreenView.swift
//  CycloStats
//
//  Created by KaayZenn on 13/07/2024.
//

import SwiftUI
import MapKit

struct MapFullScreenView: View {
    
    // Builder
    var locations: [CLLocation]
    
    @Environment(\.dismiss) private var dismiss
    
    // MARK: -
    var body: some View {
        NavigationStack {
            MapView(locations: locations)
                .frame(height: UIScreen.main.bounds.height)
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    MapFullScreenView(locations: [])
}
