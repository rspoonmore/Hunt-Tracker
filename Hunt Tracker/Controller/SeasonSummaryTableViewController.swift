//
//  SeasonSummaryTableViewController.swift
//  Hunt Tracker
//
//  Created by Ryan Spoonmore on 12/14/19.
//  Copyright © 2019 Ryan's Apps. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "subtitle"

class SeasonSummaryTableViewController: UITableViewController {
    
    var season: String?
    var realm: Realm?
    var huntArray: Results<Hunt>?
    var newHunt: Hunt?
    var chosenHuntDate: Date?
    var chosenHuntBlind: Int?
    var colorOne: UIColor?
    var colorTwo: UIColor?
    var colorThree: UIColor?

    @IBOutlet weak var newHuntButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadHunts()
        setColors()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadHunts()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return huntArray?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        cell.textLabel?.text = huntArray?[indexPath.row].dateString
        cell.detailTextLabel?.text = "Seen: \(huntArray?[indexPath.row].animalsSeen ?? 0), Shot: \(huntArray?[indexPath.row].animalsShot ?? 0)"
        
        cell.backgroundColor = colorTwo
        let accessoryImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        cell.accessoryView = accessoryImageView
        cell.accessoryView?.tintColor = colorThree
        cell.tintColor = colorTwo
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = colorThree
        cell.selectedBackgroundView = backgroundView

        return cell
    }

    // MARK: - Table Editing
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteHunt(hunt: huntArray![indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .automatic)
            loadHunts()
        }
    }

    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenHuntDate = huntArray?[indexPath.row].date
        chosenHuntBlind = huntArray?[indexPath.row].blindNumber
        loadHunts()
        performSegue(withIdentifier: "goToHunt", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToHunt" {
            let destVC = segue.destination as! TabBarViewController
            destVC.realm = realm!
            destVC.dataRequestDate = chosenHuntDate
            destVC.dataRequestBlind = chosenHuntBlind
            destVC.colorOne = colorOne
            destVC.colorTwo = colorTwo
            destVC.colorThree = colorThree
            loadHunts()
        }
        else if segue.identifier == "newHuntFromPlusTwo" {
            let destVC = segue.destination as! TabBarViewController
            destVC.realm = realm!
            destVC.dataRequestDate = newHunt?.date
            destVC.dataRequestBlind = newHunt?.blindNumber
            destVC.colorOne = colorOne
            destVC.colorTwo = colorTwo
            destVC.colorThree = colorThree
            loadHunts()
        }
    }
    
    // MARK: - Set Colors
    func setColors() {
        tableView.backgroundColor = colorTwo
        navigationController?.navigationBar.tintColor = colorThree
        navigationController?.navigationBar.backgroundColor = colorTwo
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: colorThree!]
    }
    
    // MARK: - Create New Hunt
    @IBAction func newHuntPressed(_ sender: Any) {
        createNewHunt()
        loadHunts()
        performSegue(withIdentifier: "newHuntFromPlusTwo", sender: self)
    }
    
    
    // MARK: - Load Hunts
    func loadHunts(){
        let predicate = NSPredicate(format: "self.season == %@", season!)
        huntArray = realm?.objects(Hunt.self).filter(predicate).sorted(byKeyPath: "date", ascending: false)
        tableView.reloadData()
    }
    
    // MARK: - Create New Hunt
    func createNewHunt() {
        newHunt = Hunt(on: Date()) as Hunt?
        do {
            try realm!.write{
                realm!.add(newHunt!)
            }
        }
        catch {
            print("Error creating new hunt \(error)")
        }
    }
    
    // MARK: - Delete Hunt
    func deleteHunt(hunt: Hunt) {
        do {
            try realm!.write{
                for feeder in hunt.feeders {
                    realm!.delete(feeder)
                }
                for animal in hunt.animals {
                    for animalSubType in animal.subtypes {
                        realm!.delete(animalSubType)
                    }
                    realm!.delete(animal)
                }
                realm!.delete(hunt)
            }
        }
        catch {
            print("Error deleting hunt: \(error)")
        }
    }

}
