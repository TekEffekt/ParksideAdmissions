//
//  SendChoicePopup.swift
//  Parkside Admissions
//
//  Created by Kyle Zawacki on 9/21/15.
//  Copyright © 2015 University Of Wisconsin Parkside. All rights reserved.
//

import UIKit

class SendChoicePopup: UIViewController
{
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var printButtonFrame: UIView!
    @IBOutlet weak var emailButtonFrame: UIView!
    var card:CardView?
    var newLabel:UILabel?
    var master:PDFViewController?
    var cardColor:UIColor?

    override func viewDidLoad()
    {
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        setupCardBackground()
        setupLabel()
        setupButtons()
    }
    
    func setupCardBackground()
    {
        self.card = CardView(frame: CGRectMake(10, 10, self.view.frame.width-20, self.view.frame.height-20))
        self.view.backgroundColor = UIColor.clearColor()
        card!.backgroundColor = self.cardColor
        self.view.addSubview(card!)
    }
    
    
    func setupLabel()
    {
        descLabel.removeFromSuperview()
        
        let newLabel = UILabel(frame: CGRectMake(self.card!.frame.width/2-descLabel.frame.width/2, self.card!.frame.origin.y + 20,
            descLabel.frame.width, descLabel.frame.height))
        newLabel.font = descLabel.font
        newLabel.textColor = UIColor.whiteColor()
        newLabel.text = descLabel.text
        self.card!.addSubview(newLabel)
        self.newLabel = newLabel
    }
    
    func setupButtons()
    {
        let printButton = MKButton(frame: printButtonFrame.frame)
        printButton.setTitle("Print Out", forState: UIControlState.Normal)
        printButton.titleLabel!.textAlignment = NSTextAlignment.Center
        printButton.backgroundColor = UIColor.whiteColor()
        printButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        printButton.frame = CGRectMake(newLabel!.frame.origin.x, printButton.frame.origin.y, printButton.frame.width, printButton.frame.height)
        printButton.addTarget(self, action: "print", forControlEvents: UIControlEvents.TouchUpInside)
        printButton.removeShadowing()
        
        self.card!.addSubview(printButton)
        
        let emailButton = MKButton(frame: emailButtonFrame.frame)
        emailButton.setTitle("Email It", forState: UIControlState.Normal)
        emailButton.titleLabel!.textAlignment = NSTextAlignment.Center
        emailButton.backgroundColor = UIColor.whiteColor()
        emailButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        emailButton.frame = CGRectMake(newLabel!.frame.origin.x + newLabel!.frame.width-self.emailButtonFrame.frame.width, printButton.frame.origin.y, printButton.frame.width, printButton.frame.height)
        emailButton.addTarget(self, action: "email", forControlEvents: UIControlEvents.TouchUpInside)
        emailButton.removeShadowing()
        
        self.card!.addSubview(emailButton)
    }
    
    func print()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func email()
    {
        self.dismissViewControllerAnimated(true) { () -> Void in
            self.master!.email()
        }
    }
}
