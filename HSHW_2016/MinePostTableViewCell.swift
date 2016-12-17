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
        title.frame = CGRect(x: 15, y: 16, width: WIDTH-55, height: 20)
        title.font = UIFont.systemFont(ofSize: 14)
        one.frame = CGRect(x: WIDTH-35, y: 26, width: 20, height: 20)
        one.setImage(UIImage(named: "ic_you.png"), for: UIControlState())
        timeLab.frame = CGRect(x: 15, y: 40, width: 80, height: 20)
        timeLab.font = UIFont.systemFont(ofSize: 10)
        timeLab.textColor = GREY
        conLab.frame = CGRect(x: 117, y: 40, width: 50, height: 20)
        conLab.font = UIFont.systemFont(ofSize: 10)
        conLab.textColor = GREY
        zanNum.frame = CGRect(x: 177, y: 40, width: 50, height: 20)
        zanNum.font = UIFont.systemFont(ofSize: 10)
        zanNum.textColor = GREY
        time.frame = CGRect(x: 15, y: 46.5, width: 8, height: 7)
        time.setBackgroundImage(UIImage(named: "ic_time_gray@.png"), for: UIControlState())
        conImg.frame = CGRect(x: 105, y: 47, width: 9, height: 6)
        conImg.setBackgroundImage(UIImage(named: "ic_eye_gray.png"), for: UIControlState())
        zanImg.frame = CGRect(x: 167, y: 46.5, width: 7, height: 7)
        zanImg.setBackgroundImage(UIImage(named: "ic_like_gray.png"), for: UIControlState())
        let line = UILabel(frame: CGRect(x: 0, y: 71.5, width: WIDTH, height: 0.5))
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
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
