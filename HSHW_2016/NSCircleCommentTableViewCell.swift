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
    
    @IBOutlet weak var positionLab: UILabel!
    
    @IBOutlet weak var positionLabWidth: NSLayoutConstraint!
    
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
        
        positionLab.textAlignment = .center
        positionLab.font = UIFont.systemFont(ofSize: 9)
        positionLab.textColor = UIColor.white
        self.contentView.addSubview(positionLab)
        
        dateImg.image = UIImage(named: "时间")
        dateImg.frame.size = CGSize(width: 7, height: 7)
        dateImg.contentMode = .scaleAspectFill
        self.contentView.addSubview(dateImg)
        
        dateLab.font = UIFont.systemFont(ofSize: 10)
        dateLab.textColor = UIColor(red: 178/255.0, green: 178/255.0, blue: 178/255.0, alpha: 1)
        self.contentView.addSubview(dateLab)
        
//        likeImg.image = UIImage(named: "赞")
//        likeImg.frame.size = CGSize(width: 7, height: 7)
//        likeImg.contentMode = .ScaleAspectFill
//        self.contentView.addSubview(likeImg)
        
        likeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        likeBtn.setImage(UIImage(named: "赞"), for: .normal)
        likeBtn.setImage(UIImage(named: "已点赞"), for: .selected)
        likeBtn.setTitleColor(UIColor(red: 178/255.0, green: 178/255.0, blue: 178/255.0, alpha: 1), for: .normal)
        likeBtn.setTitleColor(COLOR, for: .selected)
        likeBtn.setTitle("点赞", for: .normal)
        likeBtn.setTitle("已点赞", for: .selected)
        self.contentView.addSubview(likeBtn)
        
        deleteBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        deleteBtn.setTitleColor(UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1), for: UIControlState())
        deleteBtn.setTitle("删除", for: UIControlState())
        deleteBtn.sizeToFit()
        self.contentView.addSubview(deleteBtn)
        
        replyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        replyBtn.setTitleColor(COLOR, for: UIControlState())
        replyBtn.setTitle("回复", for: UIControlState())
        replyBtn.sizeToFit()
        self.contentView.addSubview(replyBtn)
        
        reportBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        reportBtn.setTitleColor(UIColor(red: 225/255.0, green: 202/255.0, blue: 217/255.0, alpha: 1), for: UIControlState())
        reportBtn.setTitle("举报", for: UIControlState())
        reportBtn.sizeToFit()
        self.contentView.addSubview(reportBtn)
    }
    
    var commentModel:ForumCommentsDataModel? {
        didSet {
            
            if  !NurseUtil.net.isWifi() && loadPictureOnlyWiFi {
                self.headerBtn.setImage(UIImage.init(named: "img_head_nor"), for: UIControlState())
            }else{
                self.headerBtn.sd_setImage(with: URL.init(string: SHOW_IMAGE_HEADER+(commentModel?.photo)!), for: UIControlState(), placeholderImage: UIImage.init(named: "img_head_nor"))
            }
            
            nameLab.text = commentModel?.username
            nameLab.layoutIfNeeded()
            
            positionLab.text = commentModel?.major
            positionLab.sizeToFit()
            positionLabWidth.constant = calculateWidth((commentModel?.major ?? "")!, size: 9, height: positionLab.frame.height)+positionLab.frame.height
            positionLab.layer.cornerRadius = positionLab.frame.height/2.0
            positionLab.layer.backgroundColor = COLOR.cgColor

            timeLab.text = updateTime((commentModel?.add_time)!)
            
            contentLab.text = commentModel?.content
            
            for view in self.contentView.subviews {
                if view.tag == 1000 {
                    view.removeFromSuperview()
                }
            }
            
            let contetnHeight = calculateHeight((self.commentModel!.content), size: 14, width: WIDTH-10-16)
            
            var child_commentBtnY = 8+40+8+contetnHeight+8
            
            for (_,child_comment) in (commentModel?.child_comments)!.enumerated() {
                
                let child_commentBtnHeight = child_comment.content.boundingRect(
                    with: CGSize(width: WIDTH-8-8-40-8-8-8-10, height: 0),
                    options: .usesLineFragmentOrigin,
                    attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 12)],
                    context: nil).size.height+10
                
                let bgView = UIView(frame: CGRect(
                    x: self
                        .nameLab.frame.origin.x,
                    y: child_commentBtnY,
                    width: WIDTH-8-8-40-8-8-8,
                    height: 5+20+5+child_commentBtnHeight+5))
                bgView.tag = 1000
                bgView.backgroundColor = UIColor(red: 249/255.0, green: 242/255.0, blue: 247/255.0, alpha: 1)
                self.contentView.addSubview(bgView)
                
                // 用户名
                let child_comment_userNameLab = UILabel(frame: CGRect(
                    x: 5,
                    y: 5,
                    width: WIDTH-8-8-40-8-8-8-10,
                    height: 20))
                child_comment_userNameLab.textAlignment = .left
                child_comment_userNameLab.numberOfLines = 1
                
                child_comment_userNameLab.textColor = COLOR
                child_comment_userNameLab.font = UIFont.systemFont(ofSize: 10)
                child_comment_userNameLab.text = child_comment.username+"："
                child_comment_userNameLab.adjustsFontSizeToFitWidth = true
//                child_comment_userNameLab.backgroundColor = UIColor.cyanColor()
                bgView.addSubview(child_comment_userNameLab)
                
                // 子评论内容
                let child_commentLab = UILabel(frame: CGRect(
                    x: 5,
                    y: child_comment_userNameLab.frame.maxY+5,
                    width: WIDTH-8-8-40-8-8-8-10,
                    height: child_commentBtnHeight))
                child_commentLab.textAlignment = .left
                child_commentLab.numberOfLines = 0
                
                child_commentLab.textColor = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1)
                child_commentLab.font = UIFont.systemFont(ofSize: 12)
                child_commentLab.text = child_comment.content
