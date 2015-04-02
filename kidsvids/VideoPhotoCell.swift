//
// VideoPhotoCell.swift
// Rehan Ali, 2nd April 2015
//
// View class for displaying a UICollectionViewCell
// containing a thumbnail image from a Youtube video.

import UIKit

class VideoPhotoCell: UICollectionViewCell {
    
    var videoPhotoCell: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.videoPhotoCell = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: (frame.width * 0.77)))
        
        contentView.backgroundColor = UIColor.blackColor()
        contentView.addSubview(videoPhotoCell)

    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
