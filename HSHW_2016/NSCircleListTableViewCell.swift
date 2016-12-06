//
//  NSCircleListTableViewCell.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/6.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class NSCircleListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var photoImg: UIImageView!
    
    @IBOutlet weak var nameLab: UILabel!
    
    @IBOutlet weak var countLab: UILabel!
    
    @IBOutlet weak var descriptionLab: UILabel!
    
    @IBOutlet weak var joinBtn: UIButton!
    
    
    var communityModel = CommunityModel() {
        didSet {
            self.nameLab.text = communityModel.community_name
            self.descriptionLab.text = communityModel.description
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        joinBtn.layer.cornerRadius = 6
        joinBtn.layer.borderWidth = 1
        joinBtn.layer.borderColor = COLOR.CGColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
