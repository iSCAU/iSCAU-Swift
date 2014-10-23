//
//  AboutUsViewController.swift
//  iSCAUSwift
//
//  Created by admin on 14-10-23.
//  Copyright (c) 2014年 Alvin. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let btnBack = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("back"))
        navigationItem.leftBarButtonItem = btnBack
        
        let logo = UIImageView(frame: CGRectMake(ScreenWidth/2-25, 0, 50, 50))
        logo.image = UIImage(named: "aboutUs.png")
        
        let title = UILabel(frame: CGRectMake(ScreenWidth/8, 60, ScreenWidth*7/8, 10))
        title.text = "华农宝 v2.6"
        title.textColor = UIColor.redColor()
        title.font = UIFont.systemFontOfSize(17.0)
        
       
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func back() {
        dismissViewControllerAnimated(true, completion: nil)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
