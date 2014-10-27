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

    var selectedActivity: Activity?
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var today = ActivityTableViewController()
        today.title = "今天"
        var tomorrow = ActivityTableViewController()
        tomorrow.title = "明天"
        var future = ActivityTableViewController()
        future.title = "未来"
        
        controllers = [ today, tomorrow, future ]
        
        loadData()
        refreshData()
        
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
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let sortDescriptor = NSSortDescriptor(key: "level", ascending: true)
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Activity", inManagedObjectContext: CoreDataManager.sharedInstance.managedObjectContext!)
        fetchRequest.sortDescriptors = [ sortDescriptor ]
        
        if let activities = CoreDataManager.sharedInstance.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) {
            for activity in activities {
                
                // Seperate
                let a = activity as Activity
                if let date = dateformatter.dateFromString(a.time) {
                    let dateType = date.dateType()
                    switch dateType {
                    case AZDateType.Today:
                        todayActivities.append(a)
                    case AZDateType.Tomorrow:
                        if a.level.toInt() == 9 {
                            tomorrowActivities.append(a)
                        } else {
                            futureActivities.append(a)
                        }
                    case AZDateType.Future:
                        if a.level.toInt() == 9 {
                            todayActivities.insert(a, atIndex: 0)
                        } else {
                            futureActivities.append(a)
                        }
                        
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
        if isLoading {
            return
        }
        
        isLoading = true
        ActivityHttpManager.activityList { (request, response, data, error) -> Void in
            if response?.statusCode == kResponseStatusCodeSuccess {
                var error: NSError?
                if let d = data as? NSData {
                    if let contentInfo = NSJSONSerialization.JSONObjectWithData(d, options: NSJSONReadingOptions.AllowFragments, error: &error) as? NSDictionary {
                        // Content
                        if let contents = contentInfo["content"] as? NSArray {
                            for contentDict in contents {
                                Activity.converFromDict(contentDict as NSDictionary)
                            }
                            CoreDataManager.sharedInstance.saveContext()
                            
                            Utils.activityLastUpdateTimeStamp = NSString(format: "%.0lf", NSTimeIntervalSince1970)
                        }
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.loadData()
                })
                self.isLoading = false
                return
            }
            self.isLoading = false
            Utils.activityLastUpdateTimeStamp = "0"
            Utils.showNotice("网络错误", inView: self.view)
        }
    }
    
    func checkActivityDetail(notification: NSNotification) {
        let userInfo = notification.userInfo as [ String : Activity ]
        selectedActivity = userInfo["activity"]
        
        performSegueWithIdentifier("PushActivityDetailViewController", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PushActivityDetailViewController" {
            if let detailVC = (segue.destinationViewController as? ActivityDetailViewController) {
                detailVC.content = selectedActivity!.content
            }
        }
    }
}
