//
//  TodayViewController.swift
//  Planner
//
//  Created by Zhaoyang Li on 3/22/21.
//

import UIKit
import WidgetKit

class TodayViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = 150
        }
    }
    @IBOutlet private weak var datePicker: UIDatePicker!{
        didSet {
            datePicker.datePickerMode = .date
            datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        }
    }
    @IBOutlet private weak var addView: UIView!
    @IBOutlet private weak var textView: UITextView!
    
    lazy var viewModel = TodayViewModel(delegate: self)
    var chosenDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        viewModel.loadMissions()
    }
    @IBAction func addButtonTapped(_ sender: UIButton) {
        addView.isHidden = false
    }
    
    @IBAction func accomplishButtonTapped(_ sender: UIButton) {
        if !textView.text.isEmpty && textView.text != nil {
            viewModel.createNewMission(content: textView.text, time: chosenDate)
        } else {
            // show alert
        }
        addView.isHidden = true
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        chosenDate = sender.date
    }
}

extension TodayViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(section: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Overdue"
        case 1:
            return "Today"
        case 2:
            return "Upcoming"
        default:
            return "non"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodayTableViewCell") as? TodayTableViewCell else { return UITableViewCell() }
        let singleMission = viewModel.singleMission(section: indexPath.section, index: indexPath.row)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        let stringDate = dateFormatter.string(from: singleMission.time)
        cell.cellIndexPath = indexPath
        cell.configureCell(mission: singleMission.content, date: stringDate, isAccomplished: singleMission.isAccomplished)
        cell.delegate = viewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteSwipe = UIContextualAction(style: .normal, title: "Delete") { (action, view, handler) in
            self.viewModel.deleteMission(indexPath: indexPath)
        }
        return UISwipeActionsConfiguration(actions: [deleteSwipe])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accomplishSwipe = UIContextualAction(style: .normal, title: "Accomplish") { (action, view, handler) in
            self.viewModel.accomplishMission(indexPath: indexPath)
        }
        return UISwipeActionsConfiguration(actions: [accomplishSwipe])
    }
}

extension TodayViewController: FetchedTodayDataProtocol {
    func refreshTableView() {
        self.tableView.reloadData()
    }
}

