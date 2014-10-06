//
//  TakeOutHttpManager.swift
//  iSCAUSwift
//
//  Created by Alvin on 10/3/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit
import Alamofire

class TakeOutHttpManager: NSObject {
    
    private class func startRequest(urlStr: String, completionHandler: (NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?) -> Void) {
        if let escapedStr = urlStr.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) {
            NSLog("url %@", escapedStr)
            Alamofire
                .request(.GET, escapedStr, parameters: nil)
                .response(completionHandler)
        }
    }
    
    class func restaurantList(#completionHandler: (NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?) -> Void) {
        let urlStr = "http://iscaucms.sinaapp.com/index.php/Api/syncFood?lastUpdate=\(Utils.takeOutLastUpdateTimeStamp!)"
        startRequest(urlStr, completionHandler: completionHandler)
    }
}