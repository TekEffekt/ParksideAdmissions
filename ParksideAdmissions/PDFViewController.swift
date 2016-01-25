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

class PDFViewController: UIViewController, QLPreviewControllerDataSource, QLPreviewControllerDelegate, MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate, UIPrintInteractionControllerDelegate
{
    // MARK: Properties
    var masterController:MajorSelectViewController?
    var displayedPDF = false
    var pdfIndex:Int?
    var previewController:MyPreviewController?
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var otherSpace: UIView!
    var oldBackgroundColor:UIColor?
    
    var banner: AnimatingBanner?
    @IBOutlet weak var container: UIView!
    
    // MARK: Initialization
    override func viewDidLoad() {
        let statusBar = UIToolbar(frame: CGRectMake(0, -20, self.view.frame.width , 20))
        
        statusBar.backgroundColor = self.navBar.barTintColor
        statusBar.barTintColor = self.navBar.barTintColor
        self.navBar.addSubview(statusBar)
        
        setupBannerTapGesture()
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
        
        navigationController!.navigationBarHidden = true
        
        view.addSubview(banner!)
        
        setupBannerShadow()
        startScreenTracking()
    }
    
    private func setupBannerShadow() {
        var rect = container.bounds
        rect.size.width = view.frame.width
        let shadowPath = UIBezierPath(rect: rect)
        container.layer.masksToBounds = false
        container.layer.shadowColor = UIColor.blackColor().CGColor
        container.layer.shadowOffset = CGSize(width: 0, height: 0.4)
        container.layer.shadowOpacity = 0.2
        container.layer.shadowPath = shadowPath.CGPath
    }
    
    override func viewDidAppear(animated: Bool) {
        self.oldBackgroundColor = navigationController!.view.backgroundColor
        navigationController!.view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController!.view.backgroundColor = oldBackgroundColor
        self.masterController!.view.addSubview(banner!)
    }
        
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    private func setupBannerTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: "bannerTapped")
        tap.delegate = self
        container.addGestureRecognizer(tap)
    }
    
    private func startScreenTracking() {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "PDF Screen")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    // MARK: Banner Clicked
    func bannerTapped() {
        var tracker = GAI.sharedInstance().defaultTracker
        
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Banner Tapped", action: "From PDF Screen", label: "", value: nil).build() as [NSObject : AnyObject])
        
        performSegueWithIdentifier("otherPresentWebView", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as! AppFactoryWebViewController
        destination.fromPDF = true
        
        destination.backColor = view.tintColor
    }
    
    // MARK: QL Datasource
    func numberOfPreviewItemsInPreviewController(controller: QLPreviewController) -> Int {
        return MajorsNames.NAMES.count
    }
    
    func previewController(controller: QLPreviewController, previewItemAtIndex index: Int) -> QLPreviewItem
    {
        let path = NSBundle.mainBundle().pathForResource(MajorsNames.NAMES[index], ofType: "pdf")
        
        return NSURL.fileURLWithPath(path!)
    }
            
    // MARK: User Interaction
    @IBAction func backButtonPressed(sender: UIBarButtonItem)
    {
        self.dismissViewControllerAnimated(true) { () -> Void in
            //self.banner!.removeFromSuperview()
            self.masterController!.removeTemp()
            self.masterController!.view.addSubview(self.banner!)
            self.masterController!.startScreenTracking()
        }
    }
    
    @IBAction func emailButtonPressed(sender: AnyObject) {
        let name = MajorsNames.NAMES[previewController!.currentPreviewItemIndex]
        
        let emailTitle = "Major PDF"
        let messageBody = "\(name)"
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        
        if (MFMailComposeViewController.canSendMail()) {
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle)
            mc.setMessageBody(messageBody, isHTML: false)
            
            let path = NSBundle.mainBundle().pathForResource(name, ofType: "pdf")
            let data:NSData = NSData.dataWithContentsOfMappedFile(path!) as! NSData
            mc.addAttachmentData(data, mimeType: "image/pdf", fileName: "\(name).pdf")
            mc.mailComposeDelegate = self
            
            self.presentViewController(mc, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController,
        didFinishWithResult result: MFMailComposeResult, error: NSError?) {
            // Check the result or perform other tasks.
            if result == MFMailComposeResultSent {
                let tracker = GAI.sharedInstance().defaultTracker
                
                tracker.send(GAIDictionaryBuilder.createEventWithCategory("Email", action: "\(MajorsNames.NAMES[previewController!.currentPreviewItemIndex])", label: "" , value: nil).build() as [NSObject : AnyObject])
            }
            
            // Dismiss the mail compose view controller.
            controller.dismissViewControllerAnimated(true, completion: nil)
    }
        
    @IBAction func printButtonPressed(sender: AnyObject) {
        let printController = UIPrintInteractionController.sharedPrintController()
        printController.delegate = self
        let pdfPath = MajorsNames.NAMES[previewController!.currentPreviewItemIndex]
        
        let path = NSBundle.mainBundle().pathForResource(pdfPath, ofType: "pdf")
        let data = NSData.dataWithContentsOfMappedFile(path!) as! NSData
        
        if UIPrintInteractionController.canPrintData(data) {
            let printInfo = UIPrintInfo(dictionary: nil)
            printInfo.outputType = .General
            printInfo.jobName = "\(pdfPath)  PDF"
            printInfo.duplex = .LongEdge
            printController.printInfo = printInfo
            
            printController.showsPageRange = true
            printController.printingItem = data
            
            printController.presentAnimated(true, completionHandler: nil)
        }
    }
    
    func printInteractionControllerWillStartJob(printInteractionController: UIPrintInteractionController) {
        let tracker = GAI.sharedInstance().defaultTracker
        
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Print", action: "\(MajorsNames.NAMES[previewController!.currentPreviewItemIndex])", label:"" , value: nil).build() as [NSObject : AnyObject])
    }
    
}
