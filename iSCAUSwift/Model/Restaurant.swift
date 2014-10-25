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

    @NSManaged var rid: NSNumber
    @NSManaged var shopName: String
    @NSManaged var phone: String
    @NSManaged var status: NSNumber
    @NSManaged var startTime: String
    @NSManaged var endTime: String
    @NSManaged var editTime: String
    @NSManaged var logoURL: String
    
    class func savedRestaurants() -> [ Restaurant ] {
        var savedRestaurants: [ Restaurant ] = []
        var error: NSError?
        restaurantFetchRequest.predicate = nil
        if let restaurants = CoreDataManager.sharedInstance.managedObjectContext!.executeFetchRequest(restaurantFetchRequest, error: &error) {
            for r in restaurants {
                savedRestaurants.append(r as Restaurant)
            }
        }
        return savedRestaurants
    }
    
    class func updateRestaurants(newRestaurants: [[String : String]]) {

        for restaurantDict in newRestaurants {
            if let status = restaurantDict["status"] {
                if status == "1" {
                    Restaurant.converFromDict(restaurantDict)
                } else {
                    Restaurant.deleteRestaurant(restaurantDict)
                }
            }
        }
        CoreDataManager.sharedInstance.saveContext()
    }

    class func converFromDict(info: [String : String]) -> Restaurant? {
        let rid = info["id"]!.toInt()!
        
        restaurantFetchRequest.predicate = NSPredicate(format: "rid = %d", rid)
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
        
        restaurant?.rid = rid
        restaurant?.shopName = info["shop_name"]!
        restaurant?.phone = info["phone"]!
        restaurant?.status = info["status"]!.toInt()!
        restaurant?.startTime = info["start_time"]!
        restaurant?.endTime = info["end_time"]!
        restaurant?.editTime = info["edit_time"]!
        restaurant?.logoURL = info["logo_url"]!
        return restaurant?
    }
    
    class func deleteRestaurant(info: [String : String]) {
        let rid = info["id"]!.toInt()!
        
        restaurantFetchRequest.predicate = NSPredicate(format: "rid = %d", rid)
        var restaurant: Restaurant?
        if let restaurants = CoreDataManager.sharedInstance.managedObjectContext!.executeFetchRequest(restaurantFetchRequest, error: nil) {
            for r in restaurants {
                CoreDataManager.sharedInstance.managedObjectContext!.deleteObject(r as Restaurant)
            }
        }
    }
    
    private var _titleHeight: CGFloat = 0.0
    var titleHeight: CGFloat {
        get {
            if _titleHeight < 1.0 {
                var shopName: NSString = self.shopName
                var shopNameHeight = shopName.boundingRectWithSize(CGSizeMake(ScreenWidth - 150, CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(15)], context: nil).size.height
                _titleHeight = shopNameHeight > 44.0 ? shopNameHeight : 44.0
            }
            return _titleHeight
        }
    }
}
