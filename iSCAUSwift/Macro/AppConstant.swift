//
//  AppConstant.swift
//  iSCAUSwift
//
//  Created by Alvin on 6/4/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit

let AppTintColor = UIColor(red: 44/255.0, green: 161/255.0, blue: 142/255.0, alpha: 1)

let HostName = "http://115.28.144.49"
let LibHostName = "http://202.116.174.108:8080/opac/"

let kResponseStatusCodeSuccess = 200;
let kResponseStatusCodeNullError = 404;
let kResponseStatusCodeEduUsernameError = 405;
let kResponseStatusCodeEduPwdError = 406;
let kResponseStatusCodeLibPwdError = 407;
let kResponseStatusCodeMaxRenewLimit = 408;
let kResponseStatusCodeServerError = 500;

let kStuNumKey = "kStuNumKey"
let kStuPwdKey = "kStuPwdKey"
let kStuServerKey = "kStuServerKey"
let kLibPwdKey = "kLibPwdKey"
let kEmptyClassroomParamsKey = "kEmptyClassroomParamsKey"
let kSchoolYearKey = "kSchoolYearKey"
let kSemesterKey = "kSemesterKey"
let kDormitoryAddressKey = "kDormitoryAddressKey"
let kTakeOutLastUpdateTimeStamp = "kTakeOutLastUpdateTimeStamp"
let kActivityLastUpdateTimeStamp = "kActivityLastUpdateTimeStamp"
let kSemesterStartDateKey = "kSemesterStartDateKey"
let kPreferWeekStyleClasstableKey = "kPreferWeekStyleClasstableKey"

let kReloadRestaurantTableNotification = "kReloadRestaurantTableNotification"
let kRefreshActivityDataNotification = "kRefreshActivityDataNotification"
let kCheckActivityDetailNotification = "kCheckActivityDetailNotification"

let kHideNoticeInter: Float = 1.5
let kShowNoticeNotification =  "kShowNoticeNotification"
let kHideNoticeNotification =  "kHideNoticeNotification"

// Utils
let iSCAUAppDelegate: AppDelegate = UIApplication.sharedApplication().delegate! as AppDelegate
let ScreenWidth = UIScreen.mainScreen().bounds.width
let ScreenHeight = UIScreen.mainScreen().bounds.height
