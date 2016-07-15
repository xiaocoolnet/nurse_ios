//
//  MinePostTableViewCell.swift
//  HSHW_2016
//
//  Created by apple on 16/5/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MinePostTableViewCell: UITableViewCell {

    let title = UILabel()
    let timeLab = UILabel()
    let conLab = UILabel()
    let zanNum = UILabel()
    let one = UIButton()
    let time = UIButton()
    let conImg = UIButton()
    let zanImg = UIButton()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        title.frame = CGRectMake(15, 16, WIDTH-55, 20)
        title.font = UIFont.systemFontOfSize(14)
        one.frame = CGRectMake(WIDTH-35, 26, 20, 20)
        one.setImage(UIImage(named: "ic_you.png"), forState: .Normal)
        timeLab.frame = CGRectMake(15, 40, 80, 20)
        timeLab.font = UIFont.systemFontOfSize(10)
        timeLab.textColor = GREY
        conLab.frame = CGRectMake(117, 40, 50, 20)
        conLab.font = UIFont.systemFontOfSize(10)
        conLab.textColor = GREY
        zanNum.frame = CGRectMake(177, 40, 50, 20)
        zanNum.font = UIFont.systemFontOfSize(10)
        zanNum.textColor = GREY
        time.frame = CGRectMake(15, 46.5, 8, 7)
        time.setBackgroundImage(UIImage(named: "ic_time_gray@.png"), forState: .Normal)
        conImg.frame = CGRectMake(105, 47, 9, 6)
        conImg.setBackgroundImage(UIImage(named: "ic_eye_gray.png"), forState: .Normal)
        zanImg.frame = CGRectMake(167, 46.5, 7, 7)
        zanImg.setBackgroundImage(UIImage(named: "ic_like_gray.png"), forState: .Normal)
        let line = UILabel(frame: CGRectMake(0, 71.5, WIDTH, 0.5))
        line.backgroundColor = GREY
        
        self.addSubview(line)
        self.addSubview(title)
        self.addSubview(one)
        self.addSubview(timeLab)
        self.addSubview(conLab)
        self.addSubview(zanNum)
        self.addSubview(time)
        self.addSubview(conImg)
        self.addSubview(zanImg)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
