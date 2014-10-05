//
//  RestaurantTableViewCell.swift
//  iSCAUSwift
//
//  Created by Alvin on 10/4/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var labTitle: UILabel!
    @IBOutlet weak var labTotalPrice: UILabel!
    @IBOutlet weak var imgTopSep: UIImageView!
    @IBOutlet weak var imgBottomSep: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(restaurant: Restaurant, totalPrice: String) {
        labTitle.text = restaurant.shop_name
        labTitle.width = ScreenWidth - 150
        labTitle.height = restaurant.titleHeight
        
        labTotalPrice.text = "¥ \(totalPrice)"
        
        imgTopSep.width = ScreenWidth
        
        imgBottomSep.top = restaurant.titleHeight + 19
        imgBottomSep.width = ScreenWidth
    }
}
