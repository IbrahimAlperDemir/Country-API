//
//  SavedController.swift
//  Countries
//
//  Created by Alper Demir on 26.03.2022.
//

import Foundation

import UIKit

class SavedController: UIViewController {
    
    // MARK: - Variables
    
    private let dataSource = CountryListDataSource()
    private let countryRepository = CountryRepository()
    private var countryList: [CountryCell.ViewModel] = []
    
    // MARK: - Views
    
    @IBOutlet private weak var tableview: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Saved Countries"
        setupTableView()
        bindLikedHandler()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareCountries()
    }
    
    // MARK: - Methods
    
    private func bindLikedHandler() {
        dataSource.countryLikedHandler = { [weak self] countryViewModel in
            guard let wikiDataId = countryViewModel.wikiDataId else { return }
            self?.countryRepository.dislikeCountry(with: wikiDataId)
            self?.prepareCountries()
        }
    }
    
    private func prepareCountries() {
        countryList = countryRepository.getLikedCountries().map {
            let viewModel = $0.toViewModel()
            viewModel.isLiked = true
            return viewModel
        }
        dataSource.setCountryList(countryList)
        tableview.reloadData()
    }
    
    private func setupTableView() {
        tableview.register(UINib(nibName: "CountryCell", bundle: nil), forCellReuseIdentifier: "CountryCell")
        tableview.delegate = dataSource
        tableview.dataSource = dataSource
    }
    
    
}


