//
//  DefaultHuntAnimalController.swift
//  Hunt Tracker
//
//  Created by Ryan Spoonmore on 1/6/20.
//  Copyright © 2020 Ryan's Apps. All rights reserved.
//

import UIKit
import RealmSwift

class DefaultHuntAnimalController: AnimalViewController {

    @IBOutlet weak var connectedTableView: UITableView!
    
    override func viewDidLoad() {
        tableView = connectedTableView!
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView = connectedTableView!
        super.viewWillAppear(true)
    }
    
    // MARK: - Set Colors
    override func setColors() {
        super.setColors()
        navigationController?.navigationBar.tintColor = colorThree
        navigationController?.navigationBar.backgroundColor = colorTwo
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: colorThree!]
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

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newAnimal" {
            let destVC = segue.destination as! NewAnimalViewController
            destVC.realm = realm
            destVC.defaultVC = self
            destVC.senderVC = "default"
        }
        else if segue.identifier == "newSubtype" {
            let destVC = segue.destination as! NewSubtypeViewController
            destVC.realm = realm
            destVC.animal = chosenAnimal
            destVC.defaultVC = self
            destVC.senderVC = "default"
        }
    }

    // MARK: - Load Hunt
    override func loadHunt() {
        super.loadHunt()
        let predicate: NSPredicate = NSPredicate(format: "defaultHunt == %@", argumentArray: [true])
        hunt = realm?.objects(Hunt.self).filter(predicate)[0]
        tableView!.reloadData()
    }

}
