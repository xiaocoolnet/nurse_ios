//
//  AcademicTableViewCell.swift
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

//import Alamofire

class AcademicTableViewCell: UITableViewCell {

    let titImage = UIImageView()
    
    let titLab = UILabel()
    let conNum = UILabel()
    let timeLab = UILabel()
    let zanNum = UILabel()
    let aca_zan = UIButton()
    let comBtn = UIButton()
    let timeBtn = UIButton()
    
    let hitsLab = UILabel()
    let hitsBtn = UIButton()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        titImage.frame = CGRect(x: 10, y: 10, width: WIDTH-20, height: (WIDTH-20)*0.5)
        titImage.contentMode = .scaleAspectFill
        titImage.clipsToBounds = true
        
        titLab.frame = CGRect(x: 10, y: (WIDTH-20)*0.5+15, width: WIDTH-20, height: 20)
        titLab.font = UIFont.systemFont(ofSize: 14)
        titLab.numberOfLines = 0
        
        conNum.frame = CGRect(x: WIDTH-80, y: (WIDTH-20)*0.5+36, width: 60, height: 20)
        conNum.font = UIFont.systemFont(ofSize: 12)
        conNum.textColor = UIColor.gray
        
        comBtn.frame = CGRect(x: WIDTH-100, y: (WIDTH-20)*0.5+40, width: 20, height: 20)
//        comBtn.setImage(UIImage(named: "ic_collect_nor"), for: UIControlState())
        comBtn.setImage(UIImage(named: "ic_collect_sel"), for: .normal)
        comBtn.isEnabled = false
//        comBtn.backgroundColor = UIColor.redColor()
        
        timeLab.frame = CGRect(x: 30, y: (WIDTH-20)*0.5+40, width: 100, height: 20)
        timeLab.font = UIFont.systemFont(ofSize: 14)
        timeLab.textColor = UIColor.gray
        
        timeBtn.frame = CGRect(x: 10, y: (WIDTH-20)*0.5+42, width: 12, height: 12)
//        timeBtn.setImage(UIImage(named: "ic_time_purple.png"), forState: .Normal)
        
        hitsLab.frame = CGRect(x: 30, y: (WIDTH-20)*0.5+40, width: 100, height: 20)
        hitsLab.font = UIFont.systemFont(ofSize: 12)
        hitsLab.textColor = UIColor.gray
        
        hitsBtn.frame = CGRect(x: 10, y: (WIDTH-20)*0.5+40, width: 13, height: 9)
        //        timeBtn.setImage(UIImage(named: "ic_time_purple.png"), forState: .Normal)
        
        zanNum.frame = CGRect(x: WIDTH-30, y: (WIDTH-20)*0.5+38, width: 30, height: 20)
        zanNum.font = UIFont.systemFont(ofSize: 12)
        zanNum.textColor = UIColor.gray
        zanNum.textAlignment = .left
        aca_zan.frame = CGRect(x: WIDTH-50, y: (WIDTH-20)*0.5+42, width: 14, height: 14)
//        aca_zan.setImage(UIImage(named:"ic_like_gray"), for: UIControlState())
        aca_zan.setImage(UIImage(named:"ic_like_sel"), for: UIControlState.normal)
        aca_zan.isEnabled = false
//        aca_zan.addTarget(self, action: #selector(AcademicViewController.click1(_:)), forControlEvents: .TouchUpInside)
//      zan.setImage(UIImage(named: "ic_like_gray.png"), forState: .Normal)
//      zan.setBackgroundImage(UIImage(named: "ic_like_gray.png"), forState: .Normal)
        
