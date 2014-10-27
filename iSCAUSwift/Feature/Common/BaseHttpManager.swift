//
//  BaseHttpManager.swift
//  iSCAUSwift
//
//  Created by Alvin on 10/7/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit
import Alamofire

class BaseHttpManager: NSObject {

    class func startRequest(urlStr: String, completionHandler: (NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?) -> Void) {
        if let escapedStr = urlStr.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) {
            Alamofire
                .request(.GET, escapedStr, parameters: nil)
                .response({ (request, response, data, error) -> Void in
                    if response?.statusCode == kResponseStatusCodeEduUsernameError ||
                        response?.statusCode == kResponseStatusCodeEduPwdError ||
                        response?.statusCode == kResponseStatusCodeLibPwdError {
                            Utils.postNotification(kShowNoticeNotification, info: [ kNotice : "账号或密码错误哦", kHideNoticeIntervel : kHideNoticeInter ])
                    } else if response?.statusCode == kResponseStatusCodeServerError {
                            Utils.postNotification(kShowNoticeNotification, info: [ kNotice : "服务器暂时挂了，等下再来吧", kHideNoticeIntervel : kHideNoticeInter ])
                    } else if response?.statusCode == kResponseStatusCodeNullError {
                            Utils.postNotification(kShowNoticeNotification, info: [ kNotice : "没找到相关信息哦", kHideNoticeIntervel : kHideNoticeInter ])
                    } else if response?.statusCode == kResponseStatusCodeMaxRenewLimit {
                            Utils.postNotification(kShowNoticeNotification, info: [ kNotice : "超过最大续借次数呢", kHideNoticeIntervel : kHideNoticeInter ])
                    }
                    completionHandler(request, response, data, error)
            })
        }
    }

}
