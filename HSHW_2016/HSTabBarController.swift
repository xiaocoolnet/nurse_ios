//
//  HSTabBarController.swift
//  HSHW_2016
//  Created by xiaocool on 16/6/30.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.y
//

import UIKit
import MBProgressHUD

class HSTabBarController: UITabBarController,UITabBarControllerDelegate,ViewControllerDelegate {
    var loginHelper = LoginModel()
    var showLogin = false
    
    let Imageview = UIImageView()
    let skipBtn = UIButton()
    var second = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //这一步是获取LaunchScreen.storyboard里的UIViewController,UIViewController 的identifer是LaunchScreen
        Imageview.frame = UIScreen.main.bounds
        
        self.Imageview.sd_setImage(with: URL(string: SHOW_IMAGE_HEADER)!, placeholderImage: #imageLiteral(resourceName: "启动页"))

        self.view.addSubview(self.Imageview)

        let hud = MBProgressHUD.showAdded(to: self.Imageview, animated: true)
        hud.removeFromSuperViewOnHide = true
        
        CircleNetUtil.getHomePage(userid: QCLoginUserInfo.currentInfo.userid) { (success, response) in
            if success {
                let data = response as! HomePageDataModel
                self.Imageview.sd_setImage(with: URL(string: SHOW_IMAGE_HEADER+data.photo)!, placeholderImage: #imageLiteral(resourceName: "启动页"))
                
                DispatchQueue.main.async(execute: { 
                    self.skipBtn.frame = CGRect(x: WIDTH-8-50, y: 20+8, width: 50, height: 25)
                    self.skipBtn.layer.cornerRadius = 12.5
                    self.skipBtn.layer.borderWidth = 1
                    self.skipBtn.layer.borderColor = UIColor.white.cgColor
                    self.skipBtn.layer.backgroundColor = UIColor.gray.cgColor
                    self.skipBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                    
                    self.skipBtn.setTitle("跳过 5", for: UIControlState())
                    
                    self.skipBtn.addTarget(self, action: #selector(self.skipBtnClick), for: .touchUpInside)
                    self.view.addSubview(self.skipBtn)
                    
                    
                    Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timeChanged(timer:)), userInfo: nil, repeats: true)
                })
                
            }else{
                self.Imageview.sd_setImage(with: URL(string: SHOW_IMAGE_HEADER)!, placeholderImage: #imageLiteral(resourceName: "启动页"))
                
                DispatchQueue.main.async(execute: {
                    self.Imageview.removeFromSuperview()
                })
            }
            
            hud.hide(animated: true)

        }
        
        
//        //这一步是获取上次网络请求下来的图片，如果存在就展示该图片，如果不存在就展示本地保存的名为test的图片
//        do {
//            let data = try Data(contentsOf: URL(string: "http://img3.duitang.com/uploads/item/201509/30/20150930130936_JyufE.jpeg")!)
//            
//            if data.count > 0 {
//                Imageview.image = UIImage(data: data)
//            }else{
//                Imageview.image = #imageLiteral(resourceName: "启动页")
//            }
//        } catch  {
//            Imageview.image = #imageLiteral(resourceName: "启动页")
//        }
        
        
        
        delegate = self
        childViewControllers[0].tabBarItem.selectedImage = UIImage(named:"ic_news_sel")?.withRenderingMode(.alwaysOriginal)
        childViewControllers[1].tabBarItem.image = UIImage.init(named: "ic_study_nor")?.withRenderingMode(.alwaysOriginal)
        childViewControllers[1].tabBarItem.selectedImage = UIImage(named:"ic_study_sel")?.withRenderingMode(.alwaysOriginal)
        childViewControllers[4].tabBarItem.image = UIImage(named:"ic_me_nor")?.withRenderingMode(.alwaysOriginal)
        childViewControllers[4].tabBarItem.selectedImage = UIImage(named:"ic_me_sel")?.withRenderingMode(.alwaysOriginal)
        let logInfo = UserDefaults.standard.object(forKey: LOGINFO_KEY) as? Dictionary<String,String>
        
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
    
    func timeChanged(timer:Timer) {
        
        second -= 1
        skipBtn.setTitle("跳过 \(second)", for: UIControlState())

        if second <= 0 {
            self.skipBtnClick()
            timer.invalidate()
        }else{
        }
    }
    
    func skipBtnClick() {
        
        Imageview.removeFromSuperview()
        skipBtn.removeFromSuperview()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
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
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
       
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
