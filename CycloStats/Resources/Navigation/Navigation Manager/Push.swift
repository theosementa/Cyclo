//
//  Push.swift
//  NavigationTemplate
//
//  Created by Theo Sementa on 05/07/2024.
//

import Foundation

extension NavigationManager {
    
    func pushDetail(activity: CyclingActivity) {
        navigateTo(.detail(activity: activity))
    }
    
}
