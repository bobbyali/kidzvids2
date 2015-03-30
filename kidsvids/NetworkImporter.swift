//
// NetworkImporter.swift
// Rehan Ali, 30th March 2015
//
// Service class used by Playlist model for fetching videoIDs from YouTube API

import UIKit
import AFNetworking

class NetworkImporter {

    let youtubePlaylistURLPrefix:String = "https://www.googleapis.com/youtube/v3/playlistItems?part=contentDetails&playlistId="
    let youtubeKeySuffix:String = "&key=AIzaSyDG2hPqOEDnKeaBW365MCc9KFZVHB8LUYs"
    
    var searchString:String = ""
    //var playlist:Playlist
    var nextPageToken:String?
    var firstPage:Bool = true
    var lastPage:Bool = false
    
    var playlists: PlaylistCollection = PlaylistCollection.sharedInstance
    
    // MARK: Public Methods
    init(playlist:Playlist) {
        //self.playlist = playlist
    }
    
    // starts asynchronous fetch of videoIDs
    func fetchNextSetOfVideoIDs() -> Bool {
        //self.searchString = youtubePlaylistURLPrefix + self.playlist.playlistID + youtubeKeySuffix
        self.searchString = youtubePlaylistURLPrefix + self.playlists.getCurrentPlaylist().playlistID + youtubeKeySuffix
        if let nextPageToken = self.nextPageToken {
            searchString = searchString + "&pageToken=" + nextPageToken
            queryYoutube(searchString)
        } else if firstPage == true {
            queryYoutube(searchString)
        }
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
                            //self.playlist.videoIDs.append(imageURLString)
                            self.playlists.getCurrentPlaylist().videoIDs.append(imageURLString)
                        }
                    }
                }
                
                if let nextPageToken = responseObject["nextPageToken"] as? String {
                    self.nextPageToken = nextPageToken
                    self.firstPage = false
                } else if self.firstPage == false {
                    self.lastPage = true
                }
                
                NSNotificationCenter.defaultCenter().postNotificationName(mySpecialNotificationKey, object: nil)
                
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
                
                // need to do a new notification for failure
        })
        
    }
    
}






