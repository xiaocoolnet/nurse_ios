//
//  NSCircleCommentTableViewCell.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/14.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class NSCircleCommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headerBtn: UIButton!
    
    @IBOutlet weak var nameLab: UILabel!
    
    var positionLab = UILabel()
    
    @IBOutlet weak var timeLab: UILabel!
    
    @IBOutlet weak var floorLab: UILabel!
    
    @IBOutlet weak var levelLab: UILabel!
    
    @IBOutlet weak var contentLab: UILabel!
    
    let dateImg = UIImageView()
    let dateLab = UILabel()
    
    let likeImg = UIImageView()
    let likeBtn = UIButton()
    
    let deleteBtn = UIButton()
    
    let replyBtn = UIButton()
    
    let reportBtn = UIButton()
    
    //    var delegate:child_commentBtnClickDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        positionLab.textAlignment = .Center
        positionLab.font = UIFont.systemFontOfSize(9)
        positionLab.textColor = UIColor.whiteColor()
        self.contentView.addSubview(positionLab)
        
        dateImg.image = UIImage(named: "时间")
        dateImg.frame.size = CGSize(width: 7, height: 7)
        dateImg.contentMode = .ScaleAspectFill
        self.contentView.addSubview(dateImg)
        
        dateLab.font = UIFont.systemFontOfSize(10)
        dateLab.textColor = UIColor(red: 178/255.0, green: 178/255.0, blue: 178/255.0, alpha: 1)
        self.contentView.addSubview(dateLab)
        
