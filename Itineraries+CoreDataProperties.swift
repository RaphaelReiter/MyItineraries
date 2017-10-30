//
//  Itineraries+CoreDataProperties.swift
//  ItinerariesCodeChallenge
//
//  Created by Raphaël Reiter on 26/06/2017.
//  Copyright © 2017 Raphaël Reiter. All rights reserved.
//

import Foundation
import CoreData


extension Itineraries {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Itineraries> {
        return NSFetchRequest<Itineraries>(entityName: "Itineraries")
    }

    @NSManaged public var destinationAddress: String?
    @NSManaged public var distanceFromStartToDestination: String?
    @NSManaged public var itineraryCreated: NSDate?
    @NSManaged public var itineraryTitle: String?
    @NSManaged public var startAddress: String?
    @NSManaged public var created: NSDate?

}
