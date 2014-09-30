//
//  AppConstant.swift
//  iSCAUSwift
//
//  Created by Alvin on 6/4/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit

//let kStatusCodeSuccess = 200
//let kStatusCodeNullError = 404
//let kStatusCodeEduUsernameError = 405
//let kStatusCodeEduPwdError = 406
//let kStatusCodeLibPwdError = 407
//let kStatusCodeMaxRenewLimit = 408
//let kStatusCodeServerError = 500

//enum StatusCode: Int {
//    case Success = 200
//    case NullError = 404
//    case EduStuNumError = 405
//    case EduPwdError = 406
//    case LibPwdError = 407
//    case MaxRenewLimit = 408
//    case ServerError = 500
//}

let AppTintColor = UIColor(red: 44/255.0, green: 161/255.0, blue: 142/255.0, alpha: 1)

let HostName = "http://115.28.144.49/"
let LibHostName = "http://202.116.174.108:8080/opac/"

let kStuNumKey = "kStuNumKey"
let kStuPwdKey = "kStuPwdKey"
let kStuServerKey = "kStuServerKey"
let kLibPwdKey = "kLibPwdKey"

// Utils
let iSCAUAppDelegate: AppDelegate = UIApplication.sharedApplication().delegate! as AppDelegate
