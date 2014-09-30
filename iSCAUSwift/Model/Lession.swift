//
//  Lession.swift
//  iSCAUSwift
//
//  Created by Alvin on 6/12/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import CoreData

class Lession: NSManagedObject {
    
    @NSManaged var classname: NSString
    @NSManaged var teacher: NSString
    @NSManaged var day: NSString
    @NSManaged var node: NSString
    @NSManaged var strWeek: NSString
    @NSManaged var endWeek: NSString
    @NSManaged var dsz: NSString
    @NSManaged var location: NSString
    
    class func createLession(info: NSDictionary) {
        
    }
    
    class func cellForDayLession(tableView: UITableView, lession: Lession) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(EduDayLessionCell.cellIdentifier()) as EduDayLessionCell
        
        cell.configure(lession)

        return cell as UITableViewCell
    }
}
