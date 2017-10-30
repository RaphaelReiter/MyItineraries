//
//  Itineraries+CoreDataClass.swift
//  ItinerariesCodeChallenge
//
//  Created by Raphaël Reiter on 26/06/2017.
//  Copyright © 2017 Raphaël Reiter. All rights reserved.
//

import Foundation
import CoreData

@objc(Itineraries)
public class Itineraries: NSManagedObject {

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.created = NSDate()
    }
}
