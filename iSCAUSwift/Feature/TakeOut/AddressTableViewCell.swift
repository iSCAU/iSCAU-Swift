//
//  AddressTableViewCell.swift
//  iSCAUSwift
//
//  Created by Alvin on 10/4/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit

class AddressTableViewCell: UITableViewCell {

    @IBOutlet weak var labAddress: UILabel!
    @IBOutlet weak var imgTopSep: UIImageView!
    @IBOutlet weak var imgBottomSep: UIImageView!
    
    class var cellHeight: CGFloat {
        get {
            var address = "你还没设置送餐地址"
            if (Utils.dormitoryAddress? != nil) {
                address = Utils.dormitoryAddress!
            }
            return address.boundingRectWithSize(CGSizeMake(ScreenWidth - 50, CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(16.0)], context: nil).size.height + 20
        }
    }

    func setup() {
        if let address = Utils.dormitoryAddress {
            labAddress.text = address
            labAddress.textColor = UIColor.darkTextColor()
        } else {
            labAddress.text = "你还没设置送餐地址"
            labAddress.textColor = UIColor(r: 195, g: 0, b: 19, a: 1)
        }
        
        labAddress.height = AddressTableViewCell.cellHeight - 20
        labAddress.width = ScreenWidth - 50
        
        imgTopSep.width = ScreenWidth
        
        imgBottomSep.top = labAddress.height + 19
        imgBottomSep.width = ScreenWidth
    }
    
}
