//
//  LabeledEntryTableViewCell.swift
//  Hunt Tracker
//
//  Created by Ryan Spoonmore on 12/14/19.
//  Copyright © 2019 Ryan's Apps. All rights reserved.
//

import UIKit

class LabeledEntryTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
     
    var delegate: LabeledEntryCellDelegate?
    var type: String = ""

     override func awakeFromNib() {
        super.awakeFromNib()
        addNumberToolBar()
     }

     override func setSelected(_ selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)
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
        textField.inputAccessoryView = numToolBar
    }
    
    @objc func dismissKeyboard() {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
     
     @IBAction func textEntered(_ sender: UITextField) {
         if delegate != nil {
             delegate?.textEntered(sender: self)
            if textField.isFirstResponder {
                textField.resignFirstResponder()
            }
         }
     }
    
}
