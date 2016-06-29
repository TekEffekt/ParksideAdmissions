//
//  ScreensaverController.swift
//  ParksideAdmissions
//
//  Created by Kyle Zawacki on 6/28/16.
//  Copyright © 2016 University Of Wisconsin Parkside. All rights reserved.
//

import UIKit
import Auk
import Shimmer

class ScreensaverController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var unlockLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.auk.settings.contentMode = .ScaleAspectFill
        
        for i in 1...11 {
            scrollView.auk.show(image: UIImage(named: "Banner \(i)")!)
        }
        
        scrollView.auk.startAutoScroll(delaySeconds: 5)
        
        view.alpha = 0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animateWithDuration(0.5) {
            self.view.alpha = 1
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let shimmer = FBShimmeringView(frame: unlockLabel.frame)
        view.addSubview(shimmer)
        
        shimmer.contentView = unlockLabel
        shimmer.shimmering = true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func screenTapped(sender: AnyObject) {
        UIView.animateWithDuration(0.5, animations: { 
            self.view.alpha = 0
            }) { (Bool) in
                self.dismissViewControllerAnimated(false, completion: nil)
        }
        
    }
}
