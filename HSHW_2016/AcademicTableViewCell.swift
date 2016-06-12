//
//  AcademicTableViewCell.swift
//  HSHW_2016
//
//  Created by apple on 16/5/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class AcademicTableViewCell: UITableViewCell {

    let titImage = UIImageView()
    
    let titLab = UILabel()
    let conNum = UILabel()
    let timeLab = UILabel()
    let zanNum = UILabel()
    let zan = UIButton()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        titImage.frame = CGRectMake(10, 10, WIDTH-20, (WIDTH-20)*120/355)
        titLab.frame = CGRectMake(10, (WIDTH-20)*120/355+15, WIDTH-20, 20)
        titLab.font = UIFont.systemFontOfSize(14)
        conNum.frame = CGRectMake(25, (WIDTH-20)*120/355+35, 60, 20)
        conNum.font = UIFont.systemFontOfSize(10)
        conNum.textColor = UIColor.grayColor()
        timeLab.frame = CGRectMake(100, (WIDTH-20)*120/355+35, 100, 20)
        timeLab.font = UIFont.systemFontOfSize(10)
        timeLab.textColor = UIColor.grayColor()
        zanNum.frame = CGRectMake(WIDTH-40, (WIDTH-20)*120/355+35, 30, 20)
        zanNum.font = UIFont.systemFontOfSize(10)
        zanNum.textColor = UIColor.grayColor()
        zanNum.textAlignment = .Right
        zan.frame = CGRectMake(WIDTH-56, (WIDTH-20)*120/355+37, 16, 16)
        zan.setImage(UIImage(named: "ic_like_gray.png"), forState: .Normal)
        zan.setImage(UIImage(named: "ic_like_big.png"), forState: .Highlighted)
        
        self.addSubview(titImage)
        self.addSubview(titLab)
        self.addSubview(conNum)
        self.addSubview(timeLab)
        self.addSubview(zan)
        self.addSubview(zanNum)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
