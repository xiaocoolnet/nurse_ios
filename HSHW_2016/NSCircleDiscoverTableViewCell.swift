//
//  NSCircleDiscoverTableViewCell.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/6.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire

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
        
        self.addSubview(likeBtn)
        self.addSubview(comBtn)
        self.addSubview(titleLab)
        self.addSubview(titleImg)
        self.addSubview(titSubImg)
        
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
        
        titleLab.font = UIFont.systemFontOfSize(15)
        titleLab.textColor = UIColor.darkGrayColor()
        titleLab.numberOfLines = 0
        
        contantLab.font = UIFont.systemFontOfSize(14)
        contantLab.textColor = UIColor.grayColor()
        contantLab.numberOfLines = 2
        
        likeBtn.setImage(UIImage(named: "赞"), forState: .Normal)
        likeBtn.titleLabel?.font = UIFont.systemFontOfSize(10)
        likeBtn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        
        comBtn.setImage(UIImage(named: "评论"), forState: .Normal)
        comBtn.titleLabel?.font = UIFont.systemFontOfSize(10)
        comBtn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        
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
    
    func setCellWithNewsInfo(newsInfo:NewsInfo) {
        
        let height = calculateHeight((newsInfo.post_title), size: 17, width: WIDTH-140)
        self.titleLab.frame = CGRectMake(10, 9, WIDTH-140, height)
        
        self.titleLab.text = newsInfo.post_title
        
        //        if type == 1 {
        //            heal.frame = CGRectMake(10, titLab.frame.size.height+titLab.frame.origin.y+22, 46, 15)
        //        }
        
        likeBtn.setTitle(newsInfo.term_name, forState: .Normal)
        likeBtn.tag = Int(newsInfo.term_id)!
        
        let healWidth = calculateWidth(newsInfo.term_name, size: 11, height: 15)+5
        likeBtn.frame = CGRectMake(10, titleLab.frame.size.height+titleLab.frame.origin.y+22, healWidth, 15)
        if type == 2 {
            likeBtn.removeFromSuperview()
        }
        
        comBtn.frame = CGRectMake(type == 1 ? CGRectGetMaxX(likeBtn.frame)+10:5, titleLab.frame.size.height+titleLab.frame.origin.y+25, 13, 9)
        
        var conNumStr = "0"
        if Int(newsInfo.post_hits!) > 99999 {
            conNumStr = "10W+"
        }else if Int(newsInfo.post_hits!) > 199999 {
            conNumStr = "20W+"
        }else if Int(newsInfo.post_hits!) > 299999 {
            conNumStr = "30W+"
        }else if Int(newsInfo.post_hits!) > 399999 {
            conNumStr = "40W+"
        }else if Int(newsInfo.post_hits!) > 499999 {
            conNumStr = "50W+"
        }else if Int(newsInfo.post_hits!) > 599999 {
            conNumStr = "60W+"
        }else if Int(newsInfo.post_hits!) > 799999 {
            conNumStr = "80W+"
        }else if Int(newsInfo.post_hits!) > 899999 {
            conNumStr = "90W+"
        }else if Int(newsInfo.post_hits!) > 999999 {
            conNumStr = "100W+"
        }else if Int(newsInfo.post_hits!) > 9999999 {
            conNumStr = "1000W+"
        }else{
            conNumStr = newsInfo.post_hits!
        }
        
        
        self.contantLab.text = newsInfo.post_excerpt
        
        if newsInfo.thumbArr.count == 0 {
            
            titleImg.hidden = true
            titSubImg.hidden = true
            
            self.titleLab.frame.size.width = WIDTH-20
            
        }else{
            
            if loadPictureOnlyWiFi && !(NetworkReachabilityManager()?.isReachableOnEthernetOrWiFi)! {
                
                titleImg.frame = CGRectMake(WIDTH-120, 10, 110, 80)
                self.titleImg.image = UIImage.init(named: "defaultImage.png")
                
                titleImg.hidden = false
                titSubImg.hidden = true
            }else{
                let photoUrl:String = DomainName+"data/upload/"+(newsInfo.thumbArr.first?.url)!
                //                print("GToutiaoTableViewCell =-=-=-=-=-=-=   ",photoUrl)
                
                titleImg.frame = CGRectMake(WIDTH-120, 10, 110, 80)
                self.titleImg.sd_setImageWithURL(NSURL(string:photoUrl), placeholderImage: UIImage(named: "defaultImage.png"))
                
                titleImg.hidden = false
                titSubImg.hidden = true
                //        let titleHeight:CGFloat = calculateHeight(newsInfo.post_title!, size: 16, width: WIDTH-140)
                //        titLab.frame.size.height = titleHeight+100
            }
        }
        likeBtn.frame.origin.y = self.frame.size.height-likeBtn.frame.size.height-1-8
        comBtn.frame.origin.y = self.frame.size.height-comBtn.frame.size.height-4-8
        
    }
    
    func setThreeImgCellWithNewsInfo(newsInfo:NewsInfo) {
        
        let height = calculateHeight((newsInfo.post_title), size: 17, width: WIDTH-20)
        self.titleLab.frame = CGRectMake(10, 9, WIDTH-20, height)
        
        self.titleLab.text = newsInfo.post_title
        
        //        let margin:CGFloat = 15
        
        titSubImg.frame = CGRectMake(10, CGRectGetMaxY(titleLab.frame)+10, WIDTH-20, (WIDTH-20-margin*2)/3.0*2/3.0)
        
        if loadPictureOnlyWiFi && !(NetworkReachabilityManager()?.isReachableOnEthernetOrWiFi)! {
            
            titSubImg_1.image = UIImage(named: "defaultImage.png")
            titSubImg_2.image = UIImage(named: "defaultImage.png")
            titSubImg_3.image = UIImage(named: "defaultImage.png")
        }else {
            
            let photoUrl_1:String = DomainName+"data/upload/"+(newsInfo.thumbArr[0].url)
            titSubImg_1.sd_setImageWithURL(NSURL(string:photoUrl_1), placeholderImage: UIImage(named: "defaultImage.png"))
            
            let photoUrl_2:String = DomainName+"data/upload/"+(newsInfo.thumbArr[1].url)
            titSubImg_2.sd_setImageWithURL(NSURL(string:photoUrl_2), placeholderImage: UIImage(named: "defaultImage.png"))
            
            let photoUrl_3:String = DomainName+"data/upload/"+(newsInfo.thumbArr[2].url)
            titSubImg_3.sd_setImageWithURL(NSURL(string:photoUrl_3), placeholderImage: UIImage(named: "defaultImage.png"))
        }
        
        titleImg.hidden = true
        titSubImg.hidden = false
        
        likeBtn.setTitle(newsInfo.term_name, forState: .Normal)
        likeBtn.tag = Int(newsInfo.term_id)!
        
        let healWidth = calculateWidth(newsInfo.term_name, size: 11, height: 15)+5
        likeBtn.frame = CGRectMake(10, CGRectGetMaxY(titSubImg.frame)+12, healWidth, 15)
        if type == 2 {
            likeBtn.removeFromSuperview()
        }
        
        comBtn.frame = CGRectMake(type == 1 ? CGRectGetMaxX(likeBtn.frame)+10:5, CGRectGetMaxY(titSubImg.frame)+15, 13, 9)
        
        var conNumStr = "0"
        if Int(newsInfo.post_hits!) > 99999 {
            conNumStr = "10W+"
        }else if Int(newsInfo.post_hits!) > 199999 {
            conNumStr = "20W+"
        }else if Int(newsInfo.post_hits!) > 299999 {
            conNumStr = "30W+"
        }else if Int(newsInfo.post_hits!) > 399999 {
            conNumStr = "40W+"
        }else if Int(newsInfo.post_hits!) > 499999 {
            conNumStr = "50W+"
        }else if Int(newsInfo.post_hits!) > 599999 {
            conNumStr = "60W+"
        }else if Int(newsInfo.post_hits!) > 799999 {
            conNumStr = "80W+"
        }else if Int(newsInfo.post_hits!) > 899999 {
            conNumStr = "90W+"
        }else if Int(newsInfo.post_hits!) > 999999 {
            conNumStr = "100W+"
        }else if Int(newsInfo.post_hits!) > 9999999 {
            conNumStr = "1000W+"
        }else{
            conNumStr = newsInfo.post_hits!
        }
     
        self.contantLab.text = newsInfo.post_excerpt
        
        
    }
    
}
