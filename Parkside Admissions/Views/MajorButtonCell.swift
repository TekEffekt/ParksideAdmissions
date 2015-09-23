//
//  MajorButtonCell.swift
//  Admissions
//
//  Created by Kyle Zawacki on 9/13/15.
//  Copyright © 2015 University Of Wisconsin Parkside. All rights reserved.
//

import UIKit

class MajorButtonCell: UICollectionViewCell, UIGestureRecognizerDelegate
{
    var index:Int?
    var controller:MajorSelectViewController?
    @IBOutlet weak var majorIcon: UIImageView!
    @IBOutlet weak var majorText: UILabel!
    
//    override func drawRect(rect: CGRect)
//    {
//        button.removeFromSuperview()
//        self.button = MKButton(frame: CGRectMake(0, 0, self.frame.width, self.frame.height))
//        self.layer.masksToBounds = false
//        let randomColorI = index! % Constants.majorColors.count
//        button.backgroundColor = Constants.majorColors[randomColorI]
//        button.setTitle(Constants.majorNames[index!], forState: UIControlState.Normal)
//        button.titleLabel!.font = button.titleLabel!.font.fontWithSize(30)
//        button.addTarget(self, action: "buttonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
//        button.titleLabel!.numberOfLines = 2
//        button.titleLabel!.textAlignment = NSTextAlignment.Center
//        
//        if let _ = button.superview
//        {} else
//        {
//            self.addSubview(button)
//        }
//    }
    
    override func drawRect(rect: CGRect)
    {
        print(index!)
        self.majorIcon.image = UIImage(named: Constants.majorIconNames[index!])
        self.majorText.text = Constants.majorNames[index!]
        
        let tapGeture = UITapGestureRecognizer(target: self, action: "buttonPressed")
        tapGeture.delegate = self
        self.addGestureRecognizer(tapGeture)
    }
    
    func buttonPressed()
    {
        print("Pressed at! \(index)")
        self.controller!.buttonPressed(withCell: self)
    }
    
}
