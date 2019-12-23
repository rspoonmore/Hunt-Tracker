//
//  DateEntryTableViewCell.swift
//  Hunt Tracker
//
//  Created by Ryan Spoonmore on 12/14/19.
//  Copyright © 2019 Ryan's Apps. All rights reserved.
//

import UIKit

class DateEntryTableViewCell: UITableViewCell {
    
    var delegate: DatePickerCellDelegate?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        datePicker.minuteInterval = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        if delegate != nil {
            delegate?.dateChanged(sender: self)
        }
    }
    
    
}
