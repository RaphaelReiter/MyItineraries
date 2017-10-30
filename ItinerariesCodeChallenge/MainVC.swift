//
//  ViewController.swift
//  ItinerariesCodeChallenge
//
//  Created by Raphaël Reiter on 26/06/2017.
//  Copyright © 2017 Raphaël Reiter. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    
    // outlets, Buttons & properties:
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
   var controller: NSFetchedResultsController<Itineraries>!
    
    
    @IBAction func segmentChange(_ sender: Any) {
        
        attemptFetch()
        tableView.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        attemptFetch()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        attemptFetch()
        tableView.reloadData()
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CellContent
        
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        
        return cell
        
        
    }
    
    func configureCell(cell: CellContent, indexPath: NSIndexPath) {
        let itinerary = controller.object(at: indexPath as IndexPath)
        cell.configureCell(itineraries: itinerary)
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = controller.fetchedObjects, objs.count > 0 {
            let itinerary = objs[indexPath.row]
            performSegue(withIdentifier: "toDetailsVC", sender: itinerary)
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetailsVC" {
            if let destination = segue.destination as? DetailVC {
                if let itinerary = sender as? Itineraries {
                    destination.itineraryToEdit = itinerary
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects

        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = controller.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func attemptFetch() {
        
        let fetchRequest: NSFetchRequest<Itineraries> = Itineraries.fetchRequest()
        
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let titleSort = NSSortDescriptor(key: "itineraryTitle", ascending: true)
        
        if segment.selectedSegmentIndex == 0 {
            
            
            fetchRequest.sortDescriptors = [dateSort]
        
        } else if segment.selectedSegmentIndex == 1 {
            fetchRequest.sortDescriptors = [titleSort]
        }
        
        
        
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        self.controller = controller
        
        do {
            
            try controller.performFetch()
        
        } catch {
            
            let error = error as NSError
            print("\(error)")
        }
        
        
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
            
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
            
        case.update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! CellContent
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
            
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        }
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
}

















