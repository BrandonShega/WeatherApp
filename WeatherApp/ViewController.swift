//
//  ViewController.swift
//  WeatherApp
//
//  Created by Brandon Shega on 5/26/16.
//  Copyright © 2016 Brandon Shega. All rights reserved.
//

import UIKit

let CityKey = "city"
let CoordKey = "coord"
let CountryKey = "country"
let NameKey = "name"
let LonKey = "lon"
let LatKey = "lat"
let ListKey = "list"
let PopulationKey = "population"

class ViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    
    //MARK: - Variables
    private let urlString = "http://api.openweathermap.org/data/2.5/forecast/daily?q=Winter%20Park,FL&mode=json&units=metric&cnt=14&appid=f8fdae74c29544baebdb927d392c5538"
    private var weatherData: [WeatherObject] = []
    private var cityString: String = ""
    private var coordinatesString: String = ""
    private var populationString: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        
        loadWeatherData()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func loadWeatherData() {
        
        let weatherOperation = APIOperation(url: urlString, method: .GET)
        weatherOperation.successCallback = { (data) in
            print(data)
            let cityDictionary = data[CityKey] as? [String:AnyObject] ?? [:]
            let coordDictionary = cityDictionary[CoordKey] as? [String:AnyObject] ?? [:]
            let lat = coordDictionary[LatKey] as? Double ?? 0
            let long = coordDictionary[LonKey] as? Double ?? 0
            let name = cityDictionary[NameKey] as? String ?? ""
            let country = cityDictionary[CountryKey] as? String ?? ""
            let population = cityDictionary[PopulationKey] as? Int ?? 0
            
            let listArray = data[ListKey] as? [[String:AnyObject]] ?? [[:]]
            
            self.cityString = "City: \r\n\(name), \(country)"
            self.coordinatesString = "Coordinates: \r\nLat: \(lat)\r\n Long: \(long)"
            self.populationString = "Population: \(population)"
            
            self.cityLabel.text = self.cityString
            self.coordinatesLabel.text = self.coordinatesString
            self.populationLabel.text = self.populationString
            
            for list in listArray {
                let weatherObject = WeatherObject(dictionary: list)
                self.weatherData.append(weatherObject)
            }
            self.weatherTableView.reloadData()
            
        }
        weatherOperation.failureCallback = { (error) in
            print(error?.localizedDescription)
        }
        weatherOperation.start()
        
    }


}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let weatherCell = tableView.dequeueReusableCellWithIdentifier("WeatherCell", forIndexPath: indexPath) as? WeatherAppTableViewCell else { return UITableViewCell() }
//        print(weatherData[indexPath.row])
        weatherCell.configureCellWithData(weatherData[indexPath.row])
        return weatherCell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
}

