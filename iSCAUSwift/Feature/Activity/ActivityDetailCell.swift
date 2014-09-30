//
//  ActivityDetailCell.swift
//  activity
//
//  Created by admin on 14-9-27.
//  Copyright (c) 2014年 admin. All rights reserved.
//

import UIKit

class ActivityDetailCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        var detailView : UIWebView = UIWebView(frame: CGRectMake(0, 0, self.bounds.width, 400))
        self.addSubview(detailView)
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
