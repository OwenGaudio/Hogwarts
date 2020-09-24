//
//  HouseGuessController.swift
//  Hogwarts36
//
//  Created by Maxwell Poffenbarger on 9/17/20.
//

import Foundation
import CoreData

class HouseGuessController {
    
    //MARK: - Properties
    static let sharedIntance = HouseGuessController()
    
    let fetchedResultsController: NSFetchedResultsController<HouseGuess> = {
        
        let fetchRequest: NSFetchRequest<HouseGuess> = HouseGuess.fetchRequest()
        let veiledSort = NSSortDescriptor(key: "isVisible", ascending: false)
        
        fetchRequest.sortDescriptors = [veiledSort]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "isVisible", cacheName: nil)
    }()
    
    init() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        }
    }
    
    //MARK: - CRUD Functions
    func createGuess(guessName: String, house: String) {
        _ = HouseGuess(guessName: guessName, house: house)
        
        saveToPersistentStore()
    }
    
    func updateVisibility(houseGuess: HouseGuess) {
        houseGuess.isVisible = !houseGuess.isVisible
        
        saveToPersistentStore()
    }
    
    func remove(houseGuess: HouseGuess) {
        let moc = CoreDataStack.context
        moc.delete(houseGuess)
        
        saveToPersistentStore()
    }
    
    //MARK: - Persistence
    func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        }
    }
}//End of class
