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
    
    
    var communityModel = CommunityListDataModel() {
        didSet {
            self.nameLab.text = communityModel.community_name
            
            var personNum = "\(communityModel.person_num)人"
            
            if NSString(string: communityModel.person_num).doubleValue >= 10000 {
                personNum = NSString(format: "%.2f万人", NSString(string: communityModel.person_num).doubleValue/10000.0) as String
            }
            
            var forumNum = "\(communityModel.f_count)贴子"
            
            if NSString(string: communityModel.f_count).doubleValue >= 10000 {
                forumNum = NSString(format: "%.2f万贴子", NSString(string: communityModel.f_count).doubleValue/10000.0) as String
            }
            self.countLab.text = "\(personNum) \(forumNum)"
            self.descriptionLab.text = communityModel.description
            self.photoImg.sd_setImage(with: URL(string: SHOW_IMAGE_HEADER+communityModel.photo), placeholderImage: nil)
            self.joinBtn.isSelected = communityModel.join == "1" ? true:false
//            self.joinBtn.isSelected = true
            self.joinBtn.backgroundColor = self.joinBtn.isSelected ? COLOR:UIColor.white
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        joinBtn.layer.cornerRadius = 4
        joinBtn.layer.borderWidth = 1
        joinBtn.layer.borderColor = COLOR.cgColor
        
        photoImg.contentMode = .scaleAspectFit
        photoImg.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
