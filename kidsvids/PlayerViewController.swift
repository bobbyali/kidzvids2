//
// PlayerViewController.swift
// Rehan Ali, 2nd April 2015
//
// View Controller class which loads the selected Youtube
// video using the YouTube Player CocoaPod.

import UIKit
import XCDYouTubeKit

class PlayerViewController: UIViewController {

    var videoID: String?
    var player: XCDYouTubeVideoPlayerViewController?
    var firstPlay:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        player = XCDYouTubeVideoPlayerViewController(videoIdentifier: videoID)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "moviePlayerPlaybackDidFinish:",
            name: MPMoviePlayerPlaybackDidFinishNotification,
            object: self.player?.moviePlayer)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if firstPlay {
            firstPlay = false
            self.presentMoviePlayerViewControllerAnimated(player)
        }
        
    }
    
    func moviePlayerPlaybackDidFinish(notification: NSNotification) {
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: MPMoviePlayerPlaybackDidFinishNotification,
            object: notification.object)
        
        self.player?.removeFromParentViewController()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
}
