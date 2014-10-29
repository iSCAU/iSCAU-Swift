//
//  LibHttpManager.swift
//  iSCAUSwift
//
//  Created by Alvin on 10/2/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit

class LibHttpManager: BaseHttpManager {
    
    private class func isLogined() -> Bool {
        if (Utils.stuNum? != nil &&
            Utils.libPwd? != nil) {
                return true;
        }
        return false;
    }

    class func searchBook(#title: String, page: Int, completionHandler: (NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?) -> Void) {
        let urlStr = "\(HostName)/lib/search/\(Utils.safeBase64Encode(title))/\(page)"
        startRequest(urlStr, completionHandler: completionHandler)
    }
    
    class func bookDetail(#uri: String, completionHandler: (NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?) -> Void) {
        let urlStr = "\(HostName)/lib/book/\(uri)"
        startRequest(urlStr, completionHandler: completionHandler)
    }
    
    class func borrowingBooks(#completionHandler: (NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?) -> Void) {
        let urlStr = "\(HostName)/lib/list/now/\(Utils.stuNum!)/\(Utils.libPwd!)"
        startRequest(urlStr, completionHandler: completionHandler)
    }
    
    class func borrowedBooks(#completionHandler: (NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?) -> Void) {
        let urlStr = "\(HostName)/lib/list/history/\(Utils.stuNum!)/\(Utils.libPwd!)"
        startRequest(urlStr, completionHandler: completionHandler)
    }
    
    class func renew(#barcode: String, checkCode: String, completionHandler: (NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?) -> Void) {
        let urlStr = "\(HostName)/lib/renew/\(Utils.stuNum!)/\(Utils.libPwd!)/\(barcode)/\(checkCode)"
        startRequest(urlStr, completionHandler: completionHandler)
    }
}
