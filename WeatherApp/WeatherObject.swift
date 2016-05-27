//
//  WeatherObject.swift
//  WeatherApp
//
//  Created by Brandon Shega on 5/26/16.
//  Copyright © 2016 Brandon Shega. All rights reserved.
//

import Foundation

let DateKey = "dt"
let HumidityKey = "humidity"
let TempKey = "temp"
let MinTempKey = "min"
let MaxTempKey = "max"
let WeatherKey = "weather"
let DescriptionKey = "description"
let IconKey = "icon"

struct WeatherObject {
    
    var date: NSDate
    var humidity: Int
    var minTemp: Double
    var maxTemp: Double
    var description: String
    var icon: String
    
    init(dictionary: [String:AnyObject]) {
        
        let tempDictionary = dictionary[TempKey] as? [String:AnyObject] ?? [:]
        let weatherDictionary = dictionary[WeatherKey] as? [[String:AnyObject]] ?? [[:]]
        
        let timestamp = dictionary[DateKey] as? Double ?? 0
        date = NSDate(timeIntervalSince1970: timestamp)
        humidity = dictionary[HumidityKey] as? Int ?? 0
        minTemp = tempDictionary[MinTempKey] as? Double ?? 0
        maxTemp = tempDictionary[MaxTempKey] as? Double ?? 0
        description = weatherDictionary.first?[DescriptionKey] as? String ?? ""
        let iconCode = weatherDictionary.first?[IconKey] as? String ?? ""
        icon = "http://openweathermap.org/img/w/\(iconCode).png"
        
    }
    
}
