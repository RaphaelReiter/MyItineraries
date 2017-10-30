//
//  CellContent.swift
//  ItinerariesCodeChallenge
//
//  Created by Raphaël Reiter on 26/06/2017.
//  Copyright © 2017 Raphaël Reiter. All rights reserved.
//

import UIKit

class CellContent: UITableViewCell {

    @IBOutlet weak var itineraryTitle: UILabel!
    @IBOutlet weak var startAddressLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var destinationAddressLbl: UILabel!
    
    
    func configureCell(itineraries: Itineraries) {
        itineraryTitle.text = itineraries.itineraryTitle
        startAddressLbl.text = itineraries.startAddress
        distanceLbl.text = itineraries.distanceFromStartToDestination
        destinationAddressLbl.text = itineraries.destinationAddress
    }
    
    
    
    
    
    
}
