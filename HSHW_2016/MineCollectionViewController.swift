//
//  MineCollectionViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import PagingMenuController

class MineCollectionViewController: UIViewController {
    
    var articleViewController = HSCollectionListController()
    var testViewController = HSCollectionListController()
    var ForumViewController = HSCollectionListController()

    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.navigationBar.hidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        articleViewController.title = "文章信息"
        testViewController.title = "收藏试题"
        ForumViewController.title = "收藏帖子"
        
        let viewControllers = [articleViewController,testViewController,ForumViewController]
        let options = PagingMenuOptions()
        options.menuItemMargin = 5
        options.menuHeight = 40
        options.menuDisplayMode = .SegmentedControl
        options.backgroundColor = UIColor.clearColor()
        options.selectedBackgroundColor = UIColor.whiteColor()
        options.font = UIFont.systemFontOfSize(16)
        options.selectedFont = UIFont.systemFontOfSize(16)
        options.selectedTextColor = COLOR
        options.menuItemMode = .Underline(height: 3, color: COLOR, horizontalPadding: 0, verticalPadding: 0)
        let pagingMenuController = PagingMenuController(viewControllers: viewControllers, options: options)
        pagingMenuController.view.frame = CGRectMake(0, 1, WIDTH, HEIGHT-45)
        pagingMenuController.view.frame.origin.y += 0
        pagingMenuController.view.frame.size.height -= 0
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMoveToParentViewController(self)
    }
}
