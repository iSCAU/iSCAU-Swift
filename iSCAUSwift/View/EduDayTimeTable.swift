//
//  EduDayTimeTable.swift
//  iSCAUSwift
//
//  Created by Alvin on 6/12/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit

class EduDayTimeTable: UIView {
    
    var tableView: UITableView!
    var lessions: Array<Lession>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.lessions = Array<Lession>()
        
        self.tableView = UITableView(frame: frame, style: UITableViewStyle.Plain)
        self.addSubview(self.tableView)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return (self.lessions? != nil) ? self.lessions!.count : 0
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 44.0;
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        return Lession.cellForDayLession(tableView, lession: (self.lessions![indexPath.row] as Lession))
    }
}
