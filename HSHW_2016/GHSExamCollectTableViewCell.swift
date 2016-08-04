//
//  GHSExamCollectTableViewCell.swift
//  HSHW_2016
//
//  Created by zhang on 16/8/4.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class GHSExamCollectTableViewCell: UITableViewCell {

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
        
        examTitle.frame = CGRectMake(5, 4, WIDTH, 18)
        self.addSubview(examTitle)
        
    }

    func showforModel(model:xamInfo){
//        print(model.title)
//        examTitle.text = "123456789"
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
