//
//  PostTableViewCell.swift
//  HSHW_2016
//
//  Created by apple on 16/5/16.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    let titImage = UIButton()
    let titLab = UILabel()
    let nurse = UILabel()
    let timeLab = UILabel()
    let titTit = UILabel()
    let contant = UILabel()
    let from = UILabel()
    let zanNum = UILabel()
    let comment = UILabel()
    let one = UIImageView()
    let two = UIImageView()
    let three = UIImageView()
    let fromRoom = UILabel()
    let zanBtn = UIButton()
    let conBtn = UIButton()
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        titImage.frame = CGRectMake(10, 20, 30, 30)
        titImage.layer.cornerRadius = 15
        titImage.clipsToBounds = true
        titLab.frame = CGRectMake(45, 18, WIDTH/3, 17)
        titLab.font = UIFont.systemFontOfSize(12)
        nurse.frame = CGRectMake(45, 39, WIDTH/3, 13)
        nurse.font = UIFont.systemFontOfSize(10)
        nurse.textColor = UIColor.grayColor()
        timeLab.frame = CGRectMake(WIDTH-100, 20, 90, 20)
        timeLab.textColor = UIColor.grayColor()
        timeLab.textAlignment = .Right
        timeLab.font = UIFont.systemFontOfSize(10)
        titTit.frame = CGRectMake(10, 60, WIDTH-20, 20)
        titTit.font = UIFont.systemFontOfSize(14)
        contant.frame = CGRectMake(10, 85, WIDTH-20, 35)
        contant.font = UIFont.systemFontOfSize(12)
        contant.textColor = UIColor.grayColor()
        contant.numberOfLines = 0
        from.frame = CGRectMake(10, WIDTH*80/375+140, 25, 16)
        from.font = UIFont.systemFontOfSize(12)
        from.textColor = UIColor.grayColor()
        from.text = "来自"
        zanNum.frame = CGRectMake(WIDTH-80, WIDTH*80/375+140, 30, 16)
        zanNum.font = UIFont.systemFontOfSize(10)
        zanNum.textColor = UIColor.grayColor()
        zanNum.textAlignment = .Left
        comment.frame = CGRectMake(WIDTH-40, WIDTH*80/375+140, 30, 16)
        comment.font = UIFont.systemFontOfSize(10)
        comment.textColor = UIColor.grayColor()
        comment.textAlignment = .Right
        one.frame = CGRectMake(10, 130, (WIDTH-40)/3, WIDTH*80/375)
        two.frame = CGRectMake((WIDTH-40)/3+20, 130, (WIDTH-40)/3, WIDTH*80/375)
        three.frame = CGRectMake((WIDTH-40)/3*2+30, 130, (WIDTH-40)/3, WIDTH*80/375)
        fromRoom.frame = CGRectMake(40, WIDTH*80/375+137, WIDTH/3, 22)
        fromRoom.font = UIFont.systemFontOfSize(13)
        fromRoom.textColor = COLOR
        zanBtn.frame = CGRectMake(WIDTH-96, WIDTH*80/375+140, 16, 16)
        zanBtn.setImage(UIImage(named: "ic_like_gray.png"), forState: .Normal)
        conBtn.frame = CGRectMake(WIDTH-51, WIDTH*80/375+142, 18, 12)
        conBtn.setImage(UIImage(named: "ic_eye_gray.png"), forState: .Normal)

        
        self.addSubview(titImage)
        self.addSubview(titLab)
        self.addSubview(nurse)
        self.addSubview(timeLab)
        self.addSubview(titTit)
        self.addSubview(contant)
        self.addSubview(from)
        self.addSubview(zanNum)
        self.addSubview(comment)
        self.addSubview(one)
        self.addSubview(two)
        self.addSubview(three)
        self.addSubview(fromRoom)
        self.addSubview(zanBtn)
        self.addSubview(conBtn)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
