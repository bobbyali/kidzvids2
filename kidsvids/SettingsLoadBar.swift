//
// SettingsLoadBar.swift
// Rehan Ali, 2nd April 2015
//
// View class for displaying a bar which grows and changes
// colour the longer the screen is touched.

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