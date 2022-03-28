//
//  DetailViewController.swift
//  Countries
//
//  Created by Alper Demir on 26.03.2022.
//

import UIKit

class HomeController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var countryList: [CountryCell.ViewModel] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if countryList.isEmpty {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "CountryCell",
            for: indexPath
        ) as! CountryCell
        let countryViewModel = countryList[indexPath.row]
        countryViewModel.onFavoriteTapped = { [weak self] liked in
            // TODO: - Data katmanına liked bilgisini haber verelim
            countryViewModel.isLiked = !liked
            cell.configure(with: countryViewModel)
        }
        cell.configure(with: countryViewModel)
        return cell
    }
    
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.register(UINib(nibName: "CountryCell", bundle: nil), forCellReuseIdentifier: "CountryCell")
        tableview.delegate = self
        tableview.dataSource = self
        
        title = "Countries"
        getCountry()

    }
    
    func getCountry() {
        
        let headers = [
            "X-RapidAPI-Host": "wft-geo-db.p.rapidapi.com",
            "X-RapidAPI-Key": "41206fc1famsh81365812bc793e4p1e5f08jsn518e24dfcd66"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://wft-geo-db.p.rapidapi.com/v1/geo/countries?limit=10")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let apiResponse = try? JSONDecoder().decode(CountryListResponse.self, from: data!)
                self.countryList = apiResponse?.data?.map { $0.toViewModel() } ?? []
                // TODO: - Data katmanından isLiked bilgisini alalım filtreleyelim
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
                
            
            }
        })

        dataTask.resume()
    }
                              

}
