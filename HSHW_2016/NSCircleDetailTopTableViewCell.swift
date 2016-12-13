//
//  NSCircleDetailTopTableViewCell.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/8.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class NSCircleDetailTopTableViewCell: UITableViewCell {
    
    // 帖子信息
    let topImg = UIImageView()
    let bestImg = UIImageView()
    let rewardImg = UIImageView()
    
    let titleLab = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        
        self.addSubview(titleLab)
        
        self.setSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setSubViews() {
        
        topImg.contentMode = .ScaleAspectFill
        topImg.clipsToBounds = true
        topImg.frame = CGRectMake(8, 8, 14, 14)
        topImg.image = UIImage(named: "置顶")
        self.addSubview(topImg)
        
        bestImg.contentMode = .ScaleAspectFill
        bestImg.clipsToBounds = true
        bestImg.frame = CGRectMake(27, 8, 14, 14)
        bestImg.image = UIImage(named: "加精")
        self.addSubview(bestImg)
        
        titleLab.font = UIFont.systemFontOfSize(titleSize)
        titleLab.textColor = UIColor.blackColor()        
        
    }
    
    private let titleSize:CGFloat = 14
    
    func setCellWithNewsInfo(forum:ForumModel) {
        
        var titleX:CGFloat = 8
        
        if forum.istop == "1" {
            topImg.hidden = false
            topImg.frame = CGRectMake(8, 8, 14, 14)
            titleX = 30
        }else{
            topImg.hidden = true
        }
        
        if forum.isbest == "1" {
            bestImg.hidden = false
            
            if forum.istop == "1" {
                topImg.hidden = false
                bestImg.frame = CGRectMake(27, 8, 14, 14)
                titleX = 49
            }else{
                topImg.hidden = true
                bestImg.frame = CGRectMake(8, 8, 14, 14)
                titleX = 30
            }
        }else{
            bestImg.hidden = true
        }
        
//        let height = calculateHeight((forum.title), size: titleSize, width: WIDTH-16-110-8)
        self.titleLab.frame = CGRectMake(titleX, 0, WIDTH-8-titleX, 30)
        
        self.titleLab.text = forum.title
        
    }
    
}
