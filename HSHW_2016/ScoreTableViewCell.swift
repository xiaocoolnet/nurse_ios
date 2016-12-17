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
        
        let scoreImg = UIImageView(frame: CGRect(x: 5/75*WIDTH, y: 35/1380.0*HEIGHT, width: 5/75*WIDTH, height: 4/75*WIDTH))
        scoreImg.image = UIImage(named: "score")
        self.contentView.addSubview(scoreImg)
        
        nameLab.frame = CGRect(x: scoreImg.frame.maxX+3/750.0*WIDTH, y: 35/1380.0*HEIGHT, width: 1/3.0*WIDTH, height: 35/1380.0*HEIGHT)
        nameLab.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
        nameLab.font = UIFont.systemFont(ofSize: 18)
        nameLab.textAlignment = .left
        self.contentView.addSubview(nameLab)
        
        scoreLab.frame = CGRect(x: nameLab.frame.maxX, y: nameLab.frame.minY, width: 304/750.0*WIDTH, height: 3/138.0*HEIGHT)
        scoreLab.textColor = COLOR
        scoreLab.font = UIFont.systemFont(ofSize: 18)
        scoreLab.textAlignment = .right
        self.contentView.addSubview(scoreLab)
        
        timeLab.frame = CGRect(x: nameLab.frame.maxX, y: scoreLab.frame.maxY, width: 304/750.0*WIDTH, height: 18/1380.0*HEIGHT)
        timeLab.textColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
        timeLab.font = UIFont.systemFont(ofSize: 10)
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
