//
//  FansTableViewCell.swift
//  HSHW_2016
//
//  Created by apple on 16/5/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class FansTableViewCell: UITableViewCell {

    let titImg = UIImageView()
    let nameLab = UILabel()
    let fansBtn = UIButton()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        titImg.frame = CGRectMake(15, 10, 50, 50)
        titImg.layer.cornerRadius = 25
        titImg.clipsToBounds = true
        
        nameLab.frame = CGRectMake(75, 25, 50, 20)
        nameLab.font = UIFont.systemFontOfSize(15)
        
        fansBtn.frame = CGRectMake(75+nameLab.bounds.size.width+5, 26, 19, 18)
        fansBtn.setBackgroundImage(UIImage(named: "ic_shield_purple.png"), forState: .Normal)
        fansBtn.titleLabel?.font = UIFont.systemFontOfSize(9)
        fansBtn.setTitleColor(COLOR, forState: .Normal)
        
        self.addSubview(titImg)
        self.addSubview(nameLab)
        self.addSubview(fansBtn)
        
    }
    
    var fansModel:HSFansAndFollowModel?{
        didSet {
            //TODO:image 后期要改，从网上获取
//            titImg.image = UIImage(named: newValue.headerImage)
            titImg.image = UIImage(named: "1.png")
            nameLab.text = self.fansModel!.name
            nameLab.sizeToFit()

            fansBtn.frame = CGRectMake(75+nameLab.bounds.size.width+5, 26, 19, 18)
            fansBtn.setTitle(self.fansModel!.level, forState: .Normal)
            
            
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
