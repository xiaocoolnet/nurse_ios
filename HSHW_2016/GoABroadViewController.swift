//
//  GoABroadViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/14.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import PagingMenuController

class GoABroadViewController: UIViewController {

//    let goAbroadDynamicView = AbroadViewController()
//    let successfulCaseView = SuccessfulCaseViewController()
//    let nursesTrainingView = TouTiaoViewController()
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.navigationBar.hidden = true
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.defaultStat().pageviewStartWithName("出国")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.defaultStat().pageviewEndWithName("出国")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        goAbroadDynamicView.title = "护士出国"
//        
//        nursesTrainingView.title = "护士培训"
//        nursesTrainingView.newsId = "122"
//        nursesTrainingView.slideImageId = "129"
//        
//        successfulCaseView.title = "成功案例"
//        successfulCaseView.articleID = "9"
//        
//        let viewControllers = [goAbroadDynamicView,nursesTrainingView,successfulCaseView]
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
        
        // Do any additional setup after loading the view.
        
        struct MenuItem1: MenuItemViewCustomizable {
            
            private var horizontalMargin: CGFloat = 5
            var displayMode: MenuItemDisplayMode {
                let title = MenuItemText(text: "护士出国", color: UIColor.lightGrayColor(), selectedColor: COLOR, font: UIFont.systemFontOfSize(18), selectedFont: UIFont.systemFontOfSize(18))
                return .Text(title: title)
            }
        }
        struct MenuItem2: MenuItemViewCustomizable {
            private var horizontalMargin: CGFloat = 5
            var displayMode: MenuItemDisplayMode {
                let title = MenuItemText(text: "护士培训", color: UIColor.lightGrayColor(), selectedColor: COLOR, font: UIFont.systemFontOfSize(18), selectedFont: UIFont.systemFontOfSize(18))
                return .Text(title: title)
            }
        }
        
        struct MenuItem3: MenuItemViewCustomizable {
            
            private var horizontalMargin: CGFloat = 5
            var displayMode: MenuItemDisplayMode {
                let title = MenuItemText(text: "成功案例", color: UIColor.lightGrayColor(), selectedColor: COLOR, font: UIFont.systemFontOfSize(18), selectedFont: UIFont.systemFontOfSize(18))
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
                return [MenuItem1(), MenuItem2(), MenuItem3()]
            }
        }
        
        struct PagingMenuOptions: PagingMenuControllerCustomizable {
            private var scrollEnabled: Bool = false
            var componentType: ComponentType {
                
                let goAbroadDynamicView = AbroadViewController()
                let successfulCaseView = SuccessfulCaseViewController()
                let nursesTrainingView = TouTiaoViewController()
                
                goAbroadDynamicView.title = "护士出国"
                
                nursesTrainingView.title = "护士培训"
                nursesTrainingView.newsId = "122"
                nursesTrainingView.slideImageId = "129"
                
                successfulCaseView.title = "成功案例"
                successfulCaseView.articleID = "9"
                
                return .All(menuOptions: MenuOptions(), pagingControllers: [goAbroadDynamicView,nursesTrainingView,successfulCaseView])
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
