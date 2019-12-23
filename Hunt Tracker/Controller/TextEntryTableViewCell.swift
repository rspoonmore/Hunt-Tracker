//
//  TextEntryTableViewCell.swift
//  Hunt Tracker
//
//  Created by Ryan Spoonmore on 12/14/19.
//  Copyright © 2019 Ryan's Apps. All rights reserved.
//

import UIKit

class TextEntryTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    
    var delegate: TextEntryCellDelegate?
    var type: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
            return true
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        textField.placeholder = type
        return true
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
