//
//  HSArticleCollectCell.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/7/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class HSArticleCollectCell: UITableViewCell {
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var from: UILabel!
    var selfModel:NewsInfo?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selfModel != nil {
            let next = NewsContantViewController()
            next.newsInfo = selfModel
            let tabBar = window!.rootViewController as! UITabBarController
            (tabBar.selectedViewController as? UINavigationController)?.pushViewController(next, animated: true)
        }
        // Configure the view for the selected state
    }
    
    func showforModel(model:NewsInfo){
        newsTitle.text = model.title
        selfModel = model
    }
    
}
