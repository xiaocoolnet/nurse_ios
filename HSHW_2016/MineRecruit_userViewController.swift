//
//  MineRecruit_userViewController.swift
//  HSHW_2016
//
//  Created by zhang on 16/8/8.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import PagingMenuController

class MineRecruit_userViewController: UIViewController,PagingMenuControllerDelegate {

    let oneView = ChildsViewController()
    let twoView = editResumeViewController()
    
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
        
        self.view.backgroundColor = UIColor.white
        
        oneView.title = "面试邀请"
        oneView.type = 1
        twoView.title = "我的简历"
        twoView.flag = false
        twoView.height = HEIGHT-64-44
//        let viewControllers = [oneView,twoView]
//        let options = PagingMenuOptions()
//        options.menuItemMargin = 5
//        options.menuHeight = 44
//        options.menuDisplayMode = .SegmentedControl
//        options.backgroundColor = UIColor.clearColor()
//        options.selectedBackgroundColor = UIColor.clearColor()
//        options.font = UIFont.systemFontOfSize(16)
//        options.selectedFont = UIFont.systemFontOfSize(16)
//        options.selectedTextColor = COLOR
//        options.menuItemMode = .Underline(height: 3, color: COLOR, horizontalPadding: 0, verticalPadding: 0)
//        let pagingMenuController = PagingMenuController(viewControllers: viewControllers, options: options)
//        
//        pagingMenuController.delegate = self
//        pagingMenuController.view.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
//        pagingMenuController.view.frame.origin.y += 0
//        pagingMenuController.view.frame.size.height -= 0
//        addChildViewController(pagingMenuController)
//        view.addSubview(pagingMenuController.view)
//        pagingMenuController.didMoveToParentViewController(self)
        
        struct MenuItem: MenuItemViewCustomizable {
            var horizontalMargin: CGFloat {
                return 5
            }
            var text = ""
            
            var displayMode: MenuItemDisplayMode {
                let title = MenuItemText(text: text, color: UIColor.lightGray, selectedColor: COLOR, font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.systemFont(ofSize: 16))
                return .text(title: title)
            }
        }
        
        struct MenuOptions: MenuViewCustomizable {
                        
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
                return [MenuItem.init(text: "面试邀请"), MenuItem.init(text: "我的简历")]
            }
        }
        
        struct PagingMenuOptions: PagingMenuControllerCustomizable {
            var viewControllers = [UIViewController]()
            var scrollEnabled: Bool {
                return false
            }
            
            var componentType: ComponentType {
                
                return .all(menuOptions: MenuOptions(), pagingControllers: viewControllers)
            }
        }
        
        let options = PagingMenuOptions.init(viewControllers: [oneView,twoView])
        let pagingMenuController = PagingMenuController(options: options)
        pagingMenuController.delegate = self
        pagingMenuController.view.frame = CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT)
        
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMove(toParentViewController: self)
    }
    
    func willMoveToPageMenuController(_ menuController: UIViewController, previousMenuController: UIViewController) {
        if menuController == twoView {
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "willMoveToEditResumeViewController"), object: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
