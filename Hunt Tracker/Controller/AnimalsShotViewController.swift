//
//  AnimalsShotViewController.swift
//  Hunt Tracker
//
//  Created by Ryan Spoonmore on 12/16/19.
//  Copyright © 2019 Ryan's Apps. All rights reserved.
//

import UIKit
import RealmSwift

class AnimalsShotViewController: AnimalViewController {

    var tabVC: TabBarViewController?
    @IBOutlet weak var connectedTableView: UITableView!


    override func viewDidLoad() {
        tableView = connectedTableView!
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView = connectedTableView!
        super.viewWillAppear(true)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return hunt?.animals.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hunt?.animals[section].subtypes.count ?? 1
    }
    // MARK: - Cell For Row At
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    
    // MARK: - Cell Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: - Set Colors
    override func setColors() {
        colorOne = tabVC?.colorOne
        colorTwo = tabVC?.colorTwo
        colorThree = tabVC?.colorThree
        super.setColors()
    }

    // MARK: - Load Hunt
    override func loadHunt() {
        tabVC = (self.tabBarController as! TabBarViewController)
        realm = tabVC?.realm
        dataRequestDate = tabVC?.dataRequestDate
        dataRequestBlind = tabVC?.dataRequestBlind
        guard let date = dataRequestDate else {fatalError("Cannot find selected hunt date")}
        guard let blind = dataRequestBlind else {fatalError("Cannot find selected hunt blind")}
        let predicate: NSPredicate = NSPredicate(format: "date == %@ && blindNumber == %@ && defaultHunt == %@", argumentArray: [date, blind, false])
        hunt = realm?.objects(Hunt.self).filter(predicate)[0]
        tableView?.reloadData()
    }
    

}


