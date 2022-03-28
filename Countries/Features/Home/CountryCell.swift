//
//  CountryCell.swift
//  Countries
//
//  Created by Alper Demir on 26.03.2022.
//

import UIKit

class CountryCell: UITableViewCell {

    // MARK: - Views
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var savedButton: UIButton!
    
    // MARK: - ViewModel
    
    final class ViewModel {
        var name: String?
        var wikiDataId: String?
        var isLiked: Bool = false
        var onFavoriteTapped: ((Bool) -> Void)?
    }
    
    // MARK: - Variables
    
    private lazy var viewModel = ViewModel()
    
    // MARK: - Methods
    
    func configure(with viewModel: ViewModel) {
        self.viewModel = viewModel
        nameLabel.text = viewModel.name
        let buttonImage = viewModel.isLiked ?
            UIImage(systemName: "star.fill") :
            UIImage(systemName: "star")
        savedButton.setImage(buttonImage, for: .normal)
    }
    
    // MARK: - Actions
    
    @IBAction func onSavedButton(_ sender: UIButton) {
        viewModel.onFavoriteTapped?(viewModel.isLiked)
    }
}
