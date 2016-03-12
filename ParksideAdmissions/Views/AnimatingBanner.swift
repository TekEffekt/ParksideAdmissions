//
//  AnimatingBanner.swift
//  ParksideAdmissions
//
//  Created by Kyle Zawacki on 1/20/16.
//  Copyright © 2016 University Of Wisconsin Parkside. All rights reserved.
//

import UIKit

class AnimatingBanner: UIView {

    let text: UIImageView
    let gear: UIImageView
    let mask: UIView
    
    var justLoaded = true
    
    var time = 0
    
    init(frame: CGRect, andColor color:UIColor) {
        text = UIImageView()
        gear = UIImageView()
        mask = UIView()
        super.init(frame: frame)
        text.image = UIImage(named: "Text")
        gear.image = UIImage(named: "Gear")
        
        gear.frame = CGRect(x: (bounds.width * 0.37) - 45, y: (bounds.height / 2) - 22.5, width: 45, height: 45)
        text.frame = CGRect(x: gear.frame.origin.x - 250, y: (bounds.height / 2) - 12.5, width: 250, height: 25)
        mask.frame = CGRect(x: 0, y: gear.frame.origin.y, width: gear.frame.origin.x + gear.frame.width/2, height: gear.frame.height)
        gear.transform = CGAffineTransformMakeScale(0, 0)
        
        addSubview(text)
        addSubview(mask)
        addSubview(gear)
        
        backgroundColor = color
        mask.backgroundColor = backgroundColor
        
        setupAnimationTimer()
        
        userInteractionEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAnimationTimer() {
        NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: "playAnimation", userInfo: nil, repeats: true)
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timeCount", userInfo: nil, repeats: true)
        
        playAnimation()
    }
    
    private func reloadAnimation() {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.text.alpha = 0.0
            self.gear.alpha = 0.0
            }) { (Bool) -> Void in
                self.startAnimation()
        }
    }
    
    func timeCount() {
        time += 1
    }
    
    func playAnimation() {
        if !justLoaded {
            reloadAnimation()
        } else {
            justLoaded = false
            startAnimation()
        }        
    }
    
    func startAnimation() {
        gear.alpha = 1
        gear.transform = CGAffineTransformMakeScale(0, 0)
        text.frame.origin.x = gear.frame.origin.x - 250
        text.alpha = 0.0
        
        UIView.animateWithDuration(0.7, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: [], animations: { () -> Void in
            self.gear.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }) { (Bool) -> Void in
                let rotate = CABasicAnimation(keyPath: "transform.rotation")
                rotate.fromValue = (360 * M_PI) / 180
                rotate.toValue = 0.0
                rotate.duration = 1.5
                rotate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                self.gear.layer.addAnimation(rotate, forKey: "rotate")
                
                UIView.animateWithDuration(1.5, delay: 0, options: [.CurveEaseInOut], animations: { () -> Void in
                    self.text.frame.origin.x = self.gear.frame.origin.x + self.gear.frame.width + 10
                    self.text.alpha = 1
                    }, completion: nil)
        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
