//
//  TodayViewModel.swift
//  Planner
//
//  Created by Zhaoyang Li on 3/22/21.
//

import UIKit
import CoreData

protocol FetchedTodayDataProtocol {
    func refreshTableView()
}

class TodayViewModel {
    private var dataSource = [[CurrentEntity](), [CurrentEntity](), [CurrentEntity]()] {
        didSet {
            delegate.refreshTableView()
        }
    }
    var delegate: FetchedTodayDataProtocol
    
    init(delegate: FetchedTodayDataProtocol) {
        self.delegate = delegate
    }
    
    func numberOfRows(section: Int) -> Int {
        return dataSource[section].count
    }
    
    func singleMission(section: Int, index: Int) -> MissionModel {
        
        return MissionModel(content: dataSource[section][index].mission!, time: dataSource[section][index].date!, isAccomplished: dataSource[section][index].accomplished)
    }
    
    func loadMissions() {
        let loadRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrentEntity")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext

        do {
            let temPool = try managedObjectContext.fetch(loadRequest) as! [CurrentEntity]
            for mission in temPool {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM dd"
                let dateString = dateFormatter.string(from: mission.date!)
                let todayString = dateFormatter.string(from: Date())
                if dateString > todayString {
                    dataSource[2].append(mission)
                } else if dateString == todayString {
                    dataSource[1].append(mission)
                } else {
                    dataSource[0].append(mission)
                }
            }

        } catch { fatalError("error in fetching") }
    }

    func createNewMission(content: String, time: Date) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let newMission = NSEntityDescription.insertNewObject(forEntityName: "CurrentEntity", into: managedObjectContext) as! CurrentEntity
        newMission.accomplished = false
        newMission.date = time
        newMission.mission = content
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM dd"
        let dateString = dateFormatter.string(from: time)
        let todayString = dateFormatter.string(from: Date())
        if dateString > todayString {
            dataSource[2].append(newMission)
        } else if dateString == todayString {
            dataSource[1].append(newMission)
        } else {
            dataSource[0].append(newMission)
        }

        do {
            try managedObjectContext.save()
        } catch { fatalError("error in save") }
    }
    
    func deleteMission(indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        managedObjectContext.delete(dataSource[indexPath.section][indexPath.row])

        dataSource[indexPath.section].remove(at: indexPath.row)
        
        do {
            try managedObjectContext.save()
        } catch { fatalError("error in delete") }
    }
    
    func accomplishMission(indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        dataSource[indexPath.section][indexPath.row].accomplished = !dataSource[indexPath.section][indexPath.row].accomplished
        delegate.refreshTableView()
        do {
            try managedObjectContext.save()
        } catch { fatalError("error in update") }
    }
    
    func updateMission(indexPath: IndexPath, content: String, date: Date) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        dataSource[indexPath.section][indexPath.row].date = date
        dataSource[indexPath.section][indexPath.row].mission = content
        dataSource[indexPath.section][indexPath.row].accomplished = false
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM dd"
        let dateString = dateFormatter.string(from: date)
        let todayString = dateFormatter.string(from: Date())
        if dateString > todayString {
            dataSource[2].append(dataSource[indexPath.section][indexPath.row])
        } else if dateString == todayString {
            dataSource[1].append(dataSource[indexPath.section][indexPath.row])
        } else {
            dataSource[0].append(dataSource[indexPath.section][indexPath.row])
        }
        
        dataSource[indexPath.section].remove(at: indexPath.row)
        
        delegate.refreshTableView()
        do {
            try managedObjectContext.save()
        } catch { fatalError("error in update") }
    }
}

extension TodayViewModel: TodayCellBackwards {
    func accomplishedButtonTapping(indexPath: IndexPath) {
        accomplishMission(indexPath: indexPath)
    }
}
