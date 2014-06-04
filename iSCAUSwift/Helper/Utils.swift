//
//  Utils.swift
//  iSCAUSwift
//
//  Created by Alvin on 6/4/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import Foundation

class Utils {
    class func safeBase64Encode(str: String!) -> String! {
        var unsafeStr:String? = str.dataUsingEncoding(NSUTF8StringEncoding).base64EncodedString();
        return unsafeStr!
    }
}