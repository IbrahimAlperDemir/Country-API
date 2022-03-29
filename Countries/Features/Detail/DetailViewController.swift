//
//  DetailViewController.swift
//  Countries
//
//  Created by Alper Demir on 28.03.2022.
//

import Foundation
import UIKit

class DetailController: UIViewController {
    
    @IBOutlet weak var CountryLabel: UILabel!
    
    var wikiDataId: String?
    
    init?(wikiDataId: String?, coder: NSCoder) {
        self.wikiDataId = wikiDataId
        super.init(coder: coder)
    }
    
    init(with wikiDataId: String?) {
        self.wikiDataId = wikiDataId
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.wikiDataId = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllCountryDetails(wikiDataId: wikiDataId ?? "")
    }
    
    @IBAction func moreInfoButton(_ sender: UIButton) {
        guard let wikiId = wikiDataId else { return }
        
        UIApplication.shared.open(URL(string: "https://www.wikidata.org/\(wikiId)")!,  options: [:], completionHandler: nil)
    }
    
    
    func populate(with countryDetail: CountryDetail?) {
        CountryLabel.text = countryDetail?.code
    }
    
    func getAllCountryDetails(wikiDataId:String) {
        let headers = [
          "X-RapidAPI-Host": "wft-geo-db.p.rapidapi.com",
          "X-RapidAPI-Key": "41206fc1famsh81365812bc793e4p1e5f08jsn518e24dfcd66"
        ]
        let request = NSMutableURLRequest(url: NSURL(string: "https://wft-geo-db.p.rapidapi.com/v1/geo/countries/\(wikiDataId)")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 60.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(
          with: request as URLRequest, completionHandler: { [weak self] (data, response, error) -> Void in
          if (error != nil) {
              debugPrint(error)
          } else {
              let apiResponse = try? JSONDecoder().decode(CountryDetailResponse.self, from: data!)
              let countryDetail = apiResponse?.data
              DispatchQueue.main.async {
                  self?.populate(with: countryDetail)
              }
          }
        })
        dataTask.resume()
    }
    
    
}
