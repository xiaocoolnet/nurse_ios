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
        titLab.frame = CGRectMake(57, 15, WIDTH/2, 30)
        titLab.font = UIFont.systemFontOfSize(18)
        
        self.addSubview(titImage)
        self.addSubview(titLab)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
