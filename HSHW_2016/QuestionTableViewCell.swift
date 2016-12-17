//
//  QuestionTableViewCell.swift
//  HSHW_2016
//
//  Created by apple on 16/5/17.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {

    let titImage = UIButton()
    let titLab = UILabel()
    let eyeImage = UIButton()
//    let titLeb = UILabel()
    let hitsNum = UILabel()
    let likeImage = UIButton()
    let zanNum = UILabel()
  
    let colBtn = UIButton()
    let colNum = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        titImage.frame = CGRect(x: 10, y: 20, width: 25, height: 35)
        titImage.setImage(UIImage(named: "ic_wirte.png"), for: UIControlState())
        titLab.frame = CGRect(x: 40, y: 18, width: WIDTH-45, height: 18)
        titLab.font = UIFont.systemFont(ofSize: 14)
        titLab.numberOfLines = 0
//        titLeb.frame = CGRectMake(40, 40, WIDTH/2, 17)
//        titLeb.font = UIFont.systemFontOfSize(14)
        eyeImage.frame = CGRect(x: 40, y: 21, width: 12, height: 8)
        eyeImage.setBackgroundImage(UIImage(named: "ic_eye_purple.png"), for: UIControlState())
        
        hitsNum.frame = CGRect(x: 57, y: 40, width: 35, height: 17)
        hitsNum.font = UIFont.systemFont(ofSize: 12)
        hitsNum.textColor = UIColor.gray
        
        likeImage.frame = CGRect(x: WIDTH-60, y: 43, width: 10, height: 10)
//        conImage.setImage(UIImage(named: "ic_collect_sel.png"), forState: .Normal)
        likeImage.setBackgroundImage(UIImage(named: "ic_like_sel.png"), for: .selected)
        likeImage.setBackgroundImage(UIImage(named: "ic_like_gray.png"), for: UIControlState())
        
        zanNum.frame = CGRect(x: WIDTH-40, y: 16, width: 35, height: 18)
        zanNum.font = UIFont.systemFont(ofSize: 12)
        zanNum.textColor = UIColor.gray
        
        colBtn.frame = CGRect(x: WIDTH-100, y: (WIDTH-20)*0.5+40, width: 20, height: 20)
        colBtn.setImage(UIImage(named: "ic_collect_nor"), for: UIControlState())
        colBtn.setImage(UIImage(named: "ic_collect_sel"), for: .selected)
        
        colNum.frame = CGRect(x: WIDTH-80, y: (WIDTH-20)*0.5+36, width: 60, height: 20)
        colNum.font = UIFont.systemFont(ofSize: 12)
        colNum.textColor = UIColor.gray
//        let line = UILabel(frame: CGRectMake(0, 74.5, WIDTH, 0.5))
//        line.backgroundColor = GREY
//        
//        self.addSubview(line)
        self.addSubview(titImage)
        self.addSubview(titLab)
        self.addSubview(eyeImage)
        self.addSubview(hitsNum)
        self.addSubview(likeImage)
        self.addSubview(zanNum)
        self.addSubview(colBtn)
        self.addSubview(colNum)
    }
    
    var newsInfo:NewsInfo? {
        didSet {
            
            likeImage.isSelected = false
            colBtn.isSelected = false
            
            let height = calculateHeight((newsInfo?.post_title)!, size: 14, width: WIDTH-45)
            self.titLab.text = newsInfo?.post_title
            self.titLab.frame.size.height = height
            
            self.eyeImage.frame.origin.y = self.titLab.frame.maxY+10
            
            self.hitsNum.text = "\((newsInfo?.post_hits)!) 人学习"
            self.hitsNum.sizeToFit()
            self.hitsNum.frame.origin.x = self.eyeImage.frame.maxX+5
            self.hitsNum.center.y = self.eyeImage.center.y
            
            self.colNum.text = "\((newsInfo?.favorites_count ?? "0")!)"
            self.colNum.sizeToFit()
            self.colNum.frame.origin.x = WIDTH-10-self.colNum.frame.size.width
            self.colNum.center.y = self.eyeImage.center.y
            
            self.colBtn.frame.origin.x = colNum.frame.origin.x-5-self.colBtn.frame.size.width
            self.colBtn.center.y = self.eyeImage.center.y
            
            self.zanNum.text = "\((newsInfo?.likes.count)!)"
            self.zanNum.sizeToFit()
            self.zanNum.frame.origin.x = colBtn.frame.origin.x-10-self.zanNum.frame.size.width
            self.zanNum.center.y = self.eyeImage.center.y
            
            self.likeImage.frame.origin.x = zanNum.frame.minX-5-self.likeImage.frame.size.width
            self.likeImage.center.y = self.eyeImage.center.y
            
            
            for obj in newsInfo!.likes {
                if obj.userid == QCLoginUserInfo.currentInfo.userid {
                    likeImage.isSelected = true
                }
            }
            
            if newsInfo?.favorites_add == "1" {
                colBtn.isSelected = true
            }
//            for obj in newsInfo!.favorites {
//                if obj.userid == QCLoginUserInfo.currentInfo.userid {
//                    colBtn.selected = true
//                }
//            }
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
