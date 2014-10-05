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
            let address: NSString = Utils.dormitoryAddress
            return address.boundingRectWithSize(CGSizeMake(ScreenWidth - 50, CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(16.0)], context: nil).size.height + 20
        }
    }

    func setup() {
        labAddress.text = Utils.dormitoryAddress
        labAddress.height = AddressTableViewCell.cellHeight - 20
        labAddress.width = ScreenWidth - 50
        
        imgTopSep.width = ScreenWidth
        
        imgBottomSep.top = labAddress.height + 19
        imgBottomSep.width = ScreenWidth
    }
    
}
