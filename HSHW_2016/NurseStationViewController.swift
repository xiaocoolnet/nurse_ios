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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "护士站")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "护士站")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.tabBarController?.tabBar.isHidden = false
        
        CircleNetUtil.getMyMessageList(userid: QCLoginUserInfo.currentInfo.userid, pager: "1") { (success, response) in
            
            if success {
                
                let newsListDataArray = response as! [NewsListDataModel]
                
                if UserDefaults.standard.value(forKey: newsUpdateTime) == nil || newsListDataArray.count <= 0 {
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "新消息_nav"), style: .done, target: self, action: #selector(self.newsBtnClick))
                }else{

                    if UserDefaults.standard.value(forKey: newsUpdateTime) as! String != newsListDataArray.first?.create_time {
                        
                        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "新消息_nav_new"), style: .done, target: self, action: #selector(self.newsBtnClick))
                        
                    }else{
                        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "新消息_nav"), style: .done, target: self, action: #selector(self.newsBtnClick))
                        
                    }
                }

            }
        }

    }
    
    func newsBtnClick() {
        self.navigationController?.pushViewController(NSCircleNewsViewController(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let line = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "新消息_nav"), style: .done, target: self, action: #selector(newsBtnClick))

        
        circleController.view.frame = self.view.frame
        RecVC.view.frame = self.view.frame
//        RecVC.superViewController = self
        self.addChildViewController(circleController)
        self.addChildViewController(RecVC)
        
        segment = UISegmentedControl(items: ["圈子","招聘"])
        navigationItem.titleView = segment
        navigationItem.titleView?.frame = CGRect(x: WIDTH / 2 - 75, y: 15, width: 150, height: 30)
        segment?.selectedSegmentIndex = 0
        segment?.addTarget(self, action: #selector(selectorSegment), for: UIControlEvents.valueChanged)
        
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
    
    @IBAction func selectorSegment(_ sender: UISegmentedControl) {

        if sender.selectedSegmentIndex == 0 {
            if currentVCIndex == 0 {
                return
            }
            
//            if RecVC.pagingMenuController!.currentPage == 0 || RecVC.pagingMenuController!.currentPage == 1 {
////                (RecVC.pagingMenuController!.currentViewController as! RecruitmentViewController).saveResumeBtnClicked()
//            }
            
            self.transition(from: RecVC, to: circleController, duration: 0, options: UIViewAnimationOptions(), animations: nil, completion: {(Bool) in
                self.currentVCIndex = 0
            })
        }else{
            if currentVCIndex == 1{
                return
            }
            self.transition(from: circleController, to: RecVC, duration: 0, options: UIViewAnimationOptions(), animations: nil, completion: {(Bool) in
                self.currentVCIndex = 1
            })
        }
    }
}
