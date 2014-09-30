//
//  Utils.swift
//  iSCAUSwift
//
//  Created by Alvin on 6/4/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import Foundation

@objc class Utils: NSObject {
    
    @objc class func safeBase64Encode(str: String) -> String {
        return str.dataUsingEncoding(NSUTF8StringEncoding)!.base64EncodedString()!;
    }
    
    @objc class func currentWeek(semesterStartDateString: String?) -> String {
        if (semesterStartDateString != nil) {
            let local = NSLocale(localeIdentifier: "zh_CN")
            let formatter = NSDateFormatter()
            formatter.locale = local
            formatter.dateFormat = "yyyy-MM-dd"
            let date =  NSDate()
            let startDate = formatter.dateFromString(semesterStartDateString!)

            let interval = date.timeIntervalSinceDate(startDate!)
            let intervalDays = interval / 86400
            let intervalWeek = floor(intervalDays / 7.0) + 1
            if intervalWeek > 0 && intervalWeek < 23 {
//                return "第\(intervalWeek)周"
            }
        }
        return ""
    }
    
    @objc class func indicatorColorAtIndex(index: Int) -> UIColor {
        let colorIndex = index % 4;
        switch colorIndex {
        case 0:
            return UIColor(fromHexRGB: "0x0140ca", alpha: 1)
        case 1:
            return UIColor(fromHexRGB: "0x16a61e", alpha: 1)
        case 2:
            return UIColor(fromHexRGB: "0xdd1812", alpha: 1)
        case 3:
            return UIColor(fromHexRGB: "0xfcca03", alpha: 1)
        default:
            return UIColor(fromHexRGB: "0x0140ca", alpha: 1)
        }
    }
}

// MARK: - Account

extension Utils {
    @objc class var stuNum: String? {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey(kStuNumKey) as String?
        }
        set(newStuNum) {
            NSUserDefaults.standardUserDefaults().setObject(newStuNum, forKey: kStuNumKey)
        }
    }
    
    @objc class var server: String? {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey(kStuServerKey) as String?
        }
        set(newServer) {
            NSUserDefaults.standardUserDefaults().setObject(newServer, forKey: kStuServerKey)
        }
    }

    @objc class var stuPwd: String? {
        get {
            if let existedPwd = (NSUserDefaults.standardUserDefaults().objectForKey(kStuPwdKey) as String?) {
                return safeBase64Encode(existedPwd)
            }
            return nil
        }
        set(newStuPwd) {
            NSUserDefaults.standardUserDefaults().setObject(newStuPwd, forKey: kStuPwdKey)
        }
    }
    
    @objc class var libPwd: String? {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey(kLibPwdKey) as String?
        }
        set(newLibPwd) {
            NSUserDefaults.standardUserDefaults().setObject(newLibPwd, forKey: kLibPwdKey)
        }
    }
}

// MARK: - Path

extension Utils {
    
    enum FileName: String {
        case ClassTable = "classtable.data"
        case BorrowedBooks = "borrowedbooks.data"
        case BorrowingBooks = "borrowingbooks.data"
        case PickedClass = "pickedclass.data"
        case Marks = "marks.data"
    }
    
    @objc class func documentFolderPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        return (paths[0] as String)
    }
    
    @objc class func classTablePath() -> String {
        return documentFolderPath().stringByAppendingPathComponent(FileName.ClassTable.rawValue)
    }
}