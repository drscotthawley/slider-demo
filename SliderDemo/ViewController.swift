//
//  ViewController.swift
//  SliderDemo
//
//  Created by Scott Hawley on 10/1/15.
//  Copyright © 2015 Scott Hawley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var rootView: UIView!

    var mySlider : SliderObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mySlider = SliderObject(frame: CGRectMake(150, 150, 40, 200))
        rootView.addSubview(mySlider)
        
        
        let pan:UIPanGestureRecognizer = UIPanGestureRecognizer(target:self, action:Selector("handlePan:"))
         mySlider.addGestureRecognizer(pan)
        let pinch:UIPinchGestureRecognizer = UIPinchGestureRecognizer(target:self, action:Selector("handlePinch:"))
        mySlider.addGestureRecognizer(pinch)
    }
    
    
    func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPointZero, inView: self.view)
    }
    
    func handlePinch(recognizer : UIPinchGestureRecognizer) {
        if let view = recognizer.view {
            let touch0: CGPoint = recognizer.locationOfTouch(0, inView: view)
            let touch1: CGPoint = recognizer.locationOfTouch(1, inView: view)
            let tangent: CGFloat = abs((touch1.y - touch0.y) / (touch1.x - touch0.x))
            if (tangent >  1) { //horizontal - remember we flip x & y inside SliderObject
                view.transform = CGAffineTransformScale(view.transform,
                    1, recognizer.scale)
            } else if (tangent < 1) {  // verticalview.
                view.transform = CGAffineTransformScale(view.transform,
                recognizer.scale, 1)
            } else {   // perfectly 45 degrees
                view.transform = CGAffineTransformScale(view.transform,
                    recognizer.scale, recognizer.scale)
            }
            
            
            recognizer.scale = 1
        }
        
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

