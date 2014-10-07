//
//  Utils.swift
//  iSCAUSwift
//
//  Created by Alvin on 6/4/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import Foundation

class Utils: NSObject {
    
    class func safeBase64Encode(str: String) -> String {
        return str.dataUsingEncoding(NSUTF8StringEncoding)!.base64EncodedString()!;
    }
    
    class func currentWeek(semesterStartDateString: String?) -> String {
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
    
    class func indicatorColorAtIndex(index: Int) -> UIColor {
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
    class var stuNum: String? {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey(kStuNumKey) as String?
        }
        set(newStuNum) {
            NSUserDefaults.standardUserDefaults().setObject(newStuNum, forKey: kStuNumKey)
        }
    }
    
    class var server: String? {
        get {
            return "1"
//            return NSUserDefaults.standardUserDefaults().objectForKey(kStuServerKey) as String?
        }
        set(newServer) {
            NSUserDefaults.standardUserDefaults().setObject(newServer, forKey: kStuServerKey)
        }
    }

    class var stuPwd: String? {
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
    
    class var libPwd: String? {
        get {
            if let existedPwd = (NSUserDefaults.standardUserDefaults().objectForKey(kLibPwdKey) as String?) {
                return safeBase64Encode(existedPwd)
            }
            return nil
        }
        set(newLibPwd) {
            NSUserDefaults.standardUserDefaults().setObject(newLibPwd, forKey: kLibPwdKey)
        }
    }
    
    class var emptyClassroomParams: [String : [String]]? {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey(kEmptyClassroomParamsKey) as Dictionary?
        }
        set(newEmptyClassroomParams) {
            NSUserDefaults.standardUserDefaults().setObject(newEmptyClassroomParams, forKey: kEmptyClassroomParamsKey)
        }
    }
    
    class var schoolYear: [String]? {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey(kSchoolYearKey) as [String]?
        }
        set(newSchoolYear) {
            NSUserDefaults.standardUserDefaults().setObject(newSchoolYear, forKey: kSchoolYearKey)
        }
    }
    
    class var takeOutLastUpdateTimeStamp: String? {
        get {
            if let timeStamp = NSUserDefaults.standardUserDefaults().objectForKey(kTakeOutLastUpdateTimeStamp) as? String {
                return timeStamp
            } else {
                return "0"
            }
        }
        set(newTimeStamp) {
            NSUserDefaults.standardUserDefaults().setObject(newTimeStamp, forKey: kTakeOutLastUpdateTimeStamp)
        }
    }
    
    class var activityLastUpdateTimeStamp: String? {
        get {
//            if let timeStamp = NSUserDefaults.standardUserDefaults().objectForKey(kActivityLastUpdateTimeStamp) as? String {
//                return timeStamp
//            } else {
                return "0"
//            }
        }
        set(newTimeStamp) {
            NSUserDefaults.standardUserDefaults().setObject(newTimeStamp, forKey: kActivityLastUpdateTimeStamp)
        }
    }
    
    class var preferWeekStyleClassTable: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(kPreferWeekStyleClasstableKey)
        }
        set(newValue) {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: kPreferWeekStyleClasstableKey)
        }
    }

    class var semester: [String]? {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey(kSemesterKey) as [String]?
        }
        set(newSemester) {
            NSUserDefaults.standardUserDefaults().setObject(newSemester, forKey: kSemesterKey)
        }
    }
    
    class var dormitoryAddress: String {
        get {
            if let address =  NSUserDefaults.standardUserDefaults().objectForKey(kDormitoryAddressKey) as? String {
                return address
            } else {
                return "你还未设置外卖地址"
            }
        }
        set (newDormitoryAddress) {
            NSUserDefaults.standardUserDefaults().setObject(newDormitoryAddress, forKey: kDormitoryAddressKey)
        }
    }
    
    class var semesterStartDate: String? {
        get {
            return  NSUserDefaults.standardUserDefaults().objectForKey(kSemesterStartDateKey) as String?
        }
        set (newSemeterStartDate) {
            NSUserDefaults.standardUserDefaults().setObject(newSemeterStartDate, forKey: kSemesterStartDateKey)
        }
    }
    
    class func currentWeek() -> String {
        if let startDateStr = semesterStartDate {
            let date = NSDate()
            let locale = NSLocale(localeIdentifier: "zh_CN")
            let formatter = NSDateFormatter()
            formatter.locale = locale
            formatter.dateFormat = "yyyy-MM-dd"
            if let startDate = formatter.dateFromString(startDateStr) {
                let interval = date.timeIntervalSinceDate(startDate)
                let days = Int(interval / 86400)
                let week = Int(floor(Double(days) / 7.0)) + 1
                if week > 0 && week <= 23 {
                    return "第\(week)周"
                }
            }
        }
        return ""
    }
    
    class func currentWeekNum() -> Int {
        if let startDateStr = semesterStartDate {
            let date = NSDate()
            let locale = NSLocale(localeIdentifier: "zh_CN")
            let formatter = NSDateFormatter()
            formatter.locale = locale
            formatter.dateFormat = "yyyy-MM-dd"
            if let startDate = formatter.dateFromString(startDateStr) {
                let interval = date.timeIntervalSinceDate(startDate)
                let days = Int(interval / 86400)
                let week = Int(floor(Double(days) / 7.0)) + 1
                if week > 0 && week <= 23 {
                    return week
                }
            }
        }
        return 0
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
        case MarksParam = "marksparam.data"
    }
    
    class func documentFolderPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        return (paths[0] as String)
    }
    
    class func classTablePath() -> String {
        return documentFolderPath().stringByAppendingPathComponent(FileName.ClassTable.rawValue)
    }
    
    class func marksParamPath() -> String {
        return documentFolderPath().stringByAppendingPathComponent(FileName.MarksParam.rawValue)
    }
}

// MARK: - Segue

extension Utils {
    
    enum SegueType: String {
        case Push = "Push"
        case Present = "Present"
    }
    
    class func segueIdentifier(type: SegueType, destinationViewControllerClass: AnyClass) -> String {
        return "\(type.rawValue)\(NSStringFromClass(destinationViewControllerClass))"
    }
}