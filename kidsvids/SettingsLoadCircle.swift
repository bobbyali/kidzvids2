//
// SettingsLoadCircle.swift
// Rehan Ali, 16th April 2015
//
// View class for displaying a circle which grows and changes
// colour the longer the screen is touched.

import UIKit

class SettingsLoadCircle: UIView {
    
    var xpos:Int = 20
    var height:Int = 150
    var width:Int = 150
    var ypos:Int = 20
    var arcAngle:Float = 0.0
    let circleLayer: CAShapeLayer! = CAShapeLayer()
    
    func setFrame() {
        self.frame = CGRect(x: self.xpos - (width/2), y: self.ypos - (height/2), width: self.width, height: self.height)
        self.backgroundColor = UIColor.clearColor()
        
        // Use UIBezierPath as an easy way to create the CGPath for the layer.
        // The path should be the entire circle.
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 10)/2, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
        
        // Setup the CAShapeLayer with the path, colors, and line width
        //self.circleLayer
        self.circleLayer.path = circlePath.CGPath
        self.circleLayer.fillColor = UIColor.clearColor().CGColor
        self.circleLayer.strokeColor = UIColor.redColor().CGColor
        self.circleLayer.lineWidth = 5.0;
        
        // Don't draw the circle initially
        self.circleLayer.strokeEnd = 0.0
        
        // Add the circleLayer to the view's layer's sublayers
        layer.addSublayer(self.circleLayer)
    }
    
    func setCircleArcAngle(angle:Float) {
        self.arcAngle = angle
        setFrame()
    }
    
    func setPos(xpos:Int, ypos:Int) {
        self.xpos = xpos
        self.ypos = ypos
        setFrame()
    }
    
    func animateCircle(duration: NSTimeInterval) {
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        circleLayer.strokeEnd = 1.0
        
        // Do the actual animation
        circleLayer.addAnimation(animation, forKey: "animateCircle")
    }
        
    func animateSettingsLoaded() {
        UIView.animateWithDuration(0.2, animations: {
            self.circleLayer.strokeColor = UIColor.greenColor().CGColor
        })
    }
    
}