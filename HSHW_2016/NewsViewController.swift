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
    
    let oneView = TouTiaoViewController()
    let twoView = TouTiaoViewController()
    let threeView = TouTiaoViewController()
    let fourView = AcademicViewController()
    
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
        
        struct MenuItem: MenuItemViewCustomizable {
            
            var text = ""
            
            var horizontalMargin: CGFloat {
                return 5
            }
            var displayMode: MenuItemDisplayMode {
                let title = MenuItemText(text: text, color: UIColor.lightGrayColor(), selectedColor: COLOR, font: UIFont.systemFontOfSize(18), selectedFont: UIFont.systemFontOfSize(18))
                return .Text(title: title)
            }
        }
        
        struct MenuOptions: MenuViewCustomizable {
            
            var itemTextArray = [String]()
            
            var backgroundColor: UIColor {
                return UIColor.clearColor()
            }
            var selectedBackgroundColor: UIColor {
                return UIColor.clearColor()
            }
            var height: CGFloat {
                return 44
            }
            var displayMode: MenuDisplayMode {
                return .SegmentedControl
            }
            var focusMode: MenuFocusMode {
                return .Underline(height: 3, color: COLOR, horizontalPadding: 0, verticalPadding: 0)
            }
            var itemsOptions: [MenuItemViewCustomizable] {
                
                var menuItemArray = [MenuItemViewCustomizable]()
                for text in itemTextArray {
                    menuItemArray.append(MenuItem.init(text: text))
                }
                
                return menuItemArray
            }
        }
        
        struct PagingMenuOptions: PagingMenuControllerCustomizable {

            var viewControllers = [UIViewController]()
            var itemTextArray = [String]()
            
            var scrollEnabled: Bool {
                return false
            }
            var componentType: ComponentType {
                
                return .All(menuOptions: MenuOptions.init(itemTextArray: itemTextArray), pagingControllers: viewControllers)
            }
        }
        
        let options = PagingMenuOptions.init(viewControllers: [oneView,twoView,threeView,fourView], itemTextArray: ["头条","护理界","健康","学术会议"])
        let pagingMenuController = PagingMenuController(options: options)
        pagingMenuController.view.frame = CGRectMake(0, 20, WIDTH, HEIGHT-64)
        
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMoveToParentViewController(self)
    
    }
}
