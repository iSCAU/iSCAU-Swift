//
//  ActivityViewController.swift
//  activity
//
//  Created by admin on 14-9-24.
//  Copyright (c) 2014年 admin. All rights reserved.
//

import Foundation
import UIKit

class ActivityTableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    var ActivitydataSource = NSMutableArray()
    var IndexPath : NSIndexPath?
    var tableview : UITableView?
    
    // var eHttp : HttpController = HttpController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  eHttp.onSearch("http://iscaucms.sinaapp.com/index.php/Api/getActivities?time=1234")
        
        tableview = UITableView(frame: CGRectMake(0, 40, self.view.bounds.width, self.view.bounds.height), style: UITableViewStyle.Plain)
        tableview?.delegate = self
        tableview?.dataSource = self
        //set title
        let ActivityTitleView = UILabel(frame: CGRectMake(self.view.bounds.width/9, 0, 80, 64))
        ActivityTitleView.text = "校园活动"
        ActivityTitleView.font = UIFont.systemFontOfSize(20)
        ActivityTitleView.textColor = UIColor.whiteColor()
        self.navigationItem.titleView =  ActivityTitleView
        //set backBarButtonItem
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.view.addSubview(tableview!)
        //set segment
        let darkGreenColor = UIColor(red: 31/255.5, green: 193/255.5, blue: 168/255.5, alpha: 1)
        let activitySegment = HMSegmentedControl( sectionTitles: [ "今天","明天","未来" ] )
        activitySegment?.frame = CGRectMake(0, 64, self.view.bounds.width,30)
        activitySegment?.tintColor = darkGreenColor
        activitySegment.selectionIndicatorColor = darkGreenColor
        activitySegment.selectionIndicatorHeight = 3.0
        //易错点Selector("segmentSelect:")少了“:”
        activitySegment.addTarget(self, action: Selector("segmentSelect:"), forControlEvents: UIControlEvents.ValueChanged)
        activitySegment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        self.view.addSubview(activitySegment!)
        // 此处使用Alamofire进行webrequest
        
        
        
        
        for index in 0..<12{
            let model = ActivityModel(iden : 1,title : "Title",place:"place",association:"asssociation",content:"content",level:1,logoUrl:"url",userName:"username",time:"time",editTime:"5566666")
            ActivitydataSource.addObject(model)
        }
    }//segment action
    func segmentSelect(sender : UISegmentedControl!){
        
        switch sender.selectedSegmentIndex {
        case 0 :
            //load today datasource
            loadToday()
            println("今天")
            
        case 1 :
            //load tommorrrow datasource
            loadTommorrow()
            println("明天")
            
        case 2 :
            //load future datasource
            loadFuture()
            println("后天")
            
        default:
            break
        }
    }
    
    func loadToday(){
        ActivitydataSource.removeAllObjects()
        for index in 0..<12{
            let model = ActivityModel(iden : 1,title : "今天",place:"place",association:"asssociation",content:"content",level:1,logoUrl:"url",userName:"username",time:"time",editTime:"5566666")
            ActivitydataSource.addObject(model)
        }
        tableview?.reloadData()
        
    }
    func  loadTommorrow(){
        ActivitydataSource.removeAllObjects()
        for index in 0..<12{
            let model = ActivityModel(iden : 1,title : "明天",place:"place",association:"asssociation",content:"content",level:1,logoUrl:"url",userName:"username",time:"time",editTime:"5566666")
            ActivitydataSource.addObject(model)
        }
        tableview?.reloadData()
    }
    func loadFuture(){
        ActivitydataSource.removeAllObjects()
        for index in 0..<12{
            let model = ActivityModel(iden : 1,title : "未来",place:"place",association:"asssociation",content:"content",level:1,logoUrl:"url",userName:"username",time:"time",editTime:"5566666")
            ActivitydataSource.addObject(model)
        }
        tableview?.reloadData()
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
    //点击单元格 展开、收缩 model信息
    //点击区头按钮 修改数据源数组 展开区
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.navigationController?.pushViewController(ActivityWebViewController(), animated: true)
    }
    func didReceiveResults(results:NSDictionary) {
        println(results)
    }
}