//
//  HSTabBarController.swift
//  HSHW_2016
//  Created by xiaocool on 16/6/30.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.y
//

import UIKit

class HSTabBarController: UITabBarController,UITabBarControllerDelegate,ViewControllerDelegate {
    var loginHelper = LoginModel()
    var showLogin = false
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        childViewControllers[0].tabBarItem.selectedImage = UIImage(named:"ic_news_sel")?.imageWithRenderingMode(.AlwaysOriginal)
        childViewControllers[1].tabBarItem.selectedImage = UIImage(named:"ic_study_sel")?.imageWithRenderingMode(.AlwaysOriginal)
        childViewControllers[4].tabBarItem.image = UIImage(named:"ic_me_nor")?.imageWithRenderingMode(.AlwaysOriginal)
        childViewControllers[4].tabBarItem.selectedImage = UIImage(named:"ic_me_sel")?.imageWithRenderingMode(.AlwaysOriginal)
        let logInfo = NSUserDefaults.standardUserDefaults().objectForKey(LOGINFO_KEY) as? Dictionary<String,String>
        
        if logInfo != nil {
            let usernameStr = logInfo![USER_NAME]!
            let passwordStr = logInfo![USER_PWD]!
            loginHelper.login(usernameStr, passwordNumber: passwordStr, handle: { (success, response) in
                if success {
                    LOGIN_STATE = true
                }
            })
        }
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if LOGIN_STATE == true {
            return true
        }
        
//        if viewController.isKindOfClass(StudyViewController.self){
//            return true
//        }
        
        if !viewController.isKindOfClass(NewsViewController.self){
            if showLogin {
                return false
            }
            let vc = childViewControllers[0] as! UINavigationController
            let controller = ViewController()
            controller.delegate = self
            controller.navigationController?.navigationBar.hidden = false
            controller.title = "登录"
            vc.pushViewController(controller, animated: true)
            showLogin = true
            return false
        }
        return true
    }
    
    func viewcontrollerDesmiss(){
        showLogin = false
    }
}
