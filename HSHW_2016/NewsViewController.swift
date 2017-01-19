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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "新闻")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "新闻")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
        self.navigationController?.navigationBar.barTintColor = COLOR

        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName:UIColor.white,
            NSFontAttributeName : UIFont.boldSystemFont(ofSize: 20)
        ]
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "搜索"), style: .done, target: self, action: #selector(navigationButtonClick))
        self.navigationItem.title = "中国护士网"
        
        let navigationButton = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 44))
        navigationButton.tag = 123456
        navigationButton.addTarget(self, action: #selector(navigationButtonClick), for: .touchUpInside)
        self.navigationController?.navigationBar.addSubview(navigationButton)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.viewWithTag(123456)?.removeFromSuperview()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        self.navigationController?.navigationBar.tintColor = COLOR
        
        if let barFont = UIFont(name: "ChalkboardSE-Bold", size: 18){
            self.navigationController?.navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName:COLOR,
                NSFontAttributeName : barFont
            ]
        }
        
    }
    
    func navigationButtonClick() {
        print("1234567890-")
        self.navigationController?.pushViewController(NSNewsSearchViewController(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
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
                let title = MenuItemText(text: text, color: UIColor.lightGray, selectedColor: COLOR, font: UIFont.systemFont(ofSize: 18), selectedFont: UIFont.systemFont(ofSize: 18))
                return .text(title: title)
            }
        }
        
        struct MenuOptions: MenuViewCustomizable {
            
            var itemTextArray = [String]()
            
            var backgroundColor: UIColor {
                return UIColor.clear
            }
            var selectedBackgroundColor: UIColor {
                return UIColor.clear
            }
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
                
                return .all(menuOptions: MenuOptions.init(itemTextArray: itemTextArray), pagingControllers: viewControllers)
            }
        }
        
//        let line = UIView(frame: CGRect(x: 0, y: 0, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
        let options = PagingMenuOptions.init(viewControllers: [oneView,twoView,threeView,fourView], itemTextArray: ["头条","护理界","健康","学术会议"])
        let pagingMenuController = PagingMenuController(options: options)
        pagingMenuController.view.frame = CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT-49)
        
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMove(toParentViewController: self)
    
    }
}
