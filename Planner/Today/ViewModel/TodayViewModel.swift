//
//  TodayViewModel.swift
//  Planner
//
//  Created by Zhaoyang Li on 3/22/21.
//

import UIKit

protocol FetchedTodayDataProtocol {
    func refreshTableView()
}

class TodayViewModel {
    private var dataSource = [[MissionModel](), [MissionModel](), [MissionModel]()] {
        didSet {
            delegate.refreshTableView()
            print(dataSource)
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
        return dataSource[section][index]
    }

    func initialDataSourcePopulate() {
        dataSource[1].append(MissionModel(content: "this is first mission", time: Date(), isAccomplished: false))
        dataSource[1].append(MissionModel(content: "this is second mission", time: Date(), isAccomplished: true))
        dataSource[1].append(MissionModel(content: "this is third mission", time: Date(), isAccomplished: false))
    }
}

extension TodayViewModel: TodayCellBackwards {
    func accomplishedButtonTapping(indexPath: IndexPath) {
        dataSource[indexPath.section][indexPath.row].isAccomplished = !dataSource[indexPath.section][indexPath.row].isAccomplished
    }
}
