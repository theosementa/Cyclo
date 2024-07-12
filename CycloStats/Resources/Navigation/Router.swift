//
//  Router.swift
//  Krabs
//
//  Created by Theo Sementa on 05/12/2023.
//

import SwiftUI

class Router: ObservableObject {

    enum Route {
        case navigation
        case sheet
        case fullScreenCover
        case modal
        case modalCanFullScreen
    }

    struct State {
        var navigationPath: [NavigationDirection] = []
        var presentingSheet: NavigationDirection?
        var presentingFullScreen: NavigationDirection?
        var presentingModal: NavigationDirection?
        var presentingModalCanFullScreen: NavigationDirection?
        var isPresented: Binding<NavigationDirection?>

        var isPresenting: Bool {
            if presentingSheet != nil || presentingFullScreen != nil {
                return true
            } else { return false }
        }
    }

    @Published private(set) var state: State

    @Published private(set) var dismissAction: (() -> Void)?

    init(isPresented: Binding<NavigationDirection?>) {
        state = State(isPresented: isPresented)
    }

    func view(direction: NavigationDirection, route: Route) -> AnyView {
        AnyView(EmptyView())
    }
}
 
extension Router {

    func navigateTo(_ direction: NavigationDirection) {
        state.navigationPath.append(direction)
    }

    func presentSheet(_ direction: NavigationDirection, _ dismissAction: (() -> Void)? = nil) {
        state.presentingSheet = direction
        self.dismissAction = dismissAction
    }

    func presentFullScreen(_ direction: NavigationDirection) {
        state.presentingFullScreen = direction
    }

    func presentModal(_ direction: NavigationDirection, _ dismissAction: (() -> Void)? = nil) {
        state.presentingModal = direction
        self.dismissAction = dismissAction
    }

    func presentModalCanFullScreen(_ direction: NavigationDirection) {
        state.presentingModalCanFullScreen = direction
    }
}

extension Router {

    var navigationPath: Binding<[NavigationDirection]> {
        binding(keyPath: \.navigationPath)
    }

    var presentingSheet: Binding<NavigationDirection?> {
        binding(keyPath: \.presentingSheet)
    }

    var presentingFullScreen: Binding<NavigationDirection?> {
        binding(keyPath: \.presentingFullScreen)
    }

    var presentingModal: Binding<NavigationDirection?> {
        binding(keyPath: \.presentingModal)
    }

    var presentingModalCanFullScreen: Binding<NavigationDirection?> {
        binding(keyPath: \.presentingModalCanFullScreen)
    }

    var isPresented: Binding<NavigationDirection?> {
        state.isPresented
    }
}

private extension Router {

    func binding<T>(keyPath: WritableKeyPath<State, T>) -> Binding<T> {
        Binding(
            get: { self.state[keyPath: keyPath] },
            set: { self.state[keyPath: keyPath] = $0 }
        )
    }
}

extension Router {

    func checkIfPresentedModally(completion: @escaping (Bool) -> Void) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else {
            completion(false)
            return
        }
        completion(window.rootViewController?.presentedViewController != nil)
    }

}
