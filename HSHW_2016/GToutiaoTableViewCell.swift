//
//  TouTiaoTableViewCell.swift
//  HSHW_2016
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire

protocol cateBtnClickedDelegate:NSObjectProtocol {
    func cateBtnClicked(categoryBtn:UIButton)
}

class GToutiaoTableViewCell: UITableViewCell {
    
    var delegate:cateBtnClickedDelegate?
    
    var type = 1 // 1 有分类 2 没分类
    
    let titLab = UILabel()
    let contant = UILabel()
    let titImage = UIImageView()
    let heal = UIButton()
    let conNum = UILabel()
    let timeLab = UILabel()
    let comBtn = UIButton()
    let timeBtn = UIButton()
    let titSubImg = UIImageView()
    let line = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        
        if type == 1 {
            
            self.addSubview(heal)
        }
        self.addSubview(conNum)
        self.addSubview(timeLab)
        self.addSubview(comBtn)
        self.addSubview(timeBtn)
        self.addSubview(titLab)
        
        if reuseIdentifier == "RelatedNewsListCell" {
            line.frame = CGRectMake(WIDTH*3/62.0, self.contentView.frame.size.height-0.5, WIDTH-WIDTH*3/62.0, 0.5)
            line.backgroundColor = UIColor.lightGrayColor()
            self.addSubview(line)
        }else{
            line.removeFromSuperview()
        }
//        self.addSubview(titImage)
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
       
//        titLab.frame = CGRectMake(10, 12, WIDTH-140, 40)
        titLab.font = UIFont.systemFontOfSize(17)
        titLab.numberOfLines = 0
        
        //        heal.frame = CGRectMake(10, titLab.frame.size.height+titLab.frame.origin.y+22, 46, 15)
        heal.layer.cornerRadius = 3
        heal.layer.borderColor = COLOR.CGColor
        heal.layer.borderWidth = 0.4
        heal.titleLabel?.font = UIFont.systemFontOfSize(11)
        //        heal.setTitle("健康常识", forState: .Normal)
        heal.setTitleColor(COLOR, forState: .Normal)
        heal.addTarget(self, action: #selector(categoryBtnClick(_:)), forControlEvents: .TouchUpInside)
        
        //        comBtn.setImage(UIImage(named: "ic_eye_purple.png"), forState: .Normal)
        comBtn.setBackgroundImage(UIImage(named: "ic_eye_purple.png"), forState: .Normal)
        
        conNum.font = UIFont.systemFontOfSize(13)
        conNum.textAlignment = .Left
        conNum.textColor = GREY
        
        //        timeBtn.frame = CGRectMake(CGRectGetMaxX(conNum.frame)+5, titLab.frame.size.height+titLab.frame.origin.y+23, 11, 11)
        //        timeBtn.setImage(UIImage(named: "ic_time_purple.png"), forState: .Normal)
        timeBtn.setBackgroundImage(UIImage(named: "ic_time_purple.png"), forState: .Normal)
        
        //        timeLab.frame = CGRectMake(CGRectGetMaxX(timeBtn.frame)+5, titLab.frame.size.height+titLab.frame.origin.y+22, 80, 15)
        timeLab.font = UIFont.systemFontOfSize(13)
        timeLab.textColor = GREY
        
        contant.frame = CGRectMake(10, titLab.frame.size.height+titLab.frame.origin.y+38, WIDTH-140, 40)
        contant.numberOfLines = 0
        contant.font = UIFont.systemFontOfSize(14)
        contant.textColor = UIColor.grayColor()
        
//        titImage.frame = CGRectMake(WIDTH-120, 10, 110, 80)
        titImage.contentMode = .ScaleAspectFill
        titImage.clipsToBounds = true
    }
    
