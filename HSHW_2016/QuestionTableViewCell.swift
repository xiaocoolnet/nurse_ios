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
        titImage.frame = CGRectMake(10, 20, 25, 35)
        titImage.setImage(UIImage(named: "ic_wirte.png"), forState: .Normal)
        titLab.frame = CGRectMake(40, 18, WIDTH-45, 18)
        titLab.font = UIFont.systemFontOfSize(14)
        titLab.numberOfLines = 0
//        titLeb.frame = CGRectMake(40, 40, WIDTH/2, 17)
//        titLeb.font = UIFont.systemFontOfSize(14)
        eyeImage.frame = CGRectMake(40, 21, 12, 8)
        eyeImage.setBackgroundImage(UIImage(named: "ic_eye_purple.png"), forState: .Normal)
        
        hitsNum.frame = CGRectMake(57, 40, 35, 17)
        hitsNum.font = UIFont.systemFontOfSize(12)
        hitsNum.textColor = UIColor.grayColor()
        
        likeImage.frame = CGRectMake(WIDTH-60, 43, 10, 10)
//        conImage.setImage(UIImage(named: "ic_collect_sel.png"), forState: .Normal)
        likeImage.setBackgroundImage(UIImage(named: "ic_like_sel.png"), forState: .Normal)
        zanNum.frame = CGRectMake(WIDTH-40, 16, 35, 18)
        zanNum.font = UIFont.systemFontOfSize(12)
        zanNum.textColor = UIColor.grayColor()
        
        colBtn.frame = CGRectMake(WIDTH-100, (WIDTH-20)*0.5+40, 20, 20)
        colBtn.setImage(UIImage(named: "ic_collect_nor"), forState: .Normal)
        colBtn.setImage(UIImage(named: "ic_collect_sel"), forState: .Selected)
        
        colNum.frame = CGRectMake(WIDTH-80, (WIDTH-20)*0.5+36, 60, 20)
        colNum.font = UIFont.systemFontOfSize(12)
        colNum.textColor = UIColor.grayColor()
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
            let height = calculateHeight((newsInfo?.post_title)!, size: 14, width: WIDTH-45)
            self.titLab.text = newsInfo?.post_title
            self.titLab.frame.size.height = height
            
            self.eyeImage.frame.origin.y = CGRectGetMaxY(self.titLab.frame)+10
            
            self.hitsNum.text = "\((newsInfo?.post_hits)!) 人学习"
            self.hitsNum.sizeToFit()
            self.hitsNum.frame.origin.x = CGRectGetMaxX(self.eyeImage.frame)+5
            self.hitsNum.center.y = self.eyeImage.center.y
            
            self.colNum.text = "\((newsInfo?.comments.count)!)"
            self.colNum.sizeToFit()
            self.colNum.frame.origin.x = WIDTH-10-self.colNum.frame.size.width
            self.colNum.center.y = self.eyeImage.center.y
            
            self.colBtn.frame.origin.x = colNum.frame.origin.x-5-self.colBtn.frame.size.width
            self.colBtn.center.y = self.eyeImage.center.y
            
            self.zanNum.text = "\((newsInfo?.likes.count)!)"
            self.zanNum.sizeToFit()
            self.zanNum.frame.origin.x = colBtn.frame.origin.x-10-self.zanNum.frame.size.width
            self.zanNum.center.y = self.eyeImage.center.y
            
            self.likeImage.frame.origin.x = CGRectGetMinX(zanNum.frame)-5-self.likeImage.frame.size.width
            self.likeImage.center.y = self.eyeImage.center.y
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
