//
//  AnimalsShotViewController.swift
//  Hunt Tracker
//
//  Created by Ryan Spoonmore on 12/16/19.
//  Copyright © 2019 Ryan's Apps. All rights reserved.
//

import UIKit
import RealmSwift

class AnimalsShotViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
    var realm: Realm?
    var dataRequestDate: Date?
    var dataRequestBlind: Int?
    var hunt: Hunt?
    var tabVC: TabBarViewController?
    var colorOne: UIColor?
    var colorTwo: UIColor?
    var colorThree: UIColor?

    @IBOutlet weak var tableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CounterTableViewCell", bundle: nil), forCellReuseIdentifier: "counterCell")
        loadHunt()
        setColors()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadHunt()
    }

    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return hunt?.animals.count ?? 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hunt?.animals[section].subtypes.count ?? 1
    }
    // MARK: - Cell For Row At
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let animals = hunt?.animals {
            let cell = tableView.dequeueReusableCell(withIdentifier: "counterCell", for: indexPath) as! CounterTableViewCell
            cell.delegate = self
            cell.type = "Shot"
            cell.label.text = animals[indexPath.section].subtypes[indexPath.row].name
            cell.stepper.value = Double(animals[indexPath.section].subtypes[indexPath.row].totalShot)
            cell.stepper.maximumValue = Double(animals[indexPath.section].subtypes[indexPath.row].totalSeen)
            cell.valueLabel.text = animals[indexPath.section].subtypes[indexPath.row].totalShot.description
            cell.stepperTintColor = colorThree
            cell.resetColors()
            cell.backgroundColor = colorOne
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
            cell.textLabel?.text = "No animals were seen"
            cell.backgroundColor = colorOne
            let backgroundView = UIView()
            backgroundView.backgroundColor = colorThree
            cell.selectedBackgroundView = backgroundView
            return cell
        }
    }
    // MARK: - Header Titles
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let animals = hunt?.animals else {return ""}
        // Empty Animals Array or Last Section of Table
        if section > (animals.count - 1) {
            return ""
        }
        else {
            return animals[section].name
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    // MARK: - Cell Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
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

    // MARK: - Load Hunt
    func loadHunt() {
        tabVC = (self.tabBarController as! TabBarViewController)
        realm = tabVC?.realm
        dataRequestDate = tabVC?.dataRequestDate
        dataRequestBlind = tabVC?.dataRequestBlind
        guard let date = dataRequestDate else {fatalError("Cannot find selected hunt date")}
        guard let blind = dataRequestBlind else {fatalError("Cannot find selected hunt blind")}
        let predicate: NSPredicate = NSPredicate(format: "date == %@ && blindNumber == %@", argumentArray: [date, blind])
        hunt = realm?.objects(Hunt.self).filter(predicate)[0]
        tableView.reloadData()
    }
    


}

extension AnimalsShotViewController: CounterCellDelegate {
    func countChanged(sender: CounterTableViewCell) {
        if sender.type == "Shot" {
            guard let indexPath = tableView.indexPath(for: sender) else {fatalError("Cannot unwrap indexPath from sender")}
            guard let subtype = hunt?.animals[indexPath.section].subtypes[indexPath.row] else {fatalError("Cannot unwrap subtype from indexPath")}
            do {
                try realm!.write {
                    subtype.totalShot = Int(sender.stepper.value)
                }
            }
            catch {
                print("Error saving new seen amount to subtype: \(error)")
            }
        }
        loadHunt()
    }
}

