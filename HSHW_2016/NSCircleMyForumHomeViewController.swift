//
//  NSCircleMyForumHomeViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import PagingMenuController

class NSCircleMyForumHomeViewController: UIViewController, PagingMenuControllerDelegate {
    let forumController = NSCircleMyForumViewController()
    let commentController = NSCircleMyCommentViewController()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.defaultStat().pageviewStartWithName("护士站 圈子 我的帖子")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.defaultStat().pageviewEndWithName("护士站 圈子 我的帖子")
    }
    
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我的贴子"
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        forumController.title = "贴子"
        commentController.title = "评论"
        
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
            
//            var backgroundColor: UIColor {
//                return UIColor.clearColor()
//            }
//            var selectedBackgroundColor: UIColor {
//                return UIColor.clearColor()
//            }
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
        
        let options = PagingMenuOptions.init(viewControllers: [forumController,commentController], itemTextArray: ["贴子","评论"])
        let pagingMenuController = PagingMenuController(options: options)
        pagingMenuController.view.frame = CGRectMake(0, 1, WIDTH, HEIGHT)
        
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMoveToParentViewController(self)
    }
    
}
