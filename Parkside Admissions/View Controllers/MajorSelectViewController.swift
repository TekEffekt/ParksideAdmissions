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
    
    // MARK: Initialization
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.buttonCollection.delegate = self
        self.buttonCollection.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewDidAppear(animated: Bool) {
        if let _ = self.tempButton
        {
            self.tempButton!.removeFromSuperview()
            self.tempButton = nil
        }
    }

    // MARK: Collection View Data Source
    func numberOfSectionsInCollectionView(collectionView:UICollectionView) -> Int {
            return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return Constants.majorNames.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell:MajorButtonCell = collectionView.dequeueReusableCellWithReuseIdentifier("majorCell", forIndexPath: indexPath) as! MajorButtonCell
        cell.index = indexPath.row
        cell.controller = self
        if !self.buttonViews.contains(cell.button)
        {
            self.buttonViews.append(cell.button)
        }
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
        let button = cell.button
        self.tempButton = MKButton(frame: CGRect(x: cell.center.x, y: cell.center.y, width: 10, height: 10))
        tempButton!.cornerRadius = 50
        tempButton!.backgroundColor = button.backgroundColor
        self.view.addSubview(tempButton!)
        self.createTransition(withView: tempButton!)
        
        let index = cell.index
        
        let pdfController = self.storyboard!.instantiateViewControllerWithIdentifier("pdfController") as! PDFViewController
        pdfController.pdfIndex = index
        pdfController.modalPresentationStyle = UIModalPresentationStyle.Custom
        pdfController.transitioningDelegate = self
        pdfController.view.backgroundColor = button.backgroundColor
        pdfController.masterController = self
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
    
    func removeTemp()
    {
        self.tempButton!.removeFromSuperview()
    }
}
