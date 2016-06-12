//
//  NurseStationViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/14.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import PagingMenuController

class NurseStationViewController: UIViewController {

    let oneView = AllViewController()
    let twoView = AllViewController()
    let threeView = AllViewController()
    let fourView = AllViewController()
    let fiveView = AllViewController()
    let sixView = AllViewController()
    let sevenView = AllViewController()
    let eightView = AllViewController()
    let nineView = AllViewController()
    let tenView = AllViewController()
    
    let one = RecruitmentViewController()
    let two = TalentViewController()
    let three = RecruitmentViewController()
    
    
    
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.tabBarController?.tabBar.hidden = false
        segment.selectedSegmentIndex = 1
        if segment.selectedSegmentIndex == 1 {
            one.title = "找工作"
            two.title = "找人才"
            three.title = "职场宝典"
            let viewControllers = [one,two,three]
            let options = PagingMenuOptions()
            options.menuItemMargin = 5
            options.menuHeight = 40
            options.menuDisplayMode = .SegmentedControl
            options.backgroundColor = UIColor.clearColor()
            options.selectedBackgroundColor = UIColor.whiteColor()
            options.font = UIFont.systemFontOfSize(16)
            options.selectedFont = UIFont.systemFontOfSize(16)
            options.selectedTextColor = COLOR
            options.menuItemMode = .Underline(height: 3, color: COLOR, horizontalPadding: 0, verticalPadding: 0)
            let pagingMenuController = PagingMenuController(viewControllers: viewControllers, options: options)
            pagingMenuController.view.frame = CGRectMake(0, 1, WIDTH, HEIGHT-45)
            pagingMenuController.view.frame.origin.y += 0
            pagingMenuController.view.frame.size.height -= 0
            addChildViewController(pagingMenuController)
            view.addSubview(pagingMenuController.view)
            pagingMenuController.didMoveToParentViewController(self)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
//        if segment.selectedSegmentIndex == 0 {
//            oneView.title = "全部"
//            twoView.title = "精华"
//            threeView.title = "内科"
//            fourView.title = "外科"
//            fiveView.title = "妇产科"
//            sixView.title = "儿科"
//            sevenView.title = "男科"
//            eightView.title = "中医科"
//            nineView.title = "五官科"
//            tenView.title = "神经科"
//            let viewControllers = [oneView,twoView,threeView,fourView,fiveView,sixView,sevenView,eightView,nineView,tenView]
//            
//            let options = PagingMenuOptions()
//            options.menuItemMargin = 5
//            options.menuHeight = 40
////            options.defaultPage = 2
////            options.deceleratingRate = 3
////            options.lazyLoadingPage = .Three
////            options.animationDuration = 0.3
//            
//            options.menuDisplayMode = .Infinite(widthMode: .Fixed(width: WIDTH/4), scrollingMode: .PagingEnabled)
////            options.menuPosition = .Top
//            options.backgroundColor = UIColor.clearColor()
//            options.selectedBackgroundColor = UIColor.whiteColor()
//            options.font = UIFont.systemFontOfSize(16)
//            options.selectedFont = UIFont.systemFontOfSize(16)
//            options.selectedTextColor = COLOR
//            options.menuItemMode = .Underline(height: 3, color: COLOR, horizontalPadding: 0, verticalPadding: 0)
//            let pagingMenuController = PagingMenuController(viewControllers: viewControllers, options: options)
////            pagingMenuController.setup(viewControllers: viewControllers, options: options)
//            pagingMenuController.view.frame = CGRectMake(0, 0, WIDTH, HEIGHT-44)
////            pagingMenuController.view.frame.origin.y += 0
////            pagingMenuController.view.frame.size.height -= 0
//            addChildViewController(pagingMenuController)
//            view.addSubview(pagingMenuController.view)
//            pagingMenuController.didMoveToParentViewController(self)
//            
//        }
        

        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func selectorSegment(sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 0 {
            self.view.setNeedsDisplay()
        }else{
            self.view.setNeedsDisplay()
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
