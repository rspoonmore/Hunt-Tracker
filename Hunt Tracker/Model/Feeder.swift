//
//  Feeder.swift
//  Hunt Tracker
//
//  Created by Ryan Spoonmore on 12/14/19.
//  Copyright © 2019 Ryan's Apps. All rights reserved.
//

import Foundation
import RealmSwift

class Feeder: Object {
    
    @objc dynamic var number: Int = 1
    @objc dynamic var wentOff: Bool = false
    
    let hunt = LinkingObjects(fromType: Hunt.self, property: "feeders")
    
    required convenience init(number: Int) {
        self.init()
        self.number = number
    }
}
