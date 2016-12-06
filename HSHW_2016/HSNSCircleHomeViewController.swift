//
//  HSNSCircleHomeViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/6.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import PagingMenuController

class HSNSCircleHomeViewController: UIViewController, PagingMenuControllerDelegate {
    let discoverController = NSCircleDiscoverViewController()
    let mineController = NSCircleMineViewController()
    
    var pagingMenuController:PagingMenuController?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.defaultStat().pageviewStartWithName("护士站 圈子")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.defaultStat().pageviewEndWithName("护士站 圈子")
    }
    
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        discoverController.title = "发现"
        mineController.title = "我的"
        let viewControllers = [discoverController,mineController]
        let options = PagingMenuOptions()
        options.menuItemMargin = 5
        options.menuHeight = 44
        options.menuDisplayMode = .SegmentedControl
        options.backgroundColor = UIColor.clearColor()
        options.selectedBackgroundColor = UIColor.whiteColor()
        options.font = UIFont.systemFontOfSize(18)
        options.selectedFont = UIFont.systemFontOfSize(18)
        options.selectedTextColor = COLOR
        options.menuItemMode = .Underline(height: 3, color: COLOR, horizontalPadding: 0, verticalPadding: 0)
        
        pagingMenuController = PagingMenuController(viewControllers: viewControllers, options: options)
        pagingMenuController!.delegate = self
        pagingMenuController!.view.frame = CGRectMake(0, 1, WIDTH, HEIGHT-45)
        pagingMenuController!.view.frame.origin.y += 0
        pagingMenuController!.view.frame.size.height -= 0
        addChildViewController(pagingMenuController!)
        view.addSubview(pagingMenuController!.view)
        pagingMenuController!.didMoveToParentViewController(self)
        
    }
    
}