        self.addSubview(titImage)
        self.addSubview(titLab)
        self.addSubview(comBtn)
        self.addSubview(conNum)
        self.addSubview(timeBtn)
        self.addSubview(timeLab)
        self.addSubview(aca_zan)
        self.addSubview(zanNum)
        self.addSubview(hitsLab)
        self.addSubview(hitsBtn)
    }
    
    var newsInfo:NewsInfo?{
        didSet {
            aca_zan.isSelected = false
            comBtn.isSelected = false
            if (newsInfo?.thumbArr.count > 0) {
                
                let photoUrl:String = DomainName+"data/upload/"+(newsInfo!.thumbArr.first?.url)!
                print("AcademicTableViewCell photoUrl == \(photoUrl)")
                
                if  !NurseUtil.net.isWifi() && loadPictureOnlyWiFi {
                    self.titImage.image = UIImage.init(named: "defaultImage.png")
                }else{
                    self.titImage.sd_setImage(with: URL.init(string: photoUrl), placeholderImage: UIImage.init(named: "defaultImage.png"))
                }
                //            titImage.sd_setImageWithURL(NSURL(string:photoUrl), placeholderImage: UIImage(named: "2.png"))
            }else{
                titImage.image = UIImage.init(named: "defaultImage.png")
            }
            titLab.text = newsInfo!.post_title
            titLab.frame.size.height = calculateHeight(titLab.text!, size: 14, width: WIDTH-20)
            //        cell.conNum.text = newsInfo.recommended
            
            timeBtn.setBackgroundImage(UIImage(named: "ic_time_purple.png"), for: UIControlState())

            timeLab.frame.origin.y = titLab.frame.maxY+4
            let time:Array = (newsInfo!.post_modified!.components(separatedBy: " "))
            timeLab.text = time[0]
//            let hashValue = newsInfo.likes.count.hashValue
//            print(hashValue)
//            if hashValue != 0 {
//                aca_zan.selected = true
//            }
            if newsInfo?.favorites_add == "1" {
                comBtn.isSelected = true
            }
            if newsInfo?.likes_add == "1" {
                aca_zan.isSelected = true
            }
//            for obj in newsInfo!.likes {
//                if obj.userid == QCLoginUserInfo.currentInfo.userid {
//                    aca_zan.isSelected = true
//                }
//            }
            
//            for obj in newsInfo!.favorites {
//                if obj.userid == QCLoginUserInfo.currentInfo.userid {
//                    comBtn.selected = true
//                }
//            }
            
            
//            print("\(hashValue)")
//            self.likeNum = newsInfo.likes.count
            zanNum.text =  newsInfo?.likes_count
            conNum.text = (newsInfo!.favorites_count ?? "")!
            
            timeBtn.center.y = timeLab.center.y
            aca_zan.center.y = timeLab.center.y
            zanNum.center.y = timeLab.center.y
            comBtn.center.y = timeLab.center.y
            conNum.center.y = timeLab.center.y
        }
    }
    
    var academicNewsInfo:NewsInfo?{
        didSet {
            aca_zan.isSelected = false
            comBtn.isSelected = false
            if (academicNewsInfo?.thumbArr.count > 0) {
                
                let photoUrl:String = DomainName+"data/upload/"+(academicNewsInfo!.thumbArr.first?.url)!
                print("AcademicTableViewCell photoUrl == \(photoUrl)")
                
                if  !NurseUtil.net.isWifi() && loadPictureOnlyWiFi {
                    self.titImage.image = UIImage.init(named: "defaultImage.png")
                }else{
                    self.titImage.sd_setImage(with: URL.init(string: photoUrl), placeholderImage: UIImage.init(named: "defaultImage.png"))
                }
                
                //            titImage.sd_setImageWithURL(NSURL(string:photoUrl), placeholderImage: UIImage(named: "2.png"))
            }else{
                titImage.image = UIImage.init(named: "defaultImage.png")
            }
            titLab.text = academicNewsInfo!.post_title
            titLab.frame.size.height = calculateHeight(titLab.text!, size: 14, width: WIDTH-20)
            //        cell.conNum.text = academicNewsInfo.recommended
            hitsBtn.setBackgroundImage(UIImage(named: "ic_eye_purple.png"), for: UIControlState())
            hitsLab.frame.origin.y = titLab.frame.maxY+4
            hitsLab.text = "\((academicNewsInfo?.post_hits)!) 人看过"
            hitsBtn.center.y = hitsLab.center.y
            //            let hashValue = academicNewsInfo.likes.count.hashValue
            //            print(hashValue)
            //            if hashValue != 0 {
            //                aca_zan.selected = true
            //            }
            
            if academicNewsInfo?.likes_add == "1" {
                aca_zan.isSelected = true
            }
//            for obj in academicNewsInfo!.likes {
//                if obj.userid == QCLoginUserInfo.currentInfo.userid {
//                    aca_zan.isSelected = true
//                }
//            }
            
//            for obj in academicNewsInfo!.favorites {
//                if obj.userid == QCLoginUserInfo.currentInfo.userid {
//                    comBtn.selected = true
//                }
//            }
            if academicNewsInfo?.favorites_add == "1" {
                comBtn.isSelected = true
            }
            
            //            print("\(hashValue)")
            //            self.likeNum = academicNewsInfo.likes.count
            zanNum.text =  academicNewsInfo?.likes_count
            conNum.text = String((academicNewsInfo!.favorites_count ?? "")!)
            
            timeBtn.center.y = timeLab.center.y
            aca_zan.center.y = timeLab.center.y
            zanNum.center.y = timeLab.center.y
            comBtn.center.y = timeLab.center.y
            conNum.center.y = timeLab.center.y
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
