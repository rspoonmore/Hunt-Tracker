//
//  Hunt.swift
//  Hunt Tracker
//
//  Created by Ryan Spoonmore on 12/14/19.
//  Copyright © 2019 Ryan's Apps. All rights reserved.
//

import Foundation
import RealmSwift

class Hunt: Object {
    
    @objc dynamic var hunter: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var blindNumber: Int = 2
    @objc dynamic var weather: String = ""
    @objc dynamic var notes: String = ""
    @objc dynamic var season: String = ""
    @objc dynamic var defaultHunt: Bool = false
    
    @objc dynamic var dateString: String? {
        let stringDF = DateFormatter()
        stringDF.timeStyle = .short
        stringDF.dateStyle = .medium
        
        return stringDF.string(from: self.date)
    }
    
    dynamic var animalsSeen: Int? {
        var seen: Int = 0
        for animal in animals {
            for subtype in animal.subtypes {
                seen += subtype.totalSeen
            }
        }
        return seen
    }
    
    dynamic var animalsShot: Int? {
        var shot: Int = 0
        for animal in animals {
            for subtype in animal.subtypes {
                shot += subtype.totalShot
            }
        }
        return shot
    }
    
    let animals = List<Animal>()
    let feeders = List<Feeder>()
    
    required convenience init(on date: Date) {
        self.init()
        self.date = date
        self.blindNumber = 2
        self.updateSeason()
    }
    
    func updateSeason() {
        let monthNumDF = DateFormatter()
        let yearNumDF = DateFormatter()
        
        monthNumDF.dateFormat = "MM"
        yearNumDF.dateFormat = "yyyy"
        let huntMonth: Int = Int(monthNumDF.string(from: self.date))!
        var huntYear: Int = Int(yearNumDF.string(from: self.date))!
        
        if huntMonth <= 6 {
            huntYear -= 1
        }
        
        self.season = "\(huntYear) - \(huntYear + 1) Season"
    }
}
