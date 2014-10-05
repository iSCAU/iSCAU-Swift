//
//  FoodOrderTableViewCell.swift
//  iSCAUSwift
//
//  Created by Alvin on 10/4/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit

class FoodOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var labFoodName: UILabel!
    @IBOutlet weak var labCount: UILabel!
    @IBOutlet weak var labPrice: UILabel!
    @IBOutlet weak var imgSep: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(food: Food) {
        labFoodName.text = food.food_name
        labFoodName.width = ScreenWidth - 150
        labFoodName.height = FoodOrderTableViewCell.heightForCell(food.food_name) - 20
        
        labCount.text = "共 \(food.count) 份"
        
        labPrice.text = "¥ \((food.food_price as NSString).floatValue * Float(food.count))"
        
        imgSep.top = labFoodName.height + 19.0
        imgSep.width = ScreenWidth - 15
    }
    
    class func heightForCell(foodName: String) -> CGFloat {
        let name: NSString = foodName
        return name.boundingRectWithSize(CGSizeMake(ScreenWidth - 150, CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(15)], context: nil).size.height + 20
    }
    
}
