//
//  Animal.swift
//  Hunt Tracker
//
//  Created by Ryan Spoonmore on 12/14/19.
//  Copyright © 2019 Ryan's Apps. All rights reserved.
//

import Foundation
import RealmSwift

class Animal: Object {
    
    @objc dynamic var name: String? = ""
    dynamic var totalSeen: Int? {
        var seen: Int = 0
        for subtype in subtypes {
            seen += subtype.totalSeen
        }
        return seen
    }
    
    dynamic var totalShot: Int? {
        var shot: Int = 0
        for subtype in subtypes {
            shot += subtype.totalShot
        }
        return shot
    }
    
    let hunt = LinkingObjects(fromType: Hunt.self, property: "animals")
    let subtypes = List<AnimalSubtype>()
}
