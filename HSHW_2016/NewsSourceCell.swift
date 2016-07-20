//
//  NewsSourceCell.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/8.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class NewsSourceCell: UITableViewCell{

    @IBOutlet weak var source: UILabel!
    
    
    @IBOutlet weak var lick: UIImageView!
   
    @IBOutlet weak var post_like: UILabel!

    @IBOutlet weak var checkNum: UILabel!
    
    @IBOutlet weak var createTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
      
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
