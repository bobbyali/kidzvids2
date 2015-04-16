//
// PlaylistDetailsViewController.swift
// Rehan Ali, 2nd April 2015
//
// View Controller class which shows a form for modifying
// playlist details (title / playlist ID)

import UIKit

class PlaylistDetailsViewController: UIViewController, NetworkCheckerDelegate {

    var playlistTitleField: UITextField!
    var playlistIDField: UITextField!
    var playlists: PlaylistCollection = PlaylistCollection.sharedInstance
    var isNewPlaylist: Bool = false
    var playlistValidator: NetworkImporter! = NetworkImporter()
    var inputPlaylistID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!).colorWithAlphaComponent(0.5)
        
        let newButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "savePlaylist:")
        self.navigationItem.rightBarButtonItem = newButton
        
        let topPadding = UIEdgeInsetsMake(80, 10, 10, 10)
        let padding = UIEdgeInsetsMake(10, 10, 10, -10)
        let superview = self.view
        
        var playlistTitleLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 300, height: 200))
        playlistTitleLabel.text = NSLocalizedString("playlist_title", comment: "Playlist Title")
        playlistTitleLabel.textColor = UIColor.whiteColor()
        playlistTitleLabel.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
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
            if let currentPlaylist = playlists.getCurrentPlaylist() {
                playlistTitleField.text = currentPlaylist.title
            }
        }
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
        playlistIDLabel.text = NSLocalizedString("playlist_id", comment: "Playlist ID")

        playlistIDLabel.textColor = UIColor.whiteColor()
        playlistIDLabel.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
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
            if let currentPlaylist = playlists.getCurrentPlaylist() {
                playlistIDField.text = currentPlaylist.playlistID
            }
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
        
        self.playlistValidator.checker = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Buttons
    func savePlaylist(sender:UIButton!) {
        if self.playlistTitleField.text == "" || self.playlistIDField.text == "" {
            var alert = UIAlertController(title: "Can't Leave Anything Blank", message: "Please make sure you've filled in both boxes.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Return", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        self.inputPlaylistID = processStringForPlaylistID(self.playlistIDField.text)
        self.playlistValidator.checkPlaylistIDValidity(self.inputPlaylistID!)
    }

    func processStringForPlaylistID(url:String) -> String {
        
        if url.rangeOfString("list") != nil {
            var queryStrings = [String: String]()
            var urlPieces = url.componentsSeparatedByString("?")
            for qs in urlPieces[1].componentsSeparatedByString("&") {
                // Get the parameter name
                let key = qs.componentsSeparatedByString("=")[0]
                // Get the parameter name
                var value = qs.componentsSeparatedByString("=")[1]
                value = value.stringByReplacingOccurrencesOfString("+", withString: " ")
                value = value.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                
                queryStrings[key] = value
            }
            //println("playlistID = " + queryStrings["list"]!)
            return queryStrings["list"]!
        } else {
            return url
        }
    }
    
    func validityCheck(passed:Bool) {
        if passed {
            println("Save playlist")
            if self.isNewPlaylist {
                var newPlaylist = Playlist(title: self.playlistTitleField.text, playlistID: self.inputPlaylistID!)
                self.playlists.list.append(newPlaylist)
                self.playlists.currentPlaylist = self.playlists.list.count-1
            } else {
                if let currentPlaylist = self.playlists.getCurrentPlaylist() {
                    currentPlaylist.title = self.playlistTitleField.text
                    currentPlaylist.playlistID = self.inputPlaylistID!
                }
            }
            self.playlists.saveCollection()
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            println("Don't save playlist")
            var alert = UIAlertController(title: "PlaylistID Not Valid", message: "The PlaylistID or URL you entered wasn't valid.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Return", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

        }
    }
    
}
