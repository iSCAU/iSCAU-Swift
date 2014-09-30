//
//  ActivityViewController.swift
//  activity
//
//  Created by admin on 14-9-24.
//  Copyright (c) 2014年 admin. All rights reserved.
//

import Foundation
import UIKit

class ActivityViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    var ActivitydataSource = NSMutableArray()
    var IndexPath : NSIndexPath?
    
    
    override func viewDidLoad() {
        var tableview = UITableView(frame: CGRectMake(0, 40, self.view.bounds.width, self.view.bounds.height-50), style: UITableViewStyle.Plain)
        
        tableview?.delegate = self
        tableview?.dataSource = self
        
        self.view.addSubview(tableview!)
        
        for index in 0..<12{
            let model = ActivityModel(iden : 1,title : "Title",place:"place",association:"asssociation",content:"content",level:1,logoUrl:"url",userName:"username",time:"time",editTime:"5566666")
            ActivitydataSource.addObject(model)
        }
        super.viewDidLoad()
    }
    //设置cell的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return  ActivitydataSource.count
    }
    //设置cell的数量
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    //设置cell的模型
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cellIdentifier: String = "ActivityInfoCellIdentifier"
        var cell:ActivityInfoCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? ActivityInfoCell
        if cell == nil {
            cell = ActivityInfoCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        let model: ActivityModel? = ActivitydataSource[indexPath.row] as? ActivityModel
        cell!.configureCell(model)
        return cell!
    }
    //
    
    
    
    
    //点击单元格 展开、收缩 model信息
    //点击区头按钮 修改数据源数组 展开区
}