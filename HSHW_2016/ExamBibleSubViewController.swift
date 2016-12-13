//
//  ExamBibleSubViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/11/4.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import PagingMenuController
import MBProgressHUD

class ExamBibleSubViewController: UIViewController {
    
    var term_id = ""
    
    var data = Array<GNewsCate>()
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.defaultStat().pageviewStartWithName("学习 "+(self.title ?? "")!)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.defaultStat().pageviewEndWithName("学习 "+(self.title ?? "")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData()
        
    }
    
    // MARK: 设置子视图
    func setSubviews() {
        
        self.view.backgroundColor = UIColor.whiteColor()
        
////        var viewControllers = [UIViewController]()
//        
//        let studyController = AllStudyViewController()
//        
//        studyController.title = "全部"
//        studyController.articleID = self.term_id
//        studyController.showLineView = false
//        
//        var viewControllers = [studyController]
//        
//        for (_,newsCate) in self.data.enumerate() {
//            let studyController = AllStudyViewController()
//            
//            studyController.title = newsCate.name
//            studyController.articleID = newsCate.term_id
//            studyController.showLineView = false
//            
//            viewControllers.append(studyController)
//        }
//        
//        let options = PagingMenuOptions()
//        options.menuItemMargin = 5
//        options.menuHeight = 30
////        options.menuDisplayMode = .SegmentedControl
//        options.menuDisplayMode = .Standard(widthMode: .Flexible, centerItem: false, scrollingMode: .ScrollEnabledAndBouces)
//        options.backgroundColor = UIColor.clearColor()
//        options.selectedBackgroundColor = UIColor.clearColor()
//        options.font = UIFont.systemFontOfSize(13)
//        options.selectedFont = UIFont.systemFontOfSize(13)
//        options.selectedTextColor = COLOR
//        options.menuItemMode = .Underline(height: 2, color: COLOR, horizontalPadding: 5, verticalPadding: 0)
//        let pagingMenuController = PagingMenuController(viewControllers: viewControllers, options: options)
//        pagingMenuController.view.frame = CGRectMake(0, 1, WIDTH, HEIGHT-1)
////        pagingMenuController.view.frame.origin.y += 0
////        pagingMenuController.view.frame.size.height -= 0
//        addChildViewController(pagingMenuController)
//        view.addSubview(pagingMenuController.view)
//        pagingMenuController.didMoveToParentViewController(self)
        
        struct MenuItem1: MenuItemViewCustomizable {
            
            private var horizontalMargin: CGFloat = 5
            var text = ""
            var displayMode: MenuItemDisplayMode {
                let title = MenuItemText(text: text, color: UIColor.lightGrayColor(), selectedColor: COLOR, font: UIFont.systemFontOfSize(13), selectedFont: UIFont.systemFontOfSize(13))
                return .Text(title: title)
            }
        }
        
        struct MenuOptions: MenuViewCustomizable {
            
            var backgroundColor: UIColor {
                return UIColor.clearColor()
            }
            var selectedBackgroundColor: UIColor {
                return UIColor.clearColor()
            }
            var height: CGFloat {
                return 30
            }
            var displayMode: MenuDisplayMode {
                return .Standard(widthMode: .Flexible, centerItem: false, scrollingMode: .ScrollEnabledAndBouces)
            }
            var focusMode: MenuFocusMode {
                return .Underline(height: 3, color: COLOR, horizontalPadding: 0, verticalPadding: 0)
            }
            
            var data = Array<GNewsCate>()

            var itemsOptions: [MenuItemViewCustomizable] {
                
                var menuArray = [MenuItemViewCustomizable]()
                
                menuArray.append(MenuItem1.init(horizontalMargin: 5, text: "全部"))
                for (_,newsCate) in self.data.enumerate() {
                    menuArray.append(MenuItem1.init(horizontalMargin: 5, text: newsCate.name!))
                }
                return menuArray
            }
        }
        
        struct PagingMenuOptions: PagingMenuControllerCustomizable {
            var defaultPage: Int {
                return 0
            }
            var animationDuration: NSTimeInterval {
                return 0.3
            }
            var scrollEnabled: Bool {
                return false
            }
            var backgroundColor: UIColor {
                return UIColor.whiteColor()
            }
            var lazyLoadingPage: LazyLoadingPage {
                return .Three
            }
            var menuControllerSet: MenuControllerSet {
                return .Multiple
            }
            
            var term_id = ""
            
            var data = Array<GNewsCate>()
            
            var componentType: ComponentType {
                
                let studyController = AllStudyViewController()
                
                studyController.title = "全部"
                studyController.articleID = self.term_id
                studyController.showLineView = false
                
                var viewControllers = [studyController]
                
                for (_,newsCate) in self.data.enumerate() {
                    let studyController = AllStudyViewController()
                    
                    studyController.title = newsCate.name
                    studyController.articleID = newsCate.term_id
                    studyController.showLineView = false
                    
                    viewControllers.append(studyController)
                }
                
                return .All(menuOptions: MenuOptions.init(data: self.data), pagingControllers: viewControllers)
            }
        }
        
        let options = PagingMenuOptions.init(term_id: self.term_id, data: self.data)
        let pagingMenuController = PagingMenuController(options: options)
        pagingMenuController.view.frame = CGRectMake(0, 1, WIDTH, HEIGHT-1)
        
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMoveToParentViewController(self)
    }
    
    // MARK: 加载数据
    func loadData() {
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.margin = 10
        hud.labelText = "正在加载"
        hud.removeFromSuperViewOnHide = true
        
        NewsPageHelper().getChannellist(self.term_id) { (success, response) in
            if success {
                self.data = response as! [GNewsCate]
                
//                self.rootTableView.mj_header.endRefreshing()
//                self.rootTableView.reloadData()
                self.setSubviews()
                hud.hide(true)
                
            }else{
                hud.mode = .Text
                hud.labelText = "网络错误，请稍后再试"
                hud.hide(true, afterDelay: 1)
            }
        }
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
