//
//  PlaylistDetailsViewController.swift
//  kidsvids
//
//  Created by Bobby on 01/04/2015.
//  Copyright (c) 2015 Azuki Apps. All rights reserved.
//

import UIKit

class PlaylistDetailsViewController: UIViewController {

    var playlistTitleField: UITextField!
    var playlistIDField: UITextField!
    var playlists: PlaylistCollection = PlaylistCollection.sharedInstance
    var isNewPlaylist: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let newButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "savePlaylist:")
        self.navigationItem.rightBarButtonItem = newButton
        
        let topPadding = UIEdgeInsetsMake(80, 10, 10, 10)
        let padding = UIEdgeInsetsMake(10, 10, 10, -50)
        let superview = self.view
        
        var playlistTitleLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 300, height: 200))
        playlistTitleLabel.text = "Playlist Title"
        playlistTitleLabel.textColor = UIColor.whiteColor()
        playlistTitleLabel.textAlignment = NSTextAlignment.Left
        playlistTitleLabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(17))
        self.view.addSubview(playlistTitleLabel)
        playlistTitleLabel.snp_makeConstraints { make in
            make.top.equalTo(superview.snp_top).with.offset(topPadding.top)
            make.left.equalTo(superview.snp_left).with.offset(topPadding.left)
        }
        
        playlistTitleField = UITextField(frame: CGRectMake(20, 20, 300, 200))
        playlistTitleField.placeholder = "Trucks"
        if !self.isNewPlaylist {
            playlistTitleField.text = playlists.getCurrentPlaylist().title
        }
        playlistTitleField.backgroundColor = UIColor.blackColor()
        playlistTitleField.textColor = UIColor.whiteColor()
        playlistTitleField.layer.borderWidth = 1
        playlistTitleField.layer.borderColor = UIColor.whiteColor().CGColor
        self.view.addSubview(playlistTitleField)
        playlistTitleField.snp_makeConstraints { make in
            make.top.equalTo(playlistTitleLabel.snp_bottom).with.offset(padding.top)
            make.left.equalTo(superview.snp_left).with.offset(padding.left)
            make.right.equalTo(superview.snp_right).with.offset(padding.right)
        }

        var playlistIDLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 300, height: 200))
        playlistIDLabel.text = "Playlist ID"
        playlistIDLabel.textColor = UIColor.whiteColor()
        playlistIDLabel.textAlignment = NSTextAlignment.Left
        playlistIDLabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(17))
        self.view.addSubview(playlistIDLabel)
        playlistIDLabel.snp_makeConstraints { make in
            make.top.equalTo(self.playlistTitleField.snp_bottom).with.offset(padding.top)
            make.left.equalTo(superview.snp_left).with.offset(padding.left)
        }
        
        playlistIDField = UITextField(frame: CGRectMake(20, 20, 300, 200))
        playlistIDField.placeholder = "PL35F93FA3C740F3BB"
        if !self.isNewPlaylist {
            playlistIDField.text = playlists.getCurrentPlaylist().playlistID
        }
        playlistIDField.textColor = UIColor.whiteColor()
        playlistIDField.layer.borderWidth = 1
        playlistIDField.layer.borderColor = UIColor.whiteColor().CGColor
        self.view.addSubview(playlistIDField)
        playlistIDField.snp_makeConstraints { make in
            make.top.equalTo(playlistIDLabel.snp_bottom).with.offset(padding.top)
            make.left.equalTo(superview.snp_left).with.offset(padding.left)
            make.right.equalTo(superview.snp_right).with.offset(padding.right)
        }
        
        self.view.backgroundColor = UIColor.blackColor()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func savePlaylist(sender:UIButton!) {
        if isNewPlaylist {
            var newPlaylist = Playlist(title: self.playlistTitleField.text, playlistID: self.playlistIDField.text)
            self.playlists.list.append(newPlaylist)
            self.playlists.currentPlaylist = self.playlists.list.count-1
        } else {
            self.playlists.getCurrentPlaylist().title = self.playlistTitleField.text
            self.playlists.getCurrentPlaylist().playlistID = self.playlistIDField.text
        }
        self.navigationController?.popViewControllerAnimated(true)
    }

}
