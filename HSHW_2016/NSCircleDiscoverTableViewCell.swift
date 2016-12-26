//
//  NSCircleDiscoverTableViewCell.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/6.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class NSCircleDiscoverTableViewCell: UITableViewCell {
    
    var type = 1 // 1 有分类 2 没分类
    
    let titleLab = UILabel()
    let contantLab = UILabel()
    let titleImg = UIImageView()
    let likeBtn = UIButton()
    let comBtn = UIButton()
    let titSubImg = UIImageView()
    let titSubImg_1 = UIImageView()
    let titSubImg_2 = UIImageView()
    let titSubImg_3 = UIImageView()
    
    let margin:CGFloat = 15 // 三张图 间距
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        
        self.addSubview(titleLab)
        self.addSubview(contantLab)
        self.addSubview(titleImg)
        self.addSubview(titSubImg)
        self.addSubview(likeBtn)
        self.addSubview(comBtn)
        
        self.setSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setSubViews() {
        
        titleLab.font = UIFont.systemFont(ofSize: titleSize)
        titleLab.textColor = UIColor.black
        titleLab.numberOfLines = 0
        
        contantLab.font = UIFont.systemFont(ofSize: contentSize)
        contantLab.textColor = UIColor.gray
        contantLab.numberOfLines = 2
        
        likeBtn.setImage(UIImage(named: "赞"), for: UIControlState())
        likeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        likeBtn.setTitleColor(UIColor.lightGray, for: UIControlState())
        
        comBtn.setImage(UIImage(named: "评论"), for: UIControlState())
        comBtn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        comBtn.setTitleColor(UIColor.lightGray, for: UIControlState())
        
        titleImg.contentMode = .scaleAspectFill
        titleImg.clipsToBounds = true
        
        titSubImg_1.contentMode = .scaleAspectFill
        titSubImg_1.clipsToBounds = true
        titSubImg_1.frame = CGRect(x: 0, y: 0, width: (WIDTH-20-margin*2)/3.0, height: (WIDTH-20-margin*2)/3.0*2/3.0)
        titSubImg.addSubview(titSubImg_1)
        
        titSubImg_2.contentMode = .scaleAspectFill
        titSubImg_2.clipsToBounds = true
        titSubImg_2.frame = CGRect(x: (WIDTH-20-margin*2)/3.0+margin, y: 0, width: (WIDTH-20-margin*2)/3.0, height: (WIDTH-20-margin*2)/3.0*2/3.0)
        titSubImg.addSubview(titSubImg_2)
        
        titSubImg_3.contentMode = .scaleAspectFill
        titSubImg_3.clipsToBounds = true
        titSubImg_3.frame = CGRect(x: ((WIDTH-20-margin*2)/3.0+margin)*2, y: 0, width: (WIDTH-20-margin*2)/3.0, height: (WIDTH-20-margin*2)/3.0*2/3.0)
        titSubImg.addSubview(titSubImg_3)
    }
    
    fileprivate let titleSize:CGFloat = 14
    fileprivate let contentSize:CGFloat = 12
    
    func setCell(with forum:ForumListDataModel) {
        
        
        
        var conNumStr = "0"
        if Int(forum.hits) > 99999 {
            conNumStr = "10W+"
        }else if Int(forum.hits) > 199999 {
            conNumStr = "20W+"
        }else if Int(forum.hits) > 299999 {
            conNumStr = "30W+"
        }else if Int(forum.hits) > 399999 {
            conNumStr = "40W+"
        }else if Int(forum.hits) > 499999 {
            conNumStr = "50W+"
        }else if Int(forum.hits) > 599999 {
            conNumStr = "60W+"
        }else if Int(forum.hits) > 799999 {
            conNumStr = "80W+"
        }else if Int(forum.hits) > 899999 {
            conNumStr = "90W+"
        }else if Int(forum.hits) > 999999 {
            conNumStr = "100W+"
        }else if Int(forum.hits) > 9999999 {
            conNumStr = "1000W+"
        }else{
            conNumStr = forum.hits
        }
        
        
        
        if forum.photo.count == 0 {
            
            titleImg.isHidden = true
            titSubImg.isHidden = true
            
            let height = calculateHeight((forum.title), size: titleSize, width: WIDTH-16)
            self.titleLab.frame = CGRect(x: 8, y: 8, width: WIDTH-16, height: height)
            
            self.titleLab.text = forum.title
            
            var contentHeight = calculateHeight((forum.content), size: contentSize, width: WIDTH-16)
            if contentHeight >= UIFont.systemFont(ofSize: contentSize).lineHeight*3 {
                contentHeight = UIFont.systemFont(ofSize: contentSize).lineHeight*2
            }
            self.contantLab.frame = CGRect(x: 8, y: 8+height+8, width: WIDTH-16, height: contentHeight)
            
            self.contantLab.text = forum.content
            
            likeBtn.setTitle(forum.like, for: UIControlState())
            comBtn.setTitle(forum.hits, for: UIControlState())
            
            likeBtn.sizeToFit()
            likeBtn.frame.origin = CGPoint(x: 8, y: contantLab.frame.maxY+8)
            
            comBtn.sizeToFit()
            comBtn.frame.origin = CGPoint(x: likeBtn.frame.maxX+10, y: contantLab.frame.maxY+8)
            
        }else if forum.photo.count < 3 {
            
            let height = calculateHeight((forum.title), size: titleSize, width: WIDTH-16-110-8)
            self.titleLab.frame = CGRect(x: 8, y: 8, width: WIDTH-16-110-8, height: height)
            
            self.titleLab.text = forum.title
            
            var contentHeight = calculateHeight((forum.content), size: contentSize, width: WIDTH-16-110-8)
            if contentHeight >= UIFont.systemFont(ofSize: contentSize).lineHeight*3 {
                contentHeight = UIFont.systemFont(ofSize: contentSize).lineHeight*2
            }
            self.contantLab.frame = CGRect(x: 8, y: 8+height+8, width: WIDTH-16-110-8, height: contentHeight)
            
            self.contantLab.text = forum.content
            
            if  !NurseUtil.net.isWifi() && loadPictureOnlyWiFi {
                
                titleImg.frame = CGRect(x: WIDTH-110-8, y: 10, width: 110, height: 80)
                self.titleImg.image = UIImage.init(named: "defaultImage.png")
                
                titleImg.isHidden = false
                titSubImg.isHidden = true
            }else{

                let photoUrl:String = SHOW_IMAGE_HEADER+forum.photo.first!
                
                titleImg.frame = CGRect(x: WIDTH-110-8, y: 10, width: 110, height: 80)
                self.titleImg.sd_setImage(with: URL(string:photoUrl), placeholderImage: UIImage(named: "defaultImage.png"))
                
                titleImg.isHidden = false
                titSubImg.isHidden = true
                //        let titleHeight:CGFloat = calculateHeight(newsInfo.post_title!, size: 16, width: WIDTH-140)
                //        titLab.frame.size.height = titleHeight+100
            }
            
            if 8+80+8 < contantLab.frame.maxY+24 {
                titleImg.frame.origin.y = (contantLab.frame.maxY+8+8+8-80)/2.0
            }
            
            likeBtn.setTitle(forum.like, for: UIControlState())
            comBtn.setTitle(forum.hits, for: UIControlState())
            
            likeBtn.sizeToFit()
            likeBtn.frame.origin = CGPoint(x: 8, y: max(8+80-likeBtn.frame.height, contantLab.frame.maxY+8))
            
            comBtn.sizeToFit()
            comBtn.frame.origin = CGPoint(x: likeBtn.frame.maxX+10, y: max(8+80-likeBtn.frame.height, contantLab.frame.maxY+8))
        }else{
            
            let height = calculateHeight((forum.title), size: titleSize, width: WIDTH-16)
            self.titleLab.frame = CGRect(x: 8, y: 8, width: WIDTH-16, height: height)
            
            self.titleLab.text = forum.title
            
            var contentHeight = calculateHeight((forum.content), size: contentSize, width: WIDTH-16)
            if contentHeight >= UIFont.systemFont(ofSize: contentSize).lineHeight*3 {
                contentHeight = UIFont.systemFont(ofSize: contentSize).lineHeight*2
            }
            self.contantLab.frame = CGRect(x: 8, y: 8+height+8, width: WIDTH-16, height: contentHeight)
            
            self.contantLab.text = forum.content
            
            titSubImg.frame = CGRect(x: 8, y: contantLab.frame.maxY+8, width: WIDTH-16, height: (WIDTH-16-margin*2)/3.0*2/3.0)
            
            if  !NurseUtil.net.isWifi() && loadPictureOnlyWiFi {
                
                titSubImg_1.image = UIImage(named: "defaultImage.png")
                titSubImg_2.image = UIImage(named: "defaultImage.png")
                titSubImg_3.image = UIImage(named: "defaultImage.png")
            }else {
                
                let photoUrl_1:String = SHOW_IMAGE_HEADER+forum.photo[0]
                titSubImg_1.sd_setImage(with: URL(string:photoUrl_1), placeholderImage: UIImage(named: "defaultImage.png"))
                
                let photoUrl_2:String = SHOW_IMAGE_HEADER+forum.photo[1]
                titSubImg_2.sd_setImage(with: URL(string:photoUrl_2), placeholderImage: UIImage(named: "defaultImage.png"))
                
                let photoUrl_3:String = SHOW_IMAGE_HEADER+forum.photo[2]
                titSubImg_3.sd_setImage(with: URL(string:photoUrl_3), placeholderImage: UIImage(named: "defaultImage.png"))
            }
            
            titleImg.isHidden = true
            titSubImg.isHidden = false
            
            likeBtn.setTitle(forum.like, for: UIControlState())
            comBtn.setTitle(forum.hits, for: UIControlState())
            
            likeBtn.sizeToFit()
            likeBtn.frame.origin = CGPoint(x: 8, y: titSubImg.frame.maxY+8)
            
            comBtn.sizeToFit()
            comBtn.frame.origin = CGPoint(x: likeBtn.frame.maxX+10, y: titSubImg.frame.maxY+8)
        }
        
        
        
    }
    
}
