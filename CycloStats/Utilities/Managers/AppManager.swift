//
//  AppManager.swift
//  CycloStats
//
//  Created by Theo Sementa on 19/05/2025.
//

import Foundation

final class AppManager: ObservableObject {
    static let shared = AppManager()

    @Published var selectedTab: CGFloat = 0
}
