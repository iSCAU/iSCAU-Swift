//
//  Activity.swift
//  iSCAUSwift
//
//  Created by Alvin on 10/7/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import Foundation
import CoreData

var activityFetchRequest: NSFetchRequest = {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName("Activity", inManagedObjectContext: CoreDataManager.sharedInstance.managedObjectContext!)
    return fetchRequest
    }()


class Activity: NSManagedObject {

    @NSManaged var a_id: String
    @NSManaged var title: String
    @NSManaged var place: String
    @NSManaged var association: String
    @NSManaged var content: String
    @NSManaged var level: String
    @NSManaged var logo_url: String
    @NSManaged var username: String
    @NSManaged var time: String
    @NSManaged var timestamp: String
    
    class func converFromDict(info: NSDictionary) -> Activity? {
        let a_id = info["id"] as String
        
        activityFetchRequest.predicate = NSPredicate(format: "a_id = %@", a_id)
        var activity: Activity?
        if let activities = CoreDataManager.sharedInstance.managedObjectContext!.executeFetchRequest(activityFetchRequest, error: nil) {
            for a in activities {
                activity = a as? Activity
                break
            }
        }
        if activity == nil {
            activity = NSEntityDescription.insertNewObjectForEntityForName("Activity", inManagedObjectContext: CoreDataManager.sharedInstance.managedObjectContext!) as? Activity
        }
        
        activity?.a_id = info["id"] as String
        activity?.title = info["title"] as String
        activity?.place = info["place"] as String
        activity?.association = info["association"] as String
        activity?.content = info["content"] as String
        activity?.level = info["level"] as String
        activity?.logo_url = info["logoUrl"] as String
        if let username = info["username"] as? String {
            activity?.username = username
        } else {
            activity?.username = " "
        }
        activity?.time = info["time"] as String
        if let timestamp = info["t"] as? NSNumber {
            activity?.timestamp = "\(timestamp)"
        } else {
            activity?.timestamp = " "
        }
        
        return activity?
    }
    
    class func deleteActivity(info: [String : String]) {
        let a_id = info["id"]!.toInt()!
        
        activityFetchRequest.predicate = NSPredicate(format: "a_id = %d", a_id)
        var activity: Activity?
        if let activitites = CoreDataManager.sharedInstance.managedObjectContext!.executeFetchRequest(activityFetchRequest, error: nil) {
            for a in activitites {
                CoreDataManager.sharedInstance.managedObjectContext!.deleteObject(a as Activity)
            }
        }
    }
    
    lazy var titleHeight: CGFloat = {
        var title: NSString = self.title
        var titleHeight = title.boundingRectWithSize(CGSizeMake(ScreenWidth - 80, CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.boldSystemFontOfSize(18)], context: nil).size.height
        return titleHeight > 30.0 ? titleHeight : 30.0
        }()
}
