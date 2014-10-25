//
//  ActivityTableViewController.swift
//  iSCAUSwift
//
//  Created by Alvin on 10/7/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit
import CoreData

class ActivityTableViewController: UITableViewController {

    var activities: [Activity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("refreshData"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
        tableView.backgroundColor = UIColor(white: 0, alpha: 0.02)
        tableView.separatorStyle = .None
        tableView.registerNib(UINib(nibName: "ActivityTableViewCell", bundle: nil), forCellReuseIdentifier: "ActivityTableViewCellIdentifier")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let activity = activities[indexPath.row]
        return 142 + activity.titleHeight - 30;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let activity = activities[indexPath.row]
        let cell = ActivityTableViewCell.cellForTableView(tableView, activity: activity)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let activity = activities[indexPath.row]
        NSNotificationCenter.defaultCenter().postNotificationName(kCheckActivityDetailNotification, object: nil, userInfo: ["activity" : activity])
    }
    
    func refreshData() {
        NSNotificationCenter.defaultCenter().postNotificationName(kRefreshActivityDataNotification, object: nil, userInfo: nil)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            self.refreshControl!.endRefreshing()
        })
    }
    
    func updateData(activities: [Activity]) {
        self.activities = activities
        tableView.reloadData()
    }
}
