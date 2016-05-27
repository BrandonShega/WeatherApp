//
//  WeatherAppTableViewCell.swift
//  WeatherApp
//
//  Created by Brandon Shega on 5/26/16.
//  Copyright © 2016 Brandon Shega. All rights reserved.
//

import UIKit

class WeatherAppTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MARK: - Functions
    func configureCellWithData(object: WeatherObject) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM d, YYYY"
        let dateString = dateFormatter.stringFromDate(object.date)
        
        let tempString = "Temps: \r\nMin: \(object.minTemp)\r\nMax: \(object.maxTemp)"
        let descriptionString = "Description: \r\n\(object.description)"
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { 
            guard
                let iconUrl = NSURL(string: object.icon),
                let iconData = NSData(contentsOfURL: iconUrl),
                let iconImage = UIImage(data: iconData) else { return }
            dispatch_async(dispatch_get_main_queue(), { 
                self.iconImageView.image = iconImage
            })
        }
        
        dateLabel.text = dateString
        tempLabel.text = tempString
        descriptionLabel.text = descriptionString
        
    }
    
}