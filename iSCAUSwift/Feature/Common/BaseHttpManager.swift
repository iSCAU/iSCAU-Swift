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
                .response(completionHandler)
        }
    }

}
