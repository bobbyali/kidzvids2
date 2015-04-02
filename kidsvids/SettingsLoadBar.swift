//
//  SettingsLoadBar.swift
//  kidsvids
//
//  Created by Bobby on 30/03/2015.
//  Copyright (c) 2015 Azuki Apps. All rights reserved.
//

import UIKit

class SettingsLoadBar: UIView {
    
    let xpos:Int = 20
    let height:Int = 10

    var width:Int = 0
    var ypos:Int = 0
    var maxWidth:Int = 100
    
    func setFrame() {
        self.frame = CGRect(x: self.xpos, y: self.ypos, width: self.width, height: self.height)
        self.backgroundColor = UIColor.redColor()
    }
    
    func setWidth(width:Int) {
        self.width = width
        setFrame()
    }
    
    func setYPos(ypos:Int) {
        self.ypos = ypos
        setFrame()
    }
    
    func animateBar() {
        UIView.animateWithDuration(1.0, animations: {
            self.frame.size.width = CGFloat(self.maxWidth)
        })
    }
    
    func animateSettingsLoaded() {
        UIView.animateWithDuration(0.2, animations: {
            self.backgroundColor = UIColor.greenColor()
        })
    }

}



/*
let touchPosition = sender.locationInView(self.collectionView)
longTouchIndicatorBar.frame = CGRect(x: 20, y: Int(touchPosition.y), width: 0, height: 10)

longTouchIndicatorBar.backgroundColor = UIColor.redColor()
collectionView?.addSubview(longTouchIndicatorBar)
UIView.animateWithDuration(2.5, animations: {
    self.longTouchIndicatorBar.frame.size.width = self.screenSize.width - 40
})

} else if sender.state == UIGestureRecognizerState.Ended {
    let touchPosition = sender.locationInView(self.collectionView)
    longTouchIndicatorBar.frame.size.width = 0
    longTouchIndicatorBar.removeFromSuperview()
}
*/