    func setCellWithNewsInfo(newsInfo:NewsInfo) {
        
        let height = calculateHeight((newsInfo.post_title)!, size: 17, width: WIDTH-140)
        self.titLab.frame = CGRectMake(10, 9, WIDTH-140, height)
        
        self.titLab.text = newsInfo.post_title
//        if type == 1 {
//            heal.frame = CGRectMake(10, titLab.frame.size.height+titLab.frame.origin.y+22, 46, 15)
//        }
        
        heal.setTitle(newsInfo.term_name, forState: .Normal)
        heal.tag = Int(newsInfo.term_id)!
        
        let healWidth = calculateWidth(newsInfo.term_name, size: 11, height: 15)+5
        heal.frame = CGRectMake(10, titLab.frame.size.height+titLab.frame.origin.y+22, healWidth, 15)
        if type == 2 {
            heal.removeFromSuperview()
        }
        
        comBtn.frame = CGRectMake(type == 1 ? CGRectGetMaxX(heal.frame)+10:5, titLab.frame.size.height+titLab.frame.origin.y+25, 13, 9)
        
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
        conNum.frame = CGRectMake(CGRectGetMaxX(comBtn.frame)+5, titLab.frame.size.height+titLab.frame.origin.y+22, CGRectGetWidth(conNum.frame), 15)
        
        timeBtn.frame = CGRectMake(CGRectGetMaxX(conNum.frame)+10, titLab.frame.size.height+titLab.frame.origin.y+24, 11, 11)
        timeLab.frame = CGRectMake(CGRectGetMaxX(timeBtn.frame)+5, titLab.frame.size.height+titLab.frame.origin.y+22, 80, 15)
        
        let time:Array = (newsInfo.post_date?.componentsSeparatedByString(" "))!
        let date:Array = time[0].componentsSeparatedByString("-")
        self.timeLab.text = "\(date[1])/\(date[2])"
        self.contant.text = newsInfo.post_excerpt
        
//        if newsInfo.thumb == "/data/upload/" {
//
//            self.titImage.removeFromSuperview()
//
//            self.titLab.frame.size.width = WIDTH-20
//
//        }else{
//
//            let photoUrl:String = DomainName+newsInfo.thumb!
//            print("=-=-=-=-=-=-=   ",photoUrl)
//            self.titImage.sd_setImageWithURL(NSURL(string:photoUrl), placeholderImage: UIImage(named: "defaultImage.png"))
//            self.addSubview(self.titImage)
//            //        let titleHeight:CGFloat = calculateHeight(newsInfo.post_title!, size: 16, width: WIDTH-140)
//            //        titLab.frame.size.height = titleHeight+100
//        }
        if newsInfo.thumbArr.count == 0 {
            
            self.titImage.removeFromSuperview()
            
            self.titLab.frame.size.width = WIDTH-20
            
        }else{
            
            if loadPictureOnlyWiFi && !(NetworkReachabilityManager()?.isReachableOnEthernetOrWiFi)! {
                
                titImage.frame = CGRectMake(WIDTH-120, 10, 110, 80)
                self.titImage.image = UIImage.init(named: "defaultImage.png")
                self.addSubview(self.titImage)
            }else{
                let photoUrl:String = DomainName+"data/upload/"+(newsInfo.thumbArr.first?.url)!
                print("=-=-=-=-=-=-=   ",photoUrl)
                
                titImage.frame = CGRectMake(WIDTH-120, 10, 110, 80)
                self.titImage.sd_setImageWithURL(NSURL(string:photoUrl), placeholderImage: UIImage(named: "defaultImage.png"))
                self.addSubview(self.titImage)
                //        let titleHeight:CGFloat = calculateHeight(newsInfo.post_title!, size: 16, width: WIDTH-140)
                //        titLab.frame.size.height = titleHeight+100
            }
        }
        heal.frame.origin.y = self.frame.size.height-heal.frame.size.height-1-8
        comBtn.frame.origin.y = self.frame.size.height-comBtn.frame.size.height-4-8
        conNum.frame.origin.y = self.frame.size.height-conNum.frame.size.height-1-8
        timeBtn.frame.origin.y = self.frame.size.height-timeBtn.frame.size.height-3-8
        timeLab.frame.origin.y = self.frame.size.height-timeLab.frame.size.height-1-8
        
        line.frame.origin.y = self.frame.size.height-0.5
    }
    
