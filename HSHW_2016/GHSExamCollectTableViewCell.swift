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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImg.frame = CGRect(x: 8, y: 5+8, width: 25, height: 30)
        iconImg.image = UIImage.init(named: "ic_note")
        self.contentView.addSubview(iconImg)
        
        examTitle.frame = CGRect(x: iconImg.frame.maxX+5, y: 4+8, width: WIDTH-16-iconImg.frame.maxX-5, height: 18)
        examTitle.font = UIFont.systemFont(ofSize: 14)
        examTitle.textColor = UIColor.black
        examTitle.textAlignment = NSTextAlignment.left
        self.contentView.addSubview(examTitle)
        
        timeLabel.frame = CGRect(x: iconImg.frame.maxX+5, y: examTitle.frame.maxY+1, width: WIDTH-16-iconImg.frame.maxX-5, height: 13)
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textColor = UIColor.lightGray
        timeLabel.textAlignment = NSTextAlignment.right
        self.contentView.addSubview(timeLabel)
        
    }

    func showforModel(_ model:xamInfo){
//        print(model.title)
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
    
    func showforNewsModel(_ model:NewsInfo){
//        print(model.title)
        //        examTitle.text = "123456789"
        examTitle.text = model.title
        timeLabel.text = timeStampToString(model.create_time!)
        
        //        if (newsTitle != nil) {
        //            newsTitle.text = model.title
        //        }
        //        if (timeLab != nil) {
        //            timeLab.text = timeStampToString(model.createtime)
        //        }
        //        selfModel = model
    }
    
    // Linux时间戳转标准时间
    func timeStampToString(_ timeStamp:String)->String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy-MM-dd"
        
        let date = Date(timeIntervalSince1970: timeSta)
        
//        print(dfmatter.stringFromDate(date))
        return dfmatter.string(from: date)
    }
    
}
