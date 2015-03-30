//
// Playlist.swift
// Rehan Ali, 30th March 2015
//
// Model class for defining a Playlist object (which contains a title and 
// a playlistID used for fetching playlist videoIDs from YouTube)
//

import UIKit

class Playlist {
    
    var title: String
    var playlistID: String
    var videoIDs = [String]()
    
    init(title:String, playlistID:String) {
        self.title = title
        self.playlistID = playlistID
    }
    
    func getNumberOfVideos() -> Int {
        return self.videoIDs.count
    }
    
    func addVideos(videoIDs:[String]) {
        for videoID in videoIDs {
            self.videoIDs.append(videoID)
        }
    }
    
    func getVideos() -> [String] {
        return self.videoIDs
    }
    
    func printList() {
        for item in videoIDs {
            println(item)
        }
    }
    
}


