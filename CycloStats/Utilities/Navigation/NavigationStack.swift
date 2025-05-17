//
//  NavigationStack.swift
//  Krabs
//
//  Created by Theo Sementa on 05/12/2023.
//

import Foundation
import SwiftUI

struct NavStack<Content: View>: View {

    @StateObject var router: Router
    private let content: Content

    init(router: Router, @ViewBuilder content: @escaping () -> Content) {
        _router = StateObject(wrappedValue: router)
        self.content = content()
    }

    var body: some View {
        NavigationStack(path: router.navigationPath) {
            content
                .navigationDestination(for: NavigationDirection.self) { direction in
                    router.view(direction: direction, route: .navigation)
                }
        }
        .sheet(item: router.presentingSheet, onDismiss: router.dismissAction) { direction in
            router.view(direction: direction, route: .sheet)
        }
        .sheet(item: router.presentingModal, onDismiss: router.dismissAction) { direction in
            router.view(direction: direction, route: .sheet)
                .presentationDetents([.medium])
        }
        .sheet(item: router.presentingModalCanFullScreen, onDismiss: router.dismissAction) { direction in
            router.view(direction: direction, route: .sheet)
                .presentationDetents([.medium, .large])
        }
        .fullScreenCover(item: router.presentingFullScreen, onDismiss: router.dismissAction) { direction in
            router.view(direction: direction, route: .fullScreenCover)
        }
    }
}
