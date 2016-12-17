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
        
        indexBtn.frame = CGRect(x: 5/75*WIDTH, y: 21/1380.0*HEIGHT, width: 5/75*WIDTH, height: 68/1380.0*HEIGHT)
        indexBtn.isEnabled = false
        indexBtn.setTitleColor(COLOR, for: UIControlState())
        self.contentView.addSubview(indexBtn)
       
        scoreImg.frame = CGRect(x: indexBtn.frame.maxX+22/750.0*WIDTH, y: 20/1380.0*HEIGHT, width: 70/1380.0*HEIGHT, height: 70/1380.0*HEIGHT)
        scoreImg.layer.cornerRadius = scoreImg.frame.size.width/2.0
        scoreImg.clipsToBounds = true
        self.contentView.addSubview(scoreImg)
        
        nameLab.frame = CGRect(
            x: scoreImg.frame.maxX+10/750.0*WIDTH,
            y: 35/1380.0*HEIGHT,
            width: 540/750.0*WIDTH-scoreImg.frame.maxX+10/750.0*WIDTH,
            height: 35/1380.0*HEIGHT)
        nameLab.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
        nameLab.font = UIFont.systemFont(ofSize: 18)
        nameLab.adjustsFontSizeToFitWidth = true
        nameLab.textAlignment = .left
        self.contentView.addSubview(nameLab)
        
        scoreLab.frame = CGRect(
            x: nameLab.frame.maxX,
            y: nameLab.frame.minY,
            width: 670/750.0*WIDTH-nameLab.frame.maxX,
            height: 3/138.0*HEIGHT)
        scoreLab.textColor = COLOR
        scoreLab.font = UIFont.systemFont(ofSize: 18)
        scoreLab.adjustsFontSizeToFitWidth = true
        scoreLab.textAlignment = .right
        self.contentView.addSubview(scoreLab)
        
        timeLab.frame = CGRect(
            x: nameLab.frame.maxX,
            y: scoreLab.frame.maxY,
            width: 670/750.0*WIDTH-nameLab.frame.maxX,
            height: 18/1380.0*HEIGHT)
        timeLab.textColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
        timeLab.font = UIFont.systemFont(ofSize: 10)
        timeLab.adjustsFontSizeToFitWidth = true
        timeLab.textAlignment = .right
        self.contentView.addSubview(timeLab)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
