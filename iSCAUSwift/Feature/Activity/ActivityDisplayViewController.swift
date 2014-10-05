//
//  ActivityDisplayViewController.swift
//  iSCAUSwift
//
//  Created by Alvin on 10/4/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit

class ActivityDisplayViewController: JPTabViewController, JPTabViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var today : UIViewController = ActivityViewController()
        today.title = "今天"
        var tommorraw : UIViewController = ActivityViewController()
        tommorraw.title = "明天"
        var future : UIViewController = ActivityViewController()
        future.title = "未来"
        
        controllers = [ today, tommorraw, future ]
        
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
