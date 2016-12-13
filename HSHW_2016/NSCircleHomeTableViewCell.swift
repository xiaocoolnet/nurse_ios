//
//  NSCircleHomeTableViewCell.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/12.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class NSCircleHomeTableViewCell: UITableViewCell {
    
    let iconImg = UIImageView()
    
    let titleLab = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        
        self.addSubview(iconImg)
        self.addSubview(titleLab)
        
        self.setSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setSubViews() {
        
        iconImg.contentMode = .ScaleAspectFit
        iconImg.clipsToBounds = true
        iconImg.frame = CGRectMake(8, 8, 28, 28)
        
        titleLab.frame = CGRect(x: 44, y: 0, width: WIDTH-44-8, height: 44)
        titleLab.font = UIFont.systemFontOfSize(18)
        titleLab.textColor = UIColor.blackColor()
        
    }
        
    func setCellWith(name:String) {
        
        self.iconImg.image = UIImage(named: name)
        self.titleLab.text = name
        
    }
    
}
