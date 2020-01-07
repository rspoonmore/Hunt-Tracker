//
//  SummaryViewController.swift
//  Hunt Tracker
//
//  Created by Ryan Spoonmore on 12/16/19.
//  Copyright © 2019 Ryan's Apps. All rights reserved.
//

import UIKit
import RealmSwift

class SummaryViewController: UIViewController {
    
    var realm: Realm?
    var dataRequestDate: Date?
    var dataRequestBlind: Int?
    var hunt: Hunt?
    var tabVC: TabBarViewController?
    var colorOne: UIColor?
    var colorTwo: UIColor?
    var colorThree: UIColor?

    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var summaryLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadHunt()
        setColors()
        setSummary()
    }
    
   // MARK: - Set Colors
    func setColors() {
        colorOne = tabVC?.colorOne
        colorTwo = tabVC?.colorTwo
        colorThree = tabVC?.colorThree
        navigationController?.navigationBar.tintColor = colorThree
        navigationController?.navigationBar.backgroundColor = colorTwo
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: colorThree!]
        self.view.backgroundColor = colorTwo
        summaryView.backgroundColor = colorTwo
        summaryLabel.textColor = UIColor.black //colorThree
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
    }
    
    func setSummary() {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        guard let sumHunt = hunt else {fatalError("Cannot unwrap hunt")}
        var string = "Hunt on \(df.string(from: sumHunt.date)) \n"
        string += "Blind: \(sumHunt.blindNumber) \n"
        string += "Weather: \(sumHunt.weather) \n"
        if sumHunt.feeders.isEmpty {
            string += "No feeders for this blind."
        }
        else {
            for feeder in sumHunt.feeders {
                let feederState = feeder.wentOff ? "went off" : "did not go off"
                string += "Feeder \(feeder.number) \(feederState) \n"
            }
        }
        string += "\n"
        for animal in sumHunt.animals {
            string += "\(animal.name ?? "Unnamed animal") (\(animal.totalSeen?.description ?? "1") Seen, \(animal.totalShot?.description ?? "0") Shot): \n"
            for subtype in animal.subtypes {
                string += "\t\(subtype.name ?? "Unnamed subtype") seen: \(subtype.totalSeen.description), shot: \(subtype.totalShot.description)\n"
            }
        }
        string += "\nNotes: \n\t\(sumHunt.notes)"
        
        summaryLabel.text = string
    }

}
