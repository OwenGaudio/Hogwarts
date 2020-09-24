//
//  HouseGuessTableViewCell.swift
//  Hogwarts36
//
//  Created by Maxwell Poffenbarger on 9/17/20.
//

import UIKit

//MARK: - Protocols
protocol HouseGuessTableViewCellDelegate: class {
    func houseButtonTapped(_ sender: HouseGuessTableViewCell)
}

class HouseGuessTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var personGuessLabel: UILabel!
    @IBOutlet weak var houseImageButton: UIButton!
    
    //MARK: - Properties
    var guess: HouseGuess? {
        didSet {
            updateViews()
        }
    }
    
    weak var delegate: HouseGuessTableViewCellDelegate?
    
    //MARK: - Actions
    @IBAction func houseButtonTapped(_ sender: Any) {
        delegate?.houseButtonTapped(self)
    }
    
    //MARK: - Helper Methods
    //Use this method if there is NOT a didSet on line 23
    func update(viewsFor guess: HouseGuess) {
        
        personGuessLabel.text = guess.guessName
        updateButtonFor(guess: guess)
    }
    
    //Use this method if there is a didSet on line 23
    func updateViews() {
        guard let guess = guess else {return}
        
        personGuessLabel.text = guess.guessName
        updateButtonFor(guess: guess)
    }
    
    func updateButtonFor(guess: HouseGuess) {
        if guess.isVisible {
            if let house = guess.house {
                houseImageButton.setImage(UIImage(named: house), for: .normal)
            }
        } else {
            houseImageButton.setImage(#imageLiteral(resourceName: "hogwarts"), for: .normal)
        }
    }
}//End of class
