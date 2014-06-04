//
//  EduApiClient.swift
//  iSCAUSwift
//
//  Created by Alvin on 6/4/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import Foundation

/** edusystem module */
// password need to base64urlsafeencode;
/*
array('edusys/login/:username/:password/:server\d', 
    'Edusys/login', '', 'get', 'json,'),
array('edusys/classtable/:username/:password/:server\d', 
    'Edusys/getClassTable', '', 'get', 'json,'),
array('edusys/exam/:username/:password/:server\d', 
    'Edusys/getExam', '', 'get', 'json,'),
array('edusys/goal/:username/:password/:server\d/:year/:team', 
    'Edusys/getGoal', '', 'get', 'json,'),
array('edusys/pickclassinfo/:username/:password/:server\d', 
    'Edusys/getPickClassInfo', '', 'get', 'json,'),'Edusys/getEmptyClassRoom', '', 'get', 'json,'),
array('edusys/params/emptyclassroom/:username/:password/:server\d',
    'Edusys/getEmptyClassRoomParameter', '', 'get', 'json,'),
array('edusys/params/goal/:username/:password/:server\d',
    'Edusys/getGoalParameter', '', 'get', 'json,'),
array('edusys/emptyclassroom/:username/:password/:server\d/:xq/:jslb/:ddlKsz/:ddlJsz/:xqj/:dsz/:sjd',

*/

enum EduFeature {
    case EduLogin
    case EduGetClassTable
    case EduGetExamsInfo
    case EduGetMarksInfo
    case EduGetReviewLesson
    case EduGetEmptyClassroom
    case EduGetEmptyClassroomParams
}

class EduApiClient: NSObject {
    
    let EduLoginPath = "edusys/login"
    let EduGetTimeTablePath = "edusys/classtable"
    let EduGetExamsInfoPath = "edusys/exam"
    let EduGetMarksInfoPath = "edusys/params/goal"
    let EduGetReviewLessonPath = "edusys/pickclassinfo"
    let EduGetEmptyClassroomPath = "edusys/emptyclassroom"
    let EduGetEmptyClassroomParamsPath = "edusys/params/emptyclassroom"
    
    // 单例调用
    let requestManager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
    class var sharedInstance: EduApiClient {
        get {
            struct Static {
                static var instance: EduApiClient? = nil
                static var token: dispatch_once_t = 0
            }
            dispatch_once(&Static.token) {
                Static.instance = EduApiClient()
            }
            return Static.instance!
        }
    }
        
    // 调取教务操作
    func eduAction(feature: EduFeature, params: Array<String>!, success successHandler: ((AFHTTPRequestOperation!, AnyObject!) -> Void)?, failure failureHandler: ((AFHTTPRequestOperation!, NSError!) -> Void)!) {
        var url = "\(HostName)"
        
        switch feature {
        case .EduLogin:
            url += "\(EduLoginPath)"
        case .EduGetClassTable:
            url += "\(EduGetTimeTablePath)"
        case .EduGetExamsInfo:
            url += "\(EduGetExamsInfoPath)"
        case .EduGetMarksInfo:
            url += "\(EduGetMarksInfoPath)"
        case .EduGetReviewLesson:
            url += "\(EduGetReviewLessonPath)"
        case .EduGetEmptyClassroom:
            url += "\(EduGetEmptyClassroomPath)"
        case .EduGetEmptyClassroomParams:
            url += "\(EduGetEmptyClassroomParamsPath)"
        default:
            println("Edu not support this feature")
            return
        }
        
        for param in params {
            url += "/\(param)"
        }
        
        startRequest(url, success: successHandler, failure: failureHandler)
    }
    
    func startRequest(url:String, success successHandler: ((AFHTTPRequestOperation!, AnyObject!) -> Void)?, failure failureHandler: ((AFHTTPRequestOperation!, NSError!) -> Void)!) {
        requestManager.GET(url, parameters: nil, success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
            var statusCode = operation.response.statusCode
            
            if statusCode == StatusCodeEduUsernameError || statusCode == StatusCodeEduPwdError {
                
            } else if statusCode == StatusCodeEduUsernameError || statusCode == StatusCodeEduPwdError {
                
            } else if statusCode == StatusCodeEduUsernameError || statusCode == StatusCodeEduPwdError {
                
            }
            
            if successHandler {
                successHandler!(operation, responseObject)
            }
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                // Error handle
                if failureHandler {
                    failureHandler!(operation, error)
                }
            })
    }
}
