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
    
//    var pagingMenuController:PagingMenuController?
    
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
//        let viewControllers = [discoverController,mineController]
//        let options = PagingMenuOptions()
//        options.menuItemMargin = 5
//        options.menuHeight = 44
//        options.menuDisplayMode = .SegmentedControl
//        options.backgroundColor = UIColor.clearColor()
//        options.selectedBackgroundColor = UIColor.whiteColor()
//        options.font = UIFont.systemFontOfSize(18)
//        options.selectedFont = UIFont.systemFontOfSize(18)
//        options.selectedTextColor = COLOR
//        options.menuItemMode = .Underline(height: 3, color: COLOR, horizontalPadding: 0, verticalPadding: 0)
//        
//        pagingMenuController = PagingMenuController(viewControllers: viewControllers, options: options)
//        pagingMenuController!.delegate = self
//        pagingMenuController!.view.frame = CGRectMake(0, 1, WIDTH, HEIGHT-45)
//        pagingMenuController!.view.frame.origin.y += 0
//        pagingMenuController!.view.frame.size.height -= 0
//        addChildViewController(pagingMenuController!)
//        view.addSubview(pagingMenuController!.view)
//        pagingMenuController!.didMoveToParentViewController(self)
        
//        struct MenuItem1: MenuItemViewCustomizable {
//            
//            private var horizontalMargin: CGFloat = 5
//            var displayMode: MenuItemDisplayMode {
//                let title = MenuItemText(text: "发现", color: UIColor.lightGrayColor(), selectedColor: COLOR, font: UIFont.systemFontOfSize(18), selectedFont: UIFont.systemFontOfSize(18))
//                return .Text(title: title)
//            }
//        }
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
            
            var textArray = [String]()
            
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
                for text in textArray {
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
                
                return .All(menuOptions: MenuOptions.init(textArray: itemTextArray), pagingControllers: viewControllers)
            }
        }
        
        let options = PagingMenuOptions.init(viewControllers: [discoverController,mineController], itemTextArray: ["发现","我的"])
        let pagingMenuController = PagingMenuController(options: options)
        pagingMenuController.view.frame = CGRectMake(0, 1, WIDTH, HEIGHT-45)
        
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMoveToParentViewController(self)
    }
    
}
