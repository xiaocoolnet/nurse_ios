//
//  TouTiaoTableViewCell.swift
//  HSHW_2016
//
//  Created by apple on 16/7/21.
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


protocol cateBtnClickedDelegate:NSObjectProtocol {
    func cateBtnClicked(_ categoryBtn:UIButton)
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
    let titSubImg_1 = UIImageView()
    let titSubImg_2 = UIImageView()
    let titSubImg_3 = UIImageView()
    let line = UIView()
    
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
        
        if type == 1 {
            
            self.addSubview(heal)
        }
        self.addSubview(conNum)
        self.addSubview(timeLab)
        self.addSubview(comBtn)
        self.addSubview(timeBtn)
        self.addSubview(titLab)
        self.addSubview(titImage)
        self.addSubview(titSubImg)

        if reuseIdentifier == "RelatedNewsListCell" {
            line.frame = CGRect(x: WIDTH*3/62.0, y: self.contentView.frame.size.height-0.5, width: WIDTH-WIDTH*3/62.0, height: 0.5)
            line.backgroundColor = UIColor.lightGray
            self.addSubview(line)
        }else{
            line.removeFromSuperview()
        }
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
       
//        titLab.frame = CGRectMake(10, 12, WIDTH-140, 40)
        titLab.font = UIFont.systemFont(ofSize: 17)
        titLab.numberOfLines = 0
        
