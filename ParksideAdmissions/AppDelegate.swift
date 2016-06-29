//
//  AppDelegate.swift
//  Parkside Admissions
//
//  Created by Kyle Zawacki on 9/13/15.
//  Copyright © 2015 University Of Wisconsin Parkside. All rights reserved.
//

import UIKit

//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        (UIApplication.sharedApplication() as! TimerUIApplication).resetIdleTimer()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.applicationDidTimout(_:)), name: TimerUIApplication.ApplicationDidTimoutNotification, object: nil)
        
        GAI.sharedInstance().trackUncaughtExceptions = true
        GAI.sharedInstance().dispatchInterval = 20
        GAI.sharedInstance().trackerWithTrackingId("UA-72832202-1")
        GAI.sharedInstance().logger.logLevel = GAILogLevel.Verbose
                
        return true
    }
    
    // The callback for when the timeout was fired.
    func applicationDidTimout(notification: NSNotification) {
        window = (UIApplication.sharedApplication().delegate?.window)!

        if let vc = window?.rootViewController as? UINavigationController {
            if let controller = vc.visibleViewController as? BaseViewController {
                controller.showScreensaver()
            }
        } else if let vc = window?.rootViewController as? BaseViewController {
            vc.showScreensaver()
        }
    }
}

