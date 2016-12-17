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
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "出国")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "出国")
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
            
            fileprivate var horizontalMargin: CGFloat = 5
            var displayMode: MenuItemDisplayMode {
                let title = MenuItemText(text: "护士出国", color: UIColor.lightGray, selectedColor: COLOR, font: UIFont.systemFont(ofSize: 18), selectedFont: UIFont.systemFont(ofSize: 18))
                return .text(title: title)
            }
        }
        struct MenuItem2: MenuItemViewCustomizable {
            fileprivate var horizontalMargin: CGFloat = 5
            var displayMode: MenuItemDisplayMode {
                let title = MenuItemText(text: "护士培训", color: UIColor.lightGray, selectedColor: COLOR, font: UIFont.systemFont(ofSize: 18), selectedFont: UIFont.systemFont(ofSize: 18))
                return .text(title: title)
            }
        }
        
        struct MenuItem3: MenuItemViewCustomizable {
            
            fileprivate var horizontalMargin: CGFloat = 5
            var displayMode: MenuItemDisplayMode {
                let title = MenuItemText(text: "成功案例", color: UIColor.lightGray, selectedColor: COLOR, font: UIFont.systemFont(ofSize: 18), selectedFont: UIFont.systemFont(ofSize: 18))
                return .text(title: title)
            }
        }
        
        struct MenuOptions: MenuViewCustomizable {
            
            fileprivate var backgroundColor: UIColor = UIColor.clear
            fileprivate var selectedBackgroundColor: UIColor = UIColor.clear
            fileprivate var displayMode: MenuDisplayMode = .segmentedControl
            fileprivate var height: CGFloat = 44
            
            fileprivate var focusMode: MenuFocusMode = .underline(height: 3, color: COLOR, horizontalPadding: 0, verticalPadding: 0)
            
            var itemsOptions: [MenuItemViewCustomizable] {
                return [MenuItem1(), MenuItem2(), MenuItem3()]
            }
        }
        
        struct PagingMenuOptions: PagingMenuControllerCustomizable {
            fileprivate var scrollEnabled: Bool = false
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
                
                return .all(menuOptions: MenuOptions(), pagingControllers: [goAbroadDynamicView,nursesTrainingView,successfulCaseView])
            }
        }
        
        let options = PagingMenuOptions()
        let pagingMenuController = PagingMenuController(options: options)
        pagingMenuController.view.frame = CGRect(x: 0, y: 20, width: WIDTH, height: HEIGHT-64)
        
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMove(toParentViewController: self)
    }

}
