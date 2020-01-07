//
//  InfoViewController.swift
//  Hunt Tracker
//
//  Created by Ryan Spoonmore on 12/15/19.
//  Copyright © 2019 Ryan's Apps. All rights reserved.
//

import UIKit
import RealmSwift

class InfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    var realm: Realm?
    var dataRequestDate: Date?
    var dataRequestBlind: Int?
    var hunt: Hunt?
    var huntDF = DateFormatter()
    var showDatePicker: Bool = false
    var tabVC: TabBarViewController?
    var colorOne: UIColor?
    var colorTwo: UIColor?
    var colorThree: UIColor?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setDateFormatter()
        loadHunt()
        setColors()
        
        // Keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // Table View Cells
        tableView.register(UINib(nibName: "DateEntryTableViewCell", bundle: nil), forCellReuseIdentifier: "dateEntryCell")
        tableView.register(UINib(nibName: "LabeledEntryTableViewCell", bundle: nil), forCellReuseIdentifier: "labeledEntryCell")
        tableView.register(UINib(nibName: "TextEntryTableViewCell", bundle: nil), forCellReuseIdentifier: "textEntryCell")
        tableView.register(UINib(nibName: "FeederTableViewCell", bundle: nil), forCellReuseIdentifier: "switchCell")

    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        else if section == 1 {
            return 1
        }
        else {
            return (hunt?.feeders.count ?? 0) + 1
        }
    }

    // MARK: - Cell For Row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Hunt Date Cell
        if indexPath == IndexPath(row: 0, section: 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "rightDetail", for: indexPath)
            cell.textLabel?.text = "Hunt Date"
            cell.detailTextLabel?.text = huntDF.string(from: hunt?.date ?? Date())
            cell.backgroundColor = colorOne
            return cell
        }
        // Date Picker
        if indexPath == IndexPath(row: 1, section: 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateEntryCell", for: indexPath) as! DateEntryTableViewCell
            cell.delegate = self
            cell.datePicker.date = hunt?.date ?? Date()
            cell.datePicker.isHidden = !showDatePicker
            cell.backgroundColor = colorOne
            return cell
        }
        // Blind Entry
        if indexPath == IndexPath(row:2, section: 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "labeledEntryCell", for: indexPath) as! LabeledEntryTableViewCell
            cell.delegate = self
            cell.label.text = "Blind Number"
            cell.textField.keyboardType = .numberPad
            cell.textField.text = ""
            cell.textField.placeholder = hunt?.blindNumber.description ?? "2"
            cell.type = "Blind"
            cell.backgroundColor = colorOne
            cell.textField.backgroundColor = colorOne
            return cell
        }
        // Weather Entry
        if indexPath == IndexPath(row: 0, section: 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "textEntryCell", for: indexPath) as! TextEntryTableViewCell
            cell.delegate = self
            if hunt?.weather == "" {
                cell.textField.text = ""
                cell.textField.placeholder = "Weather"
            }
            else {
                cell.textField.text = hunt?.weather
            }
            cell.type = "Weather"
            cell.backgroundColor = colorOne
            return cell
        }
        // Feeder Entry
        if indexPath == IndexPath(row: 0, section: 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "labeledEntryCell", for: indexPath) as! LabeledEntryTableViewCell
            cell.delegate = self
            cell.label.text = "Number of Feeders"
            cell.textField.keyboardType = .numberPad
            cell.textField.text = ""
            cell.textField.placeholder = hunt?.feeders.count.description
            cell.type = "Feeders"
            cell.backgroundColor = colorOne
            cell.textField.backgroundColor = colorOne
            return cell
        }
        // Feeder Values
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! FeederTableViewCell
            cell.delegate = self
            guard let feeder = hunt?.feeders[indexPath.row - 1] else {fatalError("Cannot load feeder for cell")}
            cell.label.text = "Feeder \(feeder.number) went off"
            cell.rightSwitch.isOn = feeder.wentOff
            cell.backgroundColor = colorOne
            cell.rightSwitch.tintColor = colorThree
            cell.rightSwitch.onTintColor = colorThree
            return cell
        }
    }
    
    // MARK: - Section Titles
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Time and Place"
        }
        else if section == 1 {
            return "Conditions"
        }
        else {
            return "Feeders"
        }
    }
    
    // MARK: - Row Heights
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Hunt Date Cell
        if indexPath == IndexPath(row: 0, section: 0) {
            return 45
        }
        // Date Picker
        if indexPath == IndexPath(row: 1, section: 0) {
            return showDatePicker ? 170 : 0
        }
        // Blind Entry
        if indexPath == IndexPath(row:2, section: 0) {
            return 45
        }
        // Weather Entry
        if indexPath == IndexPath(row: 0, section: 1) {
            return 45
        }
        // Feeder Entry
        if indexPath == IndexPath(row: 0, section: 2) {
            return 45
        }
        // Feeder Values
        else {
            return 50
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 0, section: 0) {
            showDatePicker = !showDatePicker
        }
        else {
            showDatePicker = false
        }
        tableView.cellForRow(at: indexPath)?.isSelected = false
        tableView.reloadData()
    }
    
    // MARK: - Keyboard Offsetting display
    @objc func keyboardWillChange(notification: Notification){

        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {fatalError("error getting keyboard rectangle")}

        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
            if (tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! LabeledEntryTableViewCell).textField.isFirstResponder {
                view.frame.origin.y = 0
            }
            else if (tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! TextEntryTableViewCell).textField.isFirstResponder {
                view.frame.origin.y = -(keyboardRect.height / 3)
            }
            else {
                view.frame.origin.y = -(keyboardRect.height / 2)
            }
        }
        else {
            view.frame.origin.y = 0
        }
    }
    
    
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return indexPath.section == 2 && indexPath.row > 0
//    }
//
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//    }
    
    // MARK: - Set Colors
    func setColors() {
        colorOne = tabVC?.colorOne
        colorTwo = tabVC?.colorTwo
        colorThree = tabVC?.colorThree
        tableView.backgroundColor = colorTwo
        tableView.separatorStyle = .none
//        navigationController?.navigationBar.tintColor = colorThree
//        navigationController?.navigationBar.backgroundColor = colorTwo
//        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: colorThree!]
    }
    
    // MARK: - Set Date Formatter
    func setDateFormatter() {
        huntDF.dateStyle = .medium
        huntDF.timeStyle = .short
    }
    
    
    // MARK: - Load Hunt
    func loadHunt() {
        tabVC = (self.tabBarController as! TabBarViewController)
        realm = tabVC?.realm
        dataRequestDate = tabVC?.dataRequestDate
        dataRequestBlind = tabVC?.dataRequestBlind
        guard let date = dataRequestDate else {fatalError("Cannot find selected hunt date")}
        guard let blind = dataRequestBlind else {fatalError("Cannot find selected hunt blind")}
        let predicate: NSPredicate = NSPredicate(format: "date == %@ && blindNumber == %@ && defaultHunt == %@", argumentArray: [date, blind, false])
        hunt = realm?.objects(Hunt.self).filter(predicate)[0]
        tableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension InfoViewController: DatePickerCellDelegate {
    func dateChanged(sender: DateEntryTableViewCell) {
        dataRequestDate = sender.datePicker.date
        tabVC?.dataRequestDate = sender.datePicker.date
        do {
            try realm!.write {
                hunt?.date = sender.datePicker.date
            }
        }
        catch {
            print("Error saving new date to realm: \(error)")
        }
        
        let indexPath = IndexPath(row: 0, section: 0)
        let detailCell = tableView.cellForRow(at: indexPath)
        detailCell?.detailTextLabel?.text = huntDF.string(from: sender.datePicker.date)
        tableView.reloadData()
    }
}

extension InfoViewController: LabeledEntryCellDelegate {
    func textEntered(sender: LabeledEntryTableViewCell) {
        guard let hunt = hunt else {fatalError("Cannot unwrap hunt")}
        if sender.type == "Blind" {
            guard let blind = sender.textField.text else {fatalError("Cannot unwrap string of blind number")}
            if let blindInt = Int(blind) {
                dataRequestBlind = blindInt
                tabVC?.dataRequestBlind = blindInt
                do {
                    try realm!.write {
                        hunt.blindNumber = blindInt
                    }
                }
                catch {
                    print("Error saving new blind number to realm: \(error)")
                }
            }
        }
        else if sender.type == "Feeders" {
            guard let feederNum = sender.textField.text else {fatalError("Cannot unwrap string of feeder number")}
            if let feederInt = Int(feederNum) {
                deleteFeeders(forHunt: hunt)
                addFeeders(numFeeders: feederInt, forHunt: hunt)
            }
            loadHunt()
        }
    }
    
    
    func deleteFeeders(forHunt hunt: Hunt) {
        if hunt.feeders.count > 0 {
            do {
                try realm!.write {
                    for feeder in hunt.feeders{
                        realm!.delete(feeder)
                    }
                }
            }
            catch {
                print("Error deleting feeders: \(error)")
            }
        }
    }
    
    
    func addFeeders(numFeeders num: Int, forHunt hunt: Hunt) {
        if num > 0 {
            for i in 1...num {
                do {
                    try realm!.write {
                        let newFeeder = Feeder(number: i)
                        hunt.feeders.append(newFeeder)
                        realm!.add(newFeeder)
                    }
                }
                catch {
                    print("Error appending new filter: \(error)")
                }
            }
        }
    }
}

extension InfoViewController: TextEntryCellDelegate {
    func textEntered(sender: TextEntryTableViewCell) {
        guard let hunt = hunt else {fatalError("Cannot unwrap hunt")}
        if sender.type == "Weather" {
            guard let weather = sender.textField.text else {fatalError("Cannot unwrap string for weather")}
            do {
                try realm!.write {
                    hunt.weather = weather
                }
            }
            catch {
                print("Error saving new weather to realm: \(error)")
            }
        }
        loadHunt()
    }
}

extension InfoViewController: FeederCellDelegate {
    func feederStatusChanged(sender: FeederTableViewCell) {
        guard let hunt = hunt else {fatalError("Cannot unwrap hunt")}
        guard let indexPath = tableView.indexPath(for: sender) else {fatalError("Cannot unwrap indexPath of sender")}
        do {
            try realm!.write {
                hunt.feeders[indexPath.row - 1].wentOff = sender.rightSwitch.isOn
            }
        }
        catch {
            print("Error saving new switch state for feeders: \(error)")
        }
        loadHunt()
    }
}
