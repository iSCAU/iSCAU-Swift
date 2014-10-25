//
//  Food.swift
//  iSCAUSwift
//
//  Created by Alvin on 10/3/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import Foundation
import CoreData

var foodFetchRequest: NSFetchRequest = {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName("Food", inManagedObjectContext: CoreDataManager.sharedInstance.managedObjectContext!)
    return fetchRequest
    }()

class Food: NSManagedObject {

    @NSManaged var foodName: String
    @NSManaged var fid: NSNumber
    @NSManaged var foodPrice: String
    @NSManaged var editTime: String
    @NSManaged var foodShopID: NSNumber
    @NSManaged var status: NSNumber
    
    var count: Int = 0
    
    class func updateFood(newFood: [[String : String]]) {
        for foodDict in newFood {
            if let status = foodDict["status"] {
                if status == "1" {
                    converFromDict(foodDict)
                } else {
                    deleteFood(foodDict)
                }
            }
        }
        CoreDataManager.sharedInstance.saveContext()
    }
    
    class func converFromDict(info: [String : String]) -> Food? {
        let fid = info["id"]!.toInt()!
        
        foodFetchRequest.predicate = NSPredicate(format: "fid = %d", fid)
        var food: Food?
        if let savedFood = CoreDataManager.sharedInstance.managedObjectContext!.executeFetchRequest(foodFetchRequest, error: nil) {
            for f in savedFood {
                food = f as? Food
                break
            }
        }
        if food == nil {
            food = NSEntityDescription.insertNewObjectForEntityForName("Food", inManagedObjectContext: CoreDataManager.sharedInstance.managedObjectContext!) as? Food
        }
        
        food?.fid = info["id"]!.toInt()!
        food?.foodName = info["food_name"]!
        food?.foodPrice = info["food_price"]!
        food?.status = info["status"]!.toInt()!
        food?.editTime = info["edit_time"]!
        food?.foodShopID = info["food_shop_id"]!.toInt()!

        return food
    }
    
    class func deleteFood(info: [String : String]) {
        let fid = info["id"]!.toInt()!
        
        foodFetchRequest.predicate = NSPredicate(format: "fid = %d", fid)
        var food: Food?
        if let foods = CoreDataManager.sharedInstance.managedObjectContext!.executeFetchRequest(foodFetchRequest, error: nil) {
            for f in foods {
                CoreDataManager.sharedInstance.managedObjectContext!.deleteObject(f as Food)
            }
        }
    }
    
    class func foodWithRestaurantID(restaurantID: NSNumber) -> [ Food ] {
        var foodInRestaurant: [ Food ] = []

        foodFetchRequest.predicate = NSPredicate(format: "foodShopID = %@", restaurantID)
        if let food = CoreDataManager.sharedInstance.managedObjectContext!.executeFetchRequest(foodFetchRequest, error: nil) {
            for f in food {
                foodInRestaurant.append(f as Food)
            }
        }
        return foodInRestaurant
    }

    private var _titleHeight: CGFloat = 0.0
    var titleHeight: CGFloat {
        get {
            if  _titleHeight < 1.0 {
                var foodName: NSString = self.foodName
                var foodNameHeight = foodName.boundingRectWithSize(CGSizeMake(UIScreen.mainScreen().bounds.width - 150, CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(17)], context: nil).size.height
                _titleHeight = foodNameHeight > 44.0 ? foodNameHeight : 44.0
            }
            return _titleHeight
        }
    }
}
