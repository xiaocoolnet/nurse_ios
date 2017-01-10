//
//  MineViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD

class MineViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var myTableView = UITableView()
    var mineHelper = HSMineHelper()
    let numNameArr:[String] = ["粉丝","关注","护士币"]
    let userNameLabel = UILabel()
    let levelBtn = UIButton()
    //    let titLabArr:[String] = ["我的贴子","我的消息","我的收藏"]
    let titLabArr:[String] = ["我的消息","我的收藏"]
    let titImgArr:[String] = ["ic_liuyan.png","ic_message.png","ic_fangkuai.png"]
    let titImage = UIButton(type:.custom)
    
    var fansCountBtn = UIButton(type: .custom)
    var attentionBtn = UIButton(type: .custom)
    var nurseCoins = UIButton(type: .custom)
    
    var timeStamp = 1
    var isLike:Bool = false
    var str = NSString()
    
    var signLab = UILabel()
    let signBtn = UIButton()
    
    var hud:MBProgressHUD?
    
    var recuit_user_Array = [InvitedInfo]()
    var recuit_company_Array = [MineJobInfo]()

    var followFansNum = FollowFansNumDataModel()

    //    var dateSource = data()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "我的")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "我的")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        
//        // MARK:要求登录
//        if !requiredLogin(self.navigationController!, previousViewController: self, hiddenNavigationBar: true) {
//            return
//        }
        
        if !LOGIN_STATE {
            self.initSubviews()
        }
        loadData()

        myTableView.reloadData()
        
        CircleNetUtil.getFollowFans_num(userid: QCLoginUserInfo.currentInfo.userid) { (success, response) in
            if success {
                self.followFansNum = response as! FollowFansNumDataModel
                self.myTableView.reloadData()
            }else{
                let followFansNumData = FollowFansNumDataModel()
                followFansNumData.fans_count = "0"
                followFansNumData.follows_count = "0"
                self.followFansNum = followFansNumData
            }
        }
        
        // 设置我的消息提醒数
        let url = PARK_URL_Header+"getsystemmessage_new"
        let param = ["userid":QCLoginUserInfo.currentInfo.userid]
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
           
            if(error != nil){
                
            }else{
                let status = newsInfoModel(JSONDecoder(json!))
                
                if(status.status == "success"){
                    let tempArray = status.data
                    
                    let url_read = PARK_URL_Header+"getMessagereadlist"
                    let param_read = ["userid":QCLoginUserInfo.currentInfo.userid]
                    NurseUtil.net.request(RequestType.requestTypeGet, URLString: url_read, Parameter: param_read as [String : AnyObject]?) { (json, error) in

                        
                        if(error != nil){
                            
                        }else{
                            let status = ReadMessageList(JSONDecoder(json!))
                            
                            unreadNum = tempArray.count-(status.data ).count
                            self.myTableView.reloadData()
                            
                        }
                    }
                }
            }
        }
        
        
        // 设置我的招聘提醒数
        if QCLoginUserInfo.currentInfo.usertype == "1" {// 个人用户
            
            let url = PARK_URL_Header+"UserGetInvite"
            let param = ["userid":QCLoginUserInfo.currentInfo.userid]
            NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in

                if(error != nil){
                    
                }else{
                    let status = InvitedModel(JSONDecoder(json!))
                    
                    if(status.status == "success"){
                        
                        self.recuit_user_Array = InvitedList(status.data!).data
                        let recuit_user_OriginalCreatetime = UserDefaults.standard.string(forKey: RECRUIT_USER_ORIGINALCREATETIME)
                        if recuit_user_OriginalCreatetime == nil {
                            recruit_user_updateNum = self.recuit_user_Array.count
                        }else{
                            
                            for (i,newsInfo) in self.recuit_user_Array.enumerated() {
                                if newsInfo.create_time == recuit_user_OriginalCreatetime {
                                    recruit_user_updateNum = i
                                    break
                                }
                            }
                        }
                        self.myTableView.reloadData()
                    }
                }
            }
        }else{// 企业用户
            
            let url = PARK_URL_Header+"getMyReciveResumeList"
            let param = ["userid":QCLoginUserInfo.currentInfo.userid]
            NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
                if(error != nil){
                    
                }else{
                    let status = MineJobModel(JSONDecoder(json!))
                    
                    if(status.status == "success"){
                        
                        self.recuit_company_Array = MineJobList(status.data!).objectlist
                        let recuit_company_OriginalCreatetime = UserDefaults.standard.string(forKey: RECRUIT_COMPANY_ORIGINALCREATETIME)
                        if recuit_company_OriginalCreatetime == nil {
                            recruit_company_updateNum = self.recuit_company_Array.count
                        }else{
                            
                            for (i,newsInfo) in self.recuit_company_Array.enumerated() {
                                if newsInfo.create_time == recuit_company_OriginalCreatetime {
                                    recruit_company_updateNum = i
                                    break
                                }
                            }
                        }
                        self.myTableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.setSubviews()
        
        // Do any additional setup after loading the view.
    }
    
    func initSubviews() {
        self.view.backgroundColor = COLOR

        myTableView.frame = CGRect(x: 0, y: -20, width: WIDTH, height: HEIGHT+20)
        //        myTableView.bounces = false
        myTableView.backgroundColor = RGREY
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(MineTableViewCell.self, forCellReuseIdentifier: "MineCell")
        myTableView.showsVerticalScrollIndicator = false
        myTableView.separatorStyle = .singleLine
        
        myTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData))
    }
    
    func setSubviews() {
        self.view.backgroundColor = COLOR
        
        myTableView.frame = CGRect(x: 0, y: -20, width: WIDTH, height: HEIGHT+20)
        //        myTableView.bounces = false
        myTableView.backgroundColor = RGREY
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(MineTableViewCell.self, forCellReuseIdentifier: "MineCell")
        myTableView.showsVerticalScrollIndicator = false
        self.view.addSubview(myTableView)
        myTableView.separatorStyle = .singleLine
        
        myTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData))
    }
    
    func loadData() {
        
        if !LOGIN_STATE {
            self.titImage.setBackgroundImage(UIImage.init(named: "img_head_nor"), for: .normal)

            self.userNameLabel.text = "我"
            self.levelBtn.setTitle("1", for: .normal)
            self.nurseCoins.setTitle("0", for: .normal)
            self.myTableView.reloadData()
            self.signLab.text = "Error"
            
            return
        }
        
        signBtn.isEnabled = false
        
        if myTableView.mj_header.isRefreshing() {
            myTableView.mj_header.endRefreshing()
        }
        
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud!.label.text = "正在获取个人信息"
        hud!.margin = 10.0
        hud!.removeFromSuperViewOnHide = true
        
        mineHelper.getPersonalInfo {(success, response) in
            if success {
                
                DispatchQueue.main.async(execute: {

                    if  !NurseUtil.net.isWifi() && loadPictureOnlyWiFi {
                        self.titImage.setImage(UIImage.init(named: "img_head_nor"), for: .normal)
                    }else{
                        self.titImage.sd_setBackgroundImage(with: URL(string: SHOW_IMAGE_HEADER+QCLoginUserInfo.currentInfo.avatar), for: .normal, placeholderImage: UIImage.init(named: "img_head_nor"))
                    }
                    self.userNameLabel.text = QCLoginUserInfo.currentInfo.userName.isEmpty ?"我":QCLoginUserInfo.currentInfo.userName
                    self.levelBtn.setTitle(QCLoginUserInfo.currentInfo.level, for: .normal)
//                    self.fansCountBtn.setTitle(self.followFansNum.fans_count, for: .normal)
//                    self.attentionBtn.setTitle(self.followFansNum.follows_count, for: .normal)
                    self.nurseCoins.setTitle(QCLoginUserInfo.currentInfo.money, for: .normal)
                    self.myTableView.reloadData()
                    //                self.hud!.hide(animated: true)
                    self.hud?.label.text = "正在获取签到状态"
                })
                self.zanAddNum()
            }else{
                DispatchQueue.main.async(execute: {
                    
                    self.hud?.mode = .text
                    self.hud?.label.text = "获取个人信息失败"
                    self.hud?.hide(animated: true, afterDelay: 1)
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
            
        ] as [String : Any];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                DispatchQueue.main.async(execute: {
                    self.hud?.mode = .text
                    self.hud?.label.text = "获取签到状态失败"
                    self.hud?.hide(animated: true, afterDelay: 1)
                    self.signLab.text = "Error"
                })
            }else{
                let status = Http(JSONDecoder(json!))
                
                DispatchQueue.main.async(execute: {
                    
                    self.signBtn.isEnabled = true
                    self.hud?.hide(animated: true)
                })
                
                // print("状态是")
                // print(status.status)
                if(status.status == "error"){
                    //                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    //                            hud.mode = MBProgressHUDMode.Text
                    ////                            hud.label.text = "HAHAHAAHAH"
                    //                            hud.margin = 10.0
                    //                            hud.removeFromSuperViewOnHide = true
                    //                            hud.hide(animated: true, afterDelay: 1)
                    self.isLike = false
                    DispatchQueue.main.async(execute: {
                        self.signLab.text = "每日签到"
                        //                        // print(status.errorData)
                    })
                }
                if(status.status == "success"){
                    
                    //                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    //                            hud.mode = MBProgressHUDMode.Text;
                    //                            hud.label.text = "签到成功"
                    //                            hud.margin = 10.0
                    //                            hud.removeFromSuperViewOnHide = true
                    //                            hud.hide(animated: true, afterDelay: 1)
                    self.isLike = true
                    DispatchQueue.main.async(execute: {
                        self.signLab.text = "已签到"
                    })
                }
                
                
            }
        }
    }
    
    // MARK:- TableView 代理
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return WIDTH*232/375+100
        }else{
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        }else if section == 5{
            return 1
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        var cell = tableView.dequeueReusableCell(withIdentifier: "MineCell_default")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "MineCell_default")
            
            cell!.selectionStyle = .none

            if indexPath.section == 0 && indexPath.row == 0 {
                // 创建渐变色图层
                let gradientLayer = CAGradientLayer.init()
                gradientLayer.frame = CGRect(x: 0, y: 0, width: WIDTH, height: WIDTH*232/375+100)
                gradientLayer.colors = [UIColor.init(red: 186/255.0, green: 125/255.0, blue: 126/255.0, alpha: 1).cgColor,UIColor.init(red: 140/255.0, green: 20/255.0, blue: 139/255.0, alpha: 1).cgColor]
                // 设置渐变方向（0-1）
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 0, y: 1)
                // 设置渐变色的起始位置和终止位置（颜色分割点）
                gradientLayer.locations = [ (0.15), (0.98)]
                gradientLayer.borderWidth = 0.0
                // 添加图层
                cell!.layer.addSublayer(gradientLayer)
                
                let person = UILabel()
                person.frame = CGRect(x: WIDTH*128/375, y: WIDTH*29/375, width: WIDTH*120/375, height: WIDTH*30/375)
                person.textColor = UIColor.white
                person.textAlignment = .center
                person.text = "个人中心"
                person.font = UIFont.systemFont(ofSize: 20)
                cell!.addSubview(person)
                
                let setBtn = UIButton()
                setBtn.frame = CGRect(x: WIDTH-50,y: WIDTH*29/375, width: 50, height: WIDTH*30/375)
                setBtn.setImage(UIImage(named: "ic_bg_set.png"), for: .normal)
                setBtn.addTarget(self, action: #selector(self.setUpData), for: .touchUpInside)
                cell!.addSubview(setBtn)
                
                titImage.frame = CGRect(x: WIDTH*128/375, y: WIDTH*69/375, width: WIDTH*120/375, height: WIDTH*120/375)
    
                titImage.addTarget(self, action: #selector(MineViewController.changeTitImage), for: .touchUpInside)
                titImage.layer.cornerRadius = WIDTH*120/375/2
                titImage.clipsToBounds = true
                titImage.layer.borderWidth = 3
                titImage.layer.borderColor = UIColor.white.cgColor
                cell!.addSubview(titImage)
                
                userNameLabel.frame = CGRect(x: WIDTH*160/375, y: WIDTH*200/375, width: WIDTH*55/375, height: 19)
                userNameLabel.textAlignment = .center
                userNameLabel.font = UIFont.systemFont(ofSize: 18)
                userNameLabel.textColor = UIColor.white
                cell!.addSubview(userNameLabel)
                
                levelBtn.setBackgroundImage(UIImage(named: "ic_shield_yellow.png"), for: .normal)
                levelBtn.setTitleColor(UIColor.yellow, for: .normal)
                levelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                cell!.addSubview(levelBtn)
                
                let signImg = UIImageView(frame: CGRect(x: WIDTH*137/375, y: WIDTH*200/375+40, width: WIDTH*22/375, height: WIDTH*22/375))
                signImg.image = UIImage(named: "ic_lalendar.png")
                cell!.addSubview(signImg)
                
                signLab.frame = CGRect(x: WIDTH*169/375, y: WIDTH*200/375+40,width: WIDTH*120/375, height: WIDTH*22/375)
                signLab.font = UIFont.systemFont(ofSize: 18)
                signLab.textColor = UIColor.yellow
                //                signLab.text = "请稍候"
                cell!.addSubview(signLab)
                
                signBtn.frame = CGRect(x: WIDTH*68/375, y: WIDTH*190/375+40, width: WIDTH*240/375, height: WIDTH*42/375)
                signBtn.layer.cornerRadius = WIDTH*42/375/2
                signBtn.layer.borderColor = UIColor.yellow.cgColor
                signBtn.layer.borderWidth = 2
                //                if self.isLike == false {
                signBtn.addTarget(self, action: #selector(MineViewController.signInToday), for: .touchUpInside)
                //                }
                cell!.addSubview(signBtn)
                
                for i in 0...2 {
                    if i == 0 {
                        fansCountBtn.frame = CGRect(x: WIDTH/3*CGFloat(i), y: WIDTH*232/375+50, width: WIDTH/3, height: 20)
                        fansCountBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                        cell!.addSubview(fansCountBtn)
                    }else if i == 1 {
                        attentionBtn.frame = CGRect(x: WIDTH/3*CGFloat(i), y: WIDTH*232/375+50, width: WIDTH/3, height: 20)
                        attentionBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                        cell!.addSubview(attentionBtn)
                    }else {
                        nurseCoins.frame = CGRect(x: WIDTH/3*CGFloat(i), y: WIDTH*232/375+50, width: WIDTH/3, height: 20)
                        nurseCoins.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                        cell!.addSubview(nurseCoins)
                    }
                    
                    let numName = UILabel(frame: CGRect(x: WIDTH/3*CGFloat(i), y: WIDTH*232/375+70, width: WIDTH/3, height: 20))
                    numName.textColor = UIColor(red: 250/255.0, green: 118/255.0, blue: 210/255.0, alpha: 1.0)
                    numName.textAlignment = .center
                    numName.font = UIFont.systemFont(ofSize: 12)
                    numName.text = numNameArr[i]
                    cell!.addSubview(numName)
                    let line = UILabel(frame: CGRect(x: WIDTH/3*CGFloat(i)-0.5, y: WIDTH*232/375+60, width: 0.5, height: 25))
                    line.backgroundColor = UIColor(red: 250/255.0, green: 118/255.0, blue: 210/255.0, alpha: 1.0)
                    cell!.addSubview(line)
                    let btn = UIButton(frame: CGRect(x: WIDTH/3*CGFloat(i), y: WIDTH*232/375+50, width: WIDTH/3, height: 50))
                    btn.addTarget(self, action: #selector(self.fineAndContact(_:)), for: .touchUpInside)
                    btn.tag = i+1
                    cell!.addSubview(btn)
                }
                
                
            }

        }
        
        if indexPath.section == 0 && indexPath.row == 0 {
            
            // TODO:JUDGE WIFI
            if  !NurseUtil.net.isWifi() && loadPictureOnlyWiFi {
//            if  !(NetworkReachabilityManager()?.isReachableOnEthernetOrWiFi)! && loadPictureOnlyWiFi {
                self.titImage.setImage(UIImage.init(named: "img_head_nor"), for: .normal)
            }else{
                self.titImage.sd_setImage(with: URL(string: SHOW_IMAGE_HEADER+QCLoginUserInfo.currentInfo.avatar), for: .normal, placeholderImage: UIImage.init(named: "img_head_nor"))
            }
            
            userNameLabel.text = QCLoginUserInfo.currentInfo.userName.isEmpty ?"我":QCLoginUserInfo.currentInfo.userName
            userNameLabel.sizeToFit()
            
            userNameLabel.frame = CGRect(x: WIDTH/2-userNameLabel.bounds.size.width/2, y: WIDTH*200/375, width: userNameLabel.bounds.size.width, height: userNameLabel.bounds.size.height)
            
            levelBtn.frame = CGRect(x: userNameLabel.bounds.size.width/2+5+WIDTH/2, y: WIDTH*200/375, width: 20, height: 19)
            levelBtn.setTitle(QCLoginUserInfo.currentInfo.level, for: .normal)
            
            for i in 0...2 {
                if i == 0 {
                    fansCountBtn.setTitle(followFansNum.fans_count, for: .normal)
                }else if i == 1 {
                    attentionBtn.setTitle(followFansNum.follows_count, for: .normal)
                }else {
                    nurseCoins.setTitle(QCLoginUserInfo.currentInfo.score, for: .normal)
                }
                
            }
            
            return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MineCell") as! MineTableViewCell
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            if indexPath.section == 1 {
                cell.titImage.setImage(UIImage(named: "ic_maozi.png"), for: .normal)
                cell.titLab.text = "我的学习"
                
                
            }else if indexPath.section == 2 {
                cell.titImage.setImage(UIImage(named: titImgArr[indexPath.row]), for: .normal)
                cell.titLab.text = titLabArr[indexPath.row]
                
                if indexPath.row == 0 {
                    if unreadNum > 0 {
                        cell.accessoryType = .none
                        
                        if unreadNum > 99 {
                            cell.numLab.text = "99+"
                        }else{
                            cell.numLab.text = String(unreadNum)
                        }
                        cell.numLab.adjustsFontSizeToFitWidth = true
                        cell.numLab.isHidden = false
                    }else{
                        cell.numLab.isHidden = true
                    }
                }
//                let line = UILabel(frame: CGRectMake(55, 59.5, WIDTH-55, 0.5))
//                line.backgroundColor = UIColor.grayColor()
//                
//                cell.addSubview(line)
//                if indexPath.row == 1 {
//                    line.removeFromSuperview()
//                }
            }else if indexPath.section == 3 {

                cell.titImage.setImage(UIImage(named: "ic_xie.png"), for: .normal)
                cell.titLab.text = "我的招聘"
                
                if QCLoginUserInfo.currentInfo.usertype == "1" {
                    
                    if recruit_user_updateNum > 0 {
                        cell.accessoryType = .none
                        
                        if recruit_user_updateNum > 99 {
                            cell.numLab.text = "99+"
                        }else{
                            cell.numLab.text = String(recruit_user_updateNum)
                        }
                        cell.numLab.adjustsFontSizeToFitWidth = true
                        cell.numLab.isHidden = false
                    }else{
                        cell.numLab.isHidden = true
                    }
                }else{
                    if recruit_company_updateNum > 0 {
                        cell.accessoryType = .none
                        
                        if recruit_company_updateNum > 99 {
                            cell.numLab.text = "99+"
                        }else{
                            cell.numLab.text = String(recruit_company_updateNum)
                        }
                        cell.numLab.adjustsFontSizeToFitWidth = true
                        cell.numLab.isHidden = false
                    }else{
                        cell.numLab.isHidden = true
                    }
                }

            }else if indexPath.section == 4{
                cell.titImage.setImage(UIImage(named: "ic_singal.png"), for: .normal)
                cell.titLab.text = "仅WiFi下载图片"
                
                let swi = UISwitch.init(frame: CGRect(x: WIDTH-51-10, y: 29/2.0, width: 51, height: 31))
                
                swi.isOn = UserDefaults.standard.bool(forKey: "loadPictureOnlyWiFi")
                swi.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
                cell.accessoryView = swi
                cell.accessoryType = .none
            }else if indexPath.section == 5 {
                cell.titImage.setImage(UIImage(named: "ic_xie.png"), for: .normal)
                cell.titLab.text = "清除缓存"
            }else if indexPath.section == 6 {
                cell.titImage.setImage(UIImage(named: "ic_bi"), for: .normal)
                cell.titLab.text = "意见反馈"
            }else {
                
                let signOutBtn = UIButton(type:.custom)
                signOutBtn.frame = CGRect(x: WIDTH/2-100, y: 10, width: 200, height: 40)
                if LOGIN_STATE {
                    signOutBtn.setTitle("退出登录", for: .normal)
                }else{
                    signOutBtn.setTitle("点击登录", for: .normal)
                }
                signOutBtn.setTitleColor(COLOR, for: .normal)
                signOutBtn.layer.cornerRadius = 20
                signOutBtn.layer.borderColor = COLOR.cgColor
                signOutBtn.layer.borderWidth = 1
                signOutBtn.addTarget(self, action: #selector(signout), for: .touchUpInside)
                cell.addSubview(signOutBtn)
                cell.accessoryType = .none
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(indexPath.row)
        if indexPath.section == 1 {
            
            if requiredLogin(self.navigationController, previousViewController: self, hiddenNavigationBar: false) {
                
            }else{
                return
            }
            
            let next = MineStudyViewController()
            self.navigationController?.pushViewController(next, animated: true)
            next.title = "我的学习"
        }else if indexPath.section == 2 {
            
            if requiredLogin(self.navigationController, previousViewController: self, hiddenNavigationBar: false) {
                
            }else{
                return
            }
            
            //            if indexPath.row == 0 {
            //                let next = MinePostViewController()
            //                self.navigationController?.pushViewController(next, animated: true)
            //                next.title = "我的贴子"
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
            
            if requiredLogin(self.navigationController, previousViewController: self, hiddenNavigationBar: false) {
                
            }else{
                return
            }
            
            if QCLoginUserInfo.currentInfo.usertype == "1" {
                
                recruit_user_updateNum = 0
                UserDefaults.standard.setValue(recuit_user_Array.first?.create_time, forKey: RECRUIT_USER_ORIGINALCREATETIME)

                
                let next = MineRecruit_userViewController()
                self.navigationController?.pushViewController(next, animated: true)
                next.title = "我的招聘"
            }else{
                recruit_company_updateNum = 0
                recruit_company_alreadyRead = true
                UserDefaults.standard.setValue(recuit_company_Array.first?.create_time, forKey: RECRUIT_COMPANY_ORIGINALCREATETIME)
                
                let next = MineRecruitViewController()
                self.navigationController?.pushViewController(next, animated: true)
                next.title = "我的招聘"
            }
        }else if indexPath.section == 5 {
            clearDisk()
        }else if indexPath.section == 6 {
            
            if requiredLogin(self.navigationController, previousViewController: self, hiddenNavigationBar: false) {
                
            }else{
                return
            }
            self.navigationController?.pushViewController(MiFeedbackListViewController(), animated: true)

        }
    }
    // MARK:-
    
    func clearDisk() {
        
        // 图片缓存大小
        let imageCacheSize = Double(SDImageCache.shared().getSize())/1000.0/1000.0
        let imageCache = String(format: "%.2f", imageCacheSize)
        
        // 网页缓存大小
        let webCacheSize = Double(URLCache.shared.currentDiskUsage)/1000.0/1000.0
        let webCache = String(format: "%.2f", webCacheSize)
        
        // 其他缓存大小
        let manager = FileManager.default
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last
        
        let files = try?manager.subpathsOfDirectory(atPath: cachePath!)
        
        var totalSize:Double = 0
        
        for filePath in files! {
            let path = (cachePath)! + filePath
            // 判断是否为文件
            var isDir:ObjCBool = false
            manager.fileExists(atPath: path, isDirectory: &isDir)
            if !isDir.boolValue {
                do {
                    let attrs = try manager.attributesOfItem(atPath: path)
                    totalSize += Double(attrs[FileAttributeKey.size]! as! NSNumber)
                }catch {
                    
                }
            }
        }
        let otherCacheSize = totalSize
        let otherCache = String(format: "%.2f", webCacheSize/1000.0/1000.0)
        
        // alertController
        let alert = UIAlertController(title: "请选择要清除的缓存类型", message: "图片缓存：\(imageCache)MB\n网页缓存: \(webCache)MB\n其他缓存：\(otherCache)MB", preferredStyle: .actionSheet)
        self.present(alert, animated: true, completion: nil)
        
        // 清理图片缓存
        let pictureAction = UIAlertAction(title: "图片缓存", style: .default) { (sureAction) in
            
            let alert = UIAlertController(title: "确认清除图片缓存？", message: "", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            
            let sureAction = UIAlertAction(title: "确认", style: .default) { (sureAction) in
                
                SDImageCache.shared().clearMemory()
                SDImageCache.shared().clearDisk(onCompletion: {
                    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hud.mode = MBProgressHUDMode.text
                    hud.label.text = "清除图片缓存成功"
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(animated: true, afterDelay: 1)
                })
            }
            alert.addAction(sureAction)
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
        }
        alert.addAction(pictureAction)
        
        // 清理网页缓存
        let webAction = UIAlertAction(title: "网页缓存", style: .default) { (sureAction) in
            
            let alert = UIAlertController(title: "确认清除网页缓存？", message: "", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            
            let sureAction = UIAlertAction(title: "确认", style: .default) { (sureAction) in
                
                URLCache.shared.removeAllCachedResponses()
                
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.mode = MBProgressHUDMode.text
                hud.label.text = "清除网页缓存成功"
                hud.margin = 10.0
                hud.removeFromSuperViewOnHide = true
                hud.hide(animated: true, afterDelay: 1)
            }
            alert.addAction(sureAction)
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
        }
        alert.addAction(webAction)
        
        // 清理其他缓存
        let otherAction = UIAlertAction(title: "其他缓存", style: .default) { (sureAction) in
            
            let alert = UIAlertController(title: "确认清除其他缓存？", message: "", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            
            let sureAction = UIAlertAction(title: "确认", style: .default) { (sureAction) in
                
                for filePath in files! {
                    let path = (cachePath)! + filePath
                    // 判断是否为文件
                    var isDir:ObjCBool = false
                    manager.fileExists(atPath: path, isDirectory: &isDir)
                    if !isDir.boolValue {
                        do {
                            try manager.removeItem(atPath: path)
                            let attrs = try?manager.attributesOfItem(atPath: path)
                            totalSize -= Double(attrs![FileAttributeKey.size]! as! NSNumber)
                        } catch  {
                            // deal with not exist
                        }
                    }
                }
                
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.mode = MBProgressHUDMode.text
                hud.label.text = "清除其他缓存成功"
                hud.detailsLabel.text = "清理了\(otherCacheSize-totalSize)MB 缓存"
                hud.margin = 10.0
                hud.removeFromSuperViewOnHide = true
                hud.hide(animated: true, afterDelay: 1)
            }
            alert.addAction(sureAction)
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
        }
        alert.addAction(otherAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
    }
    
    // MARK: switch valueChanged
    func switchValueChanged(_ swi:UISwitch) {
        UserDefaults.standard.set(swi.isOn, forKey: "loadPictureOnlyWiFi")
        loadPictureOnlyWiFi = swi.isOn
        // print("switch value changed , and swi.on = \(swi.on)")
    }
    
    // MARK: 点击头像
    func changeTitImage() {
        // print("头像")
        
        if requiredLogin(self.navigationController, previousViewController: self, hiddenNavigationBar: false) {
            
        }else{
            return
        }
        
        setUpData()
    }
    // MARK: 个人资料编辑
    func setUpData() {
        // print("设置")
        
        if requiredLogin(self.navigationController, previousViewController: self, hiddenNavigationBar: false) {
            
        }else{
            return
        }
        
        let next = SetDataViewController()
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    // MARK: 粉丝与关注
    func fineAndContact(_ btn:UIButton) {
        // print("粉丝与管理")
        
        if requiredLogin(self.navigationController, previousViewController: self, hiddenNavigationBar: false) {
            
        }else{
            return
        }
        
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
            //            hud.label.text = "敬请期待"
            //            hud.margin = 10.0
            //            hud.removeFromSuperViewOnHide = true
            //            hud.hide(animated: true, afterDelay: 1)
            let next = ScoreViewController()
            self.navigationController?.pushViewController(next, animated: true)
        }
    }
    
    // MARK: 点击签到
    func signInToday() {
        // print("点击签到")
        
        if requiredLogin(self.navigationController, previousViewController: self, hiddenNavigationBar: false) {
            
        }else{
            return
        }
        
        if isLike == false {
            self.timeNow()
            
            self.zan()
        }else{
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = MBProgressHUDMode.text
            hud.label.text = "已经签过了哦~"
            hud.margin = 10.0
            hud.removeFromSuperViewOnHide = true
            hud.hide(animated: true, afterDelay: 1)
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
        ] as [String : Any];
        // print(QCLoginUserInfo.currentInfo.userid)
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                
            }else{
                let status = addScore_ReadingInformationModel(JSONDecoder(json!))
                // print("状态是")
                // print(status.status)
                if(status.status == "error"){
                    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hud.mode = MBProgressHUDMode.text
                    hud.label.text = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(animated: true, afterDelay: 1)
                    
                }
                if(status.status == "success"){
                    
//                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                    hud.mode = MBProgressHUDMode.Text;
//                    hud.label.text = "签到成功"
//                    hud.margin = 10.0
//                    hud.removeFromSuperViewOnHide = true
//                    hud.hide(animated: true, afterDelay: 1)
                    
                    if (status.data?.event)! != "" && (status.data?.score)! != "" {
                        
                        NursePublicAction.showScoreTips(self.view, nameString: (status.data?.event)!, score: (status.data?.score)!)
                    }
                    
                    self.isLike = true
                    
                    DispatchQueue.main.async(execute: {
                        self.signLab.text = "已签到"
                    })
                    
                    
                    
                }
            }
        }
    }
    
    // MARK: 点击退出
    func signout(){
        // print("退出")
        
        if requiredLogin(self.navigationController, previousViewController: self, hiddenNavigationBar: false) {
            
        }else{
            return
        }
        
        let alert = UIAlertController(title: "确认退出", message: "您确定要退出登录吗？", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        let sureAction = UIAlertAction(title: "确认", style: .default) { (sureAction) in
            let myTab  = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
            myTab.selectedIndex = 0
            LOGIN_STATE = false
            canLookTel = false
            myInviteFriendUrl = APP_INVITEFRIEND_URL+QCLoginUserInfo.currentInfo.userid
            UserDefaults.standard.removeObject(forKey: LOGINFO_KEY)
        }
        alert.addAction(sureAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
    }
    
    func timeNow(){
        //获取当前时间
        let now = Date()
        
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日"
        // print("当前日期时间：\(dformatter.stringFromDate(now))")
        let today = dformatter.date(from: dformatter.string(from: now))
        
        
        //当前时间的时间戳
        let timeInterval:TimeInterval = today!.timeIntervalSince1970
        //        let double = (timeInterval as NSString).doubleValue
        
        //        self.timeStamp = Int(timeInterval/100)
        self.timeStamp = Int(timeInterval)
        
        // print("当前时间的时间戳：\(Int(timeInterval))")
        
    }
}
