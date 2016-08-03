//
//  contentTableViewCell.swift
//  HSHW_2016
//
//  Created by zhang on 16/8/3.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import WebKit

class contentTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let contentWeb = WKWebView.init(frame: CGRectMake(0, 0, WIDTH, HEIGHT))
        contentWeb.contentMode = .ScaleAspectFit
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
