//
//  HSComTableCell.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/22.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class HSComTableCell: UITableViewCell {
    
    @IBOutlet weak var avatarBtn: UIButton!
    @IBOutlet weak var landLorder: UILabel!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var likeNumber: UIButton!
    @IBOutlet weak var commentNumber: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func showForForumModel(model:PostModel){
        avatarBtn.layer.cornerRadius = avatarBtn.frame.size.width/2.0
        avatarBtn.layer.masksToBounds = true
        
        if model.photo == "default_header" || model.photo == "1234.png" {
            avatarBtn.setImage(UIImage.init(named: "default_header"), forState: .Normal)
        }else{
            avatarBtn.sd_setImageWithURL(NSURL.init(string: SHOW_IMAGE_HEADER+(model.photo)), forState: .Normal)
        }
        
        landLorder.text = model.name
        titleLabel.text = model.title
        contentLabel.text = model.content
        likeNumber.setTitle(String(model.like.count), forState: .Normal)
        commentNumber.setTitle(String(model.comment.count), forState: .Normal)
        HSMineHelper().getUserInfo(model.userid) { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                self.position.text = (response as! HSFansAndFollowModel).major
            })
        }
        HSNurseStationHelper().showPostInfo(model.mid) { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                self.fromLabel.text = (response as! PostModel).typename
            })
        }
    }
    
}