    func setThreeImgCellWithNewsInfo(newsInfo:NewsInfo) {
        
        let height = calculateHeight((newsInfo.post_title)!, size: 17, width: WIDTH-20)
        self.titLab.frame = CGRectMake(10, 9, WIDTH-20, height)
        
        self.titLab.text = newsInfo.post_title
            
        let margin:CGFloat = 15
        
        titImage.frame = CGRectMake(10, CGRectGetMaxY(titLab.frame)+10, WIDTH-20, (WIDTH-20-margin*2)/3.0*2/3.0)
//        titImage.backgroundColor = UIColor.redColor()

        for subview in titImage.subviews {
            if subview.isKindOfClass(UIImageView) {
                subview.removeFromSuperview()
            }
        }
        for index in 0 ... 2 {
            
            let titSubImg = UIImageView()
            titSubImg.contentMode = .ScaleAspectFill
            titSubImg.clipsToBounds = true
            titSubImg.frame = CGRectMake(((WIDTH-20-margin*2)/3.0+margin)*CGFloat(index), 0, (WIDTH-20-margin*2)/3.0, (WIDTH-20-margin*2)/3.0*2/3.0)
            
            if loadPictureOnlyWiFi && !(NetworkReachabilityManager()?.isReachableOnEthernetOrWiFi)! {
                
                titSubImg.image = UIImage(named: "defaultImage.png")
                titImage.addSubview(titSubImg)
            }else {
                
                let photoUrl:String = DomainName+"data/upload/"+(newsInfo.thumbArr[index].url)
                titSubImg.sd_setImageWithURL(NSURL(string:photoUrl), placeholderImage: UIImage(named: "defaultImage.png"))
                //            titSubImg.image = UIImage.init(named: "1.png")
                titImage.addSubview(titSubImg)
            }
        }
        self.addSubview(titImage)
        
        heal.setTitle(newsInfo.term_name, forState: .Normal)
        heal.tag = Int(newsInfo.term_id)!
        
        let healWidth = calculateWidth(newsInfo.term_name, size: 11, height: 15)+5
        heal.frame = CGRectMake(10, CGRectGetMaxY(titImage.frame)+12, healWidth, 15)
        if type == 2 {
            heal.removeFromSuperview()
        }
        
        comBtn.frame = CGRectMake(type == 1 ? CGRectGetMaxX(heal.frame)+10:5, CGRectGetMaxY(titImage.frame)+15, 13, 9)
        
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
        conNum.frame = CGRectMake(CGRectGetMaxX(comBtn.frame)+5, CGRectGetMaxY(titImage.frame)+12, CGRectGetWidth(conNum.frame), 15)
        
        timeBtn.frame = CGRectMake(CGRectGetMaxX(conNum.frame)+10, CGRectGetMaxY(titImage.frame)+14, 11, 11)
        timeLab.frame = CGRectMake(CGRectGetMaxX(timeBtn.frame)+5, CGRectGetMaxY(titImage.frame)+12, 80, 15)
        
        let time:Array = (newsInfo.post_date?.componentsSeparatedByString(" "))!
        let date:Array = time[0].componentsSeparatedByString("-")
        self.timeLab.text = "\(date[1])/\(date[2])"
        self.contant.text = newsInfo.post_excerpt
        
        line.frame.origin.y = self.frame.size.height-0.5

        //        let titleHeight:CGFloat = calculateHeight(newsInfo.post_title!, size: 16, width: WIDTH-140)
        //        titLab.frame.size.height = titleHeight+100

//        heal.frame.origin.y = self.frame.size.height-heal.frame.size.height-1-8
//        comBtn.frame.origin.y = self.frame.size.height-comBtn.frame.size.height-4-8
//        conNum.frame.origin.y = self.frame.size.height-conNum.frame.size.height-1-8
//        timeBtn.frame.origin.y = self.frame.size.height-timeBtn.frame.size.height-3-8
//        timeLab.frame.origin.y = self.frame.size.height-timeLab.frame.size.height-1-8
        
    }
    
    func categoryBtnClick(categoryBtn:UIButton) {
        print(categoryBtn.tag)
        
        self.delegate!.cateBtnClicked(categoryBtn)
    }
    
}
