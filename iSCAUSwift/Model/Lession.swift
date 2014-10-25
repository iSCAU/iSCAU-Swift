//
//  Lession.swift
//  iSCAUSwift
//
//  Created by Alvin on 6/12/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import CoreData

var lessionFetchRequest: NSFetchRequest = {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName("Lession", inManagedObjectContext: CoreDataManager.sharedInstance.managedObjectContext!)
    return fetchRequest
    }()

class Lession: NSManagedObject {
    
    @NSManaged var classname: NSString
    @NSManaged var teacher: NSString
    @NSManaged var day: NSString
    @NSManaged var node: NSString
    @NSManaged var strWeek: String
    @NSManaged var endWeek: String
    @NSManaged var dsz: NSString
    @NSManaged var location: NSString
    
    class func converFromDict(info: NSDictionary) -> Lession? {
        let lession = NSEntityDescription.insertNewObjectForEntityForName("Lession", inManagedObjectContext: CoreDataManager.sharedInstance.managedObjectContext!) as? Lession
        lession?.classname = info["classname"]! as String
        lession?.teacher = info["teacher"]! as String
        lession?.day = info["day"]! as String
        lession?.node = info["node"]! as String
//        lession?.strWeek = info["strWeek"]!.string
//        lession?.endWeek = info["endWeek"]!.string
        lession?.location = info["location"]! as String
        return lession
    }
    
    class func cellForDayLession(tableView: UITableView, lession: Lession) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(EduDayLessionCell.cellIdentifier()) as EduDayLessionCell
        
        cell.configure(lession)

        return cell as UITableViewCell
    }
}
