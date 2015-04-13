//
// PlaylistTableView.swift
// Rehan Ali, 2nd April 2015
//
// View class for displaying a table cell on the 
// playlist table view controller. Each cell contains
// a title label and an edit button.

import UIKit

protocol PlaylistTableViewCellDelegate {
    func editButton(playlistIndex:Int)
    func deleteButton(playlistIndex:Int)
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
        
        let padding = UIEdgeInsetsMake(10, 10, 10, -20)
        let superview = contentView
        
        titleLabel.snp_makeConstraints { make in
            make.top.equalTo(superview.snp_top).with.offset(padding.top)
            make.left.equalTo(superview.snp_left).with.offset(padding.left)
        }

        
        let buttonDelete   = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        buttonDelete.frame = CGRectMake(100, 10, 100, 10)
        buttonDelete.setTitle("Delete", forState: UIControlState.Normal)
        buttonDelete.addTarget(self, action: "buttonDelete:", forControlEvents: UIControlEvents.TouchUpInside)
        contentView.addSubview(buttonDelete)
        
        buttonDelete.snp_makeConstraints { make in
            make.top.equalTo(superview.snp_top).with.offset(padding.top)
            make.right.equalTo(superview.snp_right).with.offset(padding.right)
        }

        
        
        let buttonEdit   = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        buttonEdit.frame = CGRectMake(100, 10, 100, 10)
        buttonEdit.setTitle("Edit", forState: UIControlState.Normal)
        buttonEdit.addTarget(self, action: "buttonEdit:", forControlEvents: UIControlEvents.TouchUpInside)
        contentView.addSubview(buttonEdit)
        
        buttonEdit.snp_makeConstraints { make in
            make.top.equalTo(superview.snp_top).with.offset(padding.top)
            make.right.equalTo(buttonDelete.snp_left).with.offset(padding.right)
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
    
    
    // MARK: Buttons
    func buttonEdit(sender:UIButton!) {
        println("Edit button selected")
        if var playlistIndex = self.playlistIndex {
            self.delegate?.editButton(playlistIndex)
        }
    }
    
    func buttonDelete(sender:UIButton!) {
        println("Delete button selected")
        if var playlistIndex = self.playlistIndex {
            self.delegate?.deleteButton(playlistIndex)
        }
    }
    

}
