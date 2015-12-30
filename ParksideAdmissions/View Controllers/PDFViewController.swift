//
//  PDFViewController.swift
//  Parkside Admissions
//
//  Created by Kyle Zawacki on 9/14/15.
//  Copyright © 2015 University Of Wisconsin Parkside. All rights reserved.
//
//  This class handles the presentation of a major PDF.

import UIKit
import QuickLook
import MessageUI

class PDFViewController: UIViewController, QLPreviewControllerDataSource, QLPreviewControllerDelegate, MFMailComposeViewControllerDelegate
{
    // MARK: Properties
    var masterController:MajorSelectViewController?
    var displayedPDF = false
    var pdfIndex:Int?
    var previewController:MyPreviewController?
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var otherSpace: UIView!
    var oldBackgroundColor:UIColor?
    
    // MARK: Initialization
    override func viewDidLoad() {
        let statusBar = UIToolbar(frame: CGRectMake(0, -20, self.view.frame.width , 20))
        
        statusBar.backgroundColor = self.navBar.barTintColor
        statusBar.barTintColor = self.navBar.barTintColor
        self.navBar.addSubview(statusBar)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        if !self.displayedPDF
        {
            previewController = MyPreviewController()
            previewController!.dataSource = self
            previewController!.delegate = self
            previewController!.view.backgroundColor = self.view.backgroundColor
            previewController!.currentPreviewItemIndex = pdfIndex!
  
            previewController!.view.frame = CGRectMake(0, 0, self.otherSpace.frame.width, self.otherSpace.frame.height)

            self.otherSpace.addSubview(previewController!.view)
            
            self.displayedPDF = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.oldBackgroundColor = self.view.backgroundColor
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.view.backgroundColor = self.oldBackgroundColor
    }
    
    // MARK: QL Datasource
    func numberOfPreviewItemsInPreviewController(controller: QLPreviewController) -> Int
    {
        return MajorsNames.NAMES.count
    }
    
    func previewController(controller: QLPreviewController, previewItemAtIndex index: Int) -> QLPreviewItem
    {
        let path = NSBundle.mainBundle().pathForResource(MajorsNames.NAMES[index], ofType: "pdf")
        pdfIndex = index
        
        return NSURL.fileURLWithPath(path!)
    }
            
    // MARK: User Interaction
    @IBAction func backButtonPressed(sender: UIBarButtonItem)
    {
        self.dismissViewControllerAnimated(true) { () -> Void in
            self.masterController!.removeTemp()
        }
    }
    
    @IBAction func sendButtonPressed(sender: AnyObject)
    {
        let popupChoice = self.storyboard!.instantiateViewControllerWithIdentifier("SendChoicePopup") as! SendChoicePopup
        let form = MZFormSheetPresentationController(contentViewController: popupChoice)
        form.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.StyleBounce
        form.contentViewSize = CGSizeMake(400, 250)
        form.shouldDismissOnBackgroundViewTap = true
        form.shouldCenterVertically = true
        popupChoice.master = self
        popupChoice.cardColor = self.oldBackgroundColor
        
        self.presentViewController(form, animated: true, completion: nil)
    }
    
    func print()
    {
        
    }
    
    func email()
    {
        var emailTitle = "Major PDF"
        var messageBody = "\(Constants.majorNames[pdfIndex!])"
        var mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        
        let path = NSBundle.mainBundle().pathForResource(Constants.majorPdfFileName[pdfIndex!], ofType: "pdf")
        let data:NSData = NSData.dataWithContentsOfMappedFile(path!) as! NSData
        mc.addAttachmentData(data, mimeType: "image/pdf", fileName: "\(Constants.majorPdfFileName[pdfIndex!]).pdf")
        
        self.presentViewController(mc, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?)
    {

        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
