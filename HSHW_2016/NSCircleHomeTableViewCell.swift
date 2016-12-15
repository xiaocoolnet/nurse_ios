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
    
    let noteLab = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        
        self.contentView.addSubview(iconImg)
        self.contentView.addSubview(titleLab)
        self.contentView.addSubview(noteLab)
        
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
        iconImg.frame = CGRectMake(8, 11, 22, 22)
        
        titleLab.font = UIFont.systemFontOfSize(18)
        titleLab.textColor = UIColor.blackColor()
        titleLab.textAlignment = .Left
        
        noteLab.font = UIFont.systemFontOfSize(12)
        noteLab.textColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1)
        noteLab.textAlignment = .Right
    }
        
//    func setCellWith(name:String) {
//        
//        self.iconImg.image = UIImage(named: name)
//        self.titleLab.text = name
//        self.noteLab.text =
//        
//    }
    func setCellWith(name:String, imageName:String, noteStr:String?, isNetImage:Bool = false) {
        
        if isNetImage {
            
            self.iconImg.sd_setImageWithURL(NSURL(string: SHOW_IMAGE_HEADER+imageName), placeholderImage: nil)
        }else{
            
            self.iconImg.image = UIImage(named: imageName)
        }
        self.titleLab.text = name
        
        if noteStr == nil {
            self.noteLab.hidden = true
            titleLab.frame = CGRect(x: 38, y: 0, width: WIDTH-38-38, height: 44)
        }else{
            self.noteLab.hidden = false
            self.noteLab.text = noteStr
            self.titleLab.sizeToFit()
            titleLab.frame = CGRect(x: 38, y: 0, width: self.titleLab.frame.width, height: 44)
            self.noteLab.frame = CGRect(x: self.titleLab.frame.maxX, y: 0, width: WIDTH-self.titleLab.frame.maxX-38, height: 44)
        }
        
    }
    
}
