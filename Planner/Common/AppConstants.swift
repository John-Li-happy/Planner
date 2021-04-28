//
//  AppConstants.swift
//  Planner
//
//  Created by Zhaoyang Li on 4/27/21.
//

import Foundation

enum AppConstants {
    enum CoreDataConstants {
        static let pastModelName = "PastModel"
        
        static let currentEntityName = "CurrentEntity"
    }
    
    enum TableHeaders {
        static let overdue = "Overdue"
        
        static let today = "Today"
        
        static let upcoming = "Upcoming"
    }
    
    enum Table {
        static let cellIdentifier = "TodayTableViewCell"
        
        static let deleteSwipe = "Delete"
        
        static let accomplishSwipe = "Accomplish"
    }
    
    
}
