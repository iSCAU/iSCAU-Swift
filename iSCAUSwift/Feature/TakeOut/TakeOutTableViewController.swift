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

class TakeOutTableViewController: UITableViewController {

    var restaurants: [ Restaurant ]
    
    required init(coder aDecoder: NSCoder) {
        restaurants = Array()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("refreshData"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
        var error: NSError?
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Restaurant", inManagedObjectContext: CoreDataManager.sharedInstance.managedObjectContext!)
        if let restaurants = CoreDataManager.sharedInstance.managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) {
            for r in restaurants {
                self.restaurants.append(r as Restaurant)
            }
        }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return restaurants[indexPath.row].titleHeight + 20
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TakeOutTableViewCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        let restaurant = restaurants[indexPath.row]

        var frame = CGRectZero
        
        let imgLogo = cell.viewWithTag(kTakeOutCellImgLogoTag)! as UIImageView
        imgLogo.centerY = (restaurant.titleHeight + 20) / 2
        
        let labTitle = cell.viewWithTag(kTakeOutCellLabTitleTag)! as UILabel
        labTitle.height = restaurant.titleHeight
        labTitle.text = restaurant.shop_name
        
        let labStatus = cell.viewWithTag(kTakeOutCellLabStatusTag)! as UILabel
        if restaurantIsOpening(restaurant) {
            labStatus.text = ""
        } else {
            labStatus.text = "休息中"
        }
        labStatus.centerY = (restaurant.titleHeight + 20) / 2

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if let menuVC = segue.destinationViewController as? TakeOutMenuViewController {
            let cell = sender as UITableViewCell

            if let indexPath = tableView.indexPathForCell(cell) {
                let r = restaurants[indexPath.row]
                
                var error: NSError?
                let fetchRequest = NSFetchRequest()
                fetchRequest.entity = NSEntityDescription.entityForName("Food", inManagedObjectContext: CoreDataManager.sharedInstance.managedObjectContext!)
                fetchRequest.predicate = NSPredicate(format: "food_shop_id = %@", r.r_id)
                
                if let foods = CoreDataManager.sharedInstance.managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) {
                    var menu: [Food] = []
                    for f in foods {
                        menu.append(f as Food)
                    }
                    menuVC.restaurant = r
                    menuVC.food = menu
                }
            }
        }
    }
    
    // MARK: - Data
    private func restaurantIsOpening(restaurant: Restaurant) -> Bool {
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit, fromDate: NSDate())
        
        return false
    }
    
    func refreshData() {
        TakeOutHttpManager.restaurantList { (request, response, data, error) -> Void in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                var error: NSError?
                if let d = data as? NSData {
                    if let shopInfo = NSJSONSerialization.JSONObjectWithData(d, options: NSJSONReadingOptions.AllowFragments, error: &error) as? [String : [[String : String]]] {
                        
                        let fetchRequest = NSFetchRequest()
                        
                        // Shop
                        let shops = shopInfo["shop"]!
                        for shopDict in shops {
                            if let status = shopDict["status"] {
                                if status == "1" {
                                    Restaurant.converFromDict(shopDict)
                                } else {
                                    Restaurant.deleteRestaurant(shopDict)
                                }
                            }
                        }
                        CoreDataManager.sharedInstance.saveContext()
                        
                        self.restaurants.removeAll(keepCapacity: true)
                        fetchRequest.entity = NSEntityDescription.entityForName("Restaurant", inManagedObjectContext: CoreDataManager.sharedInstance.managedObjectContext!)
                        if let restaurants = CoreDataManager.sharedInstance.managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) {
                            for r in restaurants {
                                self.restaurants.append(r as Restaurant)
                            }
                        }

                        // Menu
                        let food = shopInfo["menu"]!
                        for foodDict in food {
                            if let status = foodDict["status"] {
                                if status == "1" {
                                    Food.converFromDict(foodDict)
                                } else {
                                    Food.deleteFood(foodDict)
                                }
                            }
                            
                        }
                        CoreDataManager.sharedInstance.saveContext()
                    
                        
                        Utils.takeOutLastUpdateTimeStamp = NSString(format: "%.0lf", NSDate().timeIntervalSince1970)
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                })
            })
        }
    }

}
