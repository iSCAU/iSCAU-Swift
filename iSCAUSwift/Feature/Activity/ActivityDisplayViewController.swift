//
//  ActivityDisplayViewController.swift
//  iSCAUSwift
//
//  Created by Alvin on 10/4/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit
import CoreData

class ActivityDisplayViewController: JPTabViewController, JPTabViewControllerDelegate {

    var theActivity: Activity?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var today : UIViewController = ActivityTableViewController()
        today.title = "今天"
        var tomorrow : UIViewController = ActivityTableViewController()
        tomorrow.title = "明天"
        var future : UIViewController = ActivityTableViewController()
        future.title = "未来"
        
        controllers = [ today, tomorrow, future ]
        
        loadData()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("refreshData"), name: kRefreshActivityDataNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("checkActivityDetail:"), name: kCheckActivityDetailNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        var todayActivities: [Activity] = []
        var tomorrowActivities: [Activity] = []
        var futureActivities: [Activity] = []
        var pastActivities: [Activity] = []
        
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Activity", inManagedObjectContext: CoreDataManager.sharedInstance.managedObjectContext!)
        let sortDescriptor = NSSortDescriptor(key: "level", ascending: false)
        fetchRequest.sortDescriptors = [ sortDescriptor ]
        
        if let activities = CoreDataManager.sharedInstance.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) {
            for activity in activities {
                
                // Seperate them
                let a = activity as Activity
                
                if a.level.toInt() == 9 {
                    todayActivities.append(a)
                } else if let date = dateformatter.dateFromString(a.time) {
                    let dateType = date.dateType()
                    switch dateType {
                    case AZDateType.Today:
                        todayActivities.append(a)
                    case AZDateType.Tomorrow:
                        tomorrowActivities.append(a)
                    case AZDateType.Future:
                        futureActivities.append(a)
                    case AZDateType.Past:
                        CoreDataManager.sharedInstance.managedObjectContext!.deleteObject(a as Activity)
                    }
                }
            }
            
            // Today
            let today = self.controllers[0] as ActivityTableViewController
            today.updateData(todayActivities)
            
            // Tomorrow
            let tomorrow = self.controllers[1] as ActivityTableViewController
            tomorrow.updateData(tomorrowActivities)
            
            // Future
            let future = self.controllers[2] as ActivityTableViewController
            future.updateData(futureActivities)
        }
    }
    
    func refreshData() {
        ActivityHttpManager.activityList { (request, response, data, error) -> Void in
            if response?.statusCode == 200 {
                dispatch_async(dispatch_get_main_queue(), {
                    var error: NSError?
                    if let d = data as? NSData {
                        if let contentInfo = NSJSONSerialization.JSONObjectWithData(d, options: NSJSONReadingOptions.AllowFragments, error: &error) as? NSDictionary {
                            
                            let fetchRequest = NSFetchRequest()
                            
                            // Content
                            let contents = contentInfo["content"] as NSArray
                            for contentDict in contents {
                                Activity.converFromDict(contentDict as NSDictionary)
                            }
                            CoreDataManager.sharedInstance.saveContext()
                            
                            Utils.activityLastUpdateTimeStamp = NSString(format: "%.0lf", NSDate().timeIntervalSince1970)
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.loadData()
                    })
                })
            }
        }
    }
    
    func checkActivityDetail(notification: NSNotification) {
        let userInfo = notification.userInfo as [ String : Activity ]
        theActivity = userInfo["activity"]
        
        performSegueWithIdentifier("PushActivityDetailViewController", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PushActivityDetailViewController" {
            if let detailVC = (segue.destinationViewController as? ActivityDetailViewController) {
                detailVC.content = theActivity!.content
            }
        }
    }
}
