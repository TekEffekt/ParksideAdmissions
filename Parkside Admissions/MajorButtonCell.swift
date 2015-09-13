//
//  MajorButtonCell.swift
//  Admissions
//
//  Created by Kyle Zawacki on 9/13/15.
//  Copyright © 2015 University Of Wisconsin Parkside. All rights reserved.
//

import UIKit

class MajorButtonCell: UICollectionViewCell
{
    var button = MKButton()
    var index:Int?
    
    override func drawRect(rect: CGRect)
    {
        self.button = MKButton(frame: CGRectMake(0, 0, self.frame.width, self.frame.height))
        self.layer.masksToBounds = false
        button.backgroundColor = Constants.majorColors[index!]
        button.setTitle(Constants.majorNames[index!], forState: UIControlState.Normal)
        button.titleLabel!.font = button.titleLabel!.font.fontWithSize(30)
        
        if let _ = button.superview
        {} else
        {
            self.addSubview(button)
        }
    }
}
