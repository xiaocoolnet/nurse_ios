//
//  MineRecruitViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import PagingMenuController

class MineRecruitViewController: UIViewController, PagingMenuControllerDelegate {
    
    let oneView = ChildsViewController()
    let twoView = MineRecViewController()
    var threeView = CompanyAuthViewController()

    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        oneView.title = "收到的简历"
        twoView.title = "招聘列表"
        threeView.title = "企业认证"
        let viewControllers = [oneView,twoView,threeView]
        let options = PagingMenuOptions()
        options.menuItemMargin = 5
        options.menuHeight = 44
        options.menuDisplayMode = .SegmentedControl
        options.backgroundColor = UIColor.clearColor()
        options.selectedBackgroundColor = UIColor.clearColor()
        options.font = UIFont.systemFontOfSize(16)
        options.selectedFont = UIFont.systemFontOfSize(16)
        options.selectedTextColor = COLOR
        options.menuItemMode = .Underline(height: 3, color: COLOR, horizontalPadding: 0, verticalPadding: 0)
        let pagingMenuController = PagingMenuController(viewControllers: viewControllers, options: options)
        
        pagingMenuController.delegate = self
        
        pagingMenuController.view.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        pagingMenuController.view.frame.origin.y += 0
        pagingMenuController.view.frame.size.height -= 0
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMoveToParentViewController(self)
        
    }
    
    func rightBarButtonClicked() {
        oneView.rightBarButtonClicked()
    }
    
    func showRightBtn(){
        let rightButton = UIButton(type: .Custom)
        rightButton.frame = CGRectMake(0, 0, 50, 30)
        rightButton.setTitle("返回", forState: .Normal)
        rightButton.setTitleColor(COLOR, forState: .Normal)
        rightButton.addTarget(self, action: #selector(rightBarButtonClicked), forControlEvents: .TouchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: rightButton)
    }

    func willMoveToPageMenuController(menuController: UIViewController, previousMenuController: UIViewController) {
        
        if menuController == self.threeView {
            print("this is companyAuth page")
            
            let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("接口还没好，先模拟一下吧！\n选一个您想看的状态~", comment: "empty message"), preferredStyle: .Alert)
            previousMenuController.presentViewController(alertController, animated: true, completion: nil)
            
            let authAction = UIAlertAction(title: "未认证时", style: .Default, handler: { (action) in
                self.threeView.type = 1
            })
            alertController.addAction(authAction)
            
            let waitAction = UIAlertAction(title: "审核中", style: .Default, handler: { (action) in
                self.threeView.type = 2
            })
            alertController.addAction(waitAction)
            
            let successAction = UIAlertAction(title: "已经认证", style: .Default, handler: { (action) in
                self.threeView.type = 3
            })
            alertController.addAction(successAction)
            
            let auAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
            alertController.addAction(auAction)
            
//            self.threeView.type = 3
        }
    }
}
