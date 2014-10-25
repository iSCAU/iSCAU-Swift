//
//  TodayViewController.swift
//  ClasstableWidget
//
//  Created by Alvin on 10/8/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    
    let cellHeight: CGFloat = 45.0
    var todayLessions: [NSDictionary] = []
    @IBOutlet weak var tableLession: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        updateTodayLession()
        tableLession.frame = view.bounds
        tableLession.registerNib(UINib(nibName: "LessionWidgetTableViewCell", bundle: nil), forCellReuseIdentifier: "LessionWidgetTableViewCellIdentifier")
        tableLession.reloadData()
        
        var height = cellHeight * CGFloat(todayLessions.count)
        height = height > 0 ? height : cellHeight
        preferredContentSize = CGSizeMake(0, height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
//        updateTodayLession()
//        tableLession.frame = view.bounds
//        tableLession.registerNib(UINib(nibName: "LessionWidgetTableViewCell", bundle: nil)!, forCellReuseIdentifier: "LessionWidgetTableViewCellIdentifier")
//        tableLession.reloadData()
//        
//        var height = cellHeight * CGFloat(todayLessions.count)
//        height = height > 0 ? height : cellHeight
//        preferredContentSize = CGSizeMake(0, height)
//
//        completionHandler(NCUpdateResult.NewData)
//    }
    
    private func updateTodayLession() {
        let today = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let comps = calendar.components(NSCalendarUnit.WeekCalendarUnit | NSCalendarUnit.WeekdayCalendarUnit | NSCalendarUnit.WeekdayOrdinalCalendarUnit, fromDate: today)
        let weekday = comps.weekday
        let theDay = ["日", "一", "二", "三", "四", "五", "六"][weekday - 1]
        
        let defaults = NSUserDefaults(suiteName: "group.iSCAU")
        let lessionsDict: NSDictionary = defaults?.objectForKey("kClassTableDictKey") as NSDictionary

        todayLessions = []
        let currentWeek = currentWeekNum()
        let lessions = lessionsDict["classes"] as NSArray
        for l in lessions {
            if let lessionDict = l as? NSDictionary {
                let day = lessionDict["day"] as String
                let strWeek = lessionDict["strWeek"] as Int
                let endWeek = lessionDict["endWeek"] as Int
                
                if day == theDay && strWeek <= currentWeek && endWeek >= currentWeek {
                    todayLessions.append(lessionDict)
                }
            }
        }
    }
    
    private func currentWeekNum() -> Int {
        let defaults = NSUserDefaults(suiteName: "group.iSCAU")
        if let startDateStr = defaults?.stringForKey("kSemesterStartDateKey") {
            let date = NSDate()
            let locale = NSLocale(localeIdentifier: "zh_CN")
            let formatter = NSDateFormatter()
            formatter.locale = locale
            formatter.dateFormat = "yyyy-MM-dd"
            if let startDate = formatter.dateFromString(startDateStr) {
                let interval = date.timeIntervalSinceDate(startDate)
                let days = Int(interval / 86400)
                let week = Int(floor(Double(days) / 7.0)) + 1
                if week > 0 && week <= 23 {
                    return week
                }
            }
        }
        return 0
    }
    
    // MARK: - TableView delegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todayLessions.count > 0 ? todayLessions.count : 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LessionWidgetTableViewCellIdentifier") as LessionWidgetTableViewCell
        
        if todayLessions.count > 0 {
            cell.setupWithLession(todayLessions[indexPath.row])
        } else {
            cell.setupWithLession(["classname" : "今天没有课程"])
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        extensionContext?.openURL(NSURL(string: "iSCAU://open")!, completionHandler: nil)
    }

    
}
