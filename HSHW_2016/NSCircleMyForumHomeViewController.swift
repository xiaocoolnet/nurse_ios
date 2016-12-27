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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "护士站 圈子 我的贴子")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "护士站 圈子 我的贴子")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我的贴子"
        
        let line = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
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
                let title = MenuItemText(text: text, color: UIColor.lightGray, selectedColor: COLOR, font: UIFont.systemFont(ofSize: 18), selectedFont: UIFont.systemFont(ofSize: 18))
                return .text(title: title)
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
                return .segmentedControl
            }
            var focusMode: MenuFocusMode {
                return .underline(height: 3, color: COLOR, horizontalPadding: 0, verticalPadding: 0)
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
                
                return .all(menuOptions: MenuOptions.init(textArray: itemTextArray), pagingControllers: viewControllers)
            }
        }
        
        let options = PagingMenuOptions.init(viewControllers: [forumController,commentController], itemTextArray: ["贴子","评论"])
        let pagingMenuController = PagingMenuController(options: options)
        pagingMenuController.view.frame = CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT)
        
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMove(toParentViewController: self)
    }
    
}
