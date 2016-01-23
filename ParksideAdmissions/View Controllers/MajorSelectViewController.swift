//
//  MajorSelectViewController.swift
//  Admissions
//
//  Created by Kyle Zawacki on 9/13/15.
//  Copyright © 2015 University Of Wisconsin Parkside. All rights reserved.
//
//  This class controls the selection of a major, and upon that selection, will bring up the PDF for that major.

import UIKit

class MajorSelectViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIViewControllerTransitioningDelegate
{
    // MARK: Properties
    @IBOutlet weak var buttonCollection: UICollectionView!
    var buttonViews:[MKButton] = []
    var transition:JTMaterialTransition?
    var tempButton:MKButton?
    
    @IBOutlet weak var lineHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerContainer: UIView!
    var banner: AnimatingBanner?
    
    // MARK: Initialization
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.buttonCollection.delegate = self
        self.buttonCollection.dataSource = self
        
        lineHeightConstraint.constant = 0.5        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.automaticallyAdjustsScrollViewInsets = false
        
        let shadowPath = UIBezierPath(rect: bannerContainer.bounds)
        bannerContainer.layer.masksToBounds = false
        bannerContainer.layer.shadowColor = UIColor.blackColor().CGColor
        bannerContainer.layer.shadowOffset = CGSize(width: 0, height: 0.2)
        bannerContainer.layer.shadowOpacity = 0.2
        bannerContainer.layer.shadowPath = shadowPath.CGPath
    }
    
    override func viewDidAppear(animated: Bool) {
        if let _ = self.tempButton
        {
            self.tempButton!.removeFromSuperview()
            self.tempButton = nil
        }
        
        if banner == nil {
            banner = AnimatingBanner(frame: bannerContainer.frame, andColor: bannerContainer.backgroundColor!)
            view.addSubview(banner!)
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        
    }

    // MARK: Collection View Data Source
    func numberOfSectionsInCollectionView(collectionView:UICollectionView) -> Int {
            return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return MajorsNames.NAMES.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell:MajorButtonCell = collectionView.dequeueReusableCellWithReuseIdentifier("majorCell", forIndexPath: indexPath) as! MajorButtonCell
        cell.index = indexPath.row
        cell.controller = self
        cell.setNeedsDisplay()
        
        return cell
    }
    
    // MARK: Custom Transition
    func createTransition(withView view:UIView)
    {
        self.transition = JTMaterialTransition(animatedView: view)
    }
    
    func buttonPressed(withCell cell:MajorButtonCell)
    {
        self.prepareTransition(withCell: cell);
        self.presentPdf(withSelectedCell: cell)
    }
    
    func prepareTransition(withCell cell:MajorButtonCell)
    {
        let layout = self.buttonCollection.layoutAttributesForItemAtIndexPath(NSIndexPath(forRow: cell.index!, inSection: 0))
        let cellFrameInSuperview = self.buttonCollection.convertRect(layout!.frame, toView: self.buttonCollection.superview)
        
        self.tempButton = MKButton(frame: CGRect(x: cellFrameInSuperview.origin.x + cellFrameInSuperview.size.width/2, y: cellFrameInSuperview.origin.y + cellFrameInSuperview.size.height/2, width: 10, height: 10))
        tempButton!.cornerRadius = 50
        let randomColorI = cell.index! % GetColors.getList().count
        tempButton!.backgroundColor = GetColors.getList()[randomColorI]
        self.view.addSubview(tempButton!)
        self.createTransition(withView: tempButton!)
    }
    
    func presentPdf(withSelectedCell cell:MajorButtonCell) {
        let pdfController = self.storyboard!.instantiateViewControllerWithIdentifier("pdfController") as! PDFViewController
        pdfController.pdfIndex = cell.index
        pdfController.modalPresentationStyle = UIModalPresentationStyle.Custom
        pdfController.transitioningDelegate = self
        let randomColorI = cell.index! % GetColors.getList().count
        pdfController.view.backgroundColor = GetColors.getList()[randomColorI]
        pdfController.masterController = self
        pdfController.banner = self.banner
        self.presentViewController(pdfController, animated: true, completion: nil)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transition!.reverse = false
        return self.transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transition!.reverse = true
        return self.transition
    }
    
    func removeTemp() {
        self.tempButton!.removeFromSuperview()
    }
    
}
