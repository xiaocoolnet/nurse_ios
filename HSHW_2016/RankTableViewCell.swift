//
//  RankTableViewCell.swift
//  HSHW_2016
//
//  Created by zhang on 16/8/21.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class RankTableViewCell: UITableViewCell {

    let indexBtn = UIButton()
    let scoreImg = UIImageView()
    let nameLab = UILabel()
    let scoreLab = UILabel()
    let timeLab = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        indexBtn.frame = CGRectMake(5/75*WIDTH, 21/1380.0*HEIGHT, 5/75*WIDTH, 68/1380.0*HEIGHT)
        indexBtn.enabled = false
        indexBtn.setTitleColor(COLOR, forState: .Normal)
        self.contentView.addSubview(indexBtn)
       
        scoreImg.frame = CGRectMake(CGRectGetMaxX(indexBtn.frame)+22/750.0*WIDTH, 20/1380.0*HEIGHT, 70/1380.0*HEIGHT, 70/1380.0*HEIGHT)
        scoreImg.layer.cornerRadius = scoreImg.frame.size.width/2.0
        scoreImg.clipsToBounds = true
        self.contentView.addSubview(scoreImg)
        
        nameLab.frame = CGRectMake(
            CGRectGetMaxX(scoreImg.frame)+10/750.0*WIDTH,
            35/1380.0*HEIGHT,
            540/750.0*WIDTH-CGRectGetMaxX(scoreImg.frame)+10/750.0*WIDTH,
            35/1380.0*HEIGHT)
        nameLab.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
        nameLab.font = UIFont.systemFontOfSize(18)
        nameLab.adjustsFontSizeToFitWidth = true
        nameLab.textAlignment = .Left
        self.contentView.addSubview(nameLab)
        
        scoreLab.frame = CGRectMake(
            CGRectGetMaxX(nameLab.frame),
            CGRectGetMinY(nameLab.frame),
            670/750.0*WIDTH-CGRectGetMaxX(nameLab.frame),
            3/138.0*HEIGHT)
        scoreLab.textColor = COLOR
        scoreLab.font = UIFont.systemFontOfSize(18)
        scoreLab.adjustsFontSizeToFitWidth = true
        scoreLab.textAlignment = .Right
        self.contentView.addSubview(scoreLab)
        
        timeLab.frame = CGRectMake(
            CGRectGetMaxX(nameLab.frame),
            CGRectGetMaxY(scoreLab.frame),
            670/750.0*WIDTH-CGRectGetMaxX(nameLab.frame),
            18/1380.0*HEIGHT)
        timeLab.textColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
        timeLab.font = UIFont.systemFontOfSize(10)
        timeLab.adjustsFontSizeToFitWidth = true
        timeLab.textAlignment = .Right
        self.contentView.addSubview(timeLab)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
