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
    
    let oneView = ExamBibleSubViewController()
    let twoView = ExamBibleSubViewController()
    let threeView = ExamBibleSubViewController()
    //    let threeView = QuestionBankViewController()
    
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "考试宝典"
        
        //        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        //        line.backgroundColor = COLOR
        //        self.view.addSubview(line)
        //        self.view.backgroundColor = UIColor.whiteColor()
        
        let line2 = UILabel(frame: CGRectMake(0, 40, WIDTH, 1))
        line2.backgroundColor = COLOR
        self.view.addSubview(line2)
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        oneView.title = "护士资格"
        oneView.term_id = "149"
        twoView.title = "初级护师"
        twoView.term_id = "150"
        threeView.title = "主管护师"
        threeView.term_id = "151"
        let viewControllers = [oneView,twoView,threeView]
        let options = PagingMenuOptions()
        options.scrollEnabled = false
        options.menuItemMargin = 5
        options.menuHeight = 40
        options.menuDisplayMode = .SegmentedControl
        options.backgroundColor = UIColor.clearColor()
        options.selectedBackgroundColor = UIColor.clearColor()
        options.font = UIFont.systemFontOfSize(16)
        options.selectedFont = UIFont.systemFontOfSize(16)
        options.selectedTextColor = COLOR
        options.menuItemMode = .Underline(height: 3, color: COLOR, horizontalPadding: 0, verticalPadding: 0)
        let pagingMenuController = PagingMenuController(viewControllers: viewControllers, options: options)
        pagingMenuController.view.frame = CGRectMake(0, 1, WIDTH, HEIGHT-1)
//        pagingMenuController.view.frame.origin.y += 0
//        pagingMenuController.view.frame.size.height -= 0
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMoveToParentViewController(self)
        
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