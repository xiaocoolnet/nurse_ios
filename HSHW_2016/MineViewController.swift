//
//  MineViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import MBProgressHUD

class MineViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var myTableView = UITableView()
    var mineHelper = HSMineHelper()
    let numNameArr:[String] = ["粉丝","关注","护士币"]
    let userNameLabel = UILabel()
    let levelBtn = UIButton()
//    let titLabArr:[String] = ["我的帖子","我的消息","我的收藏"]
    let titLabArr:[String] = ["我的消息","我的收藏"]
    let titImgArr:[String] = ["ic_liuyan.png","ic_message.png","ic_fangkuai.png"]
    let titImage = UIButton(type:.Custom)
    
    var fansCountBtn = UIButton(type: .Custom)
    var attentionBtn = UIButton(type: .Custom)
    var nurseCoins = UIButton(type: .Custom)
    
    var timeStamp = 1
    var isLike:Bool = false
    var str = NSString()
    
    var signLab = UILabel()
    let signBtn = UIButton()
    
    var hud:MBProgressHUD?
    
//    var dateSource = data()

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        self.navigationController?.navigationBar.hidden = true
        self.tabBarController?.tabBar.hidden = false
        
        // MARK:要求登录
        if !requiredLogin(self.navigationController!, previousViewController: self, hasBackItem: true) {
            return
        }
        
        myTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = COLOR
        
        myTableView.frame = CGRectMake(0, -20, WIDTH, HEIGHT+20)
