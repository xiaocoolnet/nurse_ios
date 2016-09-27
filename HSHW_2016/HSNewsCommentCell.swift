//
//  HSNewsCommentCell.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/7/3.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire

//protocol child_commentBtnClickDelegate {
//    func child_commentBtnClick(commentModel:commentDataModel, child_commentModel: Child_CommentsModel)
//}

class HSNewsCommentCell: UITableViewCell {

    @IBOutlet weak var headerBtn: UIButton!
    
    @IBOutlet weak var nameLab: UILabel!
    
    @IBOutlet weak var positionLab: UILabel!
    
    @IBOutlet weak var levelLab: UILabel!
    
    @IBOutlet weak var contentLab: UILabel!
    
    @IBOutlet weak var timeLab: UILabel!
    
    @IBOutlet weak var floorLab: UILabel!
    
//    var delegate:child_commentBtnClickDelegate?
    
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
    
    var commentModel:commentDataModel? {
        didSet {
            nameLab.text = commentModel?.username
            contentLab.text = commentModel?.content
            timeLab.text = self.timeStampToString((commentModel?.add_time)!)
            if  !(NetworkReachabilityManager()?.isReachableOnEthernetOrWiFi)! && loadPictureOnlyWiFi {
                self.headerBtn.setImage(UIImage.init(named: "img_head_nor"), forState: .Normal)
            }else{
                self.headerBtn.sd_setImageWithURL(NSURL.init(string: SHOW_IMAGE_HEADER+(commentModel?.photo)!), forState: .Normal, placeholderImage: UIImage.init(named: "img_head_nor"))
            }
            
            for view in self.contentView.subviews {
                if view.tag == 1000 {
                    view.removeFromSuperview()
                }
            }
            
            var child_commentBtnY = CGRectGetMaxY(timeLab.frame)+8
            for (_,child_comment) in (commentModel?.child_comments)!.enumerate() {
                
                let str = child_comment.username+"："+child_comment.content
                let nsStr = NSString(string: str)
                let attStr = NSMutableAttributedString(string: str)
                
                attStr.addAttributes([NSForegroundColorAttributeName: UIColor.blackColor(),NSFontAttributeName:UIFont.systemFontOfSize(14)], range: NSMakeRange(0, nsStr.length))
                attStr.addAttributes([NSForegroundColorAttributeName: COLOR,NSFontAttributeName:UIFont.systemFontOfSize(14)], range: NSMakeRange(0, nsStr.rangeOfString("：").location))
                
                let child_commentBtnHeight = attStr.boundingRectWithSize(CGSizeMake(WIDTH-62-10, 0), options: .UsesLineFragmentOrigin, context: nil).size.height+10
                
                let bgView = UIView(frame: CGRectMake(
                    self
                        .contentLab.frame.origin.x,
                    child_commentBtnY,
                    WIDTH-62,
                    child_commentBtnHeight))
                bgView.tag = 1000
                bgView.backgroundColor = UIColor.lightGrayColor()
                self.contentView.addSubview(bgView)
                
//                let child_commentBtn = UIButton(frame: CGRectMake(
//                    5,
//                    0,
//                    WIDTH-62-10,
//                    child_commentBtnHeight))
//                child_commentBtn.contentHorizontalAlignment = .Left
//                child_commentBtn.titleLabel?.numberOfLines = 0
//                
//                child_commentBtn.setAttributedTitle(attStr, forState: .Normal)
//                child_commentBtn.tag = i
////                child_commentBtn.addTarget(self, action: #selector(child_commentBtnClick(_:)), forControlEvents: .TouchUpInside)
//                bgView.addSubview(child_commentBtn)
                let child_commentLab = UILabel(frame: CGRectMake(
                    5,
                    0,
                    WIDTH-62-10,
                    child_commentBtnHeight))
                child_commentLab.textAlignment = .Left
                child_commentLab.numberOfLines = 0
                
                child_commentLab.attributedText = attStr
//                child_commentLab.tag = i
                //                child_commentBtn.addTarget(self, action: #selector(child_commentBtnClick(_:)), forControlEvents: .TouchUpInside)
                bgView.addSubview(child_commentLab)
                
                child_commentBtnY = CGRectGetMaxY(bgView.frame)
                
            }
            
            let lineView = UIView(frame: CGRectMake(
                self
                    .contentLab.frame.origin.x,
                child_commentBtnY+8,
                WIDTH-62,
                1))
            lineView.tag = 1000
            lineView.backgroundColor = UIColor.lightGrayColor()
            self.contentView.addSubview(lineView)
        }
    }
    
//    func child_commentBtnClick(child_commentBtn: UIButton) {
//        self.delegate!.child_commentBtnClick(self.commentModel!, child_commentModel: (self.commentModel?.child_comments[child_commentBtn.tag])!)
//    }
    
    // Linux时间戳转标准时间
    func timeStampToString(timeStamp:String)->String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:NSTimeInterval = string.doubleValue
        let dfmatter = NSDateFormatter()
        dfmatter.dateFormat="MM-dd hh:mm"
        
        let date = NSDate(timeIntervalSince1970: timeSta)
        
//        print(dfmatter.stringFromDate(date))
        return dfmatter.stringFromDate(date)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
