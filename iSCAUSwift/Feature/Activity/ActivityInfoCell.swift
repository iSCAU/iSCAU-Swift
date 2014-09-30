//
//  ActivityInfoCell.swift
//  activity
//
//  Created by admin on 14-9-24.
//  Copyright (c) 2014年 admin. All rights reserved.
//

import UIKit

class ActivityInfoCell: UITableViewCell {
  
    var  logo : UIImageView!
    var  title :UILabel!
    var  userName : UILabel!
    var  userNameImage : UIImageView!
    var  time : UILabel!
    var  timeImage : UIImageView!
    var  place : UILabel!
    var  placeImage : UIImageView!
    var  push : UIImageView!
    
    override init?(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let width : CGFloat = self.bounds.width
        let height : CGFloat = self.bounds.height
        
        
        logo = UIImageView(frame: CGRectMake(0, 0, width/3+15, 120))
        self.contentView.addSubview(logo)
        
        title = UILabel(frame: CGRectMake(width/3-10,0, width*0.66, 60))
        title.font = UIFont.systemFontOfSize(17)
        self.contentView.addSubview(title)
        
        userName = UILabel(frame: CGRectMake(width/3+15, 50, width*0.66-10,12))
        userName.font = UIFont.systemFontOfSize(10)
        self.contentView.addSubview(userName)
        userNameImage = UIImageView(frame: CGRectMake(width/3, 52, 7.5, 7.5))
        userNameImage.image = UIImage(named: "userName.png")
        self.contentView.addSubview(userNameImage)
        
        time = UILabel(frame: CGRectMake(width/3+15, 65, width*0.66-10, 12))
        time.font = UIFont.systemFontOfSize(10)
        self.contentView.addSubview(time)
        timeImage = UIImageView(frame: CGRectMake(width/3, 68 ,7.5, 7.5))
        timeImage.image = UIImage(named: "time.png")
        self.contentView.addSubview(timeImage)
        
        place = UILabel(frame: CGRectMake(width/3+15, 77, width*0.66-10, 12))
        place.font = UIFont.systemFontOfSize(10)
        self.contentView.addSubview(place)
        placeImage = UIImageView(frame: CGRectMake(width/3, 80, 7.5, 7.5))
        placeImage.image = UIImage(named: "place.png")
        self.contentView.addSubview(placeImage)
        
        push = UIImageView(frame: CGRectMake(width/2,height+70,10, 7.5))
        push.image = UIImage(named: "push.png")
        self.contentView.addSubview(push)
    
        }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureCell(activityModel: ActivityModel?) {
        if let model = activityModel{
            title.text = model.Title
            userName.text = model.UserName
            time.text = model.Time
            place.text = model.Place
          }
    }
    
}
    
    