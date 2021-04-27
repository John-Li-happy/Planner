//
//  TodayTableViewCell.swift
//  Planner
//
//  Created by Zhaoyang Li on 3/22/21.
//

import UIKit

protocol TodayCellBackwards {
    func accomplishedButtonTapping(indexPath: IndexPath)
}

class TodayTableViewCell: UITableViewCell {
    @IBOutlet private weak var missionLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var button: UIButton!
    @IBOutlet private weak var countLabel: UILabel!
    
    var cellIsAccomplished = Bool()
    var cellIndexPath = IndexPath()
    var delegate: TodayCellBackwards?
        
    @IBAction func accomplishedButtomTapped(_ sender: UIButton) {
        accomplishMission()
    }
    
    func configureCell(mission: String, date: String, isAccomplished: Bool) {
        missionLabel.text = mission
        dateLabel.text = date
        button.backgroundColor = isAccomplished ? .green : .red
        countLabel.text = cellIndexPath.isEmpty ? "0" : String(cellIndexPath.row + 1)
        cellIsAccomplished = isAccomplished
    }
    
    @objc private func accomplishMission() {
        cellIsAccomplished = !cellIsAccomplished
        button.backgroundColor = cellIsAccomplished ? .green : .red
        delegate?.accomplishedButtonTapping(indexPath: cellIndexPath)
    }
}
