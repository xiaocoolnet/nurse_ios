//
//  HSTabBarController.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/30.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class HSTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        childViewControllers[0].tabBarItem.selectedImage = UIImage(named:"ic_news_sel")?.imageWithRenderingMode(.AlwaysOriginal)
        childViewControllers[1].tabBarItem.selectedImage = UIImage(named:"ic_study_sel")?.imageWithRenderingMode(.AlwaysOriginal)
        childViewControllers[4].tabBarItem.image = UIImage(named:"ic_me_nor")?.imageWithRenderingMode(.AlwaysOriginal)
        childViewControllers[4].tabBarItem.selectedImage = UIImage(named:"ic_me_sel")?.imageWithRenderingMode(.AlwaysOriginal)
    }


}
