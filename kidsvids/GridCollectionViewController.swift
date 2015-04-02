//
// GridCollectionViewController.swift
// Rehan Ali, 2nd April 2015
//
// View Controller class which shows a grid of Youtube videos
// through a controller view container. User can select a video
// cell to initiate video playback, or do a long press to call the
// settings screen.

import UIKit

let mySpecialNotificationKey = "com.azukiapps.fetchedVideoIDs"

class GridCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIGestureRecognizerDelegate, UIScrollViewDelegate, NetworkImporterDelegate {

    private let reuseIdentifier = "videoCell"
    
    var collectionView: UICollectionView?
    
    var playlists: PlaylistCollection = PlaylistCollection.sharedInstance
    var screenSize: CGRect = UIScreen.mainScreen().bounds
    var infoLabel: UILabel = UILabel()
    var settingsLoadBar: SettingsLoadBar = SettingsLoadBar(frame: CGRect(x: 20, y: 0, width: 0, height: 20))
    
    var longPressInit = UILongPressGestureRecognizer()
    var longPressFinal = UILongPressGestureRecognizer()
    var importer: NetworkImporter!
    var activityIndicatorView: UIActivityIndicatorView!
    var loadedTwoSetsForiPad: Bool = false
    var fetchingResults: Bool = false
    
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
        
        infoLabel = UILabel(frame: CGRect(x: 10, y: 0, width: screenSize.width-40, height: 20))
        infoLabel.text = "Tap and hold for settings"
        infoLabel.numberOfLines = 2
        infoLabel.textColor = UIColor.whiteColor()
        infoLabel.textAlignment = NSTextAlignment.Center
        collectionView?.addSubview(infoLabel)
        
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
        
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        view.addSubview(activityIndicatorView)
        activityIndicatorView.center = view.center
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.stopAnimating()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        // refresh view with latest videos after returning from settings view controller
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        refreshViewController()
    }
    
    override func viewDidLayoutSubviews() {
        // need to do this to get screen bounds to update during rotation
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView?.frame = self.view.frame
        
        self.infoLabel.frame.size.width = self.view.frame.width - 40
        self.settingsLoadBar.maxWidth = Int(self.view.frame.width - 40)

        refreshViewController()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    

    // MARK: UICollectionViewDataSource

     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


     func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return playlists.getCurrentPlaylist().videoIDs.count
    }

     func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
        // Configure the cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as VideoPhotoCell
        let videoPhotoURL = "http://img.youtube.com/vi/" + playlists.getCurrentPlaylist().videoIDs[indexPath.row] + "/0.jpg"
        cell.backgroundColor = UIColor.blackColor()
        cell.videoPhotoCell.setImageWithURL(NSURL(string: videoPhotoURL ))
        cell.videoPhotoCell.frame = cell.contentView.bounds;
        cell.videoPhotoCell.autoresizingMask = UIViewAutoresizing.FlexibleWidth|UIViewAutoresizing.FlexibleHeight;
            
        return cell
    }
    
    // MARK: Collection view flow delegate
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
            
            let isLandscape = UIApplication.sharedApplication().statusBarOrientation.isLandscape
            var iconWidth: CGFloat
            if isLandscape {
                iconWidth = (self.view.frame.width - 50) * CGFloat(self.playlists.iconScale / 2)
            } else {
                iconWidth = (self.view.frame.width - 50) * CGFloat(self.playlists.iconScale)
            }
            return CGSize(width: iconWidth, height: iconWidth * 0.77)
            
            
    }
    
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    func collectionView(collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath) {

            let vc = PlayerViewController()
            vc.videoID = self.playlists.getCurrentPlaylist().videoIDs[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: Events
    func refreshViewController() {
        
        var currentPlaylist = self.playlists.getCurrentPlaylist()
        if currentPlaylist.videoIDs.count == 0 {
            // fetch videos when presented with an empty playlist
            if !fetchingResults {
                // prevent multiple fetches when app starts
                fetchingResults = true
                importer = NetworkImporter()
                importer.delegate = self
                activityIndicatorView.startAnimating()
                importer.fetchNextSetOfVideoIDs()
            }
        } else {
            self.collectionView?.reloadData()
        }
        
        if let collectionView = self.collectionView {
            collectionView.backgroundColor = UIColor.blackColor()
        }
    }
    
    // MARK: Actions
    func gestureRecognizer(UILongPressGestureRecognizer,
        shouldRecognizeSimultaneouslyWithGestureRecognizer:UILongPressGestureRecognizer) -> Bool {
            return true
    }
    
    func showLongTouchLoadInProgress(sender: UILongPressGestureRecognizer) {
        let touchPosition = sender.locationInView(self.collectionView)
        if sender.state == UIGestureRecognizerState.Began {
            self.settingsLoadBar.setYPos(Int(touchPosition.y))
            collectionView?.addSubview(self.settingsLoadBar)
            self.settingsLoadBar.animateBar()
        } else if sender.state == UIGestureRecognizerState.Ended {
            self.settingsLoadBar.setWidth(0)
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
            if !fetchingResults {
                // make sure results are only fetched once, if the
                // scroll-to-bottom action is triggered multiple times
                activityIndicatorView.startAnimating()
                var isLastPage = importer.fetchNextSetOfVideoIDs()
                if isLastPage {
                    activityIndicatorView.stopAnimating()
                }
                self.fetchingResults = true
            }

        }
    }
    
    // MARK: Delegate methods
    func fetchCompleted(nextPageToken:String?, lastPage:Bool) {
        if let token = nextPageToken {
            importer.nextPageToken = token
        } else {
            importer.nextPageToken = nil
        }
        importer.lastPage = lastPage
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            // do second fetch on iPad to take up the whole screen and
            // enable scrolling
            if self.loadedTwoSetsForiPad == false {
                self.loadedTwoSetsForiPad = true
                importer.fetchNextSetOfVideoIDs()
            }
        }
        
        activityIndicatorView.stopAnimating()
        self.fetchingResults = false
        self.collectionView?.reloadData()
    }
    
}
