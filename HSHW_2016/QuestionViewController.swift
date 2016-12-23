//
//  QuestionViewController.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/4.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import PagingMenuController

class QuestionViewController: UIViewController {
    
    let oneView = FiftyThousandExamViewController()
    let twoView = FiftyThousandExamViewController()
    let threeView = FiftyThousandExamViewController()
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
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "8万道题库"
        
//        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
//        line.backgroundColor = COLOR
//        self.view.addSubview(line)
//        self.view.backgroundColor = UIColor.whiteColor()
        
        let line2 = UILabel(frame: CGRect(x: 0, y: 40, width: WIDTH, height: 1))
        line2.backgroundColor = COLOR
        self.view.addSubview(line2)
        self.view.backgroundColor = UIColor.white
        
        self.view.backgroundColor = UIColor.white
        oneView.title = "护士资格"
        oneView.term_id = "130"
        twoView.title = "初级护师"
        twoView.term_id = "131"
        threeView.title = "主管护师"
        threeView.term_id = "132"
//        let viewControllers = [oneView,twoView,threeView]
//        let options = PagingMenuOptions()
//        options.scrollEnabled = false
//        options.menuItemMargin = 5
//        options.menuHeight = 40
//        options.menuDisplayMode = .SegmentedControl
//        options.backgroundColor = UIColor.clearColor()
//        options.selectedBackgroundColor = UIColor.clearColor()
//        options.font = UIFont.systemFontOfSize(18)
//        options.selectedFont = UIFont.systemFontOfSize(18)
//        options.selectedTextColor = COLOR
//        options.menuItemMode = .Underline(height: 3, color: COLOR, horizontalPadding: 0, verticalPadding: 0)
//        let pagingMenuController = PagingMenuController(viewControllers: viewControllers, options: options)
//        pagingMenuController.view.frame = CGRectMake(0, 1, WIDTH, HEIGHT-1)
////        pagingMenuController.view.frame.origin.y += 0
////        pagingMenuController.view.frame.size.height -= 0
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
//        struct MenuItem2: MenuItemViewCustomizable {
//            fileprivate var horizontalMargin: CGFloat = 5
//            var displayMode: MenuItemDisplayMode {
//                let title = MenuItemText(text: "初级护师", color: UIColor.lightGray, selectedColor: COLOR, font: UIFont.systemFont(ofSize: 18), selectedFont: UIFont.systemFont(ofSize: 18))
//                return .text(title: title)
//            }
//        }
//        
//        struct MenuItem3: MenuItemViewCustomizable {
//            fileprivate var horizontalMargin: CGFloat = 5
//            var displayMode: MenuItemDisplayMode {
//                let title = MenuItemText(text: "主管护师", color: UIColor.lightGray, selectedColor: COLOR, font: UIFont.systemFont(ofSize: 18), selectedFont: UIFont.systemFont(ofSize: 18))
//                return .text(title: title)
//            }
//        }
        
        struct MenuOptions: MenuViewCustomizable {
            
            var menuItemTextArray = [String]()
            
            var backgroundColor: UIColor {
                return UIColor.clear
            }
            var selectedBackgroundColor: UIColor {
                return UIColor.clear
            }
            var height: CGFloat {
                return 40
            }
            var displayMode: MenuDisplayMode {
                return .segmentedControl
            }
            var focusMode: MenuFocusMode {
                return .underline(height: 3, color: COLOR, horizontalPadding: 0, verticalPadding: 0)
            }
            
            var itemsOptions: [MenuItemViewCustomizable] {
                
                var menuArray = [MenuItemViewCustomizable]()
                for menuItemText in menuItemTextArray {
                    menuArray.append(MenuItem.init(text: menuItemText))
                }
                
                return menuArray
            }
        }
        
        struct PagingMenuOptions: PagingMenuControllerCustomizable {
            
            var viewcontrollers = [UIViewController]()
            
            var isScrollEnabled: Bool {
                return false
            }
            var componentType: ComponentType {
                
//                let oneView = FiftyThousandExamViewController()
//                let twoView = FiftyThousandExamViewController()
//                let threeView = FiftyThousandExamViewController()
//                
//                oneView.title = "护士资格"
//                oneView.term_id = "130"
//                twoView.title = "初级护师"
//                twoView.term_id = "131"
//                threeView.title = "主管护师"
//                threeView.term_id = "132"
                var menuArray = [String]()
                for view in viewcontrollers {
                    menuArray.append(view.title!)
                }
                
                return .all(menuOptions: MenuOptions.init(menuItemTextArray: menuArray), pagingControllers: viewcontrollers)
            }
        }
        
        let options = PagingMenuOptions.init(viewcontrollers: [oneView,twoView,threeView])
        let pagingMenuController = PagingMenuController(options: options)
        pagingMenuController.view.frame = CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-1)
        
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMove(toParentViewController: self)
    }
}

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

//}
