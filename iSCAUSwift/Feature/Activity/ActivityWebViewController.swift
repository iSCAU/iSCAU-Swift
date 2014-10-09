
//  ActivityWebViewController.swift
//  activity
//
//  Created by admin on 14-10-2.
//  Copyright (c) 2014年 admin. All rights reserved.
//

import UIKit


class ActivityWebViewController: UIViewController,UIWebViewDelegate{
     var activityWeb : UIWebView?
    override func viewDidLoad() {
        
        activityWeb = UIWebView(frame: CGRectMake(0, 0,self.view.bounds.width, self.view.bounds.height))
        
        self.view.addSubview(activityWeb)
        activityWeb?.loadRequest(request)
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
