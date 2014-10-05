//
//  TakeOutMenuViewController.swift
//  iSCAUSwift
//
//  Created by Alvin on 10/3/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit

let FoodTalbeViewCellIdentifier = "FoodTalbeViewCellIdentifier"

class TakeOutMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var food: [Food]?
    var restaurant: Restaurant?

    @IBOutlet weak var tableFood: UITableView!
    @IBOutlet weak var btnOrder: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableFood.registerNib(UINib(nibName: "FoodTableViewCell", bundle: nil)!, forCellReuseIdentifier: FoodTalbeViewCellIdentifier)
        
        tableFood.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let orderVC = segue.destinationViewController as? TakeOutOrderViewController {
            var orderedFood: [Food] = []
            for f in food! {
                if f.count > 0 {
                    orderedFood.append(f)
                }
            }
            orderVC.food = orderedFood
            orderVC.restaurant = restaurant
        }
    }
    
    // MARK: - TableView datasrouce
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return food!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(FoodTalbeViewCellIdentifier) as FoodTableViewCell
        
        cell.setup(food![indexPath.row])
        
        return cell
    }
    
    // MARK: - TableView delegate
    
    @IBAction func takeOrder(sender: AnyObject) {
        for f in food! {
            if f.count > 0 {
                
            }
        }
    }
}
