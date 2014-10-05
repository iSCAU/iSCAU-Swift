//
//  Restaurant.swift
//  iSCAUSwift
//
//  Created by Alvin on 10/3/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import Foundation
import CoreData

var restaurantFetchRequest: NSFetchRequest = {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName("Restaurant", inManagedObjectContext: CoreDataManager.sharedInstance.managedObjectContext!)
    return fetchRequest
    }()

class Restaurant: NSManagedObject {

    @NSManaged var r_id: NSNumber
    @NSManaged var shop_name: String
    @NSManaged var phone: String
    @NSManaged var status: NSNumber
    @NSManaged var start_time: String
    @NSManaged var end_time: String
    @NSManaged var edit_time: String
    @NSManaged var logo_url: String
    

    class func converFromDict(info: [String : String]) -> Restaurant? {
        let r_id = info["id"]!.toInt()!
        
        restaurantFetchRequest.predicate = NSPredicate(format: "r_id = %d", r_id)
        var restaurant: Restaurant?
        if let restaurants = CoreDataManager.sharedInstance.managedObjectContext!.executeFetchRequest(restaurantFetchRequest, error: nil) {
            for r in restaurants {
                restaurant = r as? Restaurant
                break
            }
        }
        if restaurant == nil {
            restaurant = NSEntityDescription.insertNewObjectForEntityForName("Restaurant", inManagedObjectContext: CoreDataManager.sharedInstance.managedObjectContext!) as? Restaurant
        }
        
        restaurant?.r_id = info["id"]!.toInt()!
        restaurant?.shop_name = info["shop_name"]!
        restaurant?.phone = info["phone"]!
        restaurant?.status = info["status"]!.toInt()!
        restaurant?.start_time = info["start_time"]!
        restaurant?.end_time = info["end_time"]!
        restaurant?.edit_time = info["edit_time"]!
        restaurant?.logo_url = info["logo_url"]!
        return restaurant?
    }
    
    class func deleteRestaurant(info: [String : String]) {
        let r_id = info["id"]!.toInt()!
        
        restaurantFetchRequest.predicate = NSPredicate(format: "r_id = %d", r_id)
        var restaurant: Restaurant?
        if let restaurants = CoreDataManager.sharedInstance.managedObjectContext!.executeFetchRequest(restaurantFetchRequest, error: nil) {
            for r in restaurants {
                CoreDataManager.sharedInstance.managedObjectContext!.deleteObject(r as Restaurant)
            }
        }
    }
    
    lazy var titleHeight: CGFloat = {
        var shopName: NSString = self.shop_name
        var shopNameHeight = shopName.boundingRectWithSize(CGSizeMake(ScreenWidth - 150, CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(15)], context: nil).size.height
        return shopNameHeight > 44.0 ? shopNameHeight : 44.0
    }()
}
