//
//  AcademicTableViewCell.swift
//  HSHW_2016
//
//  Created by apple on 16/5/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire

class AcademicTableViewCell: UITableViewCell {

    let titImage = UIImageView()
    
    let titLab = UILabel()
    let conNum = UILabel()
    let timeLab = UILabel()
    let zanNum = UILabel()
    let aca_zan = UIButton()
    let comBtn = UIButton()
    let timeBtn = UIButton()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        titImage.frame = CGRectMake(10, 10, WIDTH-20, (WIDTH-20)*0.5)
        titImage.contentMode = .ScaleAspectFill
        titImage.clipsToBounds = true
        
        titLab.frame = CGRectMake(10, (WIDTH-20)*0.5+15, WIDTH-20, 20)
        titLab.font = UIFont.systemFontOfSize(14)
        
        conNum.frame = CGRectMake(25, (WIDTH-20)*0.5+36, 60, 20)
        conNum.font = UIFont.systemFontOfSize(10)
        conNum.textColor = UIColor.grayColor()
        
        comBtn.frame = CGRectMake(10, (WIDTH-20)*0.5+40, 18, 12)
//        comBtn.setImage(UIImage(named: "ic_eye_purple.png"), forState: .Normal)
//        comBtn.backgroundColor = UIColor.redColor()
        
        timeLab.frame = CGRectMake(30, (WIDTH-20)*0.5+40, 100, 20)
        timeLab.font = UIFont.systemFontOfSize(14)
        timeLab.textColor = UIColor.grayColor()
        
        timeBtn.frame = CGRectMake(10, (WIDTH-20)*0.5+42, 12, 12)
//        timeBtn.setImage(UIImage(named: "ic_time_purple.png"), forState: .Normal)
        timeBtn.setBackgroundImage(UIImage(named: "ic_time_purple.png"), forState: .Normal)
        
        zanNum.frame = CGRectMake(WIDTH-40, (WIDTH-20)*0.5+38, 30, 20)
        zanNum.font = UIFont.systemFontOfSize(14)
        zanNum.textColor = UIColor.grayColor()
        zanNum.textAlignment = .Left
        aca_zan.frame = CGRectMake(WIDTH-60, (WIDTH-20)*0.5+42, 14, 14)
        aca_zan.setImage(UIImage(named:"ic_like_gray"), forState: UIControlState.Normal)
        aca_zan.setImage(UIImage(named:"ic_like_sel"), forState: UIControlState.Selected)
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
    }
    
    var newsInfo:NewsInfo?{
        didSet {
            aca_zan.selected = false
            if (newsInfo?.thumbArr.count > 0) {
                
                let photoUrl:String = DomainName+"data/upload/"+(newsInfo!.thumbArr.first?.url)!
                print(photoUrl)
                if  !(NetworkReachabilityManager()?.isReachableOnEthernetOrWiFi)! && loadPictureOnlyWiFi {
                    titImage.image = UIImage.init(named: "defaultImage.png")
                }else{
                    titImage.sd_setImageWithURL(NSURL.init(string: photoUrl), placeholderImage: UIImage.init(named: "defaultImage.png"))
                }
                //            titImage.sd_setImageWithURL(NSURL(string:photoUrl), placeholderImage: UIImage(named: "2.png"))
            }else{
                titImage.image = UIImage.init(named: "defaultImage.png")
            }
            titLab.text = newsInfo!.post_title
            //        cell.conNum.text = newsInfo.recommended
            let time:Array = (newsInfo!.post_date?.componentsSeparatedByString(" "))!
            timeLab.text = time[0]
//            let hashValue = newsInfo.likes.count.hashValue
//            print(hashValue)
//            if hashValue != 0 {
//                aca_zan.selected = true
//            }
            
            for obj in newsInfo!.likes {
                if obj.userid == QCLoginUserInfo.currentInfo.userid {
                    aca_zan.selected = true
                }
            }
            
//            print("\(hashValue)")
//            self.likeNum = newsInfo.likes.count
            zanNum.text =  String(newsInfo!.likes.count)

        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
