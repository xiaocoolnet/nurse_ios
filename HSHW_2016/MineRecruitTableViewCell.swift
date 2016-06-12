//
//  MineRecruitTableViewCell.swift
//  HSHW_2016
//
//  Created by apple on 16/5/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MineRecruitTableViewCell: UITableViewCell {

    let timeLab = UILabel()
    let one = UIButton()
    let time = UIImageView()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        
        one.frame = CGRectMake(WIDTH-35, 26, 20, 20)
        one.setImage(UIImage(named: "ic_you.png"), forState: .Normal)
        timeLab.frame = CGRectMake(25, 40, 80, 20)
        timeLab.font = UIFont.systemFontOfSize(10)
        timeLab.textColor = GREY
        time.frame = CGRectMake(15, 46.5, 7, 7)
        time.image = UIImage(named: "ic_time_gray@.png")
        let line = UILabel(frame: CGRectMake(0, 71.5, WIDTH, 0.5))
        line.backgroundColor = GREY
        
        self.addSubview(line)
        self.addSubview(one)
        self.addSubview(timeLab)
        self.addSubview(time)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
