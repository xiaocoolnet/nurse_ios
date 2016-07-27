//
//  HSStateCommentCell.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/7/3.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class HSStateCommentCell: UITableViewCell {

    @IBOutlet weak var headerBtn: UIButton!
    
    @IBOutlet weak var nameLab: UILabel!
    
    @IBOutlet weak var louzhuLab: UILabel!
    
    @IBOutlet weak var positionLab: UILabel!
    
    @IBOutlet weak var levelLab: UILabel!
    
    @IBOutlet weak var contentLab: UILabel!
    
    @IBOutlet weak var timeImg: UIImageView!
    
    @IBOutlet weak var timeLab: UILabel!
    
    @IBOutlet weak var locationImg: UIImageView!
    
    @IBOutlet weak var locationLab: UILabel!
    
    @IBOutlet weak var replyBtn: UIButton!
    
    @IBOutlet weak var floorLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        louzhuLab.layer.cornerRadius = 2
        louzhuLab.layer.borderWidth = 1
        louzhuLab.layer.borderColor = COLOR.CGColor
        
    }
    
    var commentModel:CommentModel?{
        didSet {
            nameLab.text = commentModel?.name
            contentLab.text = commentModel?.content
            
            HSMineHelper().getUserInfo((commentModel?.userid)!) { (success, response) in
                let model = response as! HSFansAndFollowModel
                dispatch_async(dispatch_get_main_queue(), {
                    self.headerBtn.sd_setImageWithURL(NSURL.init(string: SHOW_IMAGE_HEADER+model.photo), forState: .Normal)
                    self.positionLab.text = model.major
                    self.levelLab.text = String(format: "Lv.%02d", Int(model.level)!)
                })
            }
            
//            headerBtn.layer.masksToBounds =
            
            
            
        }
    }
    
    var comment:MineCommentModel?{
        didSet {
            nameLab.text = commentModel?.name
            contentLab.text = commentModel?.content
        }
    }
    


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
