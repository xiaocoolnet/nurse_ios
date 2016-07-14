//
//  OnlineTextTableViewCell.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/5.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class OnlineTextTableViewCell: UITableViewCell {

    let titleImg = UIButton()
    let titleLable = UILabel()
    let numLable = UILabel()
    let startBtn = UIButton()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        
        titleImg.frame = CGRectMake(10, 10, 40, 40)
        titleLable.frame = CGRectMake(57, 15, WIDTH / 3, 30)
        titleLable.font = UIFont.systemFontOfSize(18)
        startBtn.frame = CGRectMake(WIDTH-10-WIDTH/4, 15, WIDTH/4, 30)
        startBtn.setTitle("开始考试", forState: .Normal)
        startBtn.setTitleColor(COLOR, forState: .Normal)
        startBtn.layer.cornerRadius = 15
        startBtn.layer.borderColor = COLOR.CGColor
        startBtn.layer.borderWidth = 1
        
        let rightOfNum = UILabel(frame: CGRectMake(startBtn.frame.origin.x-30, 10, 25, 40))
        rightOfNum.font = UIFont.systemFontOfSize(12)
        rightOfNum.textAlignment = .Center
        rightOfNum.textColor = UIColor.grayColor()
        rightOfNum.text = "道题"
        
        numLable.frame = CGRectMake(rightOfNum.frame.origin.x-35, 10, 35, 40)
        numLable.font = UIFont.systemFontOfSize(15)
        numLable.textAlignment = .Center
        
        let leftOfNum = UILabel(frame: CGRectMake(numLable.frame.origin.x-10, 10, 15, 40))
        leftOfNum.font = UIFont.systemFontOfSize(12)
        leftOfNum.textAlignment = .Center
        leftOfNum.textColor = UIColor.grayColor()
        leftOfNum.text = "共"
        
        self.addSubview(titleImg)
        self.addSubview(titleLable)
        self.addSubview(startBtn)
        self.addSubview(numLable)
        self.addSubview(leftOfNum)
        self.addSubview(rightOfNum)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
