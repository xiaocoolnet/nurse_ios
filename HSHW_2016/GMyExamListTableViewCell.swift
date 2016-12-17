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
        
        titImg.frame = CGRect(x: 8, y: 20, width: 25, height: 30)
        titImg.image = UIImage.init(named: "ic_note")
//        titImg.layer.cornerRadius = 25
//        titImg.clipsToBounds = true
        
        titleLab.frame = CGRect(x: 75+30+15, y: 15, width: 50, height: 20)
        titleLab.font = UIFont.systemFont(ofSize: 15)
        
        timeLab.frame = CGRect(x: 75+30+15, y: 15, width: 50, height: 20)
        timeLab.textColor = UIColor.darkGray
        timeLab.font = UIFont.systemFont(ofSize: 12)
        
        // 做题数 label
        countLab.frame = CGRect(x: WIDTH-100-10, y: 15, width: 100, height: 40)
        countLab.textColor = UIColor.darkGray
        countLab.numberOfLines = 0
        countLab.font = UIFont.systemFont(ofSize: 12)
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
            titleLab.frame = CGRect(x: titImg.frame.maxX+15, y: 15, width: titleLab.frame.width, height: 20)
            
            timeLab.text = "答题时间："+timeStampToString((fansModel?.create_time)!)
            timeLab.sizeToFit()
            timeLab.frame = CGRect(x: titImg.frame.maxX+15, y: 35, width: timeLab.frame.width, height: 20)
            
            countLab.text = "正确："+(fansModel?.rightcount)!+"\n已做："+String((fansModel?.question.count)!)
            countLab.sizeToFit()
            countLab.frame = CGRect(x: WIDTH-countLab.frame.width-10, y: 15, width: countLab.frame.width, height: 40)
            
            
        }
        
    }
    
    // Linux时间戳转标准时间
    func timeStampToString(_ timeStamp:String)->String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy/MM/dd hh:mm"
        
        let date = Date(timeIntervalSince1970: timeSta)
        
//        print(dfmatter.stringFromDate(date))
        return dfmatter.string(from: date)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
