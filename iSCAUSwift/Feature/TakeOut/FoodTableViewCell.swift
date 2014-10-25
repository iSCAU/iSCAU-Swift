//
//  FoodTableViewCell.swift
//  iSCAUSwift
//
//  Created by Alvin on 10/3/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit

class FoodTableViewCell: UITableViewCell {

    var food: Food?
    
    @IBOutlet weak var labFoodName: UILabel!
    @IBOutlet weak var labPrice: UILabel!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var labCount: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    
    override func awakeFromNib() {
        btnMinus.layer.borderWidth = 1
        btnMinus.layer.cornerRadius = 3
        btnMinus.layer.borderColor = AppTintColor.CGColor
        btnMinus.setTitleColor(AppTintColor, forState: .Normal)
        btnMinus.hidden = true
        
        btnAdd.layer.borderWidth = 1
        btnAdd.layer.cornerRadius = 3
        btnAdd.setTitleColor(AppTintColor, forState: .Normal)
        btnAdd.layer.borderColor = AppTintColor.CGColor
        
        labCount.backgroundColor = AppTintColor
        labCount.textColor = UIColor.whiteColor()
        labCount.layer.cornerRadius = 3
        labCount.layer.masksToBounds = true
        labCount.hidden = true
    }
    
    func setup(food: Food) {
        self.food = food
        labFoodName.text = food.foodName
        labPrice.text = "¥ \(food.foodPrice)"
        labCount.text = "\(food.count)"
        
        labCount.hidden = (food.count == 0)
        btnMinus.hidden = (food.count == 0)
    }
    
    @IBAction func addOne(sender: AnyObject) {
        labCount.text = "\(++food!.count)"
        btnMinus.hidden = false
        labCount.hidden = false
    }

    @IBAction func minusOne(sender: AnyObject) {
        if food!.count > 1 {
            labCount.text = "\(--food!.count)"
        } else {
            food!.count = 0
            labCount.hidden = true
            btnMinus.hidden = true
        }
    }

}
