//
//  TakeOutTableViewController.swift
//  iSCAUSwift
//
//  Created by Alvin on 10/3/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit
import CoreData

let TakeOutTableViewCellIdentifier = "TakeOutTableViewCellIdentifier"
let kTakeOutCellImgLogoTag = 1000
let kTakeOutCellLabTitleTag = 1001
let kTakeOutCellLabStatusTag = 1002
let kTakeOutCellMarginHeight: CGFloat = 20.0

class TakeOutTableViewController: UITableViewController {

    var restaurants: [ Restaurant ]     // TODO: - Change to use NSFetchedResultsController
    var isLoading = false
    
    required init(coder aDecoder: NSCoder) {
        restaurants = Array()
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("refreshData"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl

        self.tableView.registerNib(UINib(nibName: "RestaurantListCell", bundle: nil), forCellReuseIdentifier: "RestaurantListCellIdentifier")
        self.restaurants = Restaurant.savedRestaurants()
        tableView.reloadData()
        
        refreshData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return restaurants[indexPath.row].titleHeight + kTakeOutCellMarginHeight
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RestaurantListCellIdentifier", forIndexPath: indexPath) as RestaurantListCell
        let restaurant = restaurants[indexPath.row]
        cell.setup(restaurant)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("PushTakeOutMenuViewController", sender: tableView.cellForRowAtIndexPath(indexPath))
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if let menuVC = segue.destinationViewController as? TakeOutMenuViewController {
            if let cell = sender as? UITableViewCell {
                if let indexPath = tableView.indexPathForCell(cell) {
                    let r = restaurants[indexPath.row]
                    menuVC.restaurant = r
                    menuVC.food = Food.foodWithRestaurantID(r.rid)
                }
            }
        }
    }
    
    // MARK: - Handle data
        
    func refreshData() {
        if isLoading {
            return
        }
        
        isLoading = true
        TakeOutHttpManager.restaurantList { (request, response, data, error) -> Void in
            if response?.statusCode == kResponseStatusCodeSuccess && error == nil {
                    var error: NSError?
                    if let d = data as? NSData {
                        if let shopInfo = NSJSONSerialization.JSONObjectWithData(d, options: NSJSONReadingOptions.AllowFragments, error: &error) as? [String : [[String : String]]] {
                            
                            // Update data in CoreData
                            Restaurant.updateRestaurants(shopInfo["shop"]!)
                            
                            // Refresh
                            self.restaurants.removeAll(keepCapacity: false)
                            self.restaurants = Restaurant.savedRestaurants()
                            
                            // Menu
                            Food.updateFood(shopInfo["menu"]!)
                            
                            Utils.takeOutLastUpdateTimeStamp = NSString(format: "%.0lf", NSDate().timeIntervalSince1970)
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                self.refreshControl?.endRefreshing()
                                self.tableView.reloadData()
                            })
                            self.isLoading = false
                        }
                    }
                return
            }
            
            self.isLoading = false
            self.refreshControl?.endRefreshing()
            Utils.takeOutLastUpdateTimeStamp = "0"
            Utils.showNotice("网络错误", inView: self.view)
        }
    }

}
