//
//  CoreDataStack.swift
//  Planner
//
//  Created by Zhaoyang Li on 4/27/21.
//

import Foundation
import CoreData

class CustomStack {
    let customPersistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PastModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error
            {
                print("error in store", error.localizedDescription)
            }
        }
        return container
    }()
}
