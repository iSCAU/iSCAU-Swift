//
//  AppDelegate.swift
//  iSCAUSwift
//
//  Created by Alvin on 6/4/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        // Override point for customization after application launch.
        
        application.statusBarStyle = UIStatusBarStyle.LightContent;
        
        UINavigationBar.appearance().barTintColor = AppTintColor
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [ NSForegroundColorAttributeName : UIColor.whiteColor() ]
        
        UITabBar.appearance().selectedImageTintColor = AppTintColor
        
    
        /*Rich：活动圈appdelegate
        let rootController = ActivityTableViewController()
        let rootNav = UINavigationController(rootViewController: rootController)
        
        let darkGreenColor = UIColor(red: 31/255.5, green: 193/255.5, blue: 168/255.5, alpha: 1)
        rootNav?.navigationBar.barTintColor = darkGreenColor
        rootNav?.navigationBar.tintColor = UIColor.whiteColor()
        rootNav?.navigationBar.translucent = true
     
        self.window?.rootViewController = rootNav
        
        */
        
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
}

