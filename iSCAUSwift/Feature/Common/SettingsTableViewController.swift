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

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.row) {
        case 7:
            if let nav = UINavigationController(rootViewController: self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as UIViewController) {
                self.presentViewController(nav, animated: true, completion: nil)
            }
        default:
            return
        }
    }

}
