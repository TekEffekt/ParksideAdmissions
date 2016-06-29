//
//  TimerUIApplication.swift
//  ParksideAdmissions
//
//  Created by Kyle Zawacki on 6/28/16.
//  Copyright © 2016 University Of Wisconsin Parkside. All rights reserved.
//

import Foundation

class TimerUIApplication: UIApplication {
    
    static let ApplicationDidTimoutNotification = "AppTimout"
    
    // The timeout in seconds for when to fire the idle timer.
    //let timeoutInSeconds: NSTimeInterval = 5 * 60
    let timeoutInSeconds: NSTimeInterval = 10
    
    var idleTimer: NSTimer?
    
    // Listen for any touch. If the screen receives a touch, the timer is reset.
    override func sendEvent(event: UIEvent) {
        super.sendEvent(event)
        
        if idleTimer != nil {
            self.resetIdleTimer()
        }
        
        if let touches = event.allTouches() {
            for touch in touches {
                if touch.phase == UITouchPhase.Began {
                    self.resetIdleTimer()
                }
            }
        }
    }
    
    // Resent the timer because there was user interaction.
    func resetIdleTimer() {
        if let idleTimer = idleTimer {
            idleTimer.invalidate()
        }
        
        idleTimer = NSTimer.scheduledTimerWithTimeInterval(timeoutInSeconds, target: self, selector: #selector(TimerUIApplication.idleTimerExceeded), userInfo: nil, repeats: false)
    }
    
    // If the timer reaches the limit as defined in timeoutInSeconds, post this notification.
    func idleTimerExceeded() {
        NSNotificationCenter.defaultCenter().postNotificationName(TimerUIApplication.ApplicationDidTimoutNotification, object: nil)
    }
}