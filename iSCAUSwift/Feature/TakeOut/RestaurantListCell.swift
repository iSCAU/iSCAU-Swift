//
//  RestaurantListCell.swift
//  iSCAUSwift
//
//  Created by Alvin on 10/19/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit

class RestaurantListCell: UITableViewCell {
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var labTitle: UILabel!
    @IBOutlet weak var labStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imgLogo.layer.borderColor = UIColor(white: 0.1, alpha: 0.2).CGColor
        self.imgLogo.layer.borderWidth = 1.0
    }

    func setup(restaurant: Restaurant) {
        // Logo
        self.imgLogo.centerY = (restaurant.titleHeight + kTakeOutCellMarginHeight) / 2
        self.imgLogo.sd_setImageWithURL(NSURL(string: restaurant.logoURL))
        // Title
        self.labTitle.removeConstraints(labTitle.constraints())
        self.labTitle.height = restaurant.titleHeight
        self.labTitle.text = restaurant.shopName
        
        // Status
        if restaurantIsOpening(restaurant) {
            self.labStatus.text = ""
        } else {
            self.labStatus.text = "休息中"
        }
        self.labStatus.centerY = (restaurant.titleHeight + kTakeOutCellMarginHeight) / 2
    }
    
    private func restaurantIsOpening(restaurant: Restaurant) -> Bool {
        let currentComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit, fromDate: NSDate())
        let startComponents = restaurant.startTime.componentsSeparatedByString(":")
        let endComponents = restaurant.endTime.componentsSeparatedByString(":")
        if startComponents.count == 2 && endComponents.count == 2 {
            let currentInterval = currentComponents.hour * 60 + currentComponents.minute
            let startTimeInterval = startComponents[0].toInt()! * 60 + startComponents[1].toInt()!
            let endTimeInterval = endComponents[0].toInt()! * 60 + endComponents[1].toInt()!
            if startTimeInterval <= currentInterval && currentInterval <= endTimeInterval {
                return true
            }
        }
        return false
    }

}
