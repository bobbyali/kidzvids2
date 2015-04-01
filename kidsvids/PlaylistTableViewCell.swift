//
//  PlaylistTableViewCell.swift
//  kidsvids
//
//  Created by Bobby on 01/04/2015.
//  Copyright (c) 2015 Azuki Apps. All rights reserved.
//

import UIKit

protocol PlaylistTableViewCellDelegate {
    func editButton(playlistIndex:Int)
}

class PlaylistTableViewCell: UITableViewCell {

    var titleLabel: UILabel!
    var playlistIndex: Int?
    var delegate: PlaylistTableViewCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        titleLabel.text = ""
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.textAlignment = NSTextAlignment.Left
        titleLabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(17))
        contentView.addSubview(titleLabel)
        
        let padding = UIEdgeInsetsMake(10, 10, 10, -50)
        let superview = contentView
        
        titleLabel.snp_makeConstraints { make in
            make.top.equalTo(superview.snp_top).with.offset(padding.top)
            make.left.equalTo(superview.snp_left).with.offset(padding.left)
        }
        
        let button   = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button.frame = CGRectMake(100, 10, 100, 10)
        button.setTitle("Edit", forState: UIControlState.Normal)
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        contentView.addSubview(button)
        
        button.snp_makeConstraints { make in
            make.top.equalTo(superview.snp_top).with.offset(padding.top)
            make.right.equalTo(superview.snp_right).with.offset(padding.right)
        }
        
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func buttonAction(sender:UIButton!) {
        println("Edit button selected")
        if var playlistIndex = self.playlistIndex {
            self.delegate?.editButton(playlistIndex)
        }
    }
    

}
