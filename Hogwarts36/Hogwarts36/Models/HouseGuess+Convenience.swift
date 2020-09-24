//
//  HouseGuess+Convenience.swift
//  Hogwarts36
//
//  Created by Maxwell Poffenbarger on 9/17/20.
//

import Foundation
import CoreData

extension HouseGuess {
    
    convenience init(guessName: String, house: String, isVisible: Bool = false, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.guessName = guessName
        self.house = house
        self.isVisible = isVisible
    }
}//End of extension
