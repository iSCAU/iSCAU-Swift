//
//  CetHttpManager.swift
//  iSCAUSwift
//
//  Created by Alvin on 11/20/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit

class CetHttpManager: BaseHttpManager {

    class func queryMarks(#cetNum: NSString, username: NSString, completionHandler: (NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?) -> Void) {
        let urlStr = "\(HostName)/cet/querymarks?cetnum=\(cetNum)&username=\(username))"
        startRequest(urlStr, completionHandler: completionHandler)
    }
    
}