//        likeImg.image = UIImage(named: "赞")
//        likeImg.frame.size = CGSize(width: 7, height: 7)
//        likeImg.contentMode = .ScaleAspectFill
//        self.contentView.addSubview(likeImg)
        
        likeBtn.titleLabel?.font = UIFont.systemFontOfSize(10)
        likeBtn.setImage(UIImage(named: "赞"), forState: .Normal)
        likeBtn.setImage(UIImage(named: "已点赞"), forState: .Selected)
        likeBtn.setTitleColor(UIColor(red: 178/255.0, green: 178/255.0, blue: 178/255.0, alpha: 1), forState: .Normal)
        likeBtn.setTitleColor(COLOR, forState: .Selected)
        likeBtn.setTitle("点赞", forState: .Normal)
        likeBtn.setTitle("已点赞", forState: .Selected)
        self.contentView.addSubview(likeBtn)
        
        deleteBtn.titleLabel?.font = UIFont.systemFontOfSize(12)
        deleteBtn.setTitleColor(UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1), forState: .Normal)
        deleteBtn.setTitle("删除", forState: .Normal)
        deleteBtn.sizeToFit()
        self.contentView.addSubview(deleteBtn)
        
        replyBtn.titleLabel?.font = UIFont.systemFontOfSize(12)
        replyBtn.setTitleColor(COLOR, forState: .Normal)
        replyBtn.setTitle("回复", forState: .Normal)
        replyBtn.sizeToFit()
        self.contentView.addSubview(replyBtn)
        
        reportBtn.titleLabel?.font = UIFont.systemFontOfSize(12)
        reportBtn.setTitleColor(UIColor(red: 225/255.0, green: 202/255.0, blue: 217/255.0, alpha: 1), forState: .Normal)
        reportBtn.setTitle("举报", forState: .Normal)
        reportBtn.sizeToFit()
        self.contentView.addSubview(reportBtn)
    }
    
    var commentModel:ForumCommentDataModel? {
        didSet {
            
            if  !NurseUtil.net.isWifi() && loadPictureOnlyWiFi {
                self.headerBtn.setImage(UIImage.init(named: "img_head_nor"), forState: .Normal)
            }else{
                self.headerBtn.sd_setImageWithURL(NSURL.init(string: SHOW_IMAGE_HEADER+(commentModel?.photo)!), forState: .Normal, placeholderImage: UIImage.init(named: "img_head_nor"))
            }
            
            nameLab.text = commentModel?.username
            
            positionLab.text = commentModel?.major
            positionLab.sizeToFit()
            positionLab.frame.size.width = positionLab.frame.width+positionLab.frame.height
            positionLab.frame.origin.x = calculateWidth((commentModel?.username ?? "")!, size: 12, height: 15)+64
            positionLab.center.y = nameLab.center.y
            positionLab.layer.cornerRadius = positionLab.frame.height/2.0
            positionLab.layer.backgroundColor = COLOR.CGColor

            timeLab.text = self.updateTime((commentModel?.add_time)!)
            
            contentLab.text = commentModel?.content
            
            for view in self.contentView.subviews {
                if view.tag == 1000 {
                    view.removeFromSuperview()
                }
            }
            
            let contetnHeight = calculateHeight((self.commentModel!.content), size: 14, width: WIDTH-10-16)
            
            var child_commentBtnY = 8+40+8+contetnHeight+8
            
            for (_,child_comment) in (commentModel?.child_comments)!.enumerate() {
                
                let child_commentBtnHeight = child_comment.content.boundingRectWithSize(
                    CGSizeMake(WIDTH-8-8-40-8-8-8-10, 0),
                    options: .UsesLineFragmentOrigin,
                    attributes: [NSFontAttributeName:UIFont.systemFontOfSize(12)],
                    context: nil).size.height+10
                
                let bgView = UIView(frame: CGRectMake(
                    self
                        .nameLab.frame.origin.x,
                    child_commentBtnY,
                    WIDTH-8-8-40-8-8-8,
                    5+20+5+child_commentBtnHeight+5))
                bgView.tag = 1000
                bgView.backgroundColor = UIColor(red: 249/255.0, green: 242/255.0, blue: 247/255.0, alpha: 1)
                self.contentView.addSubview(bgView)
                
                // 用户名
                let child_comment_userNameLab = UILabel(frame: CGRectMake(
                    5,
                    5,
                    WIDTH-8-8-40-8-8-8-10,
                    20))
                child_comment_userNameLab.textAlignment = .Left
                child_comment_userNameLab.numberOfLines = 1
                
                child_comment_userNameLab.textColor = COLOR
                child_comment_userNameLab.font = UIFont.systemFontOfSize(10)
                child_comment_userNameLab.text = child_comment.username+"："
                child_comment_userNameLab.adjustsFontSizeToFitWidth = true
//                child_comment_userNameLab.backgroundColor = UIColor.cyanColor()
                bgView.addSubview(child_comment_userNameLab)
                
                // 子评论内容
                let child_commentLab = UILabel(frame: CGRectMake(
                    5,
                    CGRectGetMaxY(child_comment_userNameLab.frame)+5,
                    WIDTH-8-8-40-8-8-8-10,
                    child_commentBtnHeight))
                child_commentLab.textAlignment = .Left
                child_commentLab.numberOfLines = 0
                
                child_commentLab.textColor = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1)
                child_commentLab.font = UIFont.systemFontOfSize(12)
                child_commentLab.text = child_comment.content
//                child_commentLab.backgroundColor = UIColor.greenColor()
                bgView.addSubview(child_commentLab)
                
                child_commentBtnY = CGRectGetMaxY(bgView.frame)
                
            }
            
            // toolbar 
            dateImg.frame.origin = CGPoint(x: headerBtn.frame.minX, y: child_commentBtnY+8)
            dateLab.text = timeStampToString((commentModel?.add_time ?? "")!)
            dateLab.sizeToFit()
            dateLab.frame.origin.x = dateImg.frame.maxX+5
            dateLab.center.y = dateImg.center.y
            
            likeBtn.sizeToFit()
            likeBtn.frame.origin.x = dateLab.frame.maxX+10
            likeBtn.center.y = dateImg.center.y
            
            reportBtn.frame.origin.x = WIDTH-8-8-reportBtn.frame.width
            reportBtn.center.y = dateImg.center.y
            
            replyBtn.frame.origin.x = reportBtn.frame.origin.x-10-replyBtn.frame.width
            replyBtn.center.y = dateImg.center.y
            
            deleteBtn.frame.origin.x = replyBtn.frame.origin.x-10-deleteBtn.frame.width
            deleteBtn.center.y = dateImg.center.y
            
            deleteBtn.hidden = commentModel?.userid == QCLoginUserInfo.currentInfo.userid ? false:true
            
            let lineView = UIView(frame: CGRectMake(
                0,
                child_commentBtnY+8+7+8,
                WIDTH,
                1/UIScreen.mainScreen().scale))
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
        dfmatter.dateFormat="yyyy/MM/dd"
        
        let date = NSDate(timeIntervalSince1970: timeSta)
        
        //        print(dfmatter.stringFromDate(date))
        return dfmatter.stringFromDate(date)
    }
    
    // MARK: - 时间戳转 “天前”
    func updateTime(time:String) -> String {
        // 获取当前时时间戳
        let currentTime = NSDate().timeIntervalSince1970
        // 创建时间
        let createTime = NSString(string: time).doubleValue
        // 时间差
        let second = currentTime - createTime
        
        if (second<60) {
            return "\(second)秒前"
        }
        // 秒转分钟
        let minutes = Int(second)/60
        if (minutes<60) {
            return "\(minutes)分钟前"
        }
        // 秒转小时
        let hours = Int(second)/3600
        if (hours<24) {
            return "\(hours)小时前"
        }
        //秒转天数
        let days = Int(second)/3600/24
        if (days < 30) {
            return "\(days)天前"
        }
        //秒转月
        let months = Int(second)/3600/24/30
        if (months < 12) {
            return "\(months)月前"
        }
        //秒转年
        let years = Int(second)/3600/24/30/12;
        return "\(years)年前"
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
