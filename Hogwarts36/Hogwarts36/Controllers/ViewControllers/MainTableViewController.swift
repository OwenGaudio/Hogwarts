//
//  MainTableViewController.swift
//  Hogwarts36
//
//  Created by Maxwell Poffenbarger on 9/17/20.
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController {

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HouseGuessController.sharedIntance.fetchedResultsController.delegate = self
    }
    
    //MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        presentAlertController()
    }
    
    //MARK: - Helper Methods
    func presentAlertController() {
        let alertController = UIAlertController(title: "Add Guess", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Person name..."
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Hogwart's house..."
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let addGuessAction = UIAlertAction(title: "Add", style: .default) { (_) in
            
            guard let guessName = alertController.textFields?[0].text, !guessName.isEmpty,
                  
                  let house = alertController.textFields?[1].text, !house.isEmpty else {return}
            
            HouseGuessController.sharedIntance.createGuess(guessName: guessName, house: house)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addGuessAction)
        
        present(alertController, animated: true)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return HouseGuessController.sharedIntance.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HouseGuessController.sharedIntance.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "guessCell", for: indexPath) as? HouseGuessTableViewCell else {return UITableViewCell()}

        let guess = HouseGuessController.sharedIntance.fetchedResultsController.object(at: indexPath)
        
        //Use this method if there is NOT a didSet on line 23 of the customCell
        //cell.update(viewsFor: guess)
        
        //Use this method is there is a didSet on line 23 of the customCell
        cell.guess = guess
        
        cell.delegate = self

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let guessToDelete = HouseGuessController.sharedIntance.fetchedResultsController.object(at: indexPath)
            HouseGuessController.sharedIntance.remove(houseGuess: guessToDelete)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 7
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return HouseGuessController.sharedIntance.fetchedResultsController.sectionIndexTitles[section] == "0" ? "Invisibility Cloak Active" : "Exposed"
    }
}//End of class

//MARK: - Extensions
extension MainTableViewController: HouseGuessTableViewCellDelegate {
    
    func houseButtonTapped(_ sender: HouseGuessTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else {return}
        let guess = HouseGuessController.sharedIntance.fetchedResultsController.object(at: indexPath)
        HouseGuessController.sharedIntance.updateVisibility(houseGuess: guess)
        sender.updateViews()
    }
}//End of extension

extension MainTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            let indexSet = IndexSet(integer: sectionIndex)
            tableView.insertSections(indexSet, with: .automatic)
            
        case .delete:
            let indexSet = IndexSet(integer: sectionIndex)
            tableView.deleteSections(indexSet, with: .automatic)
            
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else {return}
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}//End of extension
