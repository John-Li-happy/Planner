//
//  AppDelegate.swift
//  Planner
//
//  Created by Zhaoyang Li on 3/22/21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("this is \n", urls[urls.count - 1] as URL)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM dd"
        let todayString = dateFormatter.string(from: Date())
        
        if UserDefaults.standard.object(forKey: "recentDate") == nil { // first come in
            UserDefaults.standard.setValue(todayString, forKey: "recentDate")
        } else {
            if let lastDateString = UserDefaults.standard.object(forKey: "recentDate") as? String {
                if lastDateString != todayString {
                    let loadRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrentEntity")
                    let managedObjectContext = persistentContainer.viewContext
                    let customPersistentContext = CustomStack().customPersistentContainer.viewContext
                    do {
                        let allMissions = try managedObjectContext.fetch(loadRequest) as! [CurrentEntity]
                        for missionIndex in 0..<allMissions.count {
                            let dateString = dateFormatter.string(from: allMissions[missionIndex].date!)
                            if dateString < todayString && allMissions[missionIndex].accomplished {
                                let oldMission = NSEntityDescription.insertNewObject(forEntityName: "PastEntity", into: customPersistentContext) as! PastEntity
                                oldMission.accomplished = allMissions[missionIndex].accomplished
                                oldMission.date = allMissions[missionIndex].date
                                oldMission.mission = allMissions[missionIndex].mission
                            
                                try customPersistentContext.save()
                                
                                managedObjectContext.delete(allMissions[missionIndex])
                                try managedObjectContext.save()
                            }
                        }
                    } catch { fatalError("error in transforming") }
                }
            }
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CurrentModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

