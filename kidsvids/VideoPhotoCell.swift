//
//  VideoPhotoCell.swift
//  KidzVids
//
//  Created by Bobby on 17/03/2015.
//  Copyright (c) 2015 AzukiApps. All rights reserved.
//

import UIKit

class VideoPhotoCell: UICollectionViewCell {
    
    var videoPhotoCell: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.videoPhotoCell = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        //videoPhotoCell = UIImageView(frame: self.contentView.bounds)
        self.videoPhotoCell = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: (frame.width * 0.77)))
        
        contentView.backgroundColor = UIColor.blackColor()
        contentView.addSubview(videoPhotoCell)

    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
