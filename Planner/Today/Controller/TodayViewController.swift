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
        }
    }
    @IBOutlet private weak var addView: UIView!
    @IBOutlet private weak var textView: UITextView! {
        didSet {
            textView.delegate = self
        }
    }
    
    lazy var viewModel = TodayViewModel(delegate: self)
    var goingToAddFlag = Bool()
    var chosnCell = IndexPath()
    var tapRecognizer = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        viewModel.loadMissions()
        tapToResign()
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        addView.isHidden = false
        goingToAddFlag = true
        datePicker.date = Date()
        tapRecognizer.cancelsTouchesInView = true
    }
    
    @IBAction func accomplishButtonTapped(_ sender: UIButton) {
        if goingToAddFlag {
            if !textView.text.isEmpty && textView.text != nil {
                viewModel.createNewMission(content: textView.text, time: datePicker.date)
            } else {
                noDataAlert()
            }
        } else {
            if !textView.text.isEmpty && textView.text != nil {
                viewModel.updateMission(indexPath: chosnCell, content: textView.text, date: datePicker.date)
            } else {
                noDataAlert()
            }
        }
        addView.isHidden = true
        tapRecognizer.cancelsTouchesInView = false
    }
    
    private func tapToResign() {
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        tapRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapRecognizer)
    }
    
    private func noDataAlert() {
        let alertController = UIAlertController(title: "Attention", message: "Please re-enter ", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func tapHandler() {
        addView.isHidden = true
        tapRecognizer.cancelsTouchesInView = false
        textView.resignFirstResponder()
        view.endEditing(true)
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
            return AppConstants.TableHeaders.overdue
        case 1:
            return AppConstants.TableHeaders.today
        case 2:
            return AppConstants.TableHeaders.upcoming
        default:
            return "non"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.Table.cellIdentifier) as? TodayTableViewCell else { return UITableViewCell() }
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
        goingToAddFlag = false
        tapRecognizer.cancelsTouchesInView = true
        chosnCell = indexPath
        
        addView.isHidden = false
        textView.text = viewModel.singleMission(section: indexPath.section, index: indexPath.row).content
        datePicker.date = viewModel.singleMission(section: indexPath.section, index: indexPath.row).time
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteSwipe = UIContextualAction(style: .normal, title: AppConstants.Table.deleteSwipe) { (action, view, handler) in
            self.viewModel.deleteMission(indexPath: indexPath)
        }
        return UISwipeActionsConfiguration(actions: [deleteSwipe])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accomplishSwipe = UIContextualAction(style: .normal, title: AppConstants.Table.accomplishSwipe) { (action, view, handler) in
            self.viewModel.accomplishMission(indexPath: indexPath)
        }
        return UISwipeActionsConfiguration(actions: [accomplishSwipe])
    }
}

extension TodayViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
        view.endEditing(true)
    }
}

extension TodayViewController: FetchedTodayDataProtocol {
    func refreshTableView() {
        self.tableView.reloadData()
    }
}

