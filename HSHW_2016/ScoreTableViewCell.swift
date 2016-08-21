//
//  ScoreTableViewCell.swift
//  HSHW_2016
//
//  Created by zhang on 16/8/21.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class ScoreTableViewCell: UITableViewCell {

    let nameLab = UILabel()
    let scoreLab = UILabel()
    let timeLab = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let scoreImg = UIImageView(frame: CGRectMake(5/75*WIDTH, 35/1380.0*HEIGHT, 5/75*WIDTH, 4/75*WIDTH))
        scoreImg.image = UIImage(named: "score")
        self.contentView.addSubview(scoreImg)
        
        nameLab.frame = CGRectMake(CGRectGetMaxX(scoreImg.frame)+3/750.0*WIDTH, 35/1380.0*HEIGHT, 1/3.0*WIDTH, 35/1380.0*HEIGHT)
        nameLab.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
        nameLab.font = UIFont.systemFontOfSize(18)
        nameLab.textAlignment = .Left
        self.contentView.addSubview(nameLab)
        
        scoreLab.frame = CGRectMake(CGRectGetMaxX(nameLab.frame), CGRectGetMinY(nameLab.frame), 304/750.0*WIDTH, 3/138.0*HEIGHT)
        scoreLab.textColor = COLOR
        scoreLab.font = UIFont.systemFontOfSize(18)
        scoreLab.textAlignment = .Right
        self.contentView.addSubview(scoreLab)
        
        timeLab.frame = CGRectMake(CGRectGetMaxX(nameLab.frame), CGRectGetMaxY(scoreLab.frame), 304/750.0*WIDTH, 18/1380.0*HEIGHT)
        timeLab.textColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
        timeLab.font = UIFont.systemFontOfSize(10)
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
