//
//  SliderObject.swift
//  SliderDemo
//
//  Created by Scott Hawley on 10/1/15.
//  Copyright © 2015 Scott Hawley. All rights reserved.
//

import UIKit

class SliderObject: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var slider : UISlider!

   
    override init(frame: CGRect) {
        // buiild the whole thing horizontally, then rotate it vertically
        let horizFrame = CGRectMake(frame.minX, frame.minY, frame.height, frame.width) // reverse width & height
        super.init(frame: horizFrame)
        
        
        // we give it a background color so the user can have something to pinch / pan / resize with
        self.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.1)
        

        let slider = UISlider(frame: horizFrame)
        let thumbImage : UIImage = UIImage(named: "customSliderThumb_R")!
        
        let ratio : CGFloat = 1.5*frame.width / thumbImage.size.width //0.075

        let size = CGSizeMake( thumbImage.size.width * ratio, thumbImage.size.height * ratio )
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 50
        slider.continuous = true
        slider.setThumbImage( self.imageWithImage(thumbImage, scaledToSize: size), forState: UIControlState.Normal )
        slider.center = CGPointMake(self.bounds.width/2, self.bounds.height/2)
         slider.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
        
        self.addSubview(slider)

        // here's where we make it vertical
        self.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        self.frame = frame  // move into final position
        
        slider.userInteractionEnabled = true
        self.userInteractionEnabled = true
    }
    
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func encodeWithCoder(coder: NSCoder) {
        super.encodeWithCoder(coder)
    }
    
    
    func sliderValueDidChange(sender:UISlider!)
    {
        print("value = \(sender.value)")
    }
    
    // rescales image of Thumb
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    
    //Allows gesture recognizers to fire outside parent views
    // https://github.com/mattneub/Programming-iOS-Book-Examples/blob/master/bk2ch05p210hitTesting/ch18p551hitTesting/ViewController.swift
    override func hitTest(point: CGPoint, withEvent e: UIEvent?) -> UIView? {
        if let result = super.hitTest(point, withEvent:e) {
            return result
        }
        //for sub in self.subviews.reverse() as! [UIView] {
        for sub in self.subviews.reverse()  {
            let pt = self.convertPoint(point, toView:sub)
            if let result = sub.hitTest(pt, withEvent:e) {
                return result
            }
        }
        return nil
    }
    
    
    func clone() -> SliderObject {
        let data = NSKeyedArchiver.archivedDataWithRootObject(self)
        let newObj = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! SliderObject!
        return newObj!
    }

    func gotresized() {
        let newFrame = CGRectMake( self.frame.minX * self.transform.a, self.frame.minY * self.transform.d, self.frame.width * self.transform.a, self.frame.height * self.transform.d)
        let newSO = SliderObject(frame: newFrame)
        
    }
}
