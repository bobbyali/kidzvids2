//
// SettingsViewController.swift
// Rehan Ali, 2nd April 2015
//
// View Controller class which shows a simple page of 
// settings options for KidsVidz app.

import UIKit
import Snap

class SettingsViewController: UIViewController {

    var playlists: PlaylistCollection = PlaylistCollection.sharedInstance
    var numTotalPlaylists: Int = 5
    var labelPlaylists: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let topPadding = UIEdgeInsetsMake(80, 10, 10, 10)
        let padding = UIEdgeInsetsMake(10, 10, 10, -10)
        let superview = self.view
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!).colorWithAlphaComponent(0.5)
        
        labelPlaylists = UILabel(frame: CGRectMake(0, 0, 300, 200))
        //labelPlaylists.text = "\(self.playlists.list.count) Playlists out of \(self.numTotalPlaylists) currently used."
        labelPlaylists.text = NSLocalizedString("settings_total_pre", comment: "You have...") + String(self.playlists.list.count) + NSLocalizedString("settings_total_post", comment: "...Playlists set up.")
        
        //"You have \(self.playlists.list.count) Playlists set up."
        labelPlaylists.textColor = UIColor.whiteColor()
        labelPlaylists.font = UIFont(name: "Avenir", size: CGFloat(17))
        self.view.addSubview(labelPlaylists)
        
        labelPlaylists.snp_makeConstraints { make in
            make.top.equalTo(superview.snp_top).with.offset(topPadding.top)
            make.left.equalTo(superview.snp_left).with.offset(topPadding.left)
        }
        
        let editPlaylistButton   = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        editPlaylistButton.frame = CGRectMake(0, 0, 300, 200)
        editPlaylistButton.backgroundColor = UIColor.blackColor()
        editPlaylistButton.setTitle(NSLocalizedString("settings_button", comment: "Change or Edit Playlist"), forState: UIControlState.Normal)
        //editPlaylistButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        editPlaylistButton.layer.cornerRadius = 5
        editPlaylistButton.layer.borderWidth = 1
        editPlaylistButton.layer.borderColor = UIColor.whiteColor().CGColor
        editPlaylistButton.addTarget(self, action: "editPlaylistButton:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(editPlaylistButton)
        
        editPlaylistButton.snp_makeConstraints { make in
            make.top.equalTo(self.labelPlaylists.snp_bottom).with.offset(padding.top)
            make.left.equalTo(superview.snp_left).with.offset(padding.left)
            make.right.equalTo(superview.snp_right).with.offset(padding.right)
        }
        
        var labelSlider = UILabel(frame: CGRectMake(0, 0, 300, 200))
        labelSlider.text = NSLocalizedString("settings_size", comment: "Set size of video thumbnails")
        labelSlider.textColor = UIColor.whiteColor()
        labelSlider.font = UIFont(name: "Avenir", size: CGFloat(17))
        self.view.addSubview(labelSlider)

        labelSlider.snp_makeConstraints { make in
            make.top.equalTo(editPlaylistButton.snp_bottom).with.offset(padding.top)
            make.left.equalTo(superview.snp_left).with.offset(padding.left)
        }
        
        var slider = UISlider(frame: CGRectMake(0, 0, 300, 200))
        slider.addTarget(self, action: "changeImageScale:", forControlEvents: UIControlEvents.ValueChanged)
        slider.backgroundColor = nil
        slider.minimumValue = 0.2
        slider.maximumValue = 0.9
        slider.continuous = true
        slider.value = self.playlists.iconScale
        self.view.addSubview(slider)
        
        slider.snp_makeConstraints { make in
            make.top.equalTo(labelSlider.snp_bottom).with.offset(padding.top)
            make.left.equalTo(superview.snp_left).with.offset(padding.left)
            make.right.equalTo(superview.snp_right).with.offset(padding.right)
        }
                
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        //labelPlaylists.text = "You have \(self.playlists.list.count) Playlists set up."
        labelPlaylists.text = NSLocalizedString("settings_total_pre", comment: "You have...") + String(self.playlists.list.count) + NSLocalizedString("settings_total_post", comment: "...Playlists set up.")
    }
    
    // MARK: Buttons and Sliders
    func editPlaylistButton(sender:UIButton!) {
        let vc = PlaylistTableViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func changeImageScale(sender:UISlider!) {
        self.playlists.iconScale = sender.value
        self.playlists.saveCollection()
    }
    
    


}
