//
//  MineExamCollectTableViewCell.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MineExamCollectTableViewCell: UITableViewCell {
    
    let titImg = UIImageView()
    let titleLab = UILabel()
    let timeLab = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        
        titImg.frame = CGRectMake(10, 10, 50, 50)
//        titImg.layer.cornerRadius = 25
//        titImg.clipsToBounds = true
        
        titleLab.frame = CGRectMake(75, 10, 150, 50)
        titleLab.font = UIFont.systemFontOfSize(16)
        
        timeLab.frame = CGRectMake(WIDTH*(WIDTH - 80 - 20)/375, 10, 100, 50)
        timeLab.textColor = UIColor.darkGrayColor()
        timeLab.font = UIFont.systemFontOfSize(15)
        
        let line = UILabel(frame: CGRectMake(0, 69.5, WIDTH, 0.5))
        line.backgroundColor = GREY
        
        self.addSubview(titImg)
        self.addSubview(titleLab)
        self.addSubview(timeLab)
        self.addSubview(line)
    }
    
    var fansModel:CollectList?{
        didSet {
            
            titImg.image = UIImage(named: "ic_note.png")
            titleLab.text = fansModel?.title
            titleLab.numberOfLines = 0
            timeLab.text = timeStampToString((fansModel?.createtime)!)
            
        }
        
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
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
