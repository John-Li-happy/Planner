//
//  CurrentEntity+CoreDataProperties.swift
//  Planner
//
//  Created by Zhaoyang Li on 4/26/21.
//
//

import Foundation
import CoreData


extension CurrentEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentEntity> {
        return NSFetchRequest<CurrentEntity>(entityName: "CurrentEntity")
    }

    @NSManaged public var mission: String?
    @NSManaged public var date: Date?
    @NSManaged public var accomplished: Bool

}

extension CurrentEntity : Identifiable {

}
