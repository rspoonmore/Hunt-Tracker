//
//  NotesViewController.swift
//  Hunt Tracker
//
//  Created by Ryan Spoonmore on 12/16/19.
//  Copyright © 2019 Ryan's Apps. All rights reserved.
//

import UIKit
import RealmSwift

class NotesViewController: UIViewController {

    var realm: Realm?
    var dataRequestDate: Date?
    var dataRequestBlind: Int?
    var hunt: Hunt?
    var tabVC: TabBarViewController?
    var colorOne: UIColor?
    var colorTwo: UIColor?
    var colorThree: UIColor?
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        loadHunt()
        setColors()
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
        textView.backgroundColor = colorOne
        textView.textColor = UIColor.black //colorThree
        textView.layer.cornerRadius = 5
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
        textView.text = hunt?.notes ?? ""
    }

}

extension NotesViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        do {
            try realm!.write {
                hunt?.notes = textView.text
            }
        }
        catch {
            print("Error saving notes: \(error)")
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
