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
        
        titleImg.frame = CGRect(x: 10, y: 10, width: 40, height: 40)
        titleLable.frame = CGRect(x: 57, y: 15, width: WIDTH / 3, height: 30)
        titleLable.font = UIFont.systemFont(ofSize: 18)
        startBtn.frame = CGRect(x: WIDTH-10-WIDTH/4, y: 15, width: WIDTH/4, height: 30)
//        startBtn.setTitle("开始考试", forState: .Normal)
        startBtn.setTitleColor(COLOR, for: UIControlState())
        startBtn.layer.cornerRadius = 15
        startBtn.layer.borderColor = COLOR.cgColor
        startBtn.layer.borderWidth = 1
        
        let rightOfNum = UILabel(frame: CGRect(x: startBtn.frame.origin.x-30, y: 10, width: 25, height: 40))
        rightOfNum.font = UIFont.systemFont(ofSize: 12)
        rightOfNum.textAlignment = .center
        rightOfNum.textColor = UIColor.gray
        rightOfNum.text = "道题"
        
        numLable.frame = CGRect(x: rightOfNum.frame.origin.x-35, y: 10, width: 35, height: 40)
        numLable.font = UIFont.systemFont(ofSize: 15)
        numLable.textAlignment = .center
        
        let leftOfNum = UILabel(frame: CGRect(x: numLable.frame.origin.x-10, y: 10, width: 15, height: 40))
        leftOfNum.font = UIFont.systemFont(ofSize: 12)
        leftOfNum.textAlignment = .center
        leftOfNum.textColor = UIColor.gray
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
