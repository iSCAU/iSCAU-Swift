//
//  EduTimeTableViewController.swift
//  iSCAUSwift
//
//  Created by Alvin on 6/5/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit

class EduTimeTableViewController: UIViewController {
    
    var btnLessionsAction: FRDLivelyButton!

    func setup() {
        self.btnLessionsAction = FRDLivelyButton(frame: CGRectMake(0, 0, 30, 30))
        self.btnLessionsAction.options = [ kFRDLivelyButtonColor: UIColor.blueColor() ]
        self.btnLessionsAction.setStyle(kFRDLivelyButtonStylePlus, animated: false)
        self.btnLessionsAction.addTarget(self, action: Selector("displayPopoverView"), forControlEvents: UIControlEvents.TouchUpInside)
        var barButtonItem = UIBarButtonItem(customView: self.btnLessionsAction)
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = Utils.currentWeek("2014-02-14")
        
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayPopoverView() {
        self.btnLessionsAction.setStyle(kFRDLivelyButtonStyleClose, animated: true)
        
        var btnReloadLessions = UIButton(frame: CGRectMake(5, 0, 90, 40))
        btnReloadLessions.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btnReloadLessions.setTitle("更新", forState: UIControlState.Normal)
        
        var btnEditLessions = UIButton(frame: CGRectMake(5, 44, 90, 40))
        btnEditLessions.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btnEditLessions.setTitle("编辑", forState: UIControlState.Normal)
        
        var btnAddLession = UIButton(frame: CGRectMake(5, 88, 90, 40))
        btnAddLession.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btnAddLession.setTitle("添加", forState: UIControlState.Normal)
        
//        PopoverView.showPopoverAtPoint(CGPointMake(300, 64), inView: self.view, withViewArray: [btnReloadLessions, btnEditLessions, btnAddLession], delegate: self)
    }
    
    
//    // MARK: PopoverView delegate
//    func popoverView(popoverView: PopoverView, didSelectItemAtIndex index: Int) {
//        switch index {
//        case 0:
//            self.reloadLessions()
//        case 1:
//            self.editLessions()
//        case 2:
//            self.addLession()
//        default:
//            break
//        }
//        popoverView.dismiss()
//        self.btnLessionsAction.setStyle(kFRDLivelyButtonStylePlus, animated: true)
//    }

    func reloadLessions() {
        
    }
    
    func editLessions() {
        
    }
    
    func addLession() {
        
    }
}
