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
        
        let contentWeb = WKWebView.init(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT))
        contentWeb.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
