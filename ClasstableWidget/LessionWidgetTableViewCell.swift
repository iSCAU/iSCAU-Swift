//
//  LessionWidgetTableViewCell.swift
//  iSCAUSwift
//
//  Created by Alvin on 10/8/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit

class LessionWidgetTableViewCell: UITableViewCell {

    @IBOutlet weak var labClassname: UILabel!
    @IBOutlet weak var labClassroom: UILabel!
    @IBOutlet weak var labTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupWithLession(lession: NSDictionary) {
        selectedBackgroundView = selectedBackgroundView
        
        labClassname!.text = lession["classname"] as? String
        if let classroom = lession["location"] as? String {
            labClassroom!.text = "@\(classroom)"
        }
        if let time = lession["node"] as? String {
            labTime!.text = "\(time)节"
        }
    }
    
}
