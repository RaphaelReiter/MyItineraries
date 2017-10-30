//
//  DetailVC.swift
//  ItinerariesCodeChallenge
//
//  Created by Raphaël Reiter on 26/06/2017.
//  Copyright © 2017 Raphaël Reiter. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation


class DetailVC: UIViewController, UINavigationControllerDelegate, CLLocationManagerDelegate, UITextFieldDelegate {

    
    
    @IBOutlet weak var itineraryTitleTF: UITextField!
    
    
    // Text Field Outlets - Start address:

    @IBOutlet weak var startAddressNumber: UITextField!
    @IBOutlet weak var startAddressStreet: UITextField!
    @IBOutlet weak var startAddressCity: UITextField!
    @IBOutlet weak var startAddressZip: UITextField!
    
      // Text Field Outlets - Destination address:
    
    
    @IBOutlet weak var destinationAddressNumber: UITextField!
    @IBOutlet weak var destinationAddressStreet: UITextField!
    @IBOutlet weak var destinationAddressCity: UITextField!
    @IBOutlet weak var destinationAddressZip: UITextField!
    
    
    
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        self.startAddressNumber.resignFirstResponder()
//        self.startAddressStreet.resignFirstResponder()
//        self.startAddressCity.resignFirstResponder()
//        self.startAddressZip.resignFirstResponder()
//
//        self.destinationAddressNumber.resignFirstResponder()
//        self.destinationAddressStreet.resignFirstResponder()
//        self.destinationAddressCity.resignFirstResponder()
//        self.destinationAddressZip.resignFirstResponder()
//
//
//        return true
//    }
    
    // Labels
    
    @IBOutlet weak var startAddressLbl: UILabel!
    @IBOutlet weak var destinationAddressLbl: UILabel!
    
    @IBOutlet weak var distanceCalculatedLabel: UILabel!
    
    // Properties
    var startAddressLblPopulated: String?
    var destinationAddressLblPopulated: String?
    
    var startlatitude: CLLocationDegrees?
    var startLongitude: CLLocationDegrees?
    var startCoordinates: CLLocation?
    
    var destinationLatitude: CLLocationDegrees?
    var destinationLongitude: CLLocationDegrees?
    var destinationCoordinates: CLLocation?
    
    var itineraryToEdit: Itineraries?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        loadItineraryData()
        
        
        self.startAddressNumber.delegate = self
        self.startAddressStreet.delegate = self
        self.startAddressCity.delegate = self
        self.startAddressZip.delegate = self
        
        self.destinationAddressNumber.delegate = self
        self.destinationAddressStreet.delegate = self
        self.destinationAddressCity.delegate = self
        self.destinationAddressZip.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadItineraryData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // BUTTONS
    
    @IBAction func calculateDistanceTapped(_ sender: UIButton) {
        
        if startAddressNumber.text != nil {
            if startAddressStreet.text != nil {
                if startAddressCity.text != nil {
                    if startAddressZip.text != nil {
                        startAddressLblPopulated = startAddressNumber.text! + " " + startAddressStreet.text! + ", " +  startAddressCity.text! + ", " +  startAddressZip.text!
                       
                        // change this doomed pyramid to guard statement !
                    }
                }
            }
        }
        startAddressLbl.text = startAddressLblPopulated
        
        if destinationAddressNumber.text != nil {
            if destinationAddressStreet.text != nil {
                if destinationAddressCity.text != nil {
                    if destinationAddressZip.text != nil {
                        destinationAddressLblPopulated = destinationAddressNumber.text! + " " + destinationAddressStreet.text! + ", " +  destinationAddressCity.text! + ", " +  destinationAddressZip.text!
                        
                    }
                }
            }
        }
        destinationAddressLbl.text = destinationAddressLblPopulated

        
        
        
        if let address = startAddressLblPopulated {
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    print("RAPH: Couldnt find the start location coordinates")
                    return
            }
            
            
            let lat1 = location.coordinate.latitude
            let lon1 = location.coordinate.longitude
            
            self.startLongitude = lat1
            self.startLongitude = lon1
        
            
        if let address2 = self.destinationAddressLblPopulated {
            
            let geoCoder2 = CLGeocoder()
            geoCoder2.geocodeAddressString(address2) { (placemarks, error) in
                guard
                    let placemarks2 = placemarks,
                    let location2 = placemarks2.first?.location
                    else {
                        print("RAPH: Couldnt find the start location coordinates")
                        return
                }
                
                
                let lat2 = location2.coordinate.latitude
                let lon2 = location2.coordinate.longitude
                
                self.destinationLatitude = lat2
                self.destinationLongitude = lon2
            
            
            let coordinate1 = CLLocation(latitude: lat1, longitude: lon1)
            let coordinate2 = CLLocation(latitude: lat2, longitude: lon2)
            
            let distanceInMeters = coordinate1.distance(from: coordinate2)
            
            self.distanceCalculatedLabel.text = "\(Double(round(1000*distanceInMeters / 1000)/1000)) Km"

            
            
                
        }
        }
        }
        }
        
        loadItineraryData()
        
    }
  
    
    @IBAction func getMeTherTapped(_ sender: UIButton) {
        
        UIApplication.shared.open(URL(string: "http://maps.apple.com/maps?daddr=\(self.startLongitude),\(self.startLongitude)")!)

    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        
        var itinerary: Itineraries!
        
        if itineraryToEdit == nil {
            itinerary = Itineraries(context: context)
            
        } else {
            itinerary = itineraryToEdit
        }
        
        if let startAddress = startAddressLbl.text {
            itinerary.startAddress = startAddress
        }
        
        if let destinationAddress = destinationAddressLbl.text {
            itinerary.destinationAddress = destinationAddress
        }
        
        if let itineraryTitle = itineraryTitleTF.text {
            itinerary.itineraryTitle = itineraryTitle
        }
        
        if let distance = distanceCalculatedLabel.text {
            itinerary.distanceFromStartToDestination = distance
        }
        ad.saveContext()
        
        _ = navigationController?.popViewController(animated: true)
        
    }
   
    @IBAction func deleteBtnPressed(_ sender: UIBarButtonItem) {
        
        if itineraryToEdit != nil {
            context.delete(itineraryToEdit!)
            ad.saveContext()
        }
        _ = navigationController?.popViewController(animated: true)
    }

    
    func loadItineraryData() {
        
        if let itinerary = itineraryToEdit {
            
            itineraryTitleTF.text = itinerary.itineraryTitle
            startAddressLblPopulated = itinerary.startAddress
            destinationAddressLblPopulated = itinerary.destinationAddress
            distanceCalculatedLabel.text = itinerary.distanceFromStartToDestination
            
        }
    }
    
  
    
    
    }
