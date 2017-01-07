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
    let attentionController = NSCircleAttentionViewController()
    let mineController = NSCircleMineViewController()
    
//    var pagingMenuController:PagingMenuController?
    var pagingMenuController:PagingMenuController!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "护士站 圈子")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "护士站 圈子")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
        if !LOGIN_STATE {
            
            pagingMenuController.move(toPage: 0)

        }

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        discoverController.title = "发现"
        attentionController.title = "关注"
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
                let title = MenuItemText(text: text, color: UIColor.lightGray, selectedColor: COLOR, font: UIFont.systemFont(ofSize: 18), selectedFont: UIFont.systemFont(ofSize: 18))
                return .text(title: title)
            }
        }
        
        struct MenuOptions: MenuViewCustomizable {
            
            var textArray = [String]()
            
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
                for text in textArray {
                    menuItemArray.append(MenuItem.init(text: text))
                }
                
                return menuItemArray
            }
        }
        
        struct PagingMenuOptions: PagingMenuControllerCustomizable {

            
            var viewControllers = [UIViewController]()

            var scrollEnabled: Bool {
                return false
            }
            var componentType: ComponentType {
                var itemTextArray = [String]()
                
                for controller in viewControllers {
                    itemTextArray.append((controller.title ?? "")!)
                }

                return .all(menuOptions: MenuOptions.init(textArray: itemTextArray), pagingControllers: viewControllers)
            }
        }
        
        let options = PagingMenuOptions.init(viewControllers: [discoverController,attentionController,mineController])
        pagingMenuController = PagingMenuController(options: options)
        pagingMenuController.view.frame = CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-45)
        pagingMenuController.delegate = self
        
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMove(toParentViewController: self)
    }
    
    func willMove(toMenuController menuController: UIViewController, fromMenu previousMenuController: UIViewController) -> Bool {
        
        if menuController == attentionController {
            if requiredLogin(self.navigationController, previousViewController: previousMenuController, hiddenNavigationBar: false) {
                
            }else{
                return false
            }
        }else if menuController == mineController {
            if requiredLogin(self.navigationController, previousViewController: previousMenuController, hiddenNavigationBar: false) {
                
            }else{
                return false
            }
        }
        return true
    }
    
}
