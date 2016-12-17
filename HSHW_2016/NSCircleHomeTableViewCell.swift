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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setSubViews() {
        
        iconImg.contentMode = .scaleAspectFit
        iconImg.clipsToBounds = true
        iconImg.frame = CGRect(x: 8, y: 11, width: 22, height: 22)
        
        titleLab.font = UIFont.systemFont(ofSize: 18)
        titleLab.textColor = UIColor.black
        titleLab.textAlignment = .left
        
        noteLab.font = UIFont.systemFont(ofSize: 12)
        noteLab.textColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1)
        noteLab.textAlignment = .right
    }
        
//    func setCellWith(name:String) {
//        
//        self.iconImg.image = UIImage(named: name)
//        self.titleLab.text = name
//        self.noteLab.text =
//        
//    }
    func setCellWith(_ name:String, imageName:String, noteStr:String?, isNetImage:Bool = false) {
        
        if isNetImage {
            
            self.iconImg.sd_setImage(with: URL(string: SHOW_IMAGE_HEADER+imageName), placeholderImage: nil)
        }else{
            
            self.iconImg.image = UIImage(named: imageName)
        }
        self.titleLab.text = name
        
        if noteStr == nil {
            self.noteLab.isHidden = true
            titleLab.frame = CGRect(x: 38, y: 0, width: WIDTH-38-38, height: 44)
        }else{
            self.noteLab.isHidden = false
            self.noteLab.text = noteStr
            self.titleLab.sizeToFit()
            titleLab.frame = CGRect(x: 38, y: 0, width: self.titleLab.frame.width, height: 44)
            self.noteLab.frame = CGRect(x: self.titleLab.frame.maxX, y: 0, width: WIDTH-self.titleLab.frame.maxX-38, height: 44)
        }
        
    }
    
}
