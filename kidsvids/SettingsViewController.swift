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
        let padding = UIEdgeInsetsMake(10, 10, 10, -50)
        let superview = self.view
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        labelPlaylists = UILabel(frame: CGRectMake(0, 0, 300, 200))
        labelPlaylists.text = "\(self.playlists.list.count) Playlists out of \(self.numTotalPlaylists) currently used."
        labelPlaylists.textColor = UIColor.whiteColor()
        labelPlaylists.font = UIFont(name: "Avenir", size: CGFloat(17))
        self.view.addSubview(labelPlaylists)
        
        labelPlaylists.snp_makeConstraints { make in
            make.top.equalTo(superview.snp_top).with.offset(topPadding.top)
            make.left.equalTo(superview.snp_left).with.offset(topPadding.left)
        }
        
        let editPlaylistButton   = UIButton.buttonWithType(UIButtonType.System) as UIButton
        editPlaylistButton.frame = CGRectMake(0, 0, 300, 200)
        editPlaylistButton.backgroundColor = UIColor.blackColor()
        editPlaylistButton.setTitle("Change or Edit Playlists", forState: UIControlState.Normal)
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
        labelSlider.text = "Set size of video thumbnails:"
        labelSlider.textColor = UIColor.whiteColor()
        labelSlider.font = UIFont(name: "Avenir", size: CGFloat(17))
        self.view.addSubview(labelSlider)

        labelSlider.snp_makeConstraints { make in
            make.top.equalTo(editPlaylistButton.snp_bottom).with.offset(padding.top)
            make.left.equalTo(superview.snp_left).with.offset(padding.left)
        }
        
        var slider = UISlider(frame: CGRectMake(0, 0, 300, 200))
        slider.addTarget(self, action: "changeImageScale:", forControlEvents: UIControlEvents.ValueChanged)
        slider.backgroundColor = UIColor.blackColor()
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
        self.labelPlaylists.text = "\(self.playlists.list.count) Playlists out of \(self.numTotalPlaylists) currently used."
        
    }
    
    // MARK: Buttons and Sliders
    func editPlaylistButton(sender:UIButton!) {
        let vc = PlaylistTableViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func changeImageScale(sender:UISlider!) {
        self.playlists.iconScale = sender.value
    }

}
