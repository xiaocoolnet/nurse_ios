//
//  TouTiaoTableViewCell.swift
//  HSHW_2016
//
//  Created by apple on 16/5/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class TouTiaoTableViewCell: UITableViewCell {

    let titLab = UILabel()
    let contant = UILabel()
    let titImage = UIImageView()
    let heal = UIButton()
    let conNum = UILabel()
    let timeLab = UILabel()
    let comBtn = UIButton()
    let timeBtn = UIButton()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        titLab.frame = CGRectMake(10, 10, WIDTH-140, 20)
        titLab.font = UIFont.systemFontOfSize(14)
        titLab.numberOfLines = 0
        //titLab.backgroundColor = UIColor.redColor()
//        heal.frame = CGRectMake(10, 34, 46, 15)
//        heal.layer.cornerRadius = 3
//        heal.layer.borderColor = COLOR.CGColor
//        heal.layer.borderWidth = 0.4
//        heal.titleLabel?.font = UIFont.systemFontOfSize(10)
//        heal.setTitle("健康常识", forState: .Normal)
//        heal.setTitleColor(COLOR, forState: .Normal)
        heal.frame = CGRectMake(10, titLab.frame.size.height+titLab.frame.origin.y+20, 46, 15)
        heal.layer.cornerRadius = 3
        heal.layer.borderColor = COLOR.CGColor
        heal.layer.borderWidth = 0.4
        heal.titleLabel?.font = UIFont.systemFontOfSize(10)
        heal.setTitle("健康常识", forState: .Normal)
        heal.setTitleColor(COLOR, forState: .Normal)
//        conNum.frame = CGRectMake(79, 34, 30, 15)
//        conNum.font = UIFont.systemFontOfSize(9)
//        conNum.textAlignment = .Left
//        conNum.textColor = GREY
        conNum.frame = CGRectMake(79, titLab.frame.size.height+titLab.frame.origin.y+20, 30, 15)
        conNum.font = UIFont.systemFontOfSize(9)
        conNum.textAlignment = .Left
        conNum.textColor = GREY
//        timeLab.frame = CGRectMake(120, 34, 80, 15)
//        timeLab.font = UIFont.systemFontOfSize(9)
//        timeLab.textColor = GREY
        timeLab.frame = CGRectMake(120, titLab.frame.size.height+titLab.frame.origin.y+20, 80, 15)
        timeLab.font = UIFont.systemFontOfSize(9)
        timeLab.textColor = GREY
//        comBtn.frame = CGRectMake(62, 35.5, 18, 12)
//        comBtn.setImage(UIImage(named: "ic_eye_purple.png"), forState: .Normal)
        comBtn.frame = CGRectMake(62, titLab.frame.size.height+titLab.frame.origin.y+20, 18, 12)
        comBtn.setImage(UIImage(named: "ic_eye_purple.png"), forState: .Normal)
//        timeBtn.frame = CGRectMake(106, 34.5, 14, 14)
//        timeBtn.setImage(UIImage(named: "ic_time_purple.png"), forState: .Normal)
        timeBtn.frame = CGRectMake(106, titLab.frame.size.height+titLab.frame.origin.y+20, 14, 14)
        timeBtn.setImage(UIImage(named: "ic_time_purple.png"), forState: .Normal)
//        contant.frame = CGRectMake(10, 50, WIDTH-140, 40)
//        contant.numberOfLines = 0
//        contant.font = UIFont.systemFontOfSize(12)
//        contant.textColor = UIColor.grayColor()
//        titImage.frame = CGRectMake(WIDTH-120, 10, 110, 80)
        contant.frame = CGRectMake(10, titLab.frame.size.height+titLab.frame.origin.y+35, WIDTH-140, 40)
        contant.numberOfLines = 0
        contant.font = UIFont.systemFontOfSize(12)
        contant.textColor = UIColor.grayColor()
        titImage.frame = CGRectMake(WIDTH-120, 10, 110, 80)
        self.addSubview(heal)
        self.addSubview(conNum)
        self.addSubview(timeLab)
        self.addSubview(comBtn)
        self.addSubview(timeBtn)
        self.addSubview(titLab)
        self.addSubview(contant)
        self.addSubview(titImage)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
