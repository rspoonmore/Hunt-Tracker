//
//  NewSubtypeViewController.swift
//  Hunt Tracker
//
//  Created by Ryan Spoonmore on 12/15/19.
//  Copyright © 2019 Ryan's Apps. All rights reserved.
//

import UIKit
import RealmSwift

class NewSubtypeViewController: UIViewController, UITextFieldDelegate {

    var realm: Realm?
    var dataRequestDate: Date?
    var dataRequestBlind: Int?
    var hunt: Hunt?
    var animal: Animal?
    var showAddButton: Bool = false
    var parentVC: AnimalsSeenViewController?
    var colorOne: UIColor?
    var colorTwo: UIColor?
    var colorThree: UIColor?
    

    @IBOutlet weak var animalNameLabel: UILabel!
    @IBOutlet weak var subtypeNameTextField: UITextField!
    @IBOutlet weak var numberSeenTextField: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subtypeNameTextField.delegate = self
        numberSeenTextField.delegate = self
        addNumberToolBar()
        loadHunt()
        setColors()
    }
    

    func loadHunt() {
        guard let date = dataRequestDate else {fatalError("Cannot find selected hunt date")}
        guard let blind = dataRequestBlind else {fatalError("Cannot find selected hunt blind")}
        let predicate: NSPredicate = NSPredicate(format: "date == %@ && blindNumber == %@", argumentArray: [date, blind])
        hunt = realm?.objects(Hunt.self).filter(predicate)[0]
        animalNameLabel.text = "Animal Name: \(animal?.name ?? "")"
    }
    
    func setColors() {
        addButton.tintColor = colorThree
        cancelButton.tintColor = colorThree
        self.view.backgroundColor = colorTwo
    }
    
    func updateAddButtonLogic() -> Bool {
        guard subtypeNameTextField.text != "" && numberSeenTextField.text != "" else {return false}
        guard let text = numberSeenTextField.text else {return false}
        guard let _ = Int(text) else {return false}
        return true
    }
    
    func addAppear() {
        showAddButton = updateAddButtonLogic()
        addButton.isHidden = !showAddButton
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if subtypeNameTextField.isFirstResponder {
            subtypeNameTextField.resignFirstResponder()
            addAppear()
            return true
        }
        else if numberSeenTextField.isFirstResponder{
            numberSeenTextField.resignFirstResponder()
            addAppear()
            return true
        }
        return false
    }
    
    //MARK: - NumberToolBar
    func addNumberToolBar() {
        let numToolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 40))
        numToolBar.barStyle = .default
        numToolBar.isTranslucent = true
        let spacerItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        numToolBar.items = [spacerItem, doneItem]
        numToolBar.sizeToFit()
        numberSeenTextField.inputAccessoryView = numToolBar
    }
    
    @objc func dismissKeyboard() {
        if numberSeenTextField.isFirstResponder {
            numberSeenTextField.resignFirstResponder()
            addAppear()
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        subtypeNameTextField.text = ""
        numberSeenTextField.text = ""
        addAppear()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        guard let seen = Int(numberSeenTextField.text ?? "0") else {fatalError("Cannot unwrap number seen as Int")}
        do {
            try realm!.write {
                let newSubtype = AnimalSubtype()
                newSubtype.name = subtypeNameTextField.text
                newSubtype.totalSeen = seen
                animal?.subtypes.append(newSubtype)
            }
        }
        catch {
            print("Error saving new animal and subtype: \(error)")
        }
        subtypeNameTextField.text = ""
        numberSeenTextField.text = ""
        addAppear()
        parentVC?.loadHunt()
        parentVC?.tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
}

