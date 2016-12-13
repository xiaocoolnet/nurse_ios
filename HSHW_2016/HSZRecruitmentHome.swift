//
//  HSZRecruitmentHome.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/20.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import PagingMenuController

class HSZRecruitmentHome: UIViewController, PagingMenuControllerDelegate {
    
    let findJob = RecruitmentViewController()
    let findPersonnel = RecruitmentViewController()
    var workPlace:HSWorkPlaceController?
//    weak var superViewController:NurseStationViewController?
    
//    var pagingMenuController:PagingMenuController?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        findJob.superViewController = superViewController ?? nil
//        findPersonnel.superViewController = superViewController ?? nil
        
        BaiduMobStat.defaultStat().pageviewStartWithName("护士站 招聘")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.defaultStat().pageviewEndWithName("护士站 招聘")
    }
   
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        workPlace = HSWorkPlaceController(nibName: "HSWorkPlaceController", bundle: nil)
        workPlace?.articleID = "26"
        findJob.title = "找工作"
        findPersonnel.title = "找人才"
        findPersonnel.showType = 2
        workPlace!.title = "职场宝典"
//        let viewControllers = [findJob,findPersonnel,workPlace!]
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
        
//        self.view.backgroundColor = UIColor.whiteColor()
//
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
        
        struct MenuItem1: MenuItemViewCustomizable {
            
            private var horizontalMargin: CGFloat = 5
            var displayMode: MenuItemDisplayMode {
                let title = MenuItemText(text: "找工作", color: UIColor.lightGrayColor(), selectedColor: COLOR, font: UIFont.systemFontOfSize(18), selectedFont: UIFont.systemFontOfSize(18))
                return .Text(title: title)
            }
        }
        struct MenuItem2: MenuItemViewCustomizable {
            private var horizontalMargin: CGFloat = 5
            var displayMode: MenuItemDisplayMode {
                let title = MenuItemText(text: "找人才", color: UIColor.lightGrayColor(), selectedColor: COLOR, font: UIFont.systemFontOfSize(18), selectedFont: UIFont.systemFontOfSize(18))
                return .Text(title: title)
            }
        }
        
        struct MenuItem3: MenuItemViewCustomizable {
            
            private var horizontalMargin: CGFloat = 5
            var displayMode: MenuItemDisplayMode {
                let title = MenuItemText(text: "职场宝典", color: UIColor.lightGrayColor(), selectedColor: COLOR, font: UIFont.systemFontOfSize(18), selectedFont: UIFont.systemFontOfSize(18))
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
            
            var viewcontrollers = [UIViewController]()
            
            var scrollEnabled: Bool {
                return false
            }
            var componentType: ComponentType {
                
                return .All(menuOptions: MenuOptions(), pagingControllers: viewcontrollers)
            }
        }
        
        let options = PagingMenuOptions.init(viewcontrollers: [findJob,findPersonnel,workPlace!])
        let pagingMenuController = PagingMenuController(options: options)
        pagingMenuController.view.frame = CGRectMake(0, 1, WIDTH, HEIGHT-45)
        
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMoveToParentViewController(self)
        
        
    }
    
    
    
//    func rightBarButtonClicked(){
//        findJob.rightBarButtonClicked()
//        findPersonnel.rightBarButtonClicked()
//    }
    
    func willMoveToPageMenuController(menuController: UIViewController, previousMenuController: UIViewController) {
//        if previousMenuController == findJob {
//            findJob.saveResumeBtnClicked()
//        }else if previousMenuController == findPersonnel {
//            findPersonnel.saveResumeBtnClicked()
//        }
    }
}
