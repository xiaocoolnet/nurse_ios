//
//  NSCircleNewsTableViewCell.swift
//  HSHW_2016
//
//  Created by 高扬 on 2017/1/6.
//  Copyright © 2017年 校酷网络科技公司. All rights reserved.
//

import UIKit

class NSCircleNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var headerBtn: UIButton!
    
    @IBOutlet weak var contentLab: UILabel!
    
    @IBOutlet weak var userNameLab: UILabel!
    
    @IBOutlet weak var forumNameLab: UILabel!
    
    @IBOutlet weak var timeLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        self.headerBtn.layer.cornerRadius = 25
//        self.headerBtn.layer.masksToBounds = true
        
    }
    
    var newsListDataModel:NewsListDataModel! {
        didSet {
            
//            self.headerBtn.imageView?.sd_setImage(with: URL.init(string: SHOW_IMAGE_HEADER+newsListDataModel.fu_photo), placeholderImage: nil)
            self.headerBtn.sd_setImage(with: URL.init(string: SHOW_IMAGE_HEADER+newsListDataModel.fu_photo), for: .normal, placeholderImage: UIImage(named: "img_head_nor"))


//            self.headerBtn.sd_setImage(with: URL(string: SHOW_IMAGE_HEADER+newsListDataModel.fu_photo), for: UIControlState.normal, placeholderImage: nil)
            self.contentLab.text = newsListDataModel.centent
            self.userNameLab.text = newsListDataModel.fu_name
            self.forumNameLab.text = newsListDataModel.forum_title
            
            self.timeLab.text = updateTime(newsListDataModel.create_time)
            
        }
    }
    
    // Linux时间戳转标准时间
    func timeStampToString(_ timeStamp:String)->String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="MM月dd日"
        
        let date = Date(timeIntervalSince1970: timeSta)
        
        //        print(dfmatter.stringFromDate(date))
        return dfmatter.string(from: date)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
