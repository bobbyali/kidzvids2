//
// PlaylistCollection.swift
// Rehan Ali, 2nd April 2015
//
// Model class for holding references to multiple Playlist objects.

import UIKit

// this class holds references to all Playlists currently loaded

class PlaylistCollection {
    
    var list = [Playlist]()
    var currentPlaylist:Int?
    var iconScale:Float = 0.77
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let keyForListOfPlaylistTitles = "listOfPlaylistTitles"
    let keyForListOfPlaylistIDs    = "listOfPlaylistIDs"
    let keyForCurrentPlaylist      = "currentPlaylist"
    let keyForCurrentIconScale     = "currentIconScale"
    
    // define as singleton class
    class var sharedInstance: PlaylistCollection {
        struct Static {
            static let instance: PlaylistCollection = PlaylistCollection()
        }
        return Static.instance
    }
    
    init() {
        loadCollection()
    }
    
    func getCurrentPlaylist() -> Playlist? {
        if let currentPlaylist = self.currentPlaylist {
            return self.list[currentPlaylist]
        } else {
            return nil
        }
    }
    
    func saveCollection() {
        var arrayOfTitles: [NSString] = [NSString]()
        var arrayOfIDs: [NSString] = [NSString]()
        
        for item in self.list {
            arrayOfTitles.append(item.title)
            arrayOfIDs.append(item.playlistID)
        }
        
        defaults.setObject(arrayOfTitles, forKey: keyForListOfPlaylistTitles)
        defaults.setObject(arrayOfIDs, forKey: keyForListOfPlaylistIDs)
        defaults.setObject(self.currentPlaylist, forKey: keyForCurrentPlaylist)
        defaults.setObject(self.iconScale, forKey: keyForCurrentIconScale)
        //defaults.synchronize()
    }
    
    func loadCollection() {
        var readArrayOfTitles: [NSString]? = defaults.objectForKey(keyForListOfPlaylistTitles) as! [NSString]?
        var readArrayOfIDs: [NSString]? = defaults.objectForKey(keyForListOfPlaylistIDs) as! [NSString]?
        var savedCurrentPlaylist: Int? = defaults.valueForKey(keyForCurrentPlaylist) as! Int?
        var savedIconScale: Float? = defaults.valueForKey(keyForCurrentIconScale) as! Float?
        var blnEmptyUserDefaults = false
        
        if let arrayOfTitles = readArrayOfTitles {
            if let arrayOfIDs = readArrayOfIDs  {
                if arrayOfTitles.count > 0 && arrayOfIDs.count > 0 {
                    for (index, element) in enumerate(arrayOfTitles) {
                        list.append(Playlist(title: arrayOfTitles[index] as String, playlistID: arrayOfIDs[index] as String))
                    }
                }
                self.currentPlaylist = savedCurrentPlaylist!
                self.iconScale = savedIconScale!
            }
            else {
                blnEmptyUserDefaults = true
            }
        } else {
            blnEmptyUserDefaults = true
        }
    
        
        if blnEmptyUserDefaults {
            // set up default playlists
            println("saving")
            list.append(Playlist(title: "Trucks", playlistID: "PL35F93FA3C740F3BB"))
            list.append(Playlist(title: "Alphabet", playlistID: "PL97977A770B5B12E2"))
            list.append(Playlist(title: "Baby Einstein", playlistID: "PLRg7DhTholQCMjMfXLOQ2bVSTwpZz24OA"))
            list.append(Playlist(title: "Nursery Rhymes", playlistID: "PLkyj8eZFNWJSnaqiCLIkm2k-ij3XIP-az"))
            self.currentPlaylist = 0
            saveCollection()
        }
        
    }
    
}



/*
let def = NSUserDefaults.standardUserDefaults()
var key = "keySave"

var array1: [NSString] = [NSString]()
array1.append("value 1")
array1.append("value 2")

//save
var defaults = NSUserDefaults.standardUserDefaults()
defaults.setObject(array1, forKey: key)
defaults.synchronize()

//read
if let testArray : AnyObject? = defaults.objectForKey(key) {
var readArray : [NSString] = testArray! as [NSString]
}
*/