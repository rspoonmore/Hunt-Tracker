//
//  CounterTableViewCell.swift
//  Hunt Tracker
//
//  Created by Ryan Spoonmore on 12/15/19.
//  Copyright © 2019 Ryan's Apps. All rights reserved.
//

import UIKit

class CounterTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    var delegate: CounterCellDelegate?
    var stepperTintColor: UIColor?
    var type: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stepper.tintColor = stepperTintColor
        stepper.setIncrementImage(stepper.incrementImage(for: .normal), for: .normal)
        stepper.setDecrementImage(stepper.decrementImage(for: .normal), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func countChanged(_ sender: UIStepper) {
        if delegate != nil {
            delegate?.countChanged(sender: self)
        }
    }
    
    func resetColors() {
        stepper.tintColor = stepperTintColor
        stepper.setIncrementImage(stepper.incrementImage(for: .normal), for: .normal)
        stepper.setDecrementImage(stepper.decrementImage(for: .normal), for: .normal)
    }
    
}
