//
//  BaseViewController.swift
//  ParksideAdmissions
//
//  Created by Kyle Zawacki on 6/28/16.
//  Copyright © 2016 University Of Wisconsin Parkside. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let nav =  navigationController {
            if nav.view.alpha == 0 {
                UIView.animateWithDuration(0.5, animations: {
                    nav.view.alpha = 1
                })
            }
        } else {
            if view.alpha == 0 {
                UIView.animateWithDuration(0.5, animations: {
                    self.view.alpha = 1
                })
            }
        }
    }
    
    func showScreensaver() {
        let screensaver = storyboard!.instantiateViewControllerWithIdentifier("Screensaver")
        
        if let nav =  navigationController {
            UIView.animateWithDuration(0.5, animations: {
                nav.view.alpha = 0
            }) { (Bool) in
                self.presentViewController(screensaver, animated: false, completion: nil)
            }
        } else {
            UIView.animateWithDuration(0.5, animations: {
                self.view.alpha = 0
            }) { (Bool) in
                self.presentViewController(screensaver, animated: false, completion: nil)
            }
        }
    }
}
