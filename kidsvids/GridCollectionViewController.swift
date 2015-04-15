//
// GridCollectionViewController.swift
// Rehan Ali, 2nd April 2015
//
// View Controller class which shows a grid of Youtube videos
// through a controller view container. User can select a video
// cell to initiate video playback, or do a long press to call the
// settings screen.
// (extra comment line)

import UIKit
import EAIntroView

let mySpecialNotificationKey = "com.azukiapps.fetchedVideoIDs"

class GridCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIGestureRecognizerDelegate, UIScrollViewDelegate, NetworkImporterDelegate, EAIntroDelegate {

    private let reuseIdentifier = "videoCell"
    
    var collectionView: UICollectionView?
    
    var playlists: PlaylistCollection = PlaylistCollection.sharedInstance
    var screenSize: CGRect = UIScreen.mainScreen().bounds
    var topInfoLabel: UILabel = UILabel()
    var bottomInfoLabel: UILabel = UILabel()
    var settingsLoadBar: SettingsLoadBar = SettingsLoadBar(frame: CGRect(x: 20, y: 0, width: 0, height: 20))
    
    var longPressInit = UILongPressGestureRecognizer()
    var longPressFinal = UILongPressGestureRecognizer()
    var importer: NetworkImporter! = NetworkImporter()
    var activityIndicatorView: UIActivityIndicatorView!
    var loadedTwoSetsForiPad: Bool = false
    var isDataReady: Bool = false
    var updateCells: Bool = false
    var inIntro: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerClass(VideoPhotoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView!.backgroundColor = UIColor.blackColor()
        collectionView!.alwaysBounceVertical = true
        self.view.addSubview(collectionView!)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        topInfoLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 20))
        topInfoLabel.text = "Tap and hold for settings"
        topInfoLabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(12))
        topInfoLabel.numberOfLines = 1
        topInfoLabel.textColor = UIColor.whiteColor()
        topInfoLabel.textAlignment = NSTextAlignment.Center
        topInfoLabel.backgroundColor = UIColor.blackColor()
        topInfoLabel.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        //                 cell.videoPhotoCell.autoresizingMask = UIViewAutoresizing.FlexibleWidth|UIViewAutoresizing.FlexibleHeight;
        self.view.addSubview(topInfoLabel)
        
        
        bottomInfoLabel = UILabel(frame: CGRect(x: 0, y: screenSize.height-20, width: screenSize.width, height: 20))
        bottomInfoLabel.text = "Scroll to bottom to fetch more videos"
        bottomInfoLabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(12))
        bottomInfoLabel.numberOfLines = 1
        bottomInfoLabel.textColor = UIColor.whiteColor()
        bottomInfoLabel.textAlignment = NSTextAlignment.Center
        bottomInfoLabel.backgroundColor = UIColor.blackColor()
        bottomInfoLabel.autoresizingMask = UIViewAutoresizing.FlexibleWidth|UIViewAutoresizing.FlexibleTopMargin
        self.view.addSubview(bottomInfoLabel)
        
        longPressInit = UILongPressGestureRecognizer(target: self, action: "showLongTouchLoadInProgress:")
        longPressInit.minimumPressDuration = 0.5
        longPressInit.numberOfTapsRequired = 0
        longPressInit.numberOfTouchesRequired = 1
        longPressInit.delegate = self
        self.view.addGestureRecognizer(longPressInit)
        
        longPressFinal = UILongPressGestureRecognizer(target: self, action: "showLongTouchLoadReady:")
        longPressFinal.minimumPressDuration = 1.5
        longPressFinal.numberOfTapsRequired = 0
        longPressFinal.numberOfTouchesRequired = 1
        longPressFinal.delegate = self
        self.view.addGestureRecognizer(longPressFinal)
        
        
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
        
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        view.addSubview(activityIndicatorView)
        activityIndicatorView.center = view.center
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.stopAnimating()
        
        showIntro()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        // refresh view with latest videos after returning from settings view controller
        self.collectionView?.contentOffset = CGPointZero
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        println("1 viewWillAppear")
        self.isDataReady = false
        refreshViewController()
    }
    
    override func viewDidLayoutSubviews() {
        // need to do this to get screen bounds to update during rotation
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView?.frame = self.view.frame
        self.settingsLoadBar.maxWidth = Int(self.view.frame.width - 40)
        println("2 viewDidLayoutSubviews")
        self.isDataReady = true
        refreshViewController()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    

    // MARK: UICollectionViewDataSource

     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return !self.importer.isBusy ? 1 : 0
    }


     func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        if let currentPlaylist = playlists.getCurrentPlaylist() {
            return !self.importer.isBusy ? currentPlaylist.videoIDs.count : 0
        } else {
            return 0
        }
            
    }

     func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
        // Configure the cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! VideoPhotoCell
            
        if let currentPlaylist = playlists.getCurrentPlaylist() {
            if self.isDataReady {
                let videoPhotoURL = "http://img.youtube.com/vi/" + currentPlaylist.videoIDs[indexPath.row] + "/0.jpg"
                cell.backgroundColor = UIColor.blackColor()
                cell.videoPhotoCell.setImageWithURL(NSURL(string: videoPhotoURL ))
                cell.videoPhotoCell.frame = cell.contentView.bounds;
                cell.videoPhotoCell.autoresizingMask = UIViewAutoresizing.FlexibleWidth|UIViewAutoresizing.FlexibleHeight;
            }
        }
            
        return cell
    }
    
    // MARK: Collection view flow delegate
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            let isLandscape = UIApplication.sharedApplication().statusBarOrientation.isLandscape
            var iconWidth: CGFloat
            if isLandscape {
                iconWidth = (self.view.frame.width - 50) * CGFloat(self.playlists.iconScale / 2)
            } else {
                iconWidth = (self.view.frame.width - 50) * CGFloat(self.playlists.iconScale)
            }
            return CGSize(width: iconWidth, height: iconWidth * 0.77)
            
            
    }
    
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 50.0, bottom: 20.0, right: 50.0)
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    func collectionView(collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath) {

            let vc = PlayerViewController()
            if let currentPlaylist = self.playlists.getCurrentPlaylist() {
                vc.videoID = currentPlaylist.videoIDs[indexPath.row]
            }
            self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: Events
    func refreshViewController() {
        
        if let currentPlaylist = self.playlists.getCurrentPlaylist() {
            if currentPlaylist.videoIDs.count == 0 {
                // fetch videos when presented with an empty playlist
                if !self.importer.isBusy {
                    self.importer.delegate = self
                    self.isDataReady = false
                    self.activityIndicatorView.startAnimating()
                    if let currentPlaylist = self.playlists.getCurrentPlaylist() {
                        if currentPlaylist.getNumberOfVideos() == 0 {
                            self.importer.firstPage = true
                        }
                    }
                    self.importer.fetchNextSetOfVideoIDs()
                }
            } else {
                self.collectionView?.reloadData()
            }
        }
        
        if let collectionView = self.collectionView {
            collectionView.backgroundColor = UIColor.blackColor()
        }
    }
    
    // MARK: Actions
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func showLongTouchLoadInProgress(sender: UILongPressGestureRecognizer) {
        let touchPosition = sender.locationInView(self.collectionView)
        if sender.state == UIGestureRecognizerState.Began {
            self.settingsLoadBar.setYPos(Int(touchPosition.y))
            self.collectionView?.addSubview(self.settingsLoadBar)
            self.settingsLoadBar.animateBar()
        } else if sender.state == UIGestureRecognizerState.Ended {
            self.settingsLoadBar.setBarWidth(0)
            self.settingsLoadBar.removeFromSuperview()
        }
    }
    
    // a long tap is used to open the settings view controller
    func showLongTouchLoadReady(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Ended {
            let vc = SettingsViewController()
            self.navigationController?.pushViewController(vc, animated: true)

        } else if sender.state == UIGestureRecognizerState.Began {
            self.settingsLoadBar.animateSettingsLoaded()
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var scrollViewHeight = scrollView.frame.size.height;
        var scrollContentSizeHeight = scrollView.contentSize.height;
        var scrollOffset = scrollView.contentOffset.y;

        if (scrollOffset + scrollViewHeight > (scrollContentSizeHeight-10))
        {
            // scrolling hits bottom of screen
            if !self.importer.isBusy {
                self.activityIndicatorView.startAnimating()
                var isLastPage = self.importer.fetchNextSetOfVideoIDs()
                if isLastPage {
                    self.activityIndicatorView.stopAnimating()
                }
            }
        }        
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if !self.inIntro && self.isDataReady {
            if (sender.direction == .Left) {
                println("Swipe Left")
                self.playlists.getPreviousPlaylist()
            }
            if (sender.direction == .Right) {
                println("Swipe Right")
                self.playlists.getNextPlaylist()
            }
            refreshViewController()
        }
    }
    
    
    // MARK: Delegate methods
    func fetchCompleted(nextPageToken:String?, lastPage:Bool) {
        if let token = nextPageToken {
            self.importer.nextPageToken = token
        } else {
            self.importer.nextPageToken = nil
        }
        self.importer.lastPage = lastPage
        self.importer.firstPage = false
        self.activityIndicatorView.stopAnimating()
        self.importer.isBusy = false
        self.isDataReady = true
        println("a fetchCompleted")
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            // do second fetch on iPad to take up the whole screen and
            // enable scrolling
            if self.loadedTwoSetsForiPad == false {
                self.loadedTwoSetsForiPad = true
                self.importer.fetchNextSetOfVideoIDs()
            }
        }
        
        self.collectionView?.reloadData()
    }
    
    func fetchFailed() {
        // need to do a new notification for failure
        var alert = UIAlertController(title: "Alert", message: "Cannot reach YouTube. Please try again later.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        self.activityIndicatorView.stopAnimating()
        self.importer.isBusy = false
        self.isDataReady = true
        println("b fetchFailed")
    }
    
    // MARK: Intro screens
    func showIntro() {
        
        self.inIntro = true
        
        var page1: EAIntroPage = EAIntroPage()
        page1.title = "Welcome to KidsVids!"
        page1.desc = "KidsVids is a safe and simple YouTube player designed to be used by children over the age of 2."
        page1.titleIconView = UIImageView(image: UIImage(named: "Phone and Tick"))
        page1.bgColor = UIColor.blackColor()

        
        var page2: EAIntroPage = EAIntroPage()
        page2.title = "Child Friendly Videos"
        page2.desc = "KidsVids restricts videos to YouTube playlists containing child-friendly videos. There are several included, and you can also add your own custom Playlists."
        page2.titleIconView = UIImageView(image: UIImage(named: "YouTube Tick"))
        page2.titleIconPositionY = 100
        page2.bgColor = UIColor.blackColor()
        
        
        var page3: EAIntroPage = EAIntroPage()
        page3.title = "Easy To Use"
        page3.desc = "KidsVids shows a grid of pictures of videos from a YouTube Playlist. Children can start a video by touching a picture. When the video ends, KidsVids automatically returns to the grid."
        page3.titleIconView = UIImageView(image: UIImage(named: "Grid"))
        page3.bgColor = UIColor.blackColor()
        
        var page4: EAIntroPage = EAIntroPage()
        page4.title = "Simple Controls"
        page4.desc = "There are no buttons to press. To stop a video early, simply shake the device. To load more videos, scroll down. To change playlists, swipe to the side."
        page4.titleIconView = UIImageView(image: UIImage(named: "Phone and Gestures"))
        page4.bgColor = UIColor.blackColor()
        
        var page5: EAIntroPage = EAIntroPage()
        page5.title = "Settings"
        page5.desc = "To access the settings menu, touch and hold the screen for a few seconds. You'll see a red bar appear. When it turns green, stop touching the screen, and the settings screen will load."
        page5.titleIconView = UIImageView(image: UIImage(named: "Phone and Touch"))
        page5.bgColor = UIColor.blackColor()

        var page6: EAIntroPage = EAIntroPage()
        page6.title = "Have Fun!"
        page6.desc = "If you need any assistance or have any feedback, you can contact us at support@azukiapps.co.uk."
        page6.titleIconView = UIImageView(image: UIImage(named: "Phone and Tick"))
        page6.bgColor = UIColor.blackColor()
        
        var intro: EAIntroView = EAIntroView(frame: self.view.bounds, andPages: [page1 , page2, page3, page4, page5, page6])
        intro.delegate = self
        intro.showInView(self.view, animateDuration: 0.3)

    }
    
    func introDidFinish(introView: EAIntroView!) {
        println("intro ended")
        self.inIntro = false
    }
    
    // MARK: Orientations
    override func shouldAutorotate() -> Bool {
        println("checking rotations...")
        if self.inIntro {
            return false
        } else {
            return true
        }
    }
    
    override func supportedInterfaceOrientations() -> Int {
        println("rotations...")
        if self.inIntro {
            return Int(UIInterfaceOrientationMask.Portrait.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }
    
}
