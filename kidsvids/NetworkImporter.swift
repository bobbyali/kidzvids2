//
// NetworkImporter.swift
// Rehan Ali, 30th March 2015
//
// Service class used by Playlist model for fetching videoIDs from YouTube API

import UIKit
import AFNetworking

protocol NetworkImporterDelegate {
    func fetchCompleted(nextPageToken:String?, lastPage:Bool)
    func fetchFailed()
}

protocol NetworkCheckerDelegate {
    func validityCheck(passed:Bool)
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
    var checker: NetworkCheckerDelegate?
    
    var isBusy:Bool = false
    
    // MARK: Public Methods
    init() {
    }
    
    // starts asynchronous fetch of videoIDs
    func fetchNextSetOfVideoIDs() -> Bool {
        println("isBusy? \(self.isBusy)")
        if !self.isBusy {
            println("* a")
            if let currentPlaylist = self.playlists.getCurrentPlaylist() {
                println("* d")
                self.searchString = youtubePlaylistURLPrefix + currentPlaylist.playlistID + youtubeKeySuffix
                if let nextPageToken = self.nextPageToken {
                    println("* b")
                    self.searchString = self.searchString + "&pageToken=" + nextPageToken
                    queryYoutube(self.searchString)
                } else if self.firstPage == true {
                    println("* c")
                    queryYoutube(self.searchString)
                } else { println("* e") } // else if lastPage == true then do nothing
            }
        }
        return self.lastPage
    }
    

    // MARK: Private Methods
    // send an API request to Youtube to fetch playlist information
    private func queryYoutube(searchString:String) {

        let manager = AFHTTPRequestOperationManager()
        self.isBusy = true
        println("Data fetch")
        
        manager.GET( searchString ,
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                
                if let dataArray = responseObject["items"] as? [AnyObject] {
                    for dataObject in dataArray {
                        if let imageURLString = dataObject.valueForKeyPath("contentDetails.videoId") as? String {
                            if let currentPlaylist = self.playlists.getCurrentPlaylist() {
                                currentPlaylist.videoIDs.append(imageURLString)
                            }
                            
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
                self.delegate?.fetchFailed()
        })
        
    }
    
    
    
    
    func checkPlaylistIDValidity(playlistID:String) {
        
        let manager = AFHTTPRequestOperationManager()
        println("Validity check")
        
        var tempSearchString = self.youtubePlaylistURLPrefix + playlistID + self.youtubeKeySuffix
        
        manager.GET( tempSearchString ,
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in

                if let dataArray = responseObject["items"] as? [AnyObject] {
                    println("Valid!")
                    self.checker?.validityCheck(true)
                } else {
                    println("No items")
                    self.checker?.validityCheck(false)
                }
                
                
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
                println("Invalid!")
                self.checker?.validityCheck(false)
        })
        
    }
    
    
}






