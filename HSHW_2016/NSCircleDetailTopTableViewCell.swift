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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setSubViews() {
        
        topImg.contentMode = .scaleAspectFill
        topImg.clipsToBounds = true
        topImg.frame = CGRect(x: 8, y: 8, width: 14, height: 14)
        topImg.image = UIImage(named: "置顶")
        self.addSubview(topImg)
        
        bestImg.contentMode = .scaleAspectFill
        bestImg.clipsToBounds = true
        bestImg.frame = CGRect(x: 27, y: 8, width: 14, height: 14)
        bestImg.image = UIImage(named: "加精")
        self.addSubview(bestImg)
        
        titleLab.font = UIFont.systemFont(ofSize: titleSize)
        titleLab.textColor = UIColor.black        
        
    }
    
    fileprivate let titleSize:CGFloat = 14
    
    func setCellWithNewsInfo(_ forum:ForumModel) {
        
        var titleX:CGFloat = 8
        
        if forum.istop == "1" {
            topImg.isHidden = false
            topImg.frame = CGRect(x: 8, y: 8, width: 14, height: 14)
            titleX = 30
        }else{
            topImg.isHidden = true
        }
        
        if forum.isbest == "1" {
            bestImg.isHidden = false
            
            if forum.istop == "1" {
                topImg.isHidden = false
                bestImg.frame = CGRect(x: 27, y: 8, width: 14, height: 14)
                titleX = 49
            }else{
                topImg.isHidden = true
                bestImg.frame = CGRect(x: 8, y: 8, width: 14, height: 14)
                titleX = 30
            }
        }else{
            bestImg.isHidden = true
        }
        
//        let height = calculateHeight((forum.title), size: titleSize, width: WIDTH-16-110-8)
        self.titleLab.frame = CGRect(x: titleX, y: 0, width: WIDTH-8-titleX, height: 30)
        
        self.titleLab.text = forum.title
        
    }
    
}
