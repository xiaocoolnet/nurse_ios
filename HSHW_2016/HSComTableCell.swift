//
//  HSComTableCell.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/22.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class HSComTableCell: UITableViewCell {
    
    @IBOutlet weak var avatarBtn: UIButton!
    @IBOutlet weak var landLorder: UILabel!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var likeNumber: UIButton!
    @IBOutlet weak var commentNumber: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func showForForumModel(model:ForumModel){
        landLorder.text = model.name
        titleLabel.text = model.title
        contentLabel.text = model.content
    }
    
}
