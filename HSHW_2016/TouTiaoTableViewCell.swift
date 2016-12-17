//
//  TouTiaoTableViewCell.swift
//  HSHW_2016
//
//  Created by apple on 16/5/15.
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


protocol ToutiaoCateBtnClickedDelegate:NSObjectProtocol {
    func cateBtnClicked(_ categoryBtn:UIButton)
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

        titLab.frame = CGRect(x: 10, y: 9, width: WIDTH-140, height: 40)
        titLab.font = UIFont.systemFont(ofSize: 17)
        titLab.numberOfLines = 0
        heal.frame = CGRect(x: 10, y: titLab.frame.size.height+titLab.frame.origin.y+22, width: 46, height: 15)
        heal.layer.cornerRadius = 3
        heal.layer.borderColor = COLOR.cgColor
        heal.layer.borderWidth = 0.4
        heal.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        heal.setTitleColor(COLOR, for: UIControlState())
        heal.addTarget(self, action: #selector(categoryBtnClick(_:)), for: .touchUpInside)
        
        hitsBtn.frame = CGRect(x: 62, y: titLab.frame.size.height+titLab.frame.origin.y+23, width: 13, height: 9)
        hitsBtn.setBackgroundImage(UIImage(named: "ic_eye_purple.png"), for: UIControlState())
        
        hitsNum.frame = CGRect(x: 79, y: titLab.frame.size.height+titLab.frame.origin.y+22, width: 30, height: 15)
        hitsNum.font = UIFont.systemFont(ofSize: 13)
        hitsNum.textAlignment = .left
        hitsNum.textColor = GREY

        zanBtn.frame = CGRect(x: WIDTH-50, y: (WIDTH-20)*0.5+42, width: 14, height: 14)
        zanBtn.setImage(UIImage(named:"ic_like_gray"), for: UIControlState())
        zanBtn.setImage(UIImage(named:"ic_like_sel"), for: UIControlState.selected)

        zanNum.frame = CGRect(x: WIDTH-30, y: (WIDTH-20)*0.5+38, width: 30, height: 20)
        zanNum.font = UIFont.systemFont(ofSize: 12)
        zanNum.textColor = UIColor.gray
        zanNum.textAlignment = .left
        
        colBtn.frame = CGRect(x: WIDTH-50, y: (WIDTH-20)*0.5+42, width: 14, height: 14)
        colBtn.setImage(UIImage(named:"ic_collect_nor"), for: UIControlState())
        colBtn.setImage(UIImage(named:"ic_collect_sel"), for: UIControlState.selected)
        
        colNum.frame = CGRect(x: WIDTH-30, y: (WIDTH-20)*0.5+38, width: 30, height: 20)
        colNum.font = UIFont.systemFont(ofSize: 12)
        colNum.textColor = UIColor.gray
        colNum.textAlignment = .left
        
        titImage.contentMode = .scaleAspectFill
        titImage.clipsToBounds = true
        
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCellWithNewsInfo(_ newsInfo:NewsInfo) {
        self.titLab.text = newsInfo.post_title

        heal.setTitle(newsInfo.term_name, for: UIControlState())
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
//                print("TouTiaoTableViewCell   =-=-=-=-=-=-=   ",photoUrl)
                
                titImage.frame = CGRect(x: WIDTH-120, y: 10, width: 110, height: 80)
                self.titImage.sd_setImage(with: URL(string:photoUrl), placeholderImage: UIImage(named: "defaultImage.png"))
                
                titImage.isHidden = false
                titSubImg.isHidden = true
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
        
        hitsBtn.frame.origin.x = heal.frame.maxX+10
        hitsNum.frame.origin.x = hitsBtn.frame.maxX+5
        zanBtn.frame.origin.x = hitsNum.frame.maxX+10
        zanNum.frame.origin.x = zanBtn.frame.maxX+5
        colBtn.frame.origin.x = zanNum.frame.maxX+10
        colNum.frame.origin.x = colBtn.frame.maxX+5
    }
    
    func setThreeImgCellWithNewsInfo(_ newsInfo:NewsInfo) {
        let height = calculateHeight((newsInfo.post_title), size: 17, width: WIDTH-20)
        self.titLab.frame = CGRect(x: 10, y: 9, width: WIDTH-20, height: height)
        
        self.titLab.text = newsInfo.post_title
        
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
        
        let healWidth = calculateWidth(newsInfo.term_name, size: 11, height: 15)+5
        heal.frame = CGRect(x: 10, y: titSubImg.frame.maxY+12, width: healWidth, height: 15)
        heal.setTitle(newsInfo.term_name, for: UIControlState())
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
        
        hitsBtn.frame.origin.x = heal.frame.maxX+10
        hitsNum.frame.origin.x = hitsBtn.frame.maxX+5
        zanBtn.frame.origin.x = hitsNum.frame.maxX+10
        zanNum.frame.origin.x = zanBtn.frame.maxX+5
        colBtn.frame.origin.x = zanNum.frame.maxX+10
        colNum.frame.origin.x = colBtn.frame.maxX+5
    }
    
    func setconNumStr(_ string:String) -> String {
        
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

    func categoryBtnClick(_ categoryBtn:UIButton) {
//        print(categoryBtn.tag)
        
        self.delegate!.cateBtnClicked(categoryBtn)
    }
}