//        myTableView.bounces = false
        myTableView.backgroundColor = RGREY
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerClass(MineTableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.showsVerticalScrollIndicator = false
        self.view.addSubview(myTableView)
        myTableView.separatorStyle = .None
        
        myTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData))
        loadData()
        
        // Do any additional setup after loading the view.
    }
    
    func loadData() {
        
        signBtn.enabled = false

        if myTableView.mj_header.isRefreshing() {
            myTableView.mj_header.endRefreshing()
        }
        
        hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud!.labelText = "正在获取个人信息"
        hud!.margin = 10.0
        hud!.removeFromSuperViewOnHide = true
        
        mineHelper.getPersonalInfo {[unowned self] (success, response) in
            if success {
                
                dispatch_async(dispatch_get_main_queue(), {
                    if  !(NetworkReachabilityManager()?.isReachableOnEthernetOrWiFi)! && loadPictureOnlyWiFi {
                        self.titImage.setImage(UIImage.init(named: "img_head_nor"), forState: .Normal)
                    }else{
                        self.titImage.sd_setImageWithURL(NSURL(string: SHOW_IMAGE_HEADER+QCLoginUserInfo.currentInfo.avatar), forState: .Normal, placeholderImage: UIImage.init(named: "img_head_nor"))
                    }
//                    self.titImage.sd_setImageWithURL(NSURL(string: SHOW_IMAGE_HEADER+QCLoginUserInfo.currentInfo.avatar), forState: .Normal,placeholderImage: UIImage(named: "6"))
                    self.userNameLabel.text = QCLoginUserInfo.currentInfo.userName.isEmpty ?"我":QCLoginUserInfo.currentInfo.userName
                    self.levelBtn.setTitle(QCLoginUserInfo.currentInfo.level, forState: .Normal)
                    self.fansCountBtn.setTitle(QCLoginUserInfo.currentInfo.fansCount, forState: .Normal)
                    self.attentionBtn.setTitle(QCLoginUserInfo.currentInfo.attentionCount, forState: .Normal)
                    self.nurseCoins.setTitle(QCLoginUserInfo.currentInfo.money, forState: .Normal)
                    self.myTableView.reloadData()
                    //                self.hud!.hide(true)
                    self.hud?.labelText = "正在获取签到状态"
                })
                self.zanAddNum()
            }else{
                dispatch_async(dispatch_get_main_queue(), {
                    self.hud?.mode = .Text
                    self.hud?.labelText = "获取个人信息失败"
                    self.hud?.hide(true, afterDelay: 1)
                    self.signLab.text = "Error"
                })
            }
        }
    }
    
    // MARK: 获取签到状态
    func zanAddNum() {
        
        self.timeNow()
        let url = PARK_URL_Header+"GetMySignLog"
        let param = [
            
            "userid":QCLoginUserInfo.currentInfo.userid,
            "day":self.timeStamp
            
        ];
        Alamofire.request(.GET, url, parameters: param as? [String : AnyObject] ).response { request, response, json, error in
            print(request)
            if(error != nil){
                dispatch_async(dispatch_get_main_queue(), {
                    self.hud?.mode = .Text
                    self.hud?.labelText = "获取签到状态失败"
                    self.hud?.hide(true, afterDelay: 1)
                    self.signLab.text = "Error"
                })
            }else{
                let status = Http(JSONDecoder(json!))
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.signBtn.enabled = true
                    self.hud?.hide(true)
                })
                
                print("状态是")
                print(status.status)
                if(status.status == "error"){
                    //                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    //                            hud.mode = MBProgressHUDMode.Text
                    ////                            hud.labelText = "HAHAHAAHAH"
                    //                            hud.margin = 10.0
                    //                            hud.removeFromSuperViewOnHide = true
                    //                            hud.hide(true, afterDelay: 1)
                    self.isLike = false
                    dispatch_async(dispatch_get_main_queue(), {
                        self.signLab.text = "每日签到"
//                        print(status.errorData)
                    })
                }
                if(status.status == "success"){
                    
                    //                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    //                            hud.mode = MBProgressHUDMode.Text;
                    //                            hud.labelText = "签到成功"
                    //                            hud.margin = 10.0
                    //                            hud.removeFromSuperViewOnHide = true
                    //                            hud.hide(true, afterDelay: 1)
                    self.isLike = true
                    dispatch_async(dispatch_get_main_queue(), {
                        self.signLab.text = "已签到"
                    })
                }
                
                
            }
        }
    }
    
    // MARK:- TableView 代理
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return WIDTH*232/375+100
        }else{
            return 60
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return 1
        }else if section == 2 {
            return 2
        }else if section == 3 {
            return 1
        }else if section == 4{
            return 1
        }else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.selectionStyle = .None
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                // 创建渐变色图层
                let gradientLayer = CAGradientLayer.init()
                gradientLayer.frame = CGRectMake(0, 0, WIDTH, WIDTH*232/375+100)
                gradientLayer.colors = [UIColor.init(red: 186/255.0, green: 125/255.0, blue: 126/255.0, alpha: 1).CGColor,UIColor.init(red: 140/255.0, green: 20/255.0, blue: 139/255.0, alpha: 1).CGColor]
                // 设置渐变方向（0-1）
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 0, y: 1)
                // 设置渐变色的起始位置和终止位置（颜色分割点）
                gradientLayer.locations = [ (0.15), (0.98)]
                gradientLayer.borderWidth = 0.0
                // 添加图层
                cell.layer.addSublayer(gradientLayer)

                let person = UILabel()
                person.frame = CGRectMake(WIDTH*128/375, WIDTH*29/375, WIDTH*120/375, WIDTH*30/375)
                person.textColor = UIColor.whiteColor()
                person.textAlignment = .Center
                person.text = "个人中心"
                person.font = UIFont.systemFontOfSize(20)
                cell.addSubview(person)
                
                let setBtn = UIButton()
                setBtn.frame = CGRectMake(WIDTH-50,WIDTH*29/375, 50, WIDTH*30/375)
                setBtn.setImage(UIImage(named: "ic_bg_set.png"), forState: .Normal)
                setBtn.addTarget(self, action: #selector(self.setUpData), forControlEvents: .TouchUpInside)
                cell.addSubview(setBtn)
                
                titImage.frame = CGRectMake(WIDTH*128/375, WIDTH*69/375, WIDTH*120/375, WIDTH*120/375)
                if  !(NetworkReachabilityManager()?.isReachableOnEthernetOrWiFi)! && loadPictureOnlyWiFi {
                    self.titImage.setImage(UIImage.init(named: "img_head_nor"), forState: .Normal)
                }else{
                    self.titImage.sd_setImageWithURL(NSURL(string: SHOW_IMAGE_HEADER+QCLoginUserInfo.currentInfo.avatar), forState: .Normal, placeholderImage: UIImage.init(named: "img_head_nor"))
                }
//                self.titImage.sd_setImageWithURL(NSURL(string: SHOW_IMAGE_HEADER+QCLoginUserInfo.currentInfo.avatar), forState: .Normal,placeholderImage: UIImage(named: "6"))
                titImage.addTarget(self, action: #selector(MineViewController.changeTitImage), forControlEvents: .TouchUpInside)
                titImage.layer.cornerRadius = WIDTH*120/375/2
                titImage.clipsToBounds = true
                titImage.layer.borderWidth = 3
                titImage.layer.borderColor = UIColor.whiteColor().CGColor
                cell.addSubview(titImage)
                
                userNameLabel.frame = CGRectMake(WIDTH*160/375, WIDTH*200/375, WIDTH*55/375, 19)
                userNameLabel.textAlignment = .Center
                userNameLabel.font = UIFont.systemFontOfSize(18)
                userNameLabel.textColor = UIColor.whiteColor()
                userNameLabel.text = QCLoginUserInfo.currentInfo.userName.isEmpty ?"我":QCLoginUserInfo.currentInfo.userName
                userNameLabel.sizeToFit()
                
                userNameLabel.frame = CGRectMake(WIDTH/2-userNameLabel.bounds.size.width/2, WIDTH*200/375, userNameLabel.bounds.size.width, userNameLabel.bounds.size.height)
                cell.addSubview(userNameLabel)
                
                levelBtn.frame = CGRectMake(userNameLabel.bounds.size.width/2+5+WIDTH/2, WIDTH*200/375, 20, 19)
                levelBtn.setBackgroundImage(UIImage(named: "ic_shield_yellow.png"), forState: .Normal)
                levelBtn.setTitleColor(UIColor.yellowColor(), forState: .Normal)
                levelBtn.titleLabel?.font = UIFont.systemFontOfSize(9)
                levelBtn.setTitle(QCLoginUserInfo.currentInfo.level, forState: .Normal)
                cell.addSubview(levelBtn)
                
                let signImg = UIImageView(frame: CGRectMake(WIDTH*137/375, WIDTH*200/375+40, WIDTH*22/375, WIDTH*22/375))
                signImg.image = UIImage(named: "ic_lalendar.png")
                cell.addSubview(signImg)
                
                signLab.frame = CGRectMake(WIDTH*169/375, WIDTH*200/375+40,WIDTH*120/375, WIDTH*22/375)
                signLab.font = UIFont.systemFontOfSize(18)
                signLab.textColor = UIColor.yellowColor()
//                signLab.text = "请稍候"
                cell.addSubview(signLab)
                
                signBtn.frame = CGRectMake(WIDTH*68/375, WIDTH*190/375+40, WIDTH*240/375, WIDTH*42/375)
                signBtn.layer.cornerRadius = WIDTH*42/375/2
                signBtn.layer.borderColor = UIColor.yellowColor().CGColor
                signBtn.layer.borderWidth = 2
//                if self.isLike == false {
                    signBtn.addTarget(self, action: #selector(MineViewController.signInToday), forControlEvents: .TouchUpInside)
//                }
                cell.addSubview(signBtn)
                
                for i in 0...2 {
                    if i == 0 {
                        fansCountBtn.frame = CGRectMake(WIDTH/3*CGFloat(i), WIDTH*232/375+50, WIDTH/3, 20)
                        fansCountBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
                        fansCountBtn.setTitle(QCLoginUserInfo.currentInfo.fansCount, forState: .Normal)
                        cell.addSubview(fansCountBtn)
                    }else if i == 1 {
                        attentionBtn.frame = CGRectMake(WIDTH/3*CGFloat(i), WIDTH*232/375+50, WIDTH/3, 20)
                        attentionBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
                        attentionBtn.setTitle(QCLoginUserInfo.currentInfo.attentionCount, forState: .Normal)
                        cell.addSubview(attentionBtn)
                    }else {
                        nurseCoins.frame = CGRectMake(WIDTH/3*CGFloat(i), WIDTH*232/375+50, WIDTH/3, 20)
                        nurseCoins.titleLabel?.font = UIFont.systemFontOfSize(14)
                        nurseCoins.setTitle(QCLoginUserInfo.currentInfo.score, forState: .Normal)
                        cell.addSubview(nurseCoins)
                    }
                    
                    let numName = UILabel(frame: CGRectMake(WIDTH/3*CGFloat(i), WIDTH*232/375+70, WIDTH/3, 20))
                    numName.textColor = UIColor(red: 250/255.0, green: 118/255.0, blue: 210/255.0, alpha: 1.0)
                    numName.textAlignment = .Center
                    numName.font = UIFont.systemFontOfSize(12)
                    numName.text = numNameArr[i]
                    cell.addSubview(numName)
                    let line = UILabel(frame: CGRectMake(WIDTH/3*CGFloat(i)-0.5, WIDTH*232/375+60, 0.5, 25))
                    line.backgroundColor = UIColor(red: 250/255.0, green: 118/255.0, blue: 210/255.0, alpha: 1.0)
                    cell.addSubview(line)
                    let btn = UIButton(frame: CGRectMake(WIDTH/3*CGFloat(i), WIDTH*232/375+50, WIDTH/3, 50))
                    btn.addTarget(self, action: #selector(self.fineAndContact(_:)), forControlEvents: .TouchUpInside)
                    btn.tag = i+1
                    cell.addSubview(btn)
                }
                
                
            }
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)as!MineTableViewCell
            cell.selectionStyle = .None
            cell.accessoryType = .DisclosureIndicator
            if indexPath.section == 1 {
                cell.titImage.setImage(UIImage(named: "ic_maozi.png"), forState: .Normal)
                cell.titLab.text = "我的学习"
            }else if indexPath.section == 2 {
                cell.titImage.setImage(UIImage(named: titImgArr[indexPath.row]), forState: .Normal)
                cell.titLab.text = titLabArr[indexPath.row]
                let line = UILabel(frame: CGRectMake(55, 59.5, WIDTH-55, 0.5))
                line.backgroundColor = UIColor.grayColor()
                
                cell.addSubview(line)
                if indexPath.row == 1 {
                    line.removeFromSuperview()
                }
            }else if indexPath.section == 3 {
                cell.titImage.setImage(UIImage(named: "ic_xie.png"), forState: .Normal)
                cell.titLab.text = "我的招聘"
            }else if indexPath.section == 4{
                cell.titImage.setImage(UIImage(named: "ic_singal.png"), forState: .Normal)
                cell.titLab.text = "仅WiFi下载图片"

                let swi = UISwitch.init(frame: CGRectMake(WIDTH-51-10, 29/2.0, 51, 31))

                swi.on = NSUserDefaults.standardUserDefaults().boolForKey("loadPictureOnlyWiFi")
                swi.addTarget(self, action: #selector(switchValueChanged(_:)), forControlEvents: .ValueChanged)
                cell.contentView.addSubview(swi)
                cell.accessoryType = .None
            }else if indexPath.section == 5 {
                cell.titImage.setImage(UIImage(named: "ic_xie.png"), forState: .Normal)
                cell.titLab.text = "清除缓存"
            }else {
                
                let signOutBtn = UIButton(type:.Custom)
                signOutBtn.frame = CGRectMake(WIDTH/2-100, 10, 200, 40)
                signOutBtn.setTitle("退出登录", forState: .Normal)
                signOutBtn.setTitleColor(COLOR, forState: .Normal)
                signOutBtn.layer.cornerRadius = 20
                signOutBtn.layer.borderColor = COLOR.CGColor
                signOutBtn.layer.borderWidth = 1
                signOutBtn.addTarget(self, action: #selector(signout), forControlEvents: .TouchUpInside)
                cell.addSubview(signOutBtn)
                cell.accessoryType = .None
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        if indexPath.section == 1 {
            let next = MineStudyViewController()
            self.navigationController?.pushViewController(next, animated: true)
            next.title = "我的学习"
        }else if indexPath.section == 2 {
//            if indexPath.row == 0 {
//                let next = MinePostViewController()
//                self.navigationController?.pushViewController(next, animated: true)
//                next.title = "我的帖子"
//            }
            if indexPath.row == 0 {
                let next = MineMessageViewController()
                self.navigationController?.pushViewController(next, animated: true)
                next.title = "我的消息"
            }
            if indexPath.row == 1 {
                let next = MineCollectionViewController()
                self.navigationController?.pushViewController(next, animated: true)
                next.title = "我的收藏"
            }
        }else if indexPath.section == 3 {
            if QCLoginUserInfo.currentInfo.usertype == "1" {
                let next = MineRecruit_userViewController()
                self.navigationController?.pushViewController(next, animated: true)
                next.title = "我的招聘"
            }else{
                let next = MineRecruitViewController()
                self.navigationController?.pushViewController(next, animated: true)
                next.title = "我的招聘"
            }
        }else if indexPath.section == 5 {
            
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = MBProgressHUDMode.Text
            hud.labelText = "周一见"
            hud.margin = 10.0
            hud.removeFromSuperViewOnHide = true
            hud.hide(true, afterDelay: 1)
        }
    }
    // MARK:-
    
    // MARK: switch valueChanged
    func switchValueChanged(swi:UISwitch) {
        NSUserDefaults.standardUserDefaults().setBool(swi.on, forKey: "loadPictureOnlyWiFi")
        loadPictureOnlyWiFi = swi.on
        print("switch value changed , and swi.on = \(swi.on)")
    }
    
    // MARK: 点击头像
    func changeTitImage() {
        print("头像")
        setUpData()
    }
    // MARK: 个人资料编辑
    func setUpData() {
        print("设置")
        let next = SetDataViewController()
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    // MARK: 粉丝与关注
    func fineAndContact(btn:UIButton) {
        print("粉丝与管理")
        if btn.tag == 1 {
            let next = FansViewController()
            next.userType = 0
            self.navigationController?.pushViewController(next, animated: true)
        }else if btn.tag == 2 {
            let next = FansViewController()
            next.userType = 1
            self.navigationController?.pushViewController(next, animated: true)
        }else if btn.tag == 3 {
//            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//            hud.mode = MBProgressHUDMode.Text
//            hud.labelText = "敬请期待"
//            hud.margin = 10.0
//            hud.removeFromSuperViewOnHide = true
//            hud.hide(true, afterDelay: 1)
            let next = ScoreViewController()
            self.navigationController?.pushViewController(next, animated: true)
        }
    }

    // MARK: 点击签到
    func signInToday() {
        print("点击签到")
        if isLike == false {
            self.timeNow()
        
            self.zan()
        }else{
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = MBProgressHUDMode.Text
            hud.labelText = "已经签过了哦~"
            hud.margin = 10.0
            hud.removeFromSuperViewOnHide = true
            hud.hide(true, afterDelay: 1)
//            self.isLike = false
        }
    }
    
    // MARK: 签到
    func zan() {
        
        let url = PARK_URL_Header+"SignDay"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,
//                                "userid":"1",
            "day":self.timeStamp
        ];
        print(QCLoginUserInfo.currentInfo.userid)
        Alamofire.request(.GET, url, parameters: param as? [String : AnyObject] ).response { request, response, json, error in
            print(request)
            if(error != nil){
                
            }else{
                let status = Http(JSONDecoder(json!))
                print("状态是")
                print(status.status)
                if(status.status == "error"){
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text
                    hud.labelText = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)

                }
                if(status.status == "success"){
                    
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = "签到成功"
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                    self.isLike = true
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.signLab.text = "已签到"
                    })
                    
                }
            }
        }
    }

    // MARK: 点击退出
    func signout(){
        print("退出")
        
        let alert = UIAlertController(title: "确认退出", message: "您确定要退出登录吗？", preferredStyle: .Alert)
        self.presentViewController(alert, animated: true, completion: nil)
        
        let sureAction = UIAlertAction(title: "确认", style: .Default) { (sureAction) in
            let myTab  = UIApplication.sharedApplication().keyWindow?.rootViewController as! UITabBarController
            myTab.selectedIndex = 0
            LOGIN_STATE = false
            myInviteFriendUrl = APP_INVITEFRIEND_URL+QCLoginUserInfo.currentInfo.userid
            NSUserDefaults.standardUserDefaults().removeObjectForKey(LOGINFO_KEY)
        }
        alert.addAction(sureAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        alert.addAction(cancelAction)
        
    }
    
    func timeNow(){
        //获取当前时间
        let now = NSDate()
        
        // 创建一个日期格式器
        let dformatter = NSDateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日"
        print("当前日期时间：\(dformatter.stringFromDate(now))")
        let today = dformatter.dateFromString(dformatter.stringFromDate(now))

        
        //当前时间的时间戳
        let timeInterval:NSTimeInterval = today!.timeIntervalSince1970
//        let double = (timeInterval as NSString).doubleValue

//        self.timeStamp = Int(timeInterval/100)
        self.timeStamp = Int(timeInterval)
        
        print("当前时间的时间戳：\(Int(timeInterval))")

    }
}
