//
//  EduHttpManager.swift
//  iSCAUSwift
//
//  Created by Alvin on 9/23/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit
import Alamofire

class EduHttpManager: BaseHttpManager {
    
    private class func isLogined() -> Bool {
        if (Utils.stuNum? != nil &&
            Utils.stuPwd? != nil &&
            Utils.server? != nil) {
            return true;
        }
        return false;
    }
    
    class func loginWith(#stuNum: String, pwd: String, server: String, completionHandler: (NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?) -> Void) {
        if !isLogined() {
            return;
        }
        let urlStr = "\(HostName)/edusys/login/\(stuNum)/\(Utils.stuPwd!)/\(server)"
        startRequest(urlStr, completionHandler: completionHandler)
    }
    
    class func requestClassTable(#completionHandler: (NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?) -> Void) {
        if !isLogined() {
            return;
        }
        println("stu:\(Utils.stuNum!) pwd:\(Utils.stuPwd!) ser:\(Utils.server!)")
        let urlStr = "\(HostName)/edusys/classtable/\(Utils.stuNum!)/\(Utils.stuPwd!)/\(Utils.server!)"
        startRequest(urlStr, completionHandler: completionHandler)
    }
    
    class func requestExam(#completionHandler: (NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?) -> Void) {
        if !isLogined() {
            return;
        }
        let urlStr = "\(HostName)/edusys/exam/\(Utils.stuNum!)/\(Utils.stuPwd!)/\(Utils.server!)"
        startRequest(urlStr, completionHandler: completionHandler)
    }
    
    class func requestMarksInfo(#completionHandler: (NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?) -> Void) {
        if !isLogined() {
            return;
        }
        let urlStr = "\(HostName)/edusys/params/goal/\(Utils.stuNum!)/\(Utils.stuPwd!)/\(Utils.server!)"
        startRequest(urlStr, completionHandler: completionHandler)
    }

    class func requestMarks(#year: String, term: String, completionHandler: (NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?) -> Void) {
        if !isLogined() {
            return;
        }
        let urlStr = "\(HostName)/edusys/goal/\(Utils.stuNum!)/\(Utils.stuPwd!)/\(Utils.server!)/\(year)/\(term)"
        println(urlStr)
        startRequest(urlStr, completionHandler: completionHandler)
    }

    class func requestPickClassInfo(#completionHandler: (NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?) -> Void) {
        if !isLogined() {
            return;
        }
        let urlStr = "\(HostName)/edusys/pickclassinfo/\(Utils.stuNum!)/\(Utils.stuPwd!)/\(Utils.server!)"
        startRequest(urlStr, completionHandler: completionHandler)
    }
    
    class func requestEmptyClassroomInfo(
        #xq: String,
        jslb: String,
        ddlKsz: String,
        ddlJsz: String,
        xqj: String,
        dsz: String,
        sjd: String,
        completionHandler: (NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?) -> Void) {
        if !isLogined() {
            return;
        }
        let urlStr = "\(HostName)/edusys/emptyclassroom/\(Utils.stuNum!)/\(Utils.stuPwd!)/\(Utils.server!)/\(xq)/\(jslb)/\(ddlKsz)/\(ddlJsz)/\(xqj)/\(dsz)/\(sjd)"
        startRequest(urlStr, completionHandler: completionHandler)
    }
    
    class func requestEmptyClassroomParams(#completionHandler: (NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?) -> Void) {
        if !isLogined() {
            return;
        }
        let urlStr = "\(HostName)/edusys/params/emptyclassroom/\(Utils.stuNum!)/\(Utils.stuPwd!)/\(Utils.server!)"
        println(urlStr)
        startRequest(urlStr, completionHandler: completionHandler)
    }
}
