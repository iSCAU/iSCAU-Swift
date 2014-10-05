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

    @NSManaged var food_name: String
    @NSManaged var f_id: NSNumber
    @NSManaged var food_price: String
    @NSManaged var edit_time: String
    @NSManaged var food_shop_id: NSNumber
    @NSManaged var status: NSNumber
    
    var count: Int = 0
    
    class func converFromDict(info: [String : String]) -> Food? {
        let f_id = info["id"]!.toInt()!
        
        foodFetchRequest.predicate = NSPredicate(format: "f_id = %d", f_id)
        var food: Food?
        if let foods = CoreDataManager.sharedInstance.managedObjectContext!.executeFetchRequest(foodFetchRequest, error: nil) {
            for f in foods {
                food = f as? Food
                break
            }
        }
        if food == nil {
            food = NSEntityDescription.insertNewObjectForEntityForName("Food", inManagedObjectContext: CoreDataManager.sharedInstance.managedObjectContext!) as? Food
        }
        
        food?.f_id = info["id"]!.toInt()!
        food?.food_name = info["food_name"]!
        food?.food_price = info["food_price"]!
        food?.status = info["status"]!.toInt()!
        food?.edit_time = info["edit_time"]!
        food?.food_shop_id = info["food_shop_id"]!.toInt()!

        return food
    }
    
    class func deleteFood(info: [String : String]) {
        let f_id = info["id"]!.toInt()!
        
        foodFetchRequest.predicate = NSPredicate(format: "f_id = %d", f_id)
        var food: Food?
        if let foods = CoreDataManager.sharedInstance.managedObjectContext!.executeFetchRequest(foodFetchRequest, error: nil) {
            for f in foods {
                CoreDataManager.sharedInstance.managedObjectContext!.deleteObject(f as Food)
            }
        }
    }

    lazy var titleHeight: CGFloat = {
        var foodName: NSString = self.food_name
        var foodNameHeight = foodName.boundingRectWithSize(CGSizeMake(UIScreen.mainScreen().bounds.width - 150, CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(17)], context: nil).size.height
        return foodNameHeight > 44.0 ? foodNameHeight : 44.0
        }()

    
}
