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
        childViewControllers[1].tabBarItem.image = UIImage.init(named: "ic_study_nor")?.imageWithRenderingMode(.AlwaysOriginal)
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
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
        print("=-=-=-=-=-=-=-=-=-=    \(tabBarController.selectedIndex)")
//        if tabBarController.selectedIndex == 1 {
//            
//            HSNurseStationHelper().getArticleListWithID("95") { (success, response) in
//                if success {
//                    let hulibu_newsArray = response as! Array<NewsInfo>
//                    let hulibu_originalNewsUpdateTime = NSUserDefaults.standardUserDefaults().stringForKey(HULIBU_ORIGINALNEWSUPDATETIME)
//                    if hulibu_originalNewsUpdateTime == nil {
//                        NSUserDefaults.standardUserDefaults().setValue(hulibu_newsArray.first?.post_modified, forKey: HULIBU_ORIGINALNEWSUPDATETIME)
//                        hulibu_updateNum = hulibu_newsArray.count
//                    }else{
//                        
//                        for (i,newsInfo) in hulibu_newsArray.enumerate() {
//                            if newsInfo.post_modified == hulibu_originalNewsUpdateTime {
//                                hulibu_updateNum = i
//                                break
//                            }
//                        }
//                    }
//                    
//                    if hulibu_alreadyRead {
//                        NSUserDefaults.standardUserDefaults().setValue(hulibu_newsArray.first?.post_modified, forKey: HULIBU_ORIGINALNEWSUPDATETIME)
//                        hulibu_alreadyRead = false
//                    }
//                    
//                    NSNotificationCenter.defaultCenter().postNotificationName("hulibu_updateNumChanged", object: nil)
//                    
//                }
//            }
//        }

    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
       
//        if LOGIN_STATE == true {
//            return true
//        }
//        
//        if !viewController.isKindOfClass(NewsViewController.self){
//            if showLogin {
//                return false
//            }
//            let vc = childViewControllers[0] as! UINavigationController
//            let controller = ViewController()
//            controller.delegate = self
//            controller.navigationController?.navigationBar.hidden = false
//            controller.title = "登录"
//            vc.pushViewController(controller, animated: true)
//            showLogin = true
//            return false
//        }
        return true
    }
    
    func viewcontrollerDesmiss(){
        showLogin = false
    }
}
