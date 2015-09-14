//
//  MajorSelectViewController.swift
//  Admissions
//
//  Created by Kyle Zawacki on 9/13/15.
//  Copyright © 2015 University Of Wisconsin Parkside. All rights reserved.
//
//  WHAT

import UIKit

class MajorSelectViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    @IBOutlet weak var buttonCollection: UICollectionView!
    var buttonViews:[MKButton] = []
    
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
        if !self.buttonViews.contains(cell.button)
        {
            self.buttonViews.append(cell.button)
        }
        cell.setNeedsDisplay()
        
        return cell
    }
    
}
