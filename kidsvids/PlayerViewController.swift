//
//  PlayerViewController.swift
//  kidsvids
//
//  Created by Bobby on 30/03/2015.
//  Copyright (c) 2015 Azuki Apps. All rights reserved.
//

import UIKit
import XCDYouTubeKit

class PlayerViewController: UIViewController {

    var videoID: String?
    var player: XCDYouTubeVideoPlayerViewController?
    var firstPlay:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
