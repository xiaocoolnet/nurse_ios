//
//  GHSExamCollectTableViewCell.swift
//  HSHW_2016
//
//  Created by zhang on 16/8/4.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class GHSExamCollectTableViewCell: UITableViewCell {

    let iconImg = UIImageView()
    let examTitle = UILabel()
    let timeLabel = UILabel()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImg.frame = CGRectMake(8, 5+8, 25, 30)
        iconImg.image = UIImage.init(named: "ic_note")
        self.contentView.addSubview(iconImg)
        
        examTitle.frame = CGRectMake(CGRectGetMaxX(iconImg.frame)+5, 4+8, WIDTH-16-CGRectGetMaxX(iconImg.frame)-5, 18)
        examTitle.font = UIFont.systemFontOfSize(14)
        examTitle.textColor = UIColor.blackColor()
        examTitle.textAlignment = NSTextAlignment.Left
        self.contentView.addSubview(examTitle)
        
        timeLabel.frame = CGRectMake(CGRectGetMaxX(iconImg.frame)+5, CGRectGetMaxY(examTitle.frame)+1, WIDTH-16-CGRectGetMaxX(iconImg.frame)-5, 13)
        timeLabel.font = UIFont.systemFontOfSize(12)
        timeLabel.textColor = UIColor.lightGrayColor()
        timeLabel.textAlignment = NSTextAlignment.Right
        self.contentView.addSubview(timeLabel)
        
    }

    func showforModel(model:xamInfo){
        print(model.title)
//        examTitle.text = "123456789"
        examTitle.text = model.title
        timeLabel.text = timeStampToString(model.createtime)

//        if (newsTitle != nil) {
//            newsTitle.text = model.title
//        }
//        if (timeLab != nil) {
//            timeLab.text = timeStampToString(model.createtime)
//        }
//        selfModel = model
    }
    
    // Linux时间戳转标准时间
    func timeStampToString(timeStamp:String)->String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:NSTimeInterval = string.doubleValue
        let dfmatter = NSDateFormatter()
        dfmatter.dateFormat="yyyy-MM-dd"
        
        let date = NSDate(timeIntervalSince1970: timeSta)
        
        print(dfmatter.stringFromDate(date))
        return dfmatter.stringFromDate(date)
    }
    
}
