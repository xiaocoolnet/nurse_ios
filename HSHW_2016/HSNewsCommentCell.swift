//
//  HSNewsCommentCell.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/7/3.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
//import Alamofire

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

            if  !NurseUtil.net.isWifi() && loadPictureOnlyWiFi {
                self.headerBtn.setImage(UIImage.init(named: "img_head_nor"), for: UIControlState())
            }else{
                self.headerBtn.sd_setImage(with: URL.init(string: SHOW_IMAGE_HEADER+(commentModel?.photo)!), for: UIControlState(), placeholderImage: UIImage.init(named: "img_head_nor"))
            }
            
            for view in self.contentView.subviews {
                if view.tag == 1000 {
                    view.removeFromSuperview()
                }
            }
            
            let height = calculateHeight((self.commentModel!.content), size: 14, width: WIDTH-62-16)
            
            var child_commentBtnY = 8+40+8+height+8+14+8
            
//            print((self.commentModel!.content),child_commentBtnY,self.commentModel?.username)
            for (_,child_comment) in (commentModel?.child_comments)!.enumerated() {
                
                let child_commentBtnHeight = child_comment.content.boundingRect(
                    with: CGSize(width: WIDTH-52-8-10-30-16, height: 0),
                    options: .usesLineFragmentOrigin,
                    attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14)],
                    context: nil).size.height+10

                let bgView = UIView(frame: CGRect(
                    x: self
                        .contentLab.frame.origin.x+30,
                    y: child_commentBtnY,
                    width: WIDTH-52-8-30-16,
                    height: child_commentBtnHeight+5+25))
                bgView.tag = 1000
                bgView.backgroundColor = UIColor(red: 249/255.0, green: 242/255.0, blue: 247/255.0, alpha: 1)
                self.contentView.addSubview(bgView)
                
                // 用户名
                let child_comment_userNameLab = UILabel(frame: CGRect(
                    x: 5,
                    y: 5,
                    width: WIDTH-52-8-10-30,
                    height: 25))
                child_comment_userNameLab.textAlignment = .left
                child_comment_userNameLab.numberOfLines = 1
                
                child_comment_userNameLab.textColor = COLOR
                child_comment_userNameLab.font = UIFont.systemFont(ofSize: 14)
                child_comment_userNameLab.text = child_comment.username+"："
                bgView.addSubview(child_comment_userNameLab)
                
                // 子评论内容
                let child_commentLab = UILabel(frame: CGRect(
                    x: 5,
                    y: child_comment_userNameLab.frame.maxY,
                    width: WIDTH-52-8-10-30-16,
                    height: child_commentBtnHeight))
                child_commentLab.textAlignment = .left
                child_commentLab.numberOfLines = 0
                
                child_commentLab.textColor = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1)
                child_commentLab.font = UIFont.systemFont(ofSize: 14)
                child_commentLab.text = child_comment.content
                bgView.addSubview(child_commentLab)
                
                child_commentBtnY = bgView.frame.maxY
                
            }
            
            let lineView = UIView(frame: CGRect(
                x: 52,
                y: child_commentBtnY+8,
                width: WIDTH-62-16,
                height: 1))
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
        dfmatter.dateFormat="MM-dd hh:mm"
        
        let date = Date(timeIntervalSince1970: timeSta)
        
//        print(dfmatter.stringFromDate(date))
        return dfmatter.string(from: date)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
