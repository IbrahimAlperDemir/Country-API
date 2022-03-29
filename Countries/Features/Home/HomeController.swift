//
//  DetailViewController.swift
//  Countries
//
//  Created by Alper Demir on 26.03.2022.
//

import UIKit

class HomeController: UIViewController {
    
    // MARK: - Variables
    
    private var countryList: [CountryCell.ViewModel] = []
    private var likedCountries: [Country] = []
    private let dataSource = CountryListDataSource()
    private let countryRepository = CountryRepository()
    
    // MARK: - Views
    
    @IBOutlet private weak var tableview: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.register(UINib(nibName: "CountryCell", bundle: nil), forCellReuseIdentifier: "CountryCell")
        tableview.delegate = dataSource
        tableview.dataSource = dataSource
        
        title = "Countries"
        getCountries()
        bindLikedHandler()
        bindSelectionHandler()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLikedCountries()
    }
    
    // MARK: - Methods
    
    func bindLikedHandler() {
        dataSource.countryLikedHandler = { [weak self] countryViewModel in
            let liked = countryViewModel.isLiked
            if liked {
                self?.countryRepository.addLikedCountry(
                    country: countryViewModel.asCountry()
                )
            } else {
                guard let wikiDataId = countryViewModel.wikiDataId else { return }
                self?.countryRepository.dislikeCountry(with: wikiDataId)
            }
        }
    }
    
    func bindSelectionHandler() {
        dataSource.countrySelectionHandler = { [weak self] countryViewModel in
            let wikiId = countryViewModel.wikiDataId
            guard let detailViewController = self?.storyboard?.instantiateViewController(identifier: "DetailController", creator: { coder in
                DetailController(wikiDataId: wikiId, coder: coder)
            }) else { return }
            self?.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    func mapLikedCountries() {
        likedCountries = countryRepository.getLikedCountries()
        let likedWikiIds = likedCountries.map { $0.wikiDataId }
        countryList.forEach { countryViewModel in
            countryViewModel.isLiked = likedWikiIds.contains(countryViewModel.wikiDataId)
        }
    }
    
    func setupLikedCountries() {
        mapLikedCountries()
        dataSource.setCountryList(countryList)
        DispatchQueue.main.async {
            self.tableview.reloadData()
        }
    }
    
    func getCountries() {
        countryRepository.getAllCountries { [weak self] countryList in
            guard let self = self else { return }
            self.countryList = countryList
            self.setupLikedCountries()
        }
        
    }
}
