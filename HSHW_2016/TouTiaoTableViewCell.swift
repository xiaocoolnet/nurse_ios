//
//  TouTiaoTableViewCell.swift
//  HSHW_2016
//
//  Created by apple on 16/5/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire

protocol ToutiaoCateBtnClickedDelegate:NSObjectProtocol {
    func cateBtnClicked(categoryBtn:UIButton)
}

class TouTiaoTableViewCell: UITableViewCell {

    var delegate:ToutiaoCateBtnClickedDelegate?

    let titLab = UILabel()
    let contant = UILabel()
    let titImage = UIImageView()
    let heal = UIButton()
    let conNum = UILabel()
    let timeLab = UILabel()
    let comBtn = UIButton()
    let timeBtn = UIButton()
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
        self.addSubview(heal)
        self.addSubview(conNum)
        self.addSubview(timeLab)
        self.addSubview(comBtn)
        self.addSubview(timeBtn)
        self.addSubview(titLab)
        self.addSubview(titImage)
        self.addSubview(titSubImg)

        titLab.frame = CGRectMake(10, 9, WIDTH-140, 40)
        titLab.font = UIFont.systemFontOfSize(17)
        titLab.numberOfLines = 0
        heal.frame = CGRectMake(10, titLab.frame.size.height+titLab.frame.origin.y+22, 46, 15)
        heal.layer.cornerRadius = 3
        heal.layer.borderColor = COLOR.CGColor
        heal.layer.borderWidth = 0.4
        heal.titleLabel?.font = UIFont.systemFontOfSize(11)
        //        heal.setTitle("健康常识", forState: .Normal)
        heal.setTitleColor(COLOR, forState: .Normal)
        heal.addTarget(self, action: #selector(categoryBtnClick(_:)), forControlEvents: .TouchUpInside)
        
        conNum.frame = CGRectMake(79, titLab.frame.size.height+titLab.frame.origin.y+22, 30, 15)
        conNum.font = UIFont.systemFontOfSize(13)
        conNum.textAlignment = .Left
        conNum.textColor = GREY
        timeLab.frame = CGRectMake(136, titLab.frame.size.height+titLab.frame.origin.y+22, 80, 15)
        timeLab.font = UIFont.systemFontOfSize(13)
        timeLab.textColor = GREY
        comBtn.frame = CGRectMake(62, titLab.frame.size.height+titLab.frame.origin.y+23, 13, 9)
        //        comBtn.setImage(UIImage(named: "ic_eye_purple.png"), forState: .Normal)
        comBtn.setBackgroundImage(UIImage(named: "ic_eye_purple.png"), forState: .Normal)
        timeBtn.frame = CGRectMake(117, titLab.frame.size.height+titLab.frame.origin.y+23, 11, 11)
        //        timeBtn.setImage(UIImage(named: "ic_time_purple.png"), forState: .Normal)
        timeBtn.setBackgroundImage(UIImage(named: "ic_time_purple.png"), forState: .Normal)
        contant.frame = CGRectMake(10, titLab.frame.size.height+titLab.frame.origin.y+38, WIDTH-140, 40)
        contant.numberOfLines = 0
        contant.font = UIFont.systemFontOfSize(14)
        contant.textColor = UIColor.grayColor()
        //        titImage.frame = CGRectMake(WIDTH-120, 10, 110, 80)
        
        titImage.contentMode = .ScaleAspectFill
        titImage.clipsToBounds = true
        
        
        //        titSubImg.frame = CGRectMake(10, CGRectGetMaxY(titLab.frame)+10, WIDTH-20, (WIDTH-20-margin*2)/3.0*2/3.0)
        
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
//        titLab.frame = CGRectMake(10, 9, WIDTH-140, 40)
//        titLab.font = UIFont.systemFontOfSize(17)
//        titLab.numberOfLines = 0
//        heal.frame = CGRectMake(10, titLab.frame.size.height+titLab.frame.origin.y+22, 46, 15)
//        heal.layer.cornerRadius = 3
//        heal.layer.borderColor = COLOR.CGColor
//        heal.layer.borderWidth = 0.4
//        heal.titleLabel?.font = UIFont.systemFontOfSize(11)
////        heal.setTitle("健康常识", forState: .Normal)
//        heal.setTitleColor(COLOR, forState: .Normal)
//        heal.addTarget(self, action: #selector(categoryBtnClick(_:)), forControlEvents: .TouchUpInside)
//
//        conNum.frame = CGRectMake(79, titLab.frame.size.height+titLab.frame.origin.y+22, 30, 15)
//        conNum.font = UIFont.systemFontOfSize(13)
//        conNum.textAlignment = .Left
//        conNum.textColor = GREY
//        timeLab.frame = CGRectMake(136, titLab.frame.size.height+titLab.frame.origin.y+22, 80, 15)
//        timeLab.font = UIFont.systemFontOfSize(13)
//        timeLab.textColor = GREY
//        comBtn.frame = CGRectMake(62, titLab.frame.size.height+titLab.frame.origin.y+23, 13, 9)
////        comBtn.setImage(UIImage(named: "ic_eye_purple.png"), forState: .Normal)
//        comBtn.setBackgroundImage(UIImage(named: "ic_eye_purple.png"), forState: .Normal)
//        timeBtn.frame = CGRectMake(117, titLab.frame.size.height+titLab.frame.origin.y+23, 11, 11)
////        timeBtn.setImage(UIImage(named: "ic_time_purple.png"), forState: .Normal)
//        timeBtn.setBackgroundImage(UIImage(named: "ic_time_purple.png"), forState: .Normal)
//        contant.frame = CGRectMake(10, titLab.frame.size.height+titLab.frame.origin.y+38, WIDTH-140, 40)
//        contant.numberOfLines = 0
//        contant.font = UIFont.systemFontOfSize(14)
//        contant.textColor = UIColor.grayColor()
////        titImage.frame = CGRectMake(WIDTH-120, 10, 110, 80)
    }
    
