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
    let heal = UIButton()
    let hitsNum = UILabel()
    let hitsBtn = UIButton()
    let zanBtn = UIButton()
    let zanNum = UILabel()
    let colBtn = UIButton()
    let colNum = UILabel()
    let titImage = UIImageView()
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
        self.addSubview(titLab)
        self.addSubview(heal)
        self.addSubview(hitsBtn)
        self.addSubview(hitsNum)
        self.addSubview(zanBtn)
        self.addSubview(zanNum)
        self.addSubview(colBtn)
        self.addSubview(colNum)
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
        heal.setTitleColor(COLOR, forState: .Normal)
        heal.addTarget(self, action: #selector(categoryBtnClick(_:)), forControlEvents: .TouchUpInside)
        
        hitsBtn.frame = CGRectMake(62, titLab.frame.size.height+titLab.frame.origin.y+23, 13, 9)
        hitsBtn.setBackgroundImage(UIImage(named: "ic_eye_purple.png"), forState: .Normal)
        
        hitsNum.frame = CGRectMake(79, titLab.frame.size.height+titLab.frame.origin.y+22, 30, 15)
        hitsNum.font = UIFont.systemFontOfSize(13)
        hitsNum.textAlignment = .Left
        hitsNum.textColor = GREY

        zanBtn.frame = CGRectMake(WIDTH-50, (WIDTH-20)*0.5+42, 14, 14)
        zanBtn.setImage(UIImage(named:"ic_like_gray"), forState: UIControlState.Normal)
        zanBtn.setImage(UIImage(named:"ic_like_sel"), forState: UIControlState.Selected)

        zanNum.frame = CGRectMake(WIDTH-30, (WIDTH-20)*0.5+38, 30, 20)
        zanNum.font = UIFont.systemFontOfSize(12)
        zanNum.textColor = UIColor.grayColor()
        zanNum.textAlignment = .Left
        
        colBtn.frame = CGRectMake(WIDTH-50, (WIDTH-20)*0.5+42, 14, 14)
        colBtn.setImage(UIImage(named:"ic_collect_nor"), forState: UIControlState.Normal)
        colBtn.setImage(UIImage(named:"ic_collect_sel"), forState: UIControlState.Selected)
        
        colNum.frame = CGRectMake(WIDTH-30, (WIDTH-20)*0.5+38, 30, 20)
        colNum.font = UIFont.systemFontOfSize(12)
        colNum.textColor = UIColor.grayColor()
        colNum.textAlignment = .Left
        
        titImage.contentMode = .ScaleAspectFill
        titImage.clipsToBounds = true
        
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
    
    func setCellWithNewsInfo(newsInfo:NewsInfo) {
        self.titLab.text = newsInfo.post_title

        heal.setTitle(newsInfo.term_name, forState: .Normal)
        heal.tag = Int(newsInfo.term_id)!
        self.hitsNum.text = setconNumStr(newsInfo.post_hits!)
        self.hitsNum.sizeToFit()
        self.zanNum.text = String(newsInfo.likes.count)
        self.zanNum.sizeToFit()
        self.colNum.text = (newsInfo.favorites_count ?? "0")!
        self.colNum.sizeToFit()
        
//        let photoUrl:String = DomainName+newsInfo.thumb!
//        print(photoUrl)
        
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
//                print("TouTiaoTableViewCell   =-=-=-=-=-=-=   ",photoUrl)
                
                titImage.frame = CGRectMake(WIDTH-120, 10, 110, 80)
                self.titImage.sd_setImageWithURL(NSURL(string:photoUrl), placeholderImage: UIImage(named: "defaultImage.png"))
                
                titImage.hidden = false
                titSubImg.hidden = true
                //        let titleHeight:CGFloat = calculateHeight(newsInfo.post_title!, size: 16, width: WIDTH-140)
                //        titLab.frame.size.height = titleHeight+100
            }
        }
        
        let titleHeight:CGFloat = calculateHeight(newsInfo.post_title, size: 17, width: newsInfo.thumbArr.count == 0 ? WIDTH-20:WIDTH-140)
        titLab.frame.size.height = titleHeight
        
        var height = calculateHeight((newsInfo.post_title), size: 17, width: WIDTH-140)
        if height+27>100 {
            height = height+27
        }else{
            height = 100
        }
        
        heal.frame.origin.y = height-25
        hitsBtn.center.y = heal.center.y
        hitsNum.center.y = heal.center.y
        zanBtn.center.y = heal.center.y
        zanNum.center.y = heal.center.y
        colBtn.center.y = heal.center.y
        colNum.center.y = heal.center.y
        
        hitsBtn.frame.origin.x = CGRectGetMaxX(heal.frame)+10
        hitsNum.frame.origin.x = CGRectGetMaxX(hitsBtn.frame)+5
        zanBtn.frame.origin.x = CGRectGetMaxX(hitsNum.frame)+10
        zanNum.frame.origin.x = CGRectGetMaxX(zanBtn.frame)+5
        colBtn.frame.origin.x = CGRectGetMaxX(zanNum.frame)+10
        colNum.frame.origin.x = CGRectGetMaxX(colBtn.frame)+5
    }
    
    func setThreeImgCellWithNewsInfo(newsInfo:NewsInfo) {
        let height = calculateHeight((newsInfo.post_title), size: 17, width: WIDTH-20)
        self.titLab.frame = CGRectMake(10, 9, WIDTH-20, height)
        
        self.titLab.text = newsInfo.post_title
        
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
        
        self.hitsNum.text = setconNumStr(newsInfo.post_hits!)
        hitsNum.sizeToFit()
        self.zanNum.text = String(newsInfo.likes.count)
        self.zanNum.sizeToFit()
        self.colNum.text = (newsInfo.favorites_count ?? "0")!
        self.colNum.sizeToFit()

        hitsBtn.center.y = heal.center.y
        hitsNum.center.y = heal.center.y
        zanBtn.center.y = heal.center.y
        zanNum.center.y = heal.center.y
        colBtn.center.y = heal.center.y
        colNum.center.y = heal.center.y
        
        hitsBtn.frame.origin.x = CGRectGetMaxX(heal.frame)+10
        hitsNum.frame.origin.x = CGRectGetMaxX(hitsBtn.frame)+5
        zanBtn.frame.origin.x = CGRectGetMaxX(hitsNum.frame)+10
        zanNum.frame.origin.x = CGRectGetMaxX(zanBtn.frame)+5
        colBtn.frame.origin.x = CGRectGetMaxX(zanNum.frame)+10
        colNum.frame.origin.x = CGRectGetMaxX(colBtn.frame)+5
    }
    
    func setconNumStr(string:String) -> String {
        
        var conNumStr = "0"
        if Int(string) > 99999 {
            conNumStr = "10W+"
        }else if Int(string) > 199999 {
            conNumStr = "20W+"
        }else if Int(string) > 299999 {
            conNumStr = "30W+"
        }else if Int(string) > 399999 {
            conNumStr = "40W+"
        }else if Int(string) > 499999 {
            conNumStr = "50W+"
        }else if Int(string) > 599999 {
            conNumStr = "60W+"
        }else if Int(string) > 799999 {
            conNumStr = "80W+"
        }else if Int(string) > 899999 {
            conNumStr = "90W+"
        }else if Int(string) > 999999 {
            conNumStr = "100W+"
        }else if Int(string) > 9999999 {
            conNumStr = "1000W+"
        }else{
            conNumStr = string
        }
        return conNumStr
    }

    func categoryBtnClick(categoryBtn:UIButton) {
//        print(categoryBtn.tag)
        
        self.delegate!.cateBtnClicked(categoryBtn)
    }
}
