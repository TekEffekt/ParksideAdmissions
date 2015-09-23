//
//  MyPreviewController.swift
//  Parkside Admissions
//
//  Created by Kyle Zawacki on 9/20/15.
//  Copyright © 2015 University Of Wisconsin Parkside. All rights reserved.
//

import UIKit
import QuickLook

class MyPreviewController: QLPreviewController
{
    var navBar:UINavigationBar?
    var navItem:UINavigationItem?
    
    override func viewDidAppear(animated: Bool) {
//        for thing in self.childViewControllers
//        {
//            if thing is UINavigationController
//            {
//                let nav = thing as! UINavigationController
//                self.navBar = nav.navigationBar
//                self.navItem = self.navBar!.items!.first
//                print(self.navItem!.leftBarButtonItems)
//                let doneButton:UIBarButtonItem = self.navItem!.leftBarButtonItems!.first!
//                doneButton.title = "Back"
//                self.navItem!.leftBarButtonItems = [doneButton]
//                self.navItem!.titleView = UILabel()
//            }
//        }
    }
    
}
