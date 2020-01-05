//
//  SummaryTableViewController.swift
//  Hunt Tracker
//
//  Created by Ryan Spoonmore on 12/14/19.
//  Copyright © 2019 Ryan's Apps. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "subtitle"

class SummaryTableViewController: UITableViewController {

    lazy var realm: Realm = try! Realm()
    var huntArray: Results<Hunt>?
    var newGeneratedHunt: Hunt?
    var summarySeasonArray = [String]()
    var summaryCountArray = [Int]()
    var chosenSeason: String = ""
    var colorOne: UIColor = UIColor.white
    var colorTwo: UIColor = UIColor.lightGray
//    var colorTwo: UIColor = UIColor.systemGray5
    var colorThree: UIColor = UIColor(displayP3Red: 0.0, green: 144.0/250, blue: 81.0/250, alpha: 100.0)
    
    
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
        return summarySeasonArray.count > 0 ? summarySeasonArray.count : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        if !(summarySeasonArray.isEmpty) {
            cell.textLabel?.text = summarySeasonArray[indexPath.row]
            cell.detailTextLabel?.text = "\(summaryCountArray[indexPath.row]) Hunt(s)"
            cell.backgroundColor = colorTwo
            if #available(iOS 13.0, *) {
                let accessoryImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
                cell.accessoryView = accessoryImageView
                cell.accessoryView?.tintColor = colorThree
            } else {
                cell.accessoryType = .disclosureIndicator
            }
            cell.tintColor = colorTwo
            cell.accessoryView?.tintColor = colorThree
            cell.tintColor = colorTwo
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = colorThree
            cell.selectedBackgroundView = backgroundView
            
            return cell
        }
        else {
            cell.textLabel?.text = "No hunts have been added"
            cell.detailTextLabel?.text = "Press the + button to add a new hunt"
            cell.accessoryType = .none
            cell.backgroundColor = colorTwo
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !(summarySeasonArray.isEmpty) {
            chosenSeason = summarySeasonArray[indexPath.row]
            performSegue(withIdentifier: "goToSeason", sender: self)
        }
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    // MARK: - Set Colors
    func setColors() {
        tableView.backgroundColor = colorTwo
        navigationController?.navigationBar.tintColor = colorThree
        navigationController?.navigationBar.backgroundColor = colorTwo
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: colorThree]
    }
    
    // MARK: - newHuntButton Pressed
    @IBAction func newHuntPressed(_ sender: Any) {
        newHunt()
        loadHunts()
        performSegue(withIdentifier: "newHuntFromPlus", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSeason" {
            let destVC = segue.destination as! SeasonSummaryTableViewController
            destVC.realm = realm
            destVC.season = chosenSeason
            destVC.colorOne = colorOne
            destVC.colorTwo = colorTwo
            destVC.colorThree = colorThree
            loadHunts()
        }
        else if segue.identifier == "newHuntFromPlus" {
            let destVC = segue.destination as! TabBarViewController
            destVC.realm = realm
            destVC.dataRequestDate = newGeneratedHunt?.date
            destVC.dataRequestBlind = newGeneratedHunt?.blindNumber
            destVC.colorOne = colorOne
            destVC.colorTwo = colorTwo
            destVC.colorThree = colorThree
            loadHunts()
        }
    }
    
    // MARK: - Load Hunts
    func loadHunts() {
        summarySeasonArray = []
        summaryCountArray = []
        huntArray = realm.objects(Hunt.self).sorted(byKeyPath: "date", ascending: true)
        
        if !(huntArray?.isEmpty ?? true) {
            for hunt in huntArray! {
                if summarySeasonArray.contains(hunt.season) {
                    let index = summarySeasonArray.firstIndex(of: hunt.season)!
                    summaryCountArray[index] += 1
                }
                else {
                    summarySeasonArray.append(hunt.season)
                    summaryCountArray.append(1)
                }
            }
        }
        tableView.reloadData()
    }
    
    // MARK: - Create New Hunt
    func newHunt() {
        newGeneratedHunt = Hunt(on: Date()) as Hunt?
        do {
            try realm.write{
                realm.add(newGeneratedHunt!)
            }
        }
        catch {
            print("Error creating new hunt \(error)")
        }
    }

}
