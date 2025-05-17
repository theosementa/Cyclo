//
//  CustomButtonView.swift
//  CycloStats
//
//  Created by KaayZenn on 13/07/2024.
//

import SwiftUI

struct CustomButtonView<Label: View>: View {

    // Builder
    var animation: Animation
    var action: () -> Void
    var label: () -> Label

    // MARK: -
    var body: some View {
        Button(action: {
            withAnimation(animation) {
                action()
            }
        }, label: {
            label()
        })
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    CustomButtonView(animation: .smooth) { } label: {
        Text("COUCOU")
    }

}
