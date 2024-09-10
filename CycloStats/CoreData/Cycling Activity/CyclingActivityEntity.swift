//
//  CyclingActivityEntity+CoreDataProperties.swift
//  CycloStats
//
//  Created by Theo Sementa on 10/09/2024.
//
//

import Foundation
import CoreData

@objc(CyclingActivityEntity)
public class CyclingActivityEntity: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CyclingActivityEntity> {
        return NSFetchRequest<CyclingActivityEntity>(entityName: "CyclingActivityEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var maxSpeed: Double

}
