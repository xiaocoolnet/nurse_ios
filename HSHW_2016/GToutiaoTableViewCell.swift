//
//  TouTiaoTableViewCell.swift
//  HSHW_2016
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

protocol cateBtnClickedDelegate:NSObjectProtocol {
    func cateBtnClicked(categoryBtn:UIButton)
}

class GToutiaoTableViewCell: UITableViewCell {
    
    var delegate:cateBtnClickedDelegate?
    
    var type = 0 // 1 有分类 2 没分类
    
    let titLab = UILabel()
    let contant = UILabel()
    let titImage = UIImageView()
    let heal = UIButton()
    let conNum = UILabel()
    let timeLab = UILabel()
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
        
        self.addSubview(conNum)
        self.addSubview(timeLab)
        self.addSubview(comBtn)
        self.addSubview(timeBtn)
        self.addSubview(titLab)
        self.addSubview(titImage)
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
        
        if type == 1 {
            self.addSubview(heal)
        }
        titLab.frame = CGRectMake(10, 12, WIDTH-140, 40)
        titLab.font = UIFont.systemFontOfSize(16)
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
        titImage.frame = CGRectMake(WIDTH-120, 10, 110, 80)
    }
    
    func setCellWithNewsInfo(newsInfo:NewsInfo) {
        self.titLab.text = newsInfo.post_title
        if type == 1 {
            heal.frame = CGRectMake(10, titLab.frame.size.height+titLab.frame.origin.y+22, 46, 15)
        }
        
        comBtn.frame = CGRectMake(CGRectGetMaxX(heal.frame)+5, titLab.frame.size.height+titLab.frame.origin.y+23, 13, 10)
        
        self.conNum.text = newsInfo.post_hits
        conNum.sizeToFit()
        conNum.frame = CGRectMake(CGRectGetMaxX(comBtn.frame)+5, titLab.frame.size.height+titLab.frame.origin.y+22, CGRectGetWidth(conNum.frame), 15)
        
        timeBtn.frame = CGRectMake(CGRectGetMaxX(conNum.frame)+5, titLab.frame.size.height+titLab.frame.origin.y+23, 11, 11)
        timeLab.frame = CGRectMake(CGRectGetMaxX(timeBtn.frame)+5, titLab.frame.size.height+titLab.frame.origin.y+22, 80, 15)
        
        let time:Array = (newsInfo.post_date?.componentsSeparatedByString(" "))!
        self.timeLab.text = time[0]
        self.contant.text = newsInfo.post_excerpt
        heal.setTitle(newsInfo.term_name, forState: .Normal)
        heal.tag = Int(newsInfo.term_id!)!
        let photoUrl:String = "http://nurse.xiaocool.net"+newsInfo.thumb!
        print(photoUrl)
        self.titImage.sd_setImageWithURL(NSURL(string:photoUrl), placeholderImage: UIImage(named: "1.png"))
        let titleHeight:CGFloat = calculateHeight(newsInfo.post_title!, size: 16, width: WIDTH-140)
        titLab.frame.size.height = titleHeight
        heal.frame.origin.y = self.frame.size.height-25
        conNum.frame.origin.y = self.frame.size.height-25
        timeLab.frame.origin.y = self.frame.size.height-25
        comBtn.frame.origin.y = self.frame.size.height-25
        timeBtn.frame.origin.y = self.frame.size.height-25
    }
    
    func categoryBtnClick(categoryBtn:UIButton) {
        print(categoryBtn.tag)
        
        self.delegate!.cateBtnClicked(categoryBtn)
    }
    
}