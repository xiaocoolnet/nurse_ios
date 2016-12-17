//
//  GHSExamTableViewCell.swift
//  HSHW_2016
//
//  Created by DreamCool on 16/7/28.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class GHSExamTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newsTitle: UILabel!

    @IBOutlet weak var timeLabel: UILabel!
    
    var selfModel:xamInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func showforModel(_ model:xamInfo){
//        print(model.title)
        newsTitle.text = "123456789"
        newsTitle.text = model.title
        timeLabel.text = timeStampToString(model.createtime)
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
