//
//  GMyExamListTableViewCell.swift
//  HSHW_2016
//
//  Created by DreamCool on 16/7/17.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class GMyExamListTableViewCell: UITableViewCell {

    var inde:Int = 0
//    let indexLab = UILabel()
    let titImg = UIImageView()
    let titleLab = UILabel()
    let timeLab = UILabel()
    let countLab = UILabel()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        
//        indexLab.frame = CGRectMake(10, 10, 50, 50)
//        indexLab.textColor = UIColor.darkGrayColor()
        
        titImg.frame = CGRectMake(8, 20, 25, 30)
        titImg.image = UIImage.init(named: "ic_note")
//        titImg.layer.cornerRadius = 25
//        titImg.clipsToBounds = true
        
        titleLab.frame = CGRectMake(75+30+15, 15, 50, 20)
        titleLab.font = UIFont.systemFontOfSize(15)
        
        timeLab.frame = CGRectMake(75+30+15, 15, 50, 20)
        timeLab.textColor = UIColor.darkGrayColor()
        timeLab.font = UIFont.systemFontOfSize(12)
        
        // 做题数 label
        countLab.frame = CGRectMake(WIDTH-100-10, 15, 100, 40)
        countLab.textColor = UIColor.darkGrayColor()
        countLab.numberOfLines = 0
        countLab.font = UIFont.systemFontOfSize(12)
        countLab.adjustsFontSizeToFitWidth = true
        
//        self.addSubview(indexLab)
        self.addSubview(titImg)
        self.addSubview(titleLab)
        self.addSubview(timeLab)
        self.addSubview(countLab)
        
    }
    
    var fansModel:GTestExamList?{
        didSet {

            titleLab.text = fansModel?.post_title
            titleLab.sizeToFit()
            titleLab.frame = CGRectMake(CGRectGetMaxX(titImg.frame)+15, 15, CGRectGetWidth(titleLab.frame), 20)
            
            timeLab.text = "答题时间："+timeStampToString((fansModel?.create_time)!)
            timeLab.sizeToFit()
            timeLab.frame = CGRectMake(CGRectGetMaxX(titImg.frame)+15, 35, CGRectGetWidth(timeLab.frame), 20)
            
            countLab.text = "正确："+(fansModel?.rightcount)!+"\n已做："+String((fansModel?.question.count)!)
            countLab.sizeToFit()
            countLab.frame = CGRectMake(WIDTH-CGRectGetWidth(countLab.frame)-10, 15, CGRectGetWidth(countLab.frame), 40)
            
            
        }
        
    }
    
    // Linux时间戳转标准时间
    func timeStampToString(timeStamp:String)->String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:NSTimeInterval = string.doubleValue
        let dfmatter = NSDateFormatter()
        dfmatter.dateFormat="yyyy/MM/dd hh:mm"
        
        let date = NSDate(timeIntervalSince1970: timeSta)
        
//        print(dfmatter.stringFromDate(date))
        return dfmatter.stringFromDate(date)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
