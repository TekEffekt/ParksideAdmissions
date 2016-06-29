//
//  Test.swift
//  ParksideAdmissions
//
//  Created by Kyle Zawacki on 3/12/16.
//  Copyright © 2016 University Of Wisconsin Parkside. All rights reserved.
//

import UIKit

class Test: UIViewController {
    
    @IBOutlet weak var back: UIButton!
    
    @IBAction func backAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
