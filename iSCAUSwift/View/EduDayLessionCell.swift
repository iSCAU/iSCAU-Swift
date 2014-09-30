//
//  EduDayLessionCell.swift
//  iSCAUSwift
//
//  Created by Alvin on 6/12/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit

class EduDayLessionCell: UITableViewCell {
//    @IBOutlet var labClassName: UILabel
//    @IBOutlet var labLocation: UILabel
//    @IBOutlet var labWeeks: UILabel
//    
    func configure(lession: Lession) {
//        self.labClassName.text = lession.classname
//        self.labLocation.text = lession.location
//        self.labWeeks.text = lession.node
    }

    class func cellIdentifier() -> String {
        return "EduDayLessionCellIdentifier"
    }
}
