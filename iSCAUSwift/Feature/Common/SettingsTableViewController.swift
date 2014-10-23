//
//  SettingsTableViewController.swift
//  iSCAUSwift
//
//  Created by Alvin on 6/5/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
override     
    init?(style: UITableViewStyle) {
        super.init(style: style)
        // Custom initialization
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // #pragma mark - Table view data source

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return 8
    }

    override func tableView(tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0, 2, 4, 6:
            return 20.0
        case 1, 3, 5, 7:
            return 44.0
        default:
            return 0.0
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.row) {
        case 5:if let nav1 = UINavigationController(rootViewController: self.storyboard?.instantiateViewControllerWithIdentifier("AboutUsViewController") as UIViewController) {
            self.presentViewController(nav1, animated: true, completion: nil)
            }
            
        case 7:
            if let nav2 = UINavigationController(rootViewController: self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as UIViewController) {
                self.presentViewController(nav2, animated: true, completion: nil)
            }
        default:
            return
        }
    }

}
