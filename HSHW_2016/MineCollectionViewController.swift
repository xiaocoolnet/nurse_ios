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
//    var articleViewController = HSCollectionListController()
//    var testViewController = HSCollectionListController()
//    var ForumViewController = HSCollectionListController()

    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let line = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
//        articleViewController.title = "文章"
//        articleViewController.collectionType = 1
//        testViewController.title = "试题"
//        testViewController.collectionType = 2
//        ForumViewController.title = "帖子"
//        ForumViewController.collectionType = 3
//        
//        let viewControllers = [articleViewController,testViewController]
//        let options = PagingMenuOptions()
//        options.menuItemMargin = 5
//        options.menuHeight = 40
//        options.menuDisplayMode = .SegmentedControl
//        options.scrollEnabled = false
//        options.backgroundColor = UIColor.clearColor()
//        options.selectedBackgroundColor = UIColor.whiteColor()
//        options.font = UIFont.systemFontOfSize(16)
//        options.selectedFont = UIFont.systemFontOfSize(16)
//        options.selectedTextColor = COLOR
//        options.menuItemMode = .Underline(height: 3, color: COLOR, horizontalPadding: 0, verticalPadding: 0)
//        let pagingMenuController = PagingMenuController(viewControllers: viewControllers, options: options)
//        pagingMenuController.view.frame = CGRectMake(0, 1, WIDTH, HEIGHT)
//        pagingMenuController.view.frame.origin.y += 0
//        pagingMenuController.view.frame.size.height -= 0
//        addChildViewController(pagingMenuController)
//        view.addSubview(pagingMenuController.view)
//        pagingMenuController.didMoveToParentViewController(self)
        
        self.view.backgroundColor = UIColor.white
        
        struct MenuItem1: MenuItemViewCustomizable {
            
            fileprivate var horizontalMargin: CGFloat = 5
            var displayMode: MenuItemDisplayMode {
                let title = MenuItemText(text: "文章", color: UIColor.lightGray, selectedColor: COLOR, font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.systemFont(ofSize: 16))
                return .text(title: title)
            }
        }
        struct MenuItem2: MenuItemViewCustomizable {
            fileprivate var horizontalMargin: CGFloat = 5
            var displayMode: MenuItemDisplayMode {
                let title = MenuItemText(text: "试题", color: UIColor.lightGray, selectedColor: COLOR, font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.systemFont(ofSize: 16))
                return .text(title: title)
            }
        }
        
        struct MenuItem3: MenuItemViewCustomizable {
            fileprivate var horizontalMargin: CGFloat = 5
            var displayMode: MenuItemDisplayMode {
                let title = MenuItemText(text: "帖子", color: UIColor.lightGray, selectedColor: COLOR, font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.systemFont(ofSize: 16))
                return .text(title: title)
            }
        }
        
        struct MenuOptions: MenuViewCustomizable {
            
            fileprivate var backgroundColor: UIColor = UIColor.clear
            fileprivate var selectedBackgroundColor: UIColor = UIColor.clear
            fileprivate var displayMode: MenuDisplayMode = .segmentedControl
            fileprivate var height: CGFloat = 40
            
            fileprivate var focusMode: MenuFocusMode = .underline(height: 3, color: COLOR, horizontalPadding: 0, verticalPadding: 0)
            
            var itemsOptions: [MenuItemViewCustomizable] {
                return [MenuItem1(), MenuItem2(), MenuItem3()]
            }
        }
        
        struct PagingMenuOptions: PagingMenuControllerCustomizable {
            fileprivate var scrollEnabled: Bool = false
            var componentType: ComponentType {
                
                let articleViewController = HSCollectionListController()
                let testViewController = HSCollectionListController()
                let ForumViewController = HSCollectionListController()
                
                articleViewController.title = "文章"
                articleViewController.collectionType = 1
                testViewController.title = "试题"
                testViewController.collectionType = 2
                ForumViewController.title = "帖子"
                ForumViewController.collectionType = 3
                
                return .all(menuOptions: MenuOptions(), pagingControllers: [articleViewController,testViewController])
            }
        }
        
        let options = PagingMenuOptions()
        let pagingMenuController = PagingMenuController(options: options)
        pagingMenuController.view.frame = CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-1)
        
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMove(toParentViewController: self)
    }
}
