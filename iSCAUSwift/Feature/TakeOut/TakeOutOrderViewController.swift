//
//  TakeOutOrderViewController.swift
//  iSCAUSwift
//
//  Created by Alvin on 10/4/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit
import MessageUI

class TakeOutOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate, UIAlertViewDelegate {

    var food: [Food] = []
    var restaurant: Restaurant?
    
    @IBOutlet weak var btnOrder: UIButton!
    @IBOutlet weak var tableOrderInfo: UITableView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableOrderInfo.registerNib(UINib(nibName: "RestaurantTableViewCell", bundle: nil), forCellReuseIdentifier: "RestaurantTableViewCellIdentifier")
        tableOrderInfo.registerNib(UINib(nibName: "AddressTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressTableViewCellIdentifier")
        tableOrderInfo.registerNib(UINib(nibName: "FoodOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "FoodOrderTableViewCellIdentifier")
        
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
        case 0, 2:      // Seperator
            return 20.0
        case 1:         // Address
            return AddressTableViewCell.cellHeight
        case 3:         // Restaurant
            return restaurant!.titleHeight + 20
        default:        // Food or nil
            if indexPath.row - 4 < food.count {
                let theFood = food[indexPath.row - 4]
                return FoodOrderTableViewCell.heightForCell(theFood.foodName)
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
                cell.selectionStyle = .None

                if indexPath.row - 4 == food.count - 1 {
                    cell.imgSep.left = 0
                    cell.imgSep.width = ScreenWidth
                } else {
                    cell.imgSep.left = 15
                    cell.imgSep.width = ScreenWidth - 15
                }
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
    
    // MARK: - Order

    @IBAction func order(sender: AnyObject) {
        if !MFMessageComposeViewController.canSendText() {
            let alert = UIAlertView(title: "错误", message: "当前设备不支持发送短信", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        
        if let address = Utils.dormitoryAddress {
            if let r = restaurant {
                var content = "[华农宝]\n"
                for f in food {
                    content += "\(f.foodName) \(f.count)份\n"
                }
                content += address

                // Change color temporary
                UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
                UINavigationBar.appearance().tintColor = UIColor.blackColor()
                UINavigationBar.appearance().titleTextAttributes = [ NSForegroundColorAttributeName : UIColor.blackColor() ]
                
                let messageController = MFMessageComposeViewController()
                messageController.messageComposeDelegate = self
                messageController.recipients = [ r.phone ]
                messageController.body = content
                presentViewController(messageController, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertView(title: "提示", message: "你还没设置送餐地址", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
        }
    }
    
    private func totalPrice() -> String {
        var price:Float = 0.0
        for f in food {
            var c = Float(f.count) * (f.foodPrice as NSString).floatValue
            price = price + c
        }
        return "\(price)"
    }
    
    // MARK: - Message
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        if result.value == MessageComposeResultFailed.value {
            let alert = UIAlertView(title: "错误", message: "发送短信失败", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
        }

        UINavigationBar.appearance().barTintColor = AppTintColor
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [ NSForegroundColorAttributeName : UIColor.whiteColor() ]
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
