//
//  ExamBibleViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/11/4.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import PagingMenuController

class ExamBibleViewController: UIViewController {
    
    // TODO: 需要子类时  放开上边  注释下边
//    let oneView = AllStudyViewController()
//    let twoView = AllStudyViewController()
//    let threeView = AllStudyViewController()
    
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
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "考试宝典"
        
        //        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        //        line.backgroundColor = COLOR
        //        self.view.addSubview(line)
        //        self.view.backgroundColor = UIColor.whiteColor()
        
        let line2 = UILabel(frame: CGRect(x: 0, y: 40, width: WIDTH, height: 1))
        line2.backgroundColor = COLOR
        self.view.addSubview(line2)
        self.view.backgroundColor = UIColor.white
        
        self.view.backgroundColor = UIColor.white
        
        // TODO: 需要子类时  放开上边  注释下边
//        oneView.title = "护士资格"
//        oneView.articleID = "149"
//        oneView.showLineView = false
//        twoView.title = "初级护师"
//        twoView.articleID = "150"
//        twoView.showLineView = false
//        threeView.title = "主管护师"
//        threeView.articleID = "151"
//        threeView.showLineView = false
        
//        let viewControllers = [oneView,twoView,threeView]
//        let options = PagingMenuOptions()
//        options.scrollEnabled = false
//        options.menuItemMargin = 5
//        options.menuHeight = 40
//        options.menuDisplayMode = .SegmentedControl
//        options.backgroundColor = UIColor.clearColor()
//        options.selectedBackgroundColor = UIColor.clearColor()
//        options.font = UIFont.systemFontOfSize(16)
//        options.selectedFont = UIFont.systemFontOfSize(16)
//        options.selectedTextColor = COLOR
//        options.menuItemMode = .Underline(height: 3, color: COLOR, horizontalPadding: 0, verticalPadding: 0)
//        let pagingMenuController = PagingMenuController(viewControllers: viewControllers, options: options)
//        pagingMenuController.view.frame = CGRectMake(0, 1, WIDTH, HEIGHT-1)
////        pagingMenuController.view.frame.origin.y += 0
////        pagingMenuController.view.frame.size.height -= 0
//        addChildViewController(pagingMenuController)
//        view.addSubview(pagingMenuController.view)
//        pagingMenuController.didMoveToParentViewController(self)
        
        
        struct MenuItem1: MenuItemViewCustomizable {
            
            fileprivate var horizontalMargin: CGFloat = 5
            var displayMode: MenuItemDisplayMode {
                let title = MenuItemText(text: "护士资格", color: UIColor.lightGray, selectedColor: COLOR, font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.systemFont(ofSize: 16))
                return .text(title: title)
            }
        }
        struct MenuItem2: MenuItemViewCustomizable {
            fileprivate var horizontalMargin: CGFloat = 5
            var displayMode: MenuItemDisplayMode {
                let title = MenuItemText(text: "初级护师", color: UIColor.lightGray, selectedColor: COLOR, font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.systemFont(ofSize: 16))
                return .text(title: title)
            }
        }
        
        struct MenuItem3: MenuItemViewCustomizable {
            
            fileprivate var horizontalMargin: CGFloat = 5
            var displayMode: MenuItemDisplayMode {
                let title = MenuItemText(text: "主管护师", color: UIColor.lightGray, selectedColor: COLOR, font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.systemFont(ofSize: 16))
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
                
                let oneView = ExamBibleSubViewController()
                let twoView = ExamBibleSubViewController()
                let threeView = ExamBibleSubViewController()
                
                oneView.title = "护士资格"
                oneView.term_id = "149"
                twoView.title = "初级护师"
                twoView.term_id = "150"
                threeView.title = "主管护师"
                threeView.term_id = "151"
                
                return .all(menuOptions: MenuOptions(), pagingControllers: [oneView, twoView, threeView])
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
