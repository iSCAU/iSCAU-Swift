//
//  AppDelegate.swift
//  iSCAUSwift
//
//  Created by Alvin on 6/4/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit
import CoreData
import Crashlytics

let kUMengAppKey = "50b853b85270156c2b000007"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    var tintColor: UIColor?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        // Override point for customization after application launch.
        
        application.statusBarStyle = UIStatusBarStyle.LightContent;
        
        tintColor = AppTintColor
        UINavigationBar.appearance().barTintColor = AppTintColor
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [ NSForegroundColorAttributeName : UIColor.whiteColor() ]
        UITabBar.appearance().selectedImageTintColor = AppTintColor
        
        Crashlytics.startWithAPIKey("2888f0e3d016f021c4a964ee765c66087e19ab35")
        MobClick.startWithAppkey(kUMengAppKey)
        MobClick.checkUpdate()
        MobClick.updateOnlineConfig()
        
        return true
    }
}

