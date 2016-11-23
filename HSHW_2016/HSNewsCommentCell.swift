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
    
    @IBOutlet weak var contentLab: UILabel!
    
    @IBOutlet weak var timeLab: UILabel!
    
    @IBOutlet weak var floorLab: UILabel!
    
//    var delegate:child_commentBtnClickDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var commentModel:commentDataModel? {
        didSet {
            nameLab.text = commentModel?.username
            contentLab.text = commentModel?.content
            timeLab.text = self.timeStampToString((commentModel?.add_time)!)+"    回复"
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
            
            let height = calculateHeight((self.commentModel!.content), size: 14, width: WIDTH-62-16)
            
            var child_commentBtnY = 8+40+8+height+8+14+8
            
//            print((self.commentModel!.content),child_commentBtnY,self.commentModel?.username)
            for (_,child_comment) in (commentModel?.child_comments)!.enumerate() {
                
                let child_commentBtnHeight = child_comment.content.boundingRectWithSize(
                    CGSizeMake(WIDTH-52-8-10-30-16, 0),
                    options: .UsesLineFragmentOrigin,
                    attributes: [NSFontAttributeName:UIFont.systemFontOfSize(14)],
                    context: nil).size.height+10

                let bgView = UIView(frame: CGRectMake(
                    self
                        .contentLab.frame.origin.x+30,
                    child_commentBtnY,
                    WIDTH-52-8-30-16,
                    child_commentBtnHeight+5+25))
                bgView.tag = 1000
                bgView.backgroundColor = UIColor(red: 249/255.0, green: 242/255.0, blue: 247/255.0, alpha: 1)
                self.contentView.addSubview(bgView)
                
                // 用户名
                let child_comment_userNameLab = UILabel(frame: CGRectMake(
                    5,
                    5,
                    WIDTH-52-8-10-30,
                    25))
                child_comment_userNameLab.textAlignment = .Left
                child_comment_userNameLab.numberOfLines = 1
                
                child_comment_userNameLab.textColor = COLOR
                child_comment_userNameLab.font = UIFont.systemFontOfSize(14)
                child_comment_userNameLab.text = child_comment.username+"："
                bgView.addSubview(child_comment_userNameLab)
                
                // 子评论内容
                let child_commentLab = UILabel(frame: CGRectMake(
                    5,
                    CGRectGetMaxY(child_comment_userNameLab.frame),
                    WIDTH-52-8-10-30-16,
                    child_commentBtnHeight))
                child_commentLab.textAlignment = .Left
                child_commentLab.numberOfLines = 0
                
                child_commentLab.textColor = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1)
                child_commentLab.font = UIFont.systemFontOfSize(14)
                child_commentLab.text = child_comment.content
                bgView.addSubview(child_commentLab)
                
                child_commentBtnY = CGRectGetMaxY(bgView.frame)
                
            }
            
            let lineView = UIView(frame: CGRectMake(
                52,
                child_commentBtnY+8,
                WIDTH-62-16,
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
