//
//  CyclingActivityEntityRepo.swift
//  CycloStats
//
//  Created by Theo Sementa on 10/09/2024.
//

import Foundation

final class CyclingActivityEntityRepo: ObservableObject {
    static let shared = CyclingActivityEntityRepo()
    
    @Published var activities: [CyclingActivityEntity] = []
}

extension CyclingActivityEntityRepo {
    
    @MainActor
    func fetchActivities() async {
        let request = CyclingActivityEntity.fetchRequest()
        do {
            let results = try viewContext.fetch(request)
            self.activities = results
        } catch {
            
        }
    }
    
}
