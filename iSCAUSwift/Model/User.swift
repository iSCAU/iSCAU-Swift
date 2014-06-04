//
//  User.swift
//  iSCAUSwift
//
//  Created by Alvin on 6/4/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import Foundation

class User: NSObject {
    let kStuNumKey = "kStuNumKey"
    let kStuPwdKey = "kStuPwdKey"
    let kLibPwdKey = "kLibPwdKey"
    let kServerKey = "kServerKey"
    let kIsPwdSaveKey = "kIsPwdSaveKey"
    
    var stuNum = ""
    var stuPwd = ""
    var libPwd = ""
    var server = 1
    var isPwdSave:Bool {
    get {
        return NSUserDefaults.standardUserDefaults().boolForKey(kIsPwdSaveKey)
    }
    
    set {
        var def = NSUserDefaults.standardUserDefaults()
        def.setBool(newValue, forKey: kIsPwdSaveKey)
    }
    }

    // 单例下存取
    class var sharedInstance: User {
        get {
            struct Static {
                static var instance: User? = nil
                static var token: dispatch_once_t = 0
            }
            dispatch_once(&Static.token) {
                Static.instance = User()
            }
            return Static.instance!
        }
    }
    
    func saveUserInfo(stuNum: String, stuPwd: String, libPwd: String, server: Int) {
        self.stuNum = stuNum
        self.stuPwd = stuPwd
        self.libPwd = libPwd
        self.server = server
        
        var def = NSUserDefaults.standardUserDefaults()
        def.setObject(self.stuNum, forKey: kStuNumKey)
        def.setObject(self.stuPwd, forKey: kStuPwdKey)
        def.setObject(self.libPwd, forKey: kStuNumKey)
        def.setObject(self.server, forKey: kServerKey)
        
        def.synchronize()
    }
}
