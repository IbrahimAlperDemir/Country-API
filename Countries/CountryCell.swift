//
//  CountryCell.swift
//  Countries
//
//  Created by Alper Demir on 26.03.2022.
//

import UIKit

class CountryCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var savedButton: UIButton!
    
    func configure(with country:Country) {
        
        nameLabel.text = country.name
        
    }
    
    @IBAction func onSavedButton(_ sender: UIButton) {
    }
}
