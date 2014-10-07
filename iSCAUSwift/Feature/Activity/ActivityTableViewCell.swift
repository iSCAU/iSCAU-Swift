//
//  ActivityTableViewCell.swift
//  iSCAUSwift
//
//  Created by Alvin on 10/7/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var labTitle: UILabel!
    @IBOutlet weak var labUsername: UILabel!
    @IBOutlet weak var imgUsername: UIImageView!
    @IBOutlet weak var labTime: UILabel!
    @IBOutlet weak var imgTime: UIImageView!
    @IBOutlet weak var labPlace: UILabel!
    @IBOutlet weak var imgPlace: UIImageView!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imgTopSep: UIImageView!
    @IBOutlet weak var imgBottomSep: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let image = UIImage(color: UIColor(r: 206, g: 241, b: 245, a: 1))
        imgTopSep.image = image
        imgBottomSep.image = image
    }

    class func cellForTableView(tableView: UITableView, activity: Activity) -> ActivityTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ActivityTableViewCellIdentifier") as? ActivityTableViewCell
        cell!.height = activity.titleHeight
        cell!.labTitle.text = activity.title
        cell!.labPlace.text = activity.place
        cell!.labUsername.text = activity.username
        cell!.labTime.text = activity.time
        cell!.imgLogo.sd_setImageWithURL(NSURL(string: activity.logo_url))
        
        for view in [cell!.labUsername, cell!.imgUsername, cell!.labTime, cell!.imgTime, cell!.labPlace, cell!.imgPlace, cell!.imgBottomSep] {
            
        }
        
        return cell!
    }
    
}
