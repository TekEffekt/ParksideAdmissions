//
//  AppFactoryWebViewController.swift
//  ParksideAdmissions
//
//  Created by Kyle Zawacki on 1/23/16.
//  Copyright © 2016 University Of Wisconsin Parkside. All rights reserved.
//

import UIKit

class AppFactoryWebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var backColor: UIColor?
    var oldNavColor: UIColor?
    
    var fromPDF = false
    
    override func viewDidLoad() {
        navigationController!.navigationBarHidden = false
        
        let url = NSURL(string: "http://www.appfactoryuwp.com/about.php")
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }
    
    @IBAction func closeButtonTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController!.navigationBar.tintColor = backColor!
        webView.backgroundColor = UIColor.whiteColor()
        
        if fromPDF {
            navigationController!.navigationBar.barTintColor = UIColor.whiteColor()
        }
        oldNavColor = navigationController!.navigationBar.barTintColor
    }
    
    override func viewDidAppear(animated: Bool) {
        if fromPDF {
            navigationController!.navigationBar.barTintColor = oldNavColor
        }
    }
    
}
