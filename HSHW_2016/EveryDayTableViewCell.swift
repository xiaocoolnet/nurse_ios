//
//  EveryDayTableViewCell.swift
//  HSHW_2016
//
//  Created by apple on 16/5/17.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class EveryDayTableViewCell: UITableViewCell {

    let titImage = UIButton()
    let titLab = UILabel()
    let start = UIButton()
    let num = UILabel()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        titImage.frame = CGRectMake(10, 10, 40, 40)
        titLab.frame = CGRectMake(57, 15, WIDTH/3, 30)
        titLab.font = UIFont.systemFontOfSize(18)
        titLab.backgroundColor = UIColor.redColor()
        start.frame = CGRectMake(WIDTH-10-WIDTH/4, 15, WIDTH/4, 30)
        start.setTitle("开始作答", forState: .Normal)
        start.setTitleColor(COLOR, forState: .Normal)
        start.layer.cornerRadius = 15
        start.layer.borderColor = COLOR.CGColor
        start.layer.borderWidth = 1
        //let one = UILabel(frame: CGRectMake(WIDTH-150, 10, 25, 40))
        
        let one = UILabel(frame: CGRectMake(start.frame.origin.x-30, 10, 25, 40))
        
        one.font = UIFont.systemFontOfSize(12)
        one.backgroundColor = UIColor.redColor()
        one.textAlignment = .Center
        one.textColor = UIColor.grayColor()
        one.text = "道题"
        //num.frame = CGRectMake(WIDTH-168, 10, 20, 40)
        num.frame = CGRectMake(one.frame.origin.x-20, 10, 20, 40)
        num.font = UIFont.systemFontOfSize(12)
        num.textAlignment = .Center
        //num.text =  "100"
        
        let two = UILabel(frame: CGRectMake(num.frame.origin.x-10, 10, 15, 40))
        //let two = UILabel(frame: CGRectMake(num.frame.origin.x-30, 10, 15, 40))
        two.backgroundColor = UIColor.greenColor()
        two.font = UIFont.systemFontOfSize(12)
        two.textAlignment = .Center
        two.textColor = UIColor.grayColor()
        two.text = "共"
        two.backgroundColor = UIColor.greenColor()
       
        self.addSubview(one)
        self.addSubview(num)
        self.addSubview(two)
       
        self.addSubview(titImage)
        self.addSubview(titLab)
        self.addSubview(start)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
