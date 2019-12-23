//
//  AnimalsSeenViewController.swift
//  Hunt Tracker
//
//  Created by Ryan Spoonmore on 12/15/19.
//  Copyright © 2019 Ryan's Apps. All rights reserved.
//

import UIKit
import RealmSwift

class AnimalsSeenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
    var realm: Realm?
    var dataRequestDate: Date?
    var dataRequestBlind: Int?
    var hunt: Hunt?
    var chosenAnimal: Animal?
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
        guard let animals = hunt?.animals else {return 1}
        return animals.count + 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let animals = hunt?.animals else {return 1}
        return section > (animals.count - 1) ? 1 : animals[section].subtypes.count + 1
    }
    // MARK: - Cell For Row At
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let animals = hunt?.animals {
            // Empty Animals Array or Last Section of Table
            if indexPath.section > (animals.count - 1) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
                cell.textLabel?.text = " + Add an animal"
                cell.backgroundColor = colorOne
                let backgroundView = UIView()
                backgroundView.backgroundColor = colorThree
                cell.selectedBackgroundView = backgroundView
                return cell
            }
            // Last Row of Each Animal
            else if indexPath.row > (animals[indexPath.section].subtypes.count - 1) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
                cell.textLabel?.text = " + Add a new subtype to \(animals[indexPath.section].name!)"
                cell.backgroundColor = colorOne
                let backgroundView = UIView()
                backgroundView.backgroundColor = colorThree
                cell.selectedBackgroundView = backgroundView
                return cell
            }
            // Animal Subtypes
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "counterCell", for: indexPath) as! CounterTableViewCell
                cell.delegate = self
                cell.type = "Seen"
                cell.label.text = animals[indexPath.section].subtypes[indexPath.row].name
                cell.stepper.value = Double(animals[indexPath.section].subtypes[indexPath.row].totalSeen)
                cell.valueLabel.text = animals[indexPath.section].subtypes[indexPath.row].totalSeen.description
                cell.stepperTintColor = colorThree
                cell.resetColors()
                cell.backgroundColor = colorOne
                return cell
            }
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
            cell.textLabel?.text = " + Add an animal"
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
        if let animals = hunt?.animals {
            if indexPath.section > (animals.count - 1) {
                performSegue(withIdentifier: "newAnimal", sender: self)
            }
            else if indexPath.row > (animals[indexPath.section].subtypes.count - 1) {
                chosenAnimal = animals[indexPath.section]
                performSegue(withIdentifier: "newSubtype", sender: self)
            }
        }
        else {
            print("Animals was not found")
        }
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let animals = hunt?.animals {
            return indexPath.section < animals.count && indexPath.row < animals[indexPath.section].subtypes.count
        }
        else {
            return false
        }
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if hunt?.animals[indexPath.section].subtypes.count ?? 0 <= 1 {
                guard let animal = hunt?.animals[indexPath.section] else {fatalError("Cannot unwrap animal")}
                deleteAnimal(animal)
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
            }
            else {
                guard let subtype = hunt?.animals[indexPath.section].subtypes[indexPath.row] else {fatalError("Cannot unwrap animal subtype")}
                deleteAnimalSubtype(subtype)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            loadHunt()
        }
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

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newAnimal" {
            let destVC = segue.destination as! NewAnimalViewController
            destVC.realm = realm
            destVC.dataRequestDate = dataRequestDate
            destVC.dataRequestBlind = dataRequestBlind
            destVC.parentVC = self
        }
        else if segue.identifier == "newSubtype" {
            let destVC = segue.destination as! NewSubtypeViewController
            destVC.realm = realm
            destVC.dataRequestDate = dataRequestDate
            destVC.dataRequestBlind = dataRequestBlind
            destVC.animal = chosenAnimal
            destVC.parentVC = self
        }
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
    
    // MARK: - Delete Animal
    func deleteAnimal(_ animal: Animal) {
        do {
            try realm!.write {
                for sub in animal.subtypes {
                    realm!.delete(sub)
                }
                realm!.delete(animal)
            }
        }
        catch {
            print("Error deleting animal and subtypes: \(error)")
        }
    }
    
    // MARK: - Delete Animal Subtype
    func deleteAnimalSubtype(_ subtype: AnimalSubtype) {
        do {
            try realm!.write {
                realm!.delete(subtype)
            }
        }
        catch {
            print("Error deleting animal subtype: \(error)")
        }
    }

}

extension AnimalsSeenViewController: CounterCellDelegate {
    func countChanged(sender: CounterTableViewCell) {
        if sender.type == "Seen" {
            guard let indexPath = tableView.indexPath(for: sender) else {fatalError("Cannot unwrap indexPath from sender")}
            guard let subtype = hunt?.animals[indexPath.section].subtypes[indexPath.row] else {fatalError("Cannot unwrap subtype from indexPath")}
            do {
                try realm!.write {
                    subtype.totalSeen = Int(sender.stepper.value)
                }
            }
            catch {
                print("Error saving new seen amount to subtype: \(error)")
            }
        }
        loadHunt()
    }
}
