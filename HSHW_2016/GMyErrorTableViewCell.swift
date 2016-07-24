//
//  GMyErrorTableViewCell.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/22.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class GMyErrorTableViewCell: UITableViewCell {

    var inde:Int = 0
    let indexLab = UILabel()
    let titImg = UIImageView()
    let titleLab = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        
        indexLab.frame = CGRectMake(10, 10, 50, 50)
        indexLab.textColor = UIColor.darkGrayColor()
        
        titImg.frame = CGRectMake(70, 10, 50, 50)
        titImg.layer.cornerRadius = 25
        titImg.clipsToBounds = true
        
        titleLab.frame = CGRectMake(75+50+15, 15, WIDTH - 150, 50)
        titleLab.font = UIFont.systemFontOfSize(16)
        titleLab.numberOfLines = 0
        
        self.addSubview(indexLab)
        self.addSubview(titImg)
        self.addSubview(titleLab)

        
    }
    
    var fansModel:GExamInfo?{
        didSet {
            //TODO:image 后期要改，从网上获取
            indexLab.text = "\(inde+1)."
            indexLab.sizeToFit()
            indexLab.frame = CGRectMake(10, (70-CGRectGetHeight(indexLab.frame))/2.0, CGRectGetWidth(indexLab.frame), CGRectGetHeight(indexLab.frame))
            
            titImg.frame = CGRectMake(CGRectGetMaxX(indexLab.frame)+10, 10, 50, 50)
            titImg.sd_setImageWithURL(NSURL.init(string: SHOW_IMAGE_HEADER+QCLoginUserInfo.currentInfo.avatar))
            
            titleLab.text = fansModel?.post_title
            titleLab.sizeToFit()
            titleLab.frame = CGRectMake(CGRectGetMaxX(titImg.frame)+15, 15, CGRectGetWidth(titleLab.frame), 50)
            
        }
        
    }
    
    var fanModel:xamInfo?{
        didSet {
            //TODO:image 后期要改，从网上获取
            indexLab.text = "\(inde+1)."
            indexLab.sizeToFit()
            indexLab.frame = CGRectMake(10, (70-CGRectGetHeight(indexLab.frame))/2.0, CGRectGetWidth(indexLab.frame), CGRectGetHeight(indexLab.frame))
            
            titImg.frame = CGRectMake(CGRectGetMaxX(indexLab.frame)+10, 10, 50, 50)
            titImg.sd_setImageWithURL(NSURL.init(string: SHOW_IMAGE_HEADER+QCLoginUserInfo.currentInfo.avatar))
            
            titleLab.text = fanModel?.title
            titleLab.sizeToFit()
            titleLab.frame = CGRectMake(CGRectGetMaxX(titImg.frame)+15, 15, CGRectGetWidth(titleLab.frame), 50)
            
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
