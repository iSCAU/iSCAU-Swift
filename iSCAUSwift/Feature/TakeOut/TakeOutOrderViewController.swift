//
//  TakeOutOrderViewController.swift
//  iSCAUSwift
//
//  Created by Alvin on 10/4/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit

class TakeOutOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var food: [Food] = []
    var restaurant: Restaurant?
    
    @IBOutlet weak var btnOrder: UIButton!
    @IBOutlet weak var tableOrderInfo: UITableView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableOrderInfo.registerNib(UINib(nibName: "RestaurantTableViewCell", bundle: nil)!, forCellReuseIdentifier: "RestaurantTableViewCellIdentifier")
        tableOrderInfo.registerNib(UINib(nibName: "AddressTableViewCell", bundle: nil)!, forCellReuseIdentifier: "AddressTableViewCellIdentifier")
        tableOrderInfo.registerNib(UINib(nibName: "FoodOrderTableViewCell", bundle: nil)!, forCellReuseIdentifier: "FoodOrderTableViewCellIdentifier")
        
        NSNotificationCenter.defaultCenter().addObserver(self.tableOrderInfo, selector: Selector("reloadData"), name: kReloadRestaurantTableNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView datasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4 + food.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.row) {
        case 0, 2:
            return 20.0
        case 1:
            return AddressTableViewCell.cellHeight
        case 3:
            return restaurant!.titleHeight + 20
        default:
            if indexPath.row - 4 < food.count {
                let theFood = food[indexPath.row - 4]
                return FoodOrderTableViewCell.heightForCell(theFood.food_name)
            } else {
                return 0
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0, 2:
            let cell = UITableViewCell()
            cell.backgroundColor = UIColor.clearColor()
            cell.selectionStyle = .None
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("AddressTableViewCellIdentifier") as AddressTableViewCell
            cell.setup()
            return cell
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier("RestaurantTableViewCellIdentifier") as RestaurantTableViewCell
            cell.setup(restaurant!, totalPrice: totalPrice())
            cell.selectionStyle = .None
            return cell
        default:
            if indexPath.row - 4 < food.count {
                let cell = tableView.dequeueReusableCellWithIdentifier("FoodOrderTableViewCellIdentifier") as FoodOrderTableViewCell
                cell.setup(food[indexPath.row - 4])
                if indexPath.row - 4 == food.count - 1 {
                    cell.imgSep.left = 0
                    cell.imgSep.width = ScreenWidth
                } else {
                    cell.imgSep.left = 15
                    cell.imgSep.width = ScreenWidth - 15
                }
                cell.selectionStyle = .None
                return cell
            } else {
                return UITableViewCell()
            }
        }
    }
    
    // MARK: - TableView delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1 {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            let addressUpdateView = AddressUpdateView(frame: CGRectZero)
            addressUpdateView.show()
        }
    }
    
    // MARK: - Cell
    
    
    
    // MARK: - Order

    @IBAction func order(sender: AnyObject) {
    }
    
    func totalPrice() -> String {
        var price:Float = 0.0
        for f in food {
            var c = Float(f.count) * (f.food_price as NSString).floatValue
            price = price + c
        }
        return "\(price)"
    }
    
}
