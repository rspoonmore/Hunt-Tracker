//
//  AnimalSubtype.swift
//  Hunt Tracker
//
//  Created by Ryan Spoonmore on 12/14/19.
//  Copyright © 2019 Ryan's Apps. All rights reserved.
//

import Foundation
import RealmSwift

class AnimalSubtype: Object {
    
    @objc dynamic var name: String?
    @objc dynamic var totalSeen: Int = 0
    @objc dynamic var totalShot: Int = 0
    
    let animal = LinkingObjects(fromType: Animal.self, property: "subtypes")
}
