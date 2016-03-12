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
    
    override func drawRect(rect: CGRect)
    {
        self.majorIcon.image = UIImage(named: MajorsNames.NAMES[index!])
        self.majorText.text = MajorsNames.DISPLAY_NAMES[index!]
        
        let tapGeture = UITapGestureRecognizer(target: self, action: "buttonPressed")
        tapGeture.delegate = self
        self.addGestureRecognizer(tapGeture)
    }
    
    func buttonPressed() {
        self.controller!.buttonPressed(withCell: self)
    }
    
}