    func setCellWithNewsInfo(newsInfo:NewsInfo) {
        self.titLab.text = newsInfo.post_title
        
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

        self.conNum.text = conNumStr
        let time:Array = (newsInfo.post_modified?.componentsSeparatedByString(" "))!
        self.timeLab.text = time[0]
        self.contant.text = newsInfo.post_excerpt
        heal.setTitle(newsInfo.term_name, forState: .Normal)
        heal.tag = Int(newsInfo.term_id)!
        let photoUrl:String = DomainName+newsInfo.thumb!
        print(photoUrl)
        
        if newsInfo.thumbArr.count == 0 {
            
            titImage.hidden = true
            titSubImg.hidden = true
            
            self.titLab.frame.size.width = WIDTH-20
            
        }else{
            
            if loadPictureOnlyWiFi && !(NetworkReachabilityManager()?.isReachableOnEthernetOrWiFi)! {
                
                titImage.frame = CGRectMake(WIDTH-120, 10, 110, 80)
                self.titImage.image = UIImage.init(named: "defaultImage.png")
                
                titImage.hidden = false
                titSubImg.hidden = true
            }else{
                let photoUrl:String = DomainName+"data/upload/"+(newsInfo.thumbArr.first?.url)!
                print("=-=-=-=-=-=-=   ",photoUrl)
                
                titImage.frame = CGRectMake(WIDTH-120, 10, 110, 80)
                self.titImage.sd_setImageWithURL(NSURL(string:photoUrl), placeholderImage: UIImage(named: "defaultImage.png"))
                
                titImage.hidden = false
                titSubImg.hidden = true
                //        let titleHeight:CGFloat = calculateHeight(newsInfo.post_title!, size: 16, width: WIDTH-140)
                //        titLab.frame.size.height = titleHeight+100
            }
        }
        
//        self.titImage.sd_setImageWithURL(NSURL(string:photoUrl), placeholderImage: UIImage(named: "1.png"))
        let titleHeight:CGFloat = calculateHeight(newsInfo.post_title!, size: 17, width: newsInfo.thumbArr.count == 0 ? WIDTH-20:WIDTH-140)
        titLab.frame.size.height = titleHeight
        
        var height = calculateHeight((newsInfo.post_title)!, size: 17, width: WIDTH-140)
        if height+27>100 {
            height = height+27
        }else{
            height = 100
        }
        
        heal.frame.origin.y = height-25
        conNum.frame.origin.y = height-25
        timeLab.frame.origin.y = height-25
        comBtn.frame.origin.y = height-25
        timeBtn.frame.origin.y = height-25
    }
    
