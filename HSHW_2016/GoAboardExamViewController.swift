//
//  GoAboardExamViewController.swift
//  HSHW_2016
//
//  Created by zhang on 16/8/30.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import PagingMenuController

class GoAboardExamViewController: UIViewController {

    
//    let oneView = QuestionBankViewController()
//    let twoView = QuestionBankViewController()
//    let threeView = QuestionBankViewController()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "学习 "+(self.title ?? "")!)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "学习 "+(self.title ?? "")!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "出国考试"
        
        self.view.backgroundColor = UIColor.white
//        oneView.title = "美国RN"
//        oneView.term_id = "134"
//        twoView.title = "国际护士证"
//        twoView.term_id = "135"
//        threeView.title = "新加坡"
//        threeView.term_id = "136"
//        let viewControllers = [oneView,twoView,threeView]
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
//        pagingMenuController.view.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
//        pagingMenuController.view.frame.origin.y += 0
//        pagingMenuController.view.frame.size.height -= 0
//        addChildViewController(pagingMenuController)
//        view.addSubview(pagingMenuController.view)
//        pagingMenuController.didMoveToParentViewController(self)
        
        struct MenuItem1: MenuItemViewCustomizable {
            
            fileprivate var horizontalMargin: CGFloat = 5
            var displayMode: MenuItemDisplayMode {
                let title = MenuItemText(text: "美国RN", color: UIColor.lightGray, selectedColor: COLOR, font: UIFont.systemFont(ofSize: 18), selectedFont: UIFont.systemFont(ofSize: 18))
                return .text(title: title)
            }
        }
        struct MenuItem2: MenuItemViewCustomizable {
            fileprivate var horizontalMargin: CGFloat = 5
            var displayMode: MenuItemDisplayMode {
                let title = MenuItemText(text: "国际护士证", color: UIColor.lightGray, selectedColor: COLOR, font: UIFont.systemFont(ofSize: 18), selectedFont: UIFont.systemFont(ofSize: 18))
                return .text(title: title)
            }
        }
        
        struct MenuItem3: MenuItemViewCustomizable {
            
            fileprivate var horizontalMargin: CGFloat = 5
            var displayMode: MenuItemDisplayMode {
                let title = MenuItemText(text: "新加坡", color: UIColor.lightGray, selectedColor: COLOR, font: UIFont.systemFont(ofSize: 18), selectedFont: UIFont.systemFont(ofSize: 18))
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
                
                let oneView = QuestionBankViewController()
                let twoView = QuestionBankViewController()
                let threeView = QuestionBankViewController()
                
                oneView.title = "美国RN"
                oneView.term_id = "134"
                twoView.title = "国际护士证"
                twoView.term_id = "135"
                threeView.title = "新加坡"
                threeView.term_id = "136"
                
                return .all(menuOptions: MenuOptions(), pagingControllers: [oneView,twoView,threeView])
            }
        }
        
        let options = PagingMenuOptions()
        let pagingMenuController = PagingMenuController(options: options)
        pagingMenuController.view.frame = CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT)
        
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMove(toParentViewController: self)
    }
}
