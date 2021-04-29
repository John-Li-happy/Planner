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
    
    private var cellIsAccomplished = Bool()
    private var missionString = String()
    var cellIndexPath = IndexPath()
    var delegate: TodayCellBackwards?
        
    @IBAction func accomplishedButtomTapped(_ sender: UIButton) {
        if cellIsAccomplished {
            missionLabel.attributedText = nil
            missionLabel.text = missionString

            button.setImage(UIImage(systemName: "circle"), for: .normal)
        } else {
            let crossedMission = NSMutableAttributedString.init(string:  missionString)
            crossedMission.addAttributes([NSAttributedString.Key.strikethroughStyle: 1], range: NSRange(location: 0, length: crossedMission.length))
            missionLabel.text = nil
            missionLabel.attributedText = crossedMission

            button.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        }

        cellIsAccomplished = !cellIsAccomplished
        delegate?.accomplishedButtonTapping(indexPath: cellIndexPath)
    }
    
    func configureCell(mission: String, date: String, isAccomplished: Bool) {
        cellIsAccomplished = isAccomplished
        missionString = mission
        
        if cellIsAccomplished {
            let crossedMission = NSMutableAttributedString.init(string: mission)
            crossedMission.addAttributes([NSAttributedString.Key.strikethroughStyle: 1], range: NSRange(location: 0, length: crossedMission.length))
            missionLabel.attributedText = crossedMission
            button.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        } else {
            missionLabel.text = mission
            button.setImage(UIImage(systemName: "circle"), for: .normal)
        }
        dateLabel.text = date
        countLabel.text = cellIndexPath.isEmpty ? "0" : String(cellIndexPath.row + 1)
    }
}
