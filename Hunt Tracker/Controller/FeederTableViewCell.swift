//
//  FeederTableViewCell.swift
//  Hunt Tracker
//
//  Created by Ryan Spoonmore on 12/15/19.
//  Copyright © 2019 Ryan's Apps. All rights reserved.
//

import UIKit

class FeederTableViewCell: UITableViewCell {
    
    var delegate: FeederCellDelegate?
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rightSwitch: UISwitch!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func feederStatusChanged(_ sender: UISwitch) {
        if delegate != nil {
            delegate?.feederStatusChanged(sender: self)
        }
    }
    
    
}
