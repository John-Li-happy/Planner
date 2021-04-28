//
//  PastEntity+CoreDataProperties.swift
//  Planner
//
//  Created by Zhaoyang Li on 4/27/21.
//
//

import Foundation
import CoreData


extension PastEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PastEntity> {
        return NSFetchRequest<PastEntity>(entityName: "PastEntity")
    }

    @NSManaged public var accomplished: Bool
    @NSManaged public var date: Date?
    @NSManaged public var mission: String?

}

extension PastEntity : Identifiable {

}
