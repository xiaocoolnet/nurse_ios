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
        
        titImg.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
//        titImg.layer.cornerRadius = 25
//        titImg.clipsToBounds = true
        
        titleLab.frame = CGRect(x: 75, y: 10, width: 150, height: 50)
        titleLab.font = UIFont.systemFont(ofSize: 16)
        
        timeLab.frame = CGRect(x: WIDTH - 80 - 20, y: 10, width: 100, height: 50)
        timeLab.textColor = UIColor.darkGray
        timeLab.font = UIFont.systemFont(ofSize: 14)
        
        let line = UILabel(frame: CGRect(x: 0, y: 69.5, width: WIDTH, height: 0.5))
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
    
    var fanModel:NewsInfo?{
        didSet {
            
            titImg.image = UIImage(named: "ic_note.png")
            titleLab.text = fanModel?.title
            titleLab.numberOfLines = 0
            timeLab.text = timeStampToString((fanModel?.create_time)!)
            
        }
        
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
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
