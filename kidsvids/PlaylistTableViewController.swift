//
// PlaylistTableViewController.swift
// Rehan Ali, 2nd April 2015
//
// View Controller class which shows a table view of Playlists for 
// selecting / editing

import UIKit

class PlaylistTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PlaylistTableViewCellDelegate {
    
    var tableView:UITableView!
    var playlists: PlaylistCollection = PlaylistCollection.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let newButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addPlaylistButton:")
        self.navigationItem.rightBarButtonItem = newButton
        
        tableView = UITableView(frame: self.view.frame, style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(PlaylistTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        tableView.rowHeight = 44;
        self.view.addSubview(tableView)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
        var currentPlaylistID = NSIndexPath(forRow: playlists.currentPlaylist, inSection: 0)
        //tableView.selectRowAtIndexPath(currentPlaylistID, animated: false, scrollPosition: UITableViewScrollPosition.None)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.playlists.list.count
    }
    
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier") as? PlaylistTableViewCell
        
        if let newCell = cell {
            newCell.delegate = self
            newCell.playlistIndex = indexPath.row
            if var label = newCell.titleLabel {
                label.text = self.playlists.list[indexPath.row].title
            }
        }

        return cell!
    }
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.playlists.currentPlaylist = indexPath.row
    }
    
    // MARK: Buttons
    func addPlaylistButton(sender:UIButton!) {
        let targetVC = PlaylistDetailsViewController()
        targetVC.isNewPlaylist = true
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    
    // MARK: Delegate methods
    func editButton(playlistIndex:Int) {
        playlists.currentPlaylist = playlistIndex
        let targetVC = PlaylistDetailsViewController()
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    
}
