//
//  HSNewsCommentCell.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/7/3.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire

class HSNewsCommentCell: UITableViewCell {

    @IBOutlet weak var headerBtn: UIButton!
    
    @IBOutlet weak var nameLab: UILabel!
    
    @IBOutlet weak var positionLab: UILabel!
    
    @IBOutlet weak var levelLab: UILabel!
    
    @IBOutlet weak var contentLab: UILabel!
    
    @IBOutlet weak var timeLab: UILabel!
    
    @IBOutlet weak var floorLab: UILabel!
    
    @IBOutlet weak var line: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
//    var commentModel = 1 {
//        didSet {
//            nameLab.text = "用户\(commentModel)"
//            contentLab.text = "假数据，测试专用，\n真实数据内容敬请期待，\n测试内容\(commentModel)"
//            timeLab.text = self.timeStampToString(String(NSDate().timeIntervalSince1970))
//            
////            HSMineHelper().getUserInfo(QCLoginUserInfo.currentInfo.userid) { (success, response) in
////                let model = response as! HSFansAndFollowModel
////                dispatch_async(dispatch_get_main_queue(), {
////                    if  !(NetworkReachabilityManager()?.isReachableOnEthernetOrWiFi)! && loadPictureOnlyWiFi {
////                        self.headerBtn.setImage(UIImage.init(named: "img_head_nor"), forState: .Normal)
////                    }else{
////                        self.headerBtn.sd_setImageWithURL(NSURL.init(string: SHOW_IMAGE_HEADER+(model.photo)), forState: .Normal, placeholderImage: UIImage.init(named: "img_head_nor"))
////                    }
//////                    self.headerBtn.sd_setImageWithURL(NSURL.init(string: SHOW_IMAGE_HEADER+model.photo), forState: .Normal)
//////                    self.positionLab.text = model.major
//////                    self.levelLab.text = String(format: "Lv.%02d", Int(model.level)!)
////                })
////            }
//        }
//    }
    
    var commentModel:NewsCommentsModel? {
        didSet {
            nameLab.text = commentModel?.username
            contentLab.text = commentModel?.content
            timeLab.text = self.timeStampToString((commentModel?.add_time)!)
            if  !(NetworkReachabilityManager()?.isReachableOnEthernetOrWiFi)! && loadPictureOnlyWiFi {
                self.headerBtn.setImage(UIImage.init(named: "img_head_nor"), forState: .Normal)
            }else{
                self.headerBtn.sd_setImageWithURL(NSURL.init(string: SHOW_IMAGE_HEADER+(commentModel?.photo)!), forState: .Normal, placeholderImage: UIImage.init(named: "img_head_nor"))
            }
        }
    }
    
    // Linux时间戳转标准时间
    func timeStampToString(timeStamp:String)->String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:NSTimeInterval = string.doubleValue
        let dfmatter = NSDateFormatter()
        dfmatter.dateFormat="MM-dd hh:mm"
        
        let date = NSDate(timeIntervalSince1970: timeSta)
        
        print(dfmatter.stringFromDate(date))
        return dfmatter.stringFromDate(date)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
