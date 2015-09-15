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

class PDFViewController: UIViewController, QLPreviewControllerDataSource, QLPreviewControllerDelegate
{
    // MARK: Properties
    var masterController:MajorSelectViewController?
    var displayedPDF = false
    
    // MARK: Initialization
    override func viewDidLoad() {

    }
    
    override func viewWillAppear(animated: Bool) {
        
        if !self.displayedPDF
        {
            let controller = QLPreviewController()
            controller.dataSource = self
            controller.delegate = self
            controller.view.backgroundColor = self.view.backgroundColor
            
            self.presentViewController(controller, animated: false, completion: nil)
            self.displayedPDF = true
        }
    }
    
    // MARK: QL Datasource
    func numberOfPreviewItemsInPreviewController(controller: QLPreviewController) -> Int
    {
        return 1
    }
    
    func previewController(controller: QLPreviewController, previewItemAtIndex index: Int) -> QLPreviewItem
    {
        let path = NSBundle.mainBundle().pathForResource("Computer-Science-APP", ofType: "pdf")
        return NSURL.fileURLWithPath(path!)
    }
    
    // MARK: Delegate
    func previewControllerDidDismiss(controller: QLPreviewController) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            self.masterController!.removeTemp()
        }
    }
}
