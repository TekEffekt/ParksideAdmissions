//
//  MajorSelectViewController.swift
//  Admissions
//
//  Created by Kyle Zawacki on 9/13/15.
//  Copyright © 2015 University Of Wisconsin Parkside. All rights reserved.
//
//  This class controls the selection of a major, and upon that selection, will bring up the PDF for that major.

import UIKit
import SafariServices

class MajorSelectViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,
    UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate
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
        
        setupBannerTapGesture()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.automaticallyAdjustsScrollViewInsets = false
        
        setupBannerShadow()
        
        startScreenTracking()
    }
    
    private func setupBannerShadow() {
        var rect = bannerContainer.bounds
        rect.size.width = view.frame.width
        let shadowPath = UIBezierPath(rect: rect)
        bannerContainer.layer.masksToBounds = false
        bannerContainer.layer.shadowColor = UIColor.blackColor().CGColor
        bannerContainer.layer.shadowOffset = CGSize(width: 0, height: 0.4)
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
    
    private func setupBannerTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: "bannerTapped")
        tap.delegate = self
        bannerContainer.addGestureRecognizer(tap)
    }
    
    func startScreenTracking() {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Major Selection Screen")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    // MARK: Banner Clicked
    func bannerTapped() {
        var tracker = GAI.sharedInstance().defaultTracker
        
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Banner Tapped", action: "From Selection Screen", label: "", value: nil).build() as [NSObject : AnyObject])
        
        performSegueWithIdentifier("presentWebView", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as! AppFactoryWebViewController
        
        destination.backColor = view.tintColor
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
        let nav = self.storyboard!.instantiateViewControllerWithIdentifier("pdfController") as! UINavigationController
        let pdfController = nav.visibleViewController as! PDFViewController
        pdfController.pdfIndex = cell.index
        nav.modalPresentationStyle = UIModalPresentationStyle.Custom
        nav.transitioningDelegate = self
        let randomColorI = cell.index! % GetColors.getList().count
        nav.view.backgroundColor = GetColors.getList()[randomColorI]
        pdfController.masterController = self
        pdfController.banner = self.banner
        self.presentViewController(nav, animated: true, completion: nil)
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
