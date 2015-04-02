//
// NetworkImporter.swift
// Rehan Ali, 30th March 2015
//
// Service class used by Playlist model for fetching videoIDs from YouTube API

import UIKit
import AFNetworking

protocol NetworkImporterDelegate {
    func fetchCompleted(nextPageToken:String?, lastPage:Bool)
}

class NetworkImporter {

    let youtubePlaylistURLPrefix:String = "https://www.googleapis.com/youtube/v3/playlistItems?part=contentDetails&playlistId="
    let youtubeKeySuffix:String = "&key=AIzaSyDG2hPqOEDnKeaBW365MCc9KFZVHB8LUYs"
    
    var searchString:String = ""
    var nextPageToken:String?
    var firstPage:Bool = true
    var lastPage:Bool = false
    
    var playlists: PlaylistCollection = PlaylistCollection.sharedInstance
    var delegate: NetworkImporterDelegate?
    
    // MARK: Public Methods
    init() {
    }
    
    // starts asynchronous fetch of videoIDs
    func fetchNextSetOfVideoIDs() -> Bool {
        self.searchString = youtubePlaylistURLPrefix + self.playlists.getCurrentPlaylist().playlistID + youtubeKeySuffix
        if let nextPageToken = self.nextPageToken {
            searchString = searchString + "&pageToken=" + nextPageToken
            queryYoutube(searchString)
        } else if firstPage == true {
            firstPage = false
            queryYoutube(searchString)
        } // else if lastPage == true then do nothing
        return self.lastPage
    }
    

    // MARK: Private Methods
    // send an API request to Youtube to fetch playlist information
    private func queryYoutube(searchString:String) {

        let manager = AFHTTPRequestOperationManager()
        
        manager.GET( searchString ,
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                
                if let dataArray = responseObject["items"] as? [AnyObject] {
                    for dataObject in dataArray {
                        if let imageURLString = dataObject.valueForKeyPath("contentDetails.videoId") as? String {
                            //println(imageURLString)
                            self.playlists.getCurrentPlaylist().videoIDs.append(imageURLString)
                        }
                    }
                }
                
                if let nextPageToken = responseObject["nextPageToken"] as? String {
                    self.delegate?.fetchCompleted(nextPageToken, lastPage: false)
                } else if self.firstPage == false {
                    self.delegate?.fetchCompleted(nil, lastPage: true)
                }
                
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
                
                // need to do a new notification for failure
        })
        
    }
    
}






