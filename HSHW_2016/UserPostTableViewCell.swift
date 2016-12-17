//
//  UserPostTableViewCell.swift
//  HSHW_2016
//
//  Created by apple on 16/5/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class UserPostTableViewCell: UITableViewCell {

    let titImage = UIImageView()
    let titLab = UILabel()
    let timeLab = UILabel()
    let titTit = UILabel()
    let contant = UILabel()
    let from = UILabel()
    let zanNum = UILabel()
    let comment = UILabel()
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
        titImage.frame = CGRect(x: 10, y: 20, width: 30, height: 30)
        titImage.layer.cornerRadius = 15
        titImage.clipsToBounds = true
        titLab.frame = CGRect(x: 45, y: 20, width: WIDTH/3, height: 30)
        titLab.font = UIFont.systemFont(ofSize: 12)
        timeLab.frame = CGRect(x: WIDTH-100, y: 20, width: 90, height: 30)
        timeLab.textColor = UIColor.gray
        timeLab.textAlignment = .right
        timeLab.font = UIFont.systemFont(ofSize: 10)
        titTit.frame = CGRect(x: 10, y: 60, width: WIDTH-20, height: 20)
        titTit.font = UIFont.systemFont(ofSize: 14)
        contant.frame = CGRect(x: 10, y: 85, width: WIDTH-20, height: 35)
        contant.font = UIFont.systemFont(ofSize: 12)
        contant.textColor = UIColor.gray
        contant.numberOfLines = 0
        from.frame = CGRect(x: 10, y: 125, width: 25, height: 16)
        from.font = UIFont.systemFont(ofSize: 12)
        from.textColor = UIColor.gray
        from.text = "来自"
        zanNum.frame = CGRect(x: WIDTH-80, y: 125, width: 30, height: 16)
        zanNum.font = UIFont.systemFont(ofSize: 10)
        zanNum.textColor = UIColor.gray
        zanNum.textAlignment = .left
        comment.frame = CGRect(x: WIDTH-40, y: 125, width: 30, height: 16)
        comment.font = UIFont.systemFont(ofSize: 10)
        comment.textColor = UIColor.gray
        comment.textAlignment = .right
        fromRoom.frame = CGRect(x: 40, y: 122, width: WIDTH/3, height: 22)
        fromRoom.font = UIFont.systemFont(ofSize: 13)
        fromRoom.textColor = COLOR
        zanBtn.frame = CGRect(x: WIDTH-96, y: 125, width: 16, height: 16)
        zanBtn.setImage(UIImage(named: "ic_like_gray.png"), for: UIControlState())
        conBtn.frame = CGRect(x: WIDTH-51, y: 127, width: 18, height: 12)
        conBtn.setImage(UIImage(named: "ic_eye_gray.png"), for: UIControlState())
        let line = UILabel(frame: CGRect(x: 0, y: 159.5, width: WIDTH, height: 0.5))
        line.backgroundColor = GREY
        
        self.addSubview(line)
        self.addSubview(titImage)
        self.addSubview(titLab)
        self.addSubview(timeLab)
        self.addSubview(titTit)
        self.addSubview(contant)
        self.addSubview(from)
        self.addSubview(zanNum)
        self.addSubview(comment)
        self.addSubview(fromRoom)
        self.addSubview(zanBtn)
        self.addSubview(conBtn)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
