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
    
    var segment:UISegmentedControl?
    var currentVCIndex:Int = 0
//    let ComVC = HSWCommunityHome(nibName: "HSWCommunityHome", bundle: nil)
    let circleController = HSNSCircleHomeViewController()
    let RecVC = HSZRecruitmentHome()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.defaultStat().pageviewStartWithName("护士站")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.defaultStat().pageviewEndWithName("护士站")
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        circleController.view.frame = self.view.frame
        RecVC.view.frame = self.view.frame
//        RecVC.superViewController = self
        self.addChildViewController(circleController)
        self.addChildViewController(RecVC)
        
        segment = UISegmentedControl(items: ["圈子","招聘"])
        navigationItem.titleView = segment
        navigationItem.titleView?.frame = CGRectMake(WIDTH / 2 - 75, 15, 150, 30)
        segment?.selectedSegmentIndex = 0
        segment?.addTarget(self, action: #selector(selectorSegment), forControlEvents: UIControlEvents.ValueChanged)
        
        view.addSubview(circleController.view)
        currentVCIndex = 0
        
//        self.showRightBtn()
    }
    
//    func rightBarButtonClicked() {
//        RecVC.rightBarButtonClicked()
//    }
//    
//    func showRightBtn(){
//        let rightButton = UIButton(type: .Custom)
//        rightButton.frame = CGRectMake(0, 0, 50, 30)
//        rightButton.setTitle("返回", forState: .Normal)
//        rightButton.setTitleColor(COLOR, forState: .Normal)
//        rightButton.addTarget(self, action: #selector(rightBarButtonClicked), forControlEvents: .TouchUpInside)
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: rightButton)
//    }
//    
//    func hiddenBtn(){
//        navigationItem.leftBarButtonItem = nil
//    }
    
    @IBAction func selectorSegment(sender: UISegmentedControl) {

        if sender.selectedSegmentIndex == 0 {
            if currentVCIndex == 0 {
                return
            }
            
            if RecVC.pagingMenuController!.currentPage == 0 || RecVC.pagingMenuController!.currentPage == 1 {
//                (RecVC.pagingMenuController!.currentViewController as! RecruitmentViewController).saveResumeBtnClicked()
            }
            
            self.transitionFromViewController(RecVC, toViewController: circleController, duration: 0, options: .TransitionNone, animations: nil, completion: { [unowned self](Bool) in
                self.currentVCIndex = 0
            })
        }else{
            if currentVCIndex == 1{
                return
            }
            self.transitionFromViewController(circleController, toViewController: RecVC, duration: 0, options: .TransitionNone, animations: nil, completion: { [unowned self] (Bool) in
                self.currentVCIndex = 1
            })
        }
    }
}
