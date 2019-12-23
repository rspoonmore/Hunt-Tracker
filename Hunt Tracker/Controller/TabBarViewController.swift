//
//  TabBarViewController.swift
//  Hunt Tracker
//
//  Created by Ryan Spoonmore on 12/15/19.
//  Copyright © 2019 Ryan's Apps. All rights reserved.
//

import UIKit
import RealmSwift

class TabBarViewController: UITabBarController {

    var realm: Realm?
    var dataRequestDate: Date?
    var dataRequestBlind: Int?
    var hunt: Hunt?
    var colorOne: UIColor?
    var colorTwo: UIColor?
    var colorThree: UIColor?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.tintColor = colorThree
        navigationController?.navigationBar.tintColor = colorThree
        navigationController?.navigationBar.backgroundColor = colorTwo
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: colorThree!]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: colorThree!]
    }
    
    @IBAction func savePressed(_ sender: Any) {
        let destVC = SummaryTableViewController()
        destVC.loadHunts()
        navigationController?.popToRootViewController(animated: true)
    }
    

    

}