    func setThreeImgCellWithNewsInfo(newsInfo:NewsInfo) {
        let height = calculateHeight((newsInfo.post_title)!, size: 17, width: WIDTH-20)
        self.titLab.frame = CGRectMake(10, 9, WIDTH-20, height)
        
        self.titLab.text = newsInfo.post_title
        
//        let margin:CGFloat = 15
//        
//        titImage.frame = CGRectMake(10, CGRectGetMaxY(titLab.frame)+10, 60, (WIDTH-20-margin*2)/3.0*2/3.0)
//        titImage.backgroundColor = UIColor.redColor()
//        print(titImage.frame)
        //        titImage.backgroundColor = UIColor.redColor()
        
        titSubImg.frame = CGRectMake(10, CGRectGetMaxY(titLab.frame)+10, WIDTH-20, (WIDTH-20-margin*2)/3.0*2/3.0)
        
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
        
        titImage.hidden = true
        titSubImg.hidden = false
        
        let healWidth = calculateWidth(newsInfo.term_name, size: 11, height: 15)+5
        heal.frame = CGRectMake(10, CGRectGetMaxY(titSubImg.frame)+12, healWidth, 15)
        heal.setTitle(newsInfo.term_name, forState: .Normal)
        heal.tag = Int(newsInfo.term_id)!
//        heal.backgroundColor = UIColor.redColor()
//        print(heal.frame)
        
        comBtn.frame = CGRectMake(CGRectGetMaxX(heal.frame)+10, CGRectGetMaxY(titSubImg.frame)+15, 13, 9)

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
        
        self.conNum.text = conNumStr
        conNum.sizeToFit()
        conNum.frame = CGRectMake(CGRectGetMaxX(comBtn.frame)+5, CGRectGetMaxY(titSubImg.frame)+12, CGRectGetWidth(conNum.frame), 15)

        timeBtn.frame = CGRectMake(CGRectGetMaxX(conNum.frame)+10, CGRectGetMaxY(titSubImg.frame)+14, 11, 11)
        timeLab.frame = CGRectMake(CGRectGetMaxX(timeBtn.frame)+5, CGRectGetMaxY(titSubImg.frame)+12, 80, 15)
        
        let time:Array = (newsInfo.post_modified?.componentsSeparatedByString(" "))!
        let date:Array = time[0].componentsSeparatedByString("-")
        self.timeLab.text = "\(date[1])/\(date[2])"
        self.contant.text = newsInfo.post_excerpt
        
        //        self.titImage.sd_setImageWithURL(NSURL(string:photoUrl), placeholderImage: UIImage(named: "1.png"))
//        let titleHeight:CGFloat = calculateHeight(newsInfo.post_title!, size: 16, width: newsInfo.thumbArr.count == 0 ? WIDTH-20:WIDTH-140)
//        titLab.frame.size.height = titleHeight
//        heal.frame.origin.y = self.frame.size.height-25
//        conNum.frame.origin.y = self.frame.size.height-25
//        timeLab.frame.origin.y = self.frame.size.height-25
//        comBtn.frame.origin.y = self.frame.size.height-25
//        timeBtn.frame.origin.y = self.frame.size.height-25
    }

    func categoryBtnClick(categoryBtn:UIButton) {
        print(categoryBtn.tag)
        
        self.delegate!.cateBtnClicked(categoryBtn)
    }
}
