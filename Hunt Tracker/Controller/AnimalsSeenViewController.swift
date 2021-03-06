//
//  AnimalsSeenViewController.swift
//  Hunt Tracker
//
//  Created by Ryan Spoonmore on 12/15/19.
//  Copyright © 2019 Ryan's Apps. All rights reserved.
//

import UIKit
import RealmSwift

class AnimalsSeenViewController: AnimalViewController {

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
    
    // MARK: - Set Colors
    override func setColors() {
        colorOne = tabVC?.colorOne
        colorTwo = tabVC?.colorTwo
        colorThree = tabVC?.colorThree
        super.setColors()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newAnimal" {
            let destVC = segue.destination as! NewAnimalViewController
            destVC.realm = realm
            destVC.dataRequestDate = dataRequestDate
            destVC.dataRequestBlind = dataRequestBlind
            destVC.parentVC = self
            destVC.senderVC = "seen"
        }
        else if segue.identifier == "newSubtype" {
            let destVC = segue.destination as! NewSubtypeViewController
            destVC.realm = realm
            destVC.dataRequestDate = dataRequestDate
            destVC.dataRequestBlind = dataRequestBlind
            destVC.animal = chosenAnimal
            destVC.parentVC = self
            destVC.senderVC = "seen"
        }
    }

    // MARK: - Load Hunt
    override func loadHunt() {
        super.loadHunt()
        tabVC = (self.tabBarController as! TabBarViewController)
        realm = tabVC?.realm
        dataRequestDate = tabVC?.dataRequestDate
        dataRequestBlind = tabVC?.dataRequestBlind
        guard let date = dataRequestDate else {fatalError("Cannot find selected hunt date")}
        guard let blind = dataRequestBlind else {fatalError("Cannot find selected hunt blind")}
        let predicate: NSPredicate = NSPredicate(format: "date == %@ && blindNumber == %@ && defaultHunt == %@", argumentArray: [date, blind, false])
        hunt = realm?.objects(Hunt.self).filter(predicate)[0]
        tableView!.reloadData()
    }

}