//                child_commentLab.backgroundColor = UIColor.greenColor()
                bgView.addSubview(child_commentLab)
                
                child_commentBtnY = bgView.frame.maxY
                
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
            
            if commentModel?.userid == QCLoginUserInfo.currentInfo.userid {
                
                reportBtn.isHidden = true
                
                replyBtn.frame.origin.x = WIDTH-8-8-reportBtn.frame.width
                replyBtn.center.y = dateImg.center.y
                
                deleteBtn.frame.origin.x = replyBtn.frame.origin.x-10-deleteBtn.frame.width
                deleteBtn.center.y = dateImg.center.y

            }else{
                reportBtn.isHidden = false

                reportBtn.frame.origin.x = WIDTH-8-8-reportBtn.frame.width
                reportBtn.center.y = dateImg.center.y
                
                replyBtn.frame.origin.x = reportBtn.frame.origin.x-10-replyBtn.frame.width
                replyBtn.center.y = dateImg.center.y
                
                deleteBtn.frame.origin.x = replyBtn.frame.origin.x-10-deleteBtn.frame.width
                deleteBtn.center.y = dateImg.center.y
            }
            

//            deleteBtn.isHidden = commentModel?.userid == QCLoginUserInfo.currentInfo.userid ? false:true
            
            let lineView = UIView(frame: CGRect(
                x: 0,
                y: child_commentBtnY+8+7+8+5,
                width: WIDTH,
                height: 1/UIScreen.main.scale))
            lineView.tag = 1000
            lineView.backgroundColor = UIColor.lightGray
            self.contentView.addSubview(lineView)
        }
    }
    
    //    func child_commentBtnClick(child_commentBtn: UIButton) {
    //        self.delegate!.child_commentBtnClick(self.commentModel!, child_commentModel: (self.commentModel?.child_comments[child_commentBtn.tag])!)
    //    }
    
    // Linux时间戳转标准时间
    func timeStampToString(_ timeStamp:String)->String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy/MM/dd"
        
        let date = Date(timeIntervalSince1970: timeSta)
        
        //        print(dfmatter.stringFromDate(date))
        return dfmatter.string(from: date)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
