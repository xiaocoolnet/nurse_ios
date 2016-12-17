//
//  MineTableViewCell.swift
//  HSHW_2016
//
//  Created by apple on 16/5/16.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MineTableViewCell: UITableViewCell {

    let titImage = UIButton()
    let titLab = UILabel()
    let numLab = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        titImage.frame = CGRect(x: 10, y: 10, width: 40, height: 40)
        titLab.frame = CGRect(x: 57, y: 15, width: WIDTH/2, height: 30)
        titLab.font = UIFont.systemFont(ofSize: 18)
        
        numLab.frame = CGRect(x: WIDTH-25-8, y: 17.5, width: 25, height: 25)
        numLab.backgroundColor = UIColor.red
        numLab.layer.cornerRadius = 12.5
        numLab.clipsToBounds = true
        numLab.textAlignment = .center
        numLab.textColor = UIColor.white
        numLab.font = UIFont.systemFont(ofSize: 15)
        numLab.isHidden = true
//        if recruit_user_updateNum > 99 {
//            numLab.text = "99+"
//        }else{
//            numLab.text = String(hulibu_updateNum)
//        }
//        numLab.adjustsFontSizeToFitWidth = true
        
        self.addSubview(titImage)
        self.addSubview(titLab)
        self.addSubview(numLab)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
