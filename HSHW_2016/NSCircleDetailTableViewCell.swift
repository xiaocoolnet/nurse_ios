//
//  NSCircleDetailTableViewCell.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/8.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class NSCircleDetailTableViewCell: UITableViewCell {
    
    // 个人信息
    let imgBtn = UIButton()
    let nameLab = UILabel()
    let positionLab = UILabel()
    let timeLab = UILabel()
    let levelLab = UILabel()
    
    // 帖子信息
    let titleLab = UILabel()
    let contantLab = UILabel()
    let titleImg = UIImageView()
    let likeBtn = UIButton()
    let comBtn = UIButton()
    let addressBtn = UIButton()
    let moreBtn = UIButton()
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
        
        self.addSubview(imgBtn)
        self.addSubview(nameLab)
        self.addSubview(positionLab)
        self.addSubview(timeLab)
        self.addSubview(levelLab)

        self.addSubview(titleLab)
        self.addSubview(contantLab)
        self.addSubview(titleImg)
        self.addSubview(titSubImg)
        self.addSubview(likeBtn)
        self.addSubview(comBtn)
        self.addSubview(addressBtn)
        self.addSubview(moreBtn)
        
        self.setSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setSubViews() {
        
        imgBtn.frame = CGRect(x: 8, y: 10, width: 35, height: 35)
        imgBtn.layer.cornerRadius = 17.5
        imgBtn.clipsToBounds = true
        
        nameLab.font = UIFont.systemFontOfSize(12)
        nameLab.textColor = UIColor.blackColor()
        
        positionLab.font = UIFont.systemFontOfSize(8)
        positionLab.textColor = UIColor.whiteColor()
//        positionLab.backgroundColor = COLOR
        positionLab.layer.backgroundColor = COLOR.CGColor
        positionLab.textAlignment = .Center
        
        timeLab.font = UIFont.systemFontOfSize(10)
        timeLab.textColor = UIColor.lightGrayColor()
        
        levelLab.font = UIFont.systemFontOfSize(10)
        levelLab.textColor = COLOR
        
        titleLab.font = UIFont.systemFontOfSize(titleSize)
        titleLab.textColor = UIColor.blackColor()
        titleLab.numberOfLines = 0
        
        contantLab.font = UIFont.systemFontOfSize(contentSize)
        contantLab.textColor = UIColor.grayColor()
        contantLab.numberOfLines = 2
        
        likeBtn.setImage(UIImage(named: "赞"), forState: .Normal)
        likeBtn.titleLabel?.font = UIFont.systemFontOfSize(10)
        likeBtn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        
        comBtn.setImage(UIImage(named: "评论"), forState: .Normal)
        comBtn.titleLabel?.font = UIFont.systemFontOfSize(10)
        comBtn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        
        addressBtn.setImage(UIImage(named: "发帖位置"), forState: .Normal)
        addressBtn.titleLabel?.font = UIFont.systemFontOfSize(10)
        addressBtn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        
        moreBtn.setTitle("···", forState: .Normal)
        moreBtn.titleLabel?.font = UIFont.systemFontOfSize(18)
        moreBtn.layer.cornerRadius = 2
        moreBtn.setTitleColor(UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1), forState: .Normal)
        moreBtn.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
        
        titleImg.contentMode = .ScaleAspectFill
        titleImg.clipsToBounds = true
        
        titSubImg_1.contentMode = .ScaleAspectFill
        titSubImg_1.clipsToBounds = true
        titSubImg_1.frame = CGRectMake(0, 0, (WIDTH-20-margin*2)/3.0, (WIDTH-20-margin*2)/3.0*2/3.0)
        titSubImg.addSubview(titSubImg_1)
        
        titSubImg_2.contentMode = .ScaleAspectFill
        titSubImg_2.clipsToBounds = true
        titSubImg_2.frame = CGRectMake((WIDTH-20-margin*2)/3.0+margin, 0, (WIDTH-20-margin*2)/3.0, (WIDTH-20-margin*2)/3.0*2/3.0)
        titSubImg.addSubview(titSubImg_2)
        
        titSubImg_3.contentMode = .ScaleAspectFill
        titSubImg_3.clipsToBounds = true
        titSubImg_3.frame = CGRectMake(((WIDTH-20-margin*2)/3.0+margin)*2, 0, (WIDTH-20-margin*2)/3.0, (WIDTH-20-margin*2)/3.0*2/3.0)
        titSubImg.addSubview(titSubImg_3)
    }
    
    private let titleSize:CGFloat = 14
    private let contentSize:CGFloat = 12
    
    func setCellWithNewsInfo(forum:ForumModel) {
        
        
        
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
        
        imgBtn.sd_setImageWithURL(NSURL(string: SHOW_IMAGE_HEADER+"avatar20161116173819639.png"), forState: .Normal)
        
        nameLab.text = "小丫头妈咪宝贝"
        nameLab.frame = CGRect(x: imgBtn.frame.maxX+8, y: 10, width: calculateWidth("小丫头妈咪宝贝", size: 12, height: 17), height: 17)
//        nameLab.sizeToFit()
//        nameLab.frame.origin = CGPoint(x: imgBtn.frame.maxX+8, y: 10)
        
        positionLab.text = "护士"
        positionLab.frame = CGRect(x: nameLab.frame.maxX+8, y: 0, width: calculateWidth("护士", size: 8, height: 12)+12, height: 12)
        positionLab.center.y = nameLab.center.y
        positionLab.layer.cornerRadius = 6
        
        timeLab.text = "3分钟前"
        timeLab.sizeToFit()
        timeLab.frame.origin.x = WIDTH-8-timeLab.frame.width
        timeLab.center.y = nameLab.center.y
        
        levelLab.text = "Lv.35"
        levelLab.frame = CGRect(x: imgBtn.frame.maxX+8, y: nameLab.frame.maxY+1, width: calculateWidth("Lv.35", size: 10, height: 17), height: 17)
        
        let forumMinY:CGFloat = 55
        
        if forum.photo.count == 0 {
            
            titleImg.hidden = true
            titSubImg.hidden = true
            
            let height = calculateHeight((forum.title), size: titleSize, width: WIDTH-16)
            self.titleLab.frame = CGRectMake(8, forumMinY, WIDTH-16, height)
            
            self.titleLab.text = forum.title
            
            var contentHeight = calculateHeight((forum.content), size: contentSize, width: WIDTH-16)
            if contentHeight >= UIFont.systemFontOfSize(contentSize).lineHeight*3 {
                contentHeight = UIFont.systemFontOfSize(contentSize).lineHeight*2
            }
            self.contantLab.frame = CGRectMake(8, self.titleLab.frame.maxY+8, WIDTH-16, contentHeight)
            
            self.contantLab.text = forum.content
            
            likeBtn.setTitle(forum.like, forState: .Normal)
            comBtn.setTitle(forum.hits, forState: .Normal)
            // TODO:
            addressBtn.setTitle(QCLoginUserInfo.currentInfo.address, forState: .Normal)

            likeBtn.sizeToFit()
            likeBtn.frame.origin = CGPoint(x: 8, y: contantLab.frame.maxY+8)
            
            comBtn.sizeToFit()
            comBtn.frame.origin = CGPoint(x: likeBtn.frame.maxX+10, y: contantLab.frame.maxY+8)
            
            addressBtn.sizeToFit()
            addressBtn.frame.origin = CGPoint(x: comBtn.frame.maxX+10, y: contantLab.frame.maxY+8)
            
        }else if forum.photo.count < 3 {
            
            let height = calculateHeight((forum.title), size: titleSize, width: WIDTH-16-110-8)
            self.titleLab.frame = CGRectMake(8, forumMinY, WIDTH-16-110-8, height)
            
            self.titleLab.text = forum.title
            
            var contentHeight = calculateHeight((forum.content), size: contentSize, width: WIDTH-16-110-8)
            if contentHeight >= UIFont.systemFontOfSize(contentSize).lineHeight*3 {
                contentHeight = UIFont.systemFontOfSize(contentSize).lineHeight*2
            }
            self.contantLab.frame = CGRectMake(8, self.titleLab.frame.maxY+8, WIDTH-16-110-8, contentHeight)
            
            self.contantLab.text = forum.content
            
            if  !NurseUtil.net.isWifi() && loadPictureOnlyWiFi {
                
                titleImg.frame = CGRectMake(WIDTH-110-8, forumMinY+8, 110, 80)
                self.titleImg.image = UIImage.init(named: "defaultImage.png")
                
                titleImg.hidden = false
                titSubImg.hidden = true
            }else{
                let photoUrl:String = DomainName+"data/upload/"+(forum.photo.first!.url ?? "")!
                
                titleImg.frame = CGRectMake(WIDTH-110-8, forumMinY+8, 110, 80)
                self.titleImg.sd_setImageWithURL(NSURL(string:photoUrl), placeholderImage: UIImage(named: "defaultImage.png"))
                
                titleImg.hidden = false
                titSubImg.hidden = true
                //        let titleHeight:CGFloat = calculateHeight(newsInfo.post_title!, size: 16, width: WIDTH-140)
                //        titLab.frame.size.height = titleHeight+100
            }
            
            if 80 < contantLab.frame.maxY-8-forumMinY {
                titleImg.frame.origin.y = (contantLab.frame.maxY-8-forumMinY-80)/2.0+forumMinY
            }else{
                
                self.titleLab.frame.origin.y = forumMinY+(80-height-8-contentHeight)/2.0
                self.contantLab.frame.origin.y = self.titleLab.frame.maxY+8

                titleImg.frame.origin.y = forumMinY
            }
            
            likeBtn.setTitle(forum.like, forState: .Normal)
            comBtn.setTitle(forum.hits, forState: .Normal)
            // TODO:
            addressBtn.setTitle(QCLoginUserInfo.currentInfo.address, forState: .Normal)
            
            likeBtn.sizeToFit()
            likeBtn.frame.origin = CGPoint(x: 8, y: max(titleImg.frame.maxY+8, contantLab.frame.maxY+8))
            
            comBtn.sizeToFit()
            comBtn.frame.origin = CGPoint(x: likeBtn.frame.maxX+10, y: max(titleImg.frame.maxY+8, contantLab.frame.maxY+8))
            
            addressBtn.sizeToFit()
            addressBtn.frame.origin = CGPoint(x: comBtn.frame.maxX+10, y: max(titleImg.frame.maxY+8, contantLab.frame.maxY+8))
            
        }else{
            
            let height = calculateHeight((forum.title), size: titleSize, width: WIDTH-16)
            self.titleLab.frame = CGRectMake(8, forumMinY, WIDTH-16, height)
            
            self.titleLab.text = forum.title
            
            var contentHeight = calculateHeight((forum.content), size: contentSize, width: WIDTH-16)
            if contentHeight >= UIFont.systemFontOfSize(contentSize).lineHeight*3 {
                contentHeight = UIFont.systemFontOfSize(contentSize).lineHeight*2
            }
            self.contantLab.frame = CGRectMake(8, self.titleLab.frame.maxY+8, WIDTH-16, contentHeight)
            
            self.contantLab.text = forum.content
            
            titSubImg.frame = CGRectMake(8, contantLab.frame.maxY+8, WIDTH-16, (WIDTH-16-margin*2)/3.0*2/3.0)
            
            if  !NurseUtil.net.isWifi() && loadPictureOnlyWiFi {
                
                titSubImg_1.image = UIImage(named: "defaultImage.png")
                titSubImg_2.image = UIImage(named: "defaultImage.png")
                titSubImg_3.image = UIImage(named: "defaultImage.png")
            }else {
                
                let photoUrl_1:String = DomainName+"data/upload/"+(forum.photo[0].url)
                titSubImg_1.sd_setImageWithURL(NSURL(string:photoUrl_1), placeholderImage: UIImage(named: "defaultImage.png"))
                
                let photoUrl_2:String = DomainName+"data/upload/"+(forum.photo[1].url)
                titSubImg_2.sd_setImageWithURL(NSURL(string:photoUrl_2), placeholderImage: UIImage(named: "defaultImage.png"))
                
                let photoUrl_3:String = DomainName+"data/upload/"+(forum.photo[2].url)
                titSubImg_3.sd_setImageWithURL(NSURL(string:photoUrl_3), placeholderImage: UIImage(named: "defaultImage.png"))
            }
            
            titleImg.hidden = true
            titSubImg.hidden = false
            
            likeBtn.setTitle(forum.like, forState: .Normal)
            comBtn.setTitle(forum.hits, forState: .Normal)
            // TODO:
            addressBtn.setTitle(QCLoginUserInfo.currentInfo.address, forState: .Normal)
            
            likeBtn.sizeToFit()
            likeBtn.frame.origin = CGPoint(x: 8, y: titSubImg.frame.maxY+8)
            
            comBtn.sizeToFit()
            comBtn.frame.origin = CGPoint(x: likeBtn.frame.maxX+10, y: titSubImg.frame.maxY+8)
            
            addressBtn.sizeToFit()
            addressBtn.frame.origin = CGPoint(x: comBtn.frame.maxX+10, y: titSubImg.frame.maxY+8)

        }
        
        let moreBtnWidth = calculateWidth("···", size: 18, height: comBtn.frame.height)+10
        moreBtn.frame = CGRect(x: WIDTH-8-moreBtnWidth, y: 0, width: moreBtnWidth, height: comBtn.frame.height)
        moreBtn.center.y = comBtn.center.y
        
    }
    
}
