//
//  MineMessageTableViewCell.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MineMessageTableViewCell: UITableViewCell {
    
    let titleLable = UILabel()
    let nameLable = UILabel()
    let timeLable = UILabel()
    let imgBtn = UIImageView()
    let small = UIButton()
    
    var indexPath:IndexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        
//        imgBtn.frame = CGRectMake(10, 10, 60, 60)
        imgBtn.layer.cornerRadius = 6
        imgBtn.clipsToBounds = true
        imgBtn.contentMode = .scaleAspectFill
        
//        small.frame = CGRectMake(CGRectGetMaxX(imgBtn.frame)-5, CGRectGetMinY(imgBtn.frame)-5, 10, 10)
        
//        titleLable.frame = CGRectMake(85, 10, WIDTH-10-85, 30)
        titleLable.font = UIFont.systemFont(ofSize: 17)
        titleLable.numberOfLines = 0
        titleLable.textColor = UIColor.black
        
//        nameLable.frame = CGRectMake(85, 40, WIDTH*(WIDTH - 105)/375, 30)
        nameLable.font = UIFont.systemFont(ofSize: 16)
        nameLable.textColor = GREY
        
//        timeLable.frame = CGRectMake(WIDTH - 130, 10, 120, 30)
        timeLable.font = UIFont.systemFont(ofSize: 16)
        timeLable.textColor = GREY
        timeLable.textAlignment = NSTextAlignment.right

//        let line = UILabel(frame: CGRectMake(0, 80, WIDTH, 0.5))
//        line.backgroundColor = GREY
        
        self.addSubview(titleLable)
        self.addSubview(nameLable)
        self.addSubview(imgBtn)
        self.addSubview(small)
        self.addSubview(timeLable)
//        self.addSubview(line)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
