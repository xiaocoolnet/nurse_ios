//
//  NewsViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/14.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import PagingMenuController

class NewsViewController: UIViewController {
    
//    let oneView = TouTiaoViewController()
//    let twoView = TouTiaoViewController()
//    let threeView = TouTiaoViewController()
//    let fourView = AcademicViewController()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.defaultStat().pageviewStartWithName("新闻")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.defaultStat().pageviewEndWithName("新闻")
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.navigationBar.hidden = true
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
//        oneView.title = "头条"
//        oneView.newsId = "4"
//        oneView.slideImageId = "108"
//        twoView.title = "护理界"
//        twoView.newsId = "5"
//        twoView.slideImageId = "109"
//        threeView.title = "健康"
//        threeView.newsId = "6"
//        threeView.slideImageId = "110"
//        fourView.title = "学术会议"
////        fourView.articleID = "7"
//        let viewControllers = [oneView,twoView,threeView,fourView]
//        let options = PagingMenuOptions()
//        options.menuItemMargin = 5
//        options.menuHeight = 44
//        options.menuDisplayMode = .SegmentedControl
//        options.backgroundColor = UIColor.clearColor()
//        options.selectedBackgroundColor = UIColor.clearColor()
//        options.font = UIFont.systemFontOfSize(18)
//        options.selectedFont = UIFont.systemFontOfSize(18)
//        options.selectedTextColor = COLOR
//        options.menuItemMode = .Underline(height: 3, color: COLOR, horizontalPadding: 0, verticalPadding: 0)
//        let pagingMenuController = PagingMenuController(viewControllers: viewControllers, options: options)
//        pagingMenuController.view.frame = CGRectMake(0, 20, WIDTH, HEIGHT-64)
//        pagingMenuController.view.frame.origin.y += 0
//        pagingMenuController.view.frame.size.height -= 0
//        addChildViewController(pagingMenuController)
//        view.addSubview(pagingMenuController.view)
//        pagingMenuController.didMoveToParentViewController(self)
        
        struct MenuItem1: MenuItemViewCustomizable {
            
            private var horizontalMargin: CGFloat = 5
            var displayMode: MenuItemDisplayMode {
                let title = MenuItemText(text: "头条", color: UIColor.lightGrayColor(), selectedColor: COLOR, font: UIFont.systemFontOfSize(18), selectedFont: UIFont.systemFontOfSize(18))
                return .Text(title: title)
            }
        }
        struct MenuItem2: MenuItemViewCustomizable {
            private var horizontalMargin: CGFloat = 5
            var displayMode: MenuItemDisplayMode {
                let title = MenuItemText(text: "护理界", color: UIColor.lightGrayColor(), selectedColor: COLOR, font: UIFont.systemFontOfSize(18), selectedFont: UIFont.systemFontOfSize(18))
                return .Text(title: title)
            }
        }
        
        struct MenuItem3: MenuItemViewCustomizable {
            
            private var horizontalMargin: CGFloat = 5
            var displayMode: MenuItemDisplayMode {
                let title = MenuItemText(text: "健康", color: UIColor.lightGrayColor(), selectedColor: COLOR, font: UIFont.systemFontOfSize(18), selectedFont: UIFont.systemFontOfSize(18))
                return .Text(title: title)
            }
        }
        
        struct MenuItem4: MenuItemViewCustomizable {
            
            private var horizontalMargin: CGFloat = 5
            var displayMode: MenuItemDisplayMode {
                let title = MenuItemText(text: "学术会议", color: UIColor.lightGrayColor(), selectedColor: COLOR, font: UIFont.systemFontOfSize(18), selectedFont: UIFont.systemFontOfSize(18))
                return .Text(title: title)
            }
        }
        
        struct MenuOptions: MenuViewCustomizable {
            
            private var backgroundColor: UIColor = UIColor.clearColor()
            private var selectedBackgroundColor: UIColor = UIColor.clearColor()
            private var displayMode: MenuDisplayMode = .SegmentedControl
            private var height: CGFloat = 44
            
            private var focusMode: MenuFocusMode = .Underline(height: 3, color: COLOR, horizontalPadding: 0, verticalPadding: 0)
            
            var itemsOptions: [MenuItemViewCustomizable] {
                return [MenuItem1(), MenuItem2(), MenuItem3(), MenuItem4()]
            }
        }
        
        struct PagingMenuOptions: PagingMenuControllerCustomizable {
            private var scrollEnabled: Bool = false
            var componentType: ComponentType {
                
                let oneView = TouTiaoViewController()
                let twoView = TouTiaoViewController()
                let threeView = TouTiaoViewController()
                let fourView = AcademicViewController()
                
                oneView.title = "头条"
                oneView.newsId = "4"
                oneView.slideImageId = "108"
                twoView.title = "护理界"
                twoView.newsId = "5"
                twoView.slideImageId = "109"
                threeView.title = "健康"
                threeView.newsId = "6"
                threeView.slideImageId = "110"
                fourView.title = "学术会议"
                
                return .All(menuOptions: MenuOptions(), pagingControllers: [oneView, twoView, threeView, fourView])
            }
        }
        
        let options = PagingMenuOptions()
        let pagingMenuController = PagingMenuController(options: options)
        pagingMenuController.view.frame = CGRectMake(0, 20, WIDTH, HEIGHT-64)
        
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMoveToParentViewController(self)
    
    }
}
