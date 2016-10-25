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
    
    var indexPath:NSIndexPath = NSIndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        
        titleLable.frame = CGRectMake(85, 10, WIDTH-130-10-85, 30)
        titleLable.font = UIFont.systemFontOfSize(18)
        titleLable.textColor = UIColor.blackColor()
        
        nameLable.frame = CGRectMake(85, 40, WIDTH*(WIDTH - 105)/375, 30)
        nameLable.font = UIFont.systemFontOfSize(16)
        nameLable.textColor = GREY

        imgBtn.frame = CGRectMake(10, 10, 60, 60)
        imgBtn.layer.cornerRadius = 6
        imgBtn.clipsToBounds = true
        imgBtn.contentMode = .ScaleAspectFill
        
        small.frame = CGRectMake(65, 5, 10, 10)
        
        timeLable.frame = CGRectMake(WIDTH - 130, 10, 120, 30)
        timeLable.font = UIFont.systemFontOfSize(16)
        timeLable.textColor = GREY
        timeLable.textAlignment = NSTextAlignment.Right

        let line = UILabel(frame: CGRectMake(0, 80, WIDTH, 0.5))
        line.backgroundColor = GREY
        
        self.addSubview(titleLable)
        self.addSubview(nameLable)
        self.addSubview(imgBtn)
        self.addSubview(small)
        self.addSubview(timeLable)
        self.addSubview(line)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
