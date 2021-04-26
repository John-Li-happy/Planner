//
//  TodayViewController.swift
//  Planner
//
//  Created by Zhaoyang Li on 3/22/21.
//

import UIKit

class TodayViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = 150
        }
    }
    
    lazy var viewModel = TodayViewModel(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        initialTest()
    }
    
    private func initialTest() {
        viewModel.initialDataSourcePopulate()
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
        dateFormatter.dateFormat = "MM dd, yyyy"
        let stringDate = dateFormatter.string(from: singleMission.time)
        cell.configureCell(mission: singleMission.content, date: stringDate, isAccomplished: singleMission.isAccomplished)
        cell.cellIndexPath = indexPath
        cell.delegate = viewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TodayViewController: FetchedTodayDataProtocol {
    func refreshTableView() {
        self.tableView.reloadData()
    }
}