        //        heal.frame = CGRectMake(10, titLab.frame.size.height+titLab.frame.origin.y+22, 46, 15)
        heal.layer.cornerRadius = 3
        heal.layer.borderColor = COLOR.cgColor
        heal.layer.borderWidth = 0.4
        heal.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        //        heal.setTitle("健康常识", forState: .Normal)
        heal.setTitleColor(COLOR, for: UIControlState())
        heal.addTarget(self, action: #selector(categoryBtnClick(_:)), for: .touchUpInside)
        
        //        comBtn.setImage(UIImage(named: "ic_eye_purple.png"), forState: .Normal)
        comBtn.setBackgroundImage(UIImage(named: "ic_eye_purple.png"), for: UIControlState())
        
        conNum.font = UIFont.systemFont(ofSize: 13)
        conNum.textAlignment = .left
        conNum.textColor = GREY
        
        //        timeBtn.frame = CGRectMake(CGRectGetMaxX(conNum.frame)+5, titLab.frame.size.height+titLab.frame.origin.y+23, 11, 11)
        //        timeBtn.setImage(UIImage(named: "ic_time_purple.png"), forState: .Normal)
        timeBtn.setBackgroundImage(UIImage(named: "ic_time_purple.png"), for: UIControlState())
        
        //        timeLab.frame = CGRectMake(CGRectGetMaxX(timeBtn.frame)+5, titLab.frame.size.height+titLab.frame.origin.y+22, 80, 15)
        timeLab.font = UIFont.systemFont(ofSize: 13)
        timeLab.textColor = GREY
        
//        contant.frame = CGRectMake(10, titLab.frame.size.height+titLab.frame.origin.y+38, WIDTH-140, 40)
//        contant.numberOfLines = 0
//        contant.font = UIFont.systemFontOfSize(14)
//        contant.textColor = UIColor.grayColor()
        
//        titImage.frame = CGRectMake(WIDTH-120, 10, 110, 80)
        titImage.contentMode = .scaleAspectFill
        titImage.clipsToBounds = true
        
        
//        titSubImg.frame = CGRectMake(10, CGRectGetMaxY(titLab.frame)+10, WIDTH-20, (WIDTH-20-margin*2)/3.0*2/3.0)
        
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
    
    func setCellWithNewsInfo(_ newsInfo:NewsInfo) {
        
        let height = calculateHeight((newsInfo.post_title), size: 17, width: WIDTH-140)
        self.titLab.frame = CGRect(x: 10, y: 9, width: WIDTH-140, height: height)
        
        self.titLab.text = newsInfo.post_title

//        if type == 1 {
//            heal.frame = CGRectMake(10, titLab.frame.size.height+titLab.frame.origin.y+22, 46, 15)
//        }
        
        heal.setTitle(newsInfo.term_name, for: UIControlState())
        heal.tag = Int(newsInfo.term_id)!
        
        let healWidth = calculateWidth(newsInfo.term_name, size: 11, height: 15)+5
        heal.frame = CGRect(x: 10, y: titLab.frame.size.height+titLab.frame.origin.y+22, width: healWidth, height: 15)
        if type == 2 {
            heal.removeFromSuperview()
        }
        
        comBtn.frame = CGRect(x: type == 1 ? heal.frame.maxX+10:5, y: titLab.frame.size.height+titLab.frame.origin.y+25, width: 13, height: 9)
        
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
        conNum.frame = CGRect(x: comBtn.frame.maxX+5, y: titLab.frame.size.height+titLab.frame.origin.y+22, width: conNum.frame.width, height: 15)
        
        timeBtn.frame = CGRect(x: conNum.frame.maxX+10, y: titLab.frame.size.height+titLab.frame.origin.y+24, width: 11, height: 11)
        timeLab.frame = CGRect(x: timeBtn.frame.maxX+5, y: titLab.frame.size.height+titLab.frame.origin.y+22, width: 80, height: 15)
        
        let time:Array = (newsInfo.post_modified?.components(separatedBy: " "))!
        let date:Array = time[0].components(separatedBy: "-")
        if date.count >= 3 {
            self.timeLab.text = "\(date[1])/\(date[2])"
        }else{
            self.timeLab.text = "01/01"
        }
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
            
            titImage.isHidden = true
            titSubImg.isHidden = true
            
            self.titLab.frame.size.width = WIDTH-20
            
        }else{
            
            if  !NurseUtil.net.isWifi() && loadPictureOnlyWiFi {
                
                titImage.frame = CGRect(x: WIDTH-120, y: 10, width: 110, height: 80)
                self.titImage.image = UIImage.init(named: "defaultImage.png")

                titImage.isHidden = false
                titSubImg.isHidden = true
            }else{
                let photoUrl:String = DomainName+"data/upload/"+(newsInfo.thumbArr.first?.url)!
//                print("GToutiaoTableViewCell =-=-=-=-=-=-=   ",photoUrl)
                
                titImage.frame = CGRect(x: WIDTH-120, y: 10, width: 110, height: 80)
                self.titImage.sd_setImage(with: URL(string:photoUrl), placeholderImage: UIImage(named: "defaultImage.png"))

                titImage.isHidden = false
                titSubImg.isHidden = true
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
    
    func setThreeImgCellWithNewsInfo(_ newsInfo:NewsInfo) {
        
        let height = calculateHeight((newsInfo.post_title), size: 17, width: WIDTH-20)
        self.titLab.frame = CGRect(x: 10, y: 9, width: WIDTH-20, height: height)
        
        self.titLab.text = newsInfo.post_title
            
//        let margin:CGFloat = 15
        
        titSubImg.frame = CGRect(x: 10, y: titLab.frame.maxY+10, width: WIDTH-20, height: (WIDTH-20-margin*2)/3.0*2/3.0)
        
        if  !NurseUtil.net.isWifi() && loadPictureOnlyWiFi {
            
            titSubImg_1.image = UIImage(named: "defaultImage.png")
            titSubImg_2.image = UIImage(named: "defaultImage.png")
            titSubImg_3.image = UIImage(named: "defaultImage.png")
        }else {
            
            let photoUrl_1:String = DomainName+"data/upload/"+(newsInfo.thumbArr[0].url)
            titSubImg_1.sd_setImage(with: URL(string:photoUrl_1), placeholderImage: UIImage(named: "defaultImage.png"))
            
            let photoUrl_2:String = DomainName+"data/upload/"+(newsInfo.thumbArr[1].url)
            titSubImg_2.sd_setImage(with: URL(string:photoUrl_2), placeholderImage: UIImage(named: "defaultImage.png"))
            
            let photoUrl_3:String = DomainName+"data/upload/"+(newsInfo.thumbArr[2].url)
            titSubImg_3.sd_setImage(with: URL(string:photoUrl_3), placeholderImage: UIImage(named: "defaultImage.png"))
        }
        
        titImage.isHidden = true
        titSubImg.isHidden = false
        
        heal.setTitle(newsInfo.term_name, for: UIControlState())
        heal.tag = Int(newsInfo.term_id)!
        
        let healWidth = calculateWidth(newsInfo.term_name, size: 11, height: 15)+5
        heal.frame = CGRect(x: 10, y: titSubImg.frame.maxY+12, width: healWidth, height: 15)
        if type == 2 {
            heal.removeFromSuperview()
        }
        
        comBtn.frame = CGRect(x: type == 1 ? heal.frame.maxX+10:5, y: titSubImg.frame.maxY+15, width: 13, height: 9)
        
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
        conNum.frame = CGRect(x: comBtn.frame.maxX+5, y: titSubImg.frame.maxY+12, width: conNum.frame.width, height: 15)
        
        timeBtn.frame = CGRect(x: conNum.frame.maxX+10, y: titSubImg.frame.maxY+14, width: 11, height: 11)
        timeLab.frame = CGRect(x: timeBtn.frame.maxX+5, y: titSubImg.frame.maxY+12, width: 80, height: 15)
        
        let time:Array = (newsInfo.post_modified?.components(separatedBy: " "))!
        let date:Array = time[0].components(separatedBy: "-")
        if date.count >= 3 {
            self.timeLab.text = "\(date[1])/\(date[2])"
        }else if date.count >= 2 {
            self.timeLab.text = "\(date[0])/\(date[1])"
        }else{
            self.timeLab.text = "\(date[0])"
        }
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
    
    func categoryBtnClick(_ categoryBtn:UIButton) {
//        print(categoryBtn.tag)
        
        self.delegate!.cateBtnClicked(categoryBtn)
    }
    
}
