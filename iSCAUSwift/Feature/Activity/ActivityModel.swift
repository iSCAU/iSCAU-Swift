
//  ActivityModel.swift
//  Activity
//
//  Created by admin on 14-9-24.
//  Copyright (c) 2014年 admin. All rights reserved.
//

import Foundation
import UIKit

class ActivityModel: NSObject {
    var Id : Int?
    var Title : String?
    var Place : String?
    var Association : String?
    var Content : String?
    var Level : Int?
    var LogoUrl : String?
    var UserName : String?
    var Time : String?
    var EditTime : String?
    
    init(iden : Int,title : String,place:String,association:String,content:String,level:Int,logoUrl:String,userName:String,time:String,editTime:String){
        self.Id = iden
        self.Title = title
        self.Place = place
        self.Association = association
        self.Content = content
        self.Level = level
        self.LogoUrl = logoUrl
        self.UserName = userName
        self.Time = time
        self.EditTime = editTime ;
        super.init()
    }
}
