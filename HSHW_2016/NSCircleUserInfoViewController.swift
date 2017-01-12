//
//  NSCircleUserInfoViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/26.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class NSCircleUserInfoViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
    
    var rootTableView = UITableView()
    
    var headerView:UIImageView = UIImageView()//头像
    var nameLabel:UILabel = UILabel()//用户名
    var leavel:UIButton = UIButton()//等级
    var authTypeStr = ""
    var noteLab:UILabel = UILabel()//简介
    var focusBtn:UIButton = UIButton()//关注按钮
    
    var userid:String = ""
    
    var helper = HSMineHelper()
    
    var userInfo:HSFansAndFollowModel?
    
    var forumModelArray = [ForumListDataModel]()

    var communityModelArray = [CommunityListDataModel]()
    
    var followFansNum = FollowFansNumDataModel()

    var followFlag = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setSubviews()
        
    }
    
    // MARK: - 加载数据
    func loadData() {
        
        var flag = 0
        let total = 6
        
        // 获取个人信息
        helper.getUserInfo(userid) { (success, response) in
            self.userInfo = (response as! HSFansAndFollowModel)
            DispatchQueue.main.async(execute: {
                self.title = self.userInfo?.name
                self.setTableHeaderView()
                self.rootTableView.reloadData()

            })
            
            flag += 1
            
            if flag == total {
                self.rootTableView.mj_header.endRefreshing()
            }
            
        }
        
        // 获取个人认证状态
        CircleNetUtil.getPersonAuth(userid: userid) { (success, response) in
            if success {
                self.authTypeStr = (response as! PersonAuthDataModel).auth_type
                self.setTableHeaderView()
                self.rootTableView.reloadData()

            }
            
            flag += 1
            
            if flag == total {
                self.rootTableView.mj_header.endRefreshing()
            }
        }
        
        // 获取我加入的圈子
        CircleNetUtil.getMyCommunityList(userid: userid, pager: "") { (success, response) in
            if success {
                self.communityModelArray = response as! [CommunityListDataModel]
                self.setTableHeaderView()
                self.rootTableView.reloadData()

            }
            
            flag += 1
            
            if flag == total {
                self.rootTableView.mj_header.endRefreshing()
            }
        }
        
        // 获取发布的贴子
        CircleNetUtil.getMyForumList(userid: userid, cid: "", isbest: "", istop: "", pager: "1") { (success, response) in
            if success {
                self.pager = 2
                self.rootTableView.mj_footer.resetNoMoreData()
                
                self.forumModelArray = response as! [ForumListDataModel]
                self.rootTableView.reloadData()
            }
            
            flag += 1
            
            if flag == total {
                self.rootTableView.mj_header.endRefreshing()
            }
        }

        // 获取关注粉丝数
        CircleNetUtil.getFollowFans_num(userid: userid) { (success, response) in
            if success {
                self.followFansNum = response as! FollowFansNumDataModel
                self.setTableHeaderView()
                self.rootTableView.reloadData()
            }
            flag += 1
            
            if flag == total {
                self.rootTableView.mj_header.endRefreshing()
            }
        }
        
        // 判断是否已关注
        CircleNetUtil.judgeFollowFans(follow_id: userid, fans_id: QCLoginUserInfo.currentInfo.userid) { (success, response) in
            if success {
                self.followFlag =  response as! String
                self.setTableHeaderView()
                self.rootTableView.reloadData()
            }
            flag += 1
            
            if flag == total {
                self.rootTableView.mj_header.endRefreshing()
            }
        }
        
    }
    
    // MARK: - 加载数据（上拉加载）
    var pager = 1
    func loadData_pullUp() {
        
        CircleNetUtil.getMyForumList(userid: userid, cid: "", isbest: "", istop: "", pager: String(pager)) { (success, response) in
            if success {
                self.pager += 1
                
                let forumModelArray = response as! [ForumListDataModel]
                
                if forumModelArray.count == 0 {
                    self.rootTableView.mj_footer.endRefreshingWithNoMoreData()
                }else{
                    
                    self.rootTableView.mj_footer.endRefreshing()
                    for forumListData in forumModelArray {
                        self.forumModelArray.append(forumListData)
                    }
                    self.rootTableView.reloadData()
                    
                }
            }else{
                
                self.rootTableView.mj_footer.endRefreshing()
            }
        }
        
    }
    
    // MARK: - 设置子视图
    func setSubviews() {
        self.automaticallyAdjustsScrollViewInsets = false
        
//        let shareBtn:UIButton = UIButton.init(frame: CGRect(x: 0, y: 7, width: 30, height: 30))
//        shareBtn.setImage(UIImage.init(named: "ic_fenxiang"), for: UIControlState())
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: shareBtn)
        
        // 主 tableView
        rootTableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT-64), style: .grouped)
        rootTableView.register(UINib(nibName: "HSComTableCell",bundle: nil), forCellReuseIdentifier: "cell")
        rootTableView.separatorStyle = .none
        rootTableView.delegate = self
        rootTableView.dataSource = self
        self.view.addSubview(rootTableView)
        
        rootTableView.register(NSCircleDetailTableViewCell.self, forCellReuseIdentifier: "circleDetailCell")
        
        rootTableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadData))
        rootTableView.mj_header.beginRefreshing()
        
        rootTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadData_pullUp))

    }
    
    // MARK: - 设置 tableView HeaderView
    func setTableHeaderView() {
        if self.userInfo != nil {
            
            let bgView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 0))
//            bgView.backgroundColor = UIColor.cyan
            
            let bgImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 0))
            bgImageView.isUserInteractionEnabled = true
            bgView.addSubview(bgImageView)
            
            // 创建渐变色图层
            let gradientLayer = CAGradientLayer.init()
            gradientLayer.frame = CGRect(x: 0, y: 0, width: WIDTH, height: 0)
            gradientLayer.colors = [UIColor.init(red: 186/255.0, green: 125/255.0, blue: 126/255.0, alpha: 1).cgColor,UIColor.init(red: 140/255.0, green: 20/255.0, blue: 139/255.0, alpha: 1).cgColor]
            // 设置渐变方向（0-1）
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            // 设置渐变色的起始位置和终止位置（颜色分割点）
            gradientLayer.locations = [ (0.15), (0.98)]
            gradientLayer.borderWidth = 0.0
            // 添加图层
            bgImageView.layer.addSublayer(gradientLayer)
            
            // 头像
            headerView = UIImageView.init(frame: CGRect(x: WIDTH/2.0-50, y: 20, width: 100, height: 100))
            headerView.backgroundColor = UIColor.cyan
            let str = SHOW_IMAGE_HEADER+(userInfo?.photo)!
            
            if  !NurseUtil.net.isWifi() && loadPictureOnlyWiFi {
                headerView.image = UIImage.init(named: "defaultImage.png")
            }else{
                headerView.sd_setImage(with: URL.init(string: str), placeholderImage: UIImage.init(named: "defaultImage.png"))
            }
            //                headerView.sd_setImageWithURL(NSURL.init(string: str))
            headerView.layer.cornerRadius = 50
            headerView.clipsToBounds = true
            headerView.layer.borderWidth = 3
            headerView.layer.borderColor = UIColor.white.cgColor
            print(str)
            
            bgImageView.addSubview(headerView)
            
            // 用户名
            nameLabel = UILabel.init(frame: CGRect(x: self.view.center.x, y: headerView.frame.maxY+20, width: 100, height: 30))
            nameLabel.textColor = UIColor.white
            nameLabel.text = userInfo!.name
            nameLabel.sizeToFit()
            nameLabel.frame = CGRect(x: (WIDTH-nameLabel.frame.size.width)/2.0-10, y: nameLabel.frame.origin.y, width: nameLabel.frame.size.width, height: nameLabel.frame.size.height)
            bgImageView.addSubview(nameLabel)
            
            // 性别
            let sexImg = UIImageView(frame: CGRect(x: nameLabel.frame.maxX+5, y: 0, width: 0, height: 0))

            if userInfo?.sex == "0" {
                sexImg.image = UIImage(named: "性别女")
                sexImg.frame.size = (UIImage(named: "性别女")?.size ?? CGSize())!
                sexImg.center.y = nameLabel.center.y
            }else if userInfo?.sex == "1"{
                sexImg.image = UIImage(named: "性别男")
                sexImg.frame.size = (UIImage(named: "性别男")?.size ?? CGSize())!
                sexImg.center.y = nameLabel.center.y
            }
            bgImageView.addSubview(sexImg)

            // 等级
            let leavel = UIButton.init(frame: CGRect(x: sexImg.frame.maxX+5, y: nameLabel.frame.minY, width: 18, height: 20))
            leavel.setBackgroundImage(UIImage.init(named: "ic_shield_yellow.png"), for: UIControlState())
            leavel.titleLabel?.font = UIFont.systemFont(ofSize: 9)
            leavel.setTitleColor(UIColor.yellow, for: UIControlState())
            leavel.setTitle(userInfo?.level, for: UIControlState())
            bgImageView.addSubview(leavel)
            
            // 认证类型
            let authType = UILabel(frame: CGRect(x: leavel.frame.maxX+5, y: nameLabel.frame.minY, width: calculateWidth(authTypeStr, size: 8, height: nameLabel.frame.height)+UIFont.systemFont(ofSize: 8).lineHeight, height: UIFont.systemFont(ofSize: 8).lineHeight))
            authType.layer.cornerRadius = UIFont.systemFont(ofSize: 8).lineHeight/2.0
            authType.layer.backgroundColor = COLOR.cgColor
            authType.font = UIFont.systemFont(ofSize: 8)
            authType.textAlignment = .center
            authType.textColor = UIColor.white
            authType.center.y = nameLabel.center.y
            if authTypeStr == "" {
                authType.removeFromSuperview()
            }else{
                authType.text = authTypeStr
                authType.layer.backgroundColor = NSCirclePublicAction.getAuthColor(with: authTypeStr).cgColor

//                authType.backgroundColor = NSCirclePublicAction.getAuthColor(with: authTypeStr)
                bgImageView.addSubview(authType)
            }
            
            // 关注 粉丝
            noteLab = UILabel.init(frame: CGRect(x: 0, y: leavel.frame.maxY+15, width: WIDTH, height: UIFont.systemFont(ofSize: 12).lineHeight))
            noteLab.font = UIFont.systemFont(ofSize: 12)
            noteLab.textAlignment = NSTextAlignment.center
            noteLab.textColor = UIColor.init(red: 248/255.0, green: 122/255.0, blue: 215/255.0, alpha: 1)
            noteLab.text = "关注：\(followFansNum.follows_count)    粉丝：\(followFansNum.fans_count)"
            bgImageView.addSubview(noteLab)
            
            // 关注按钮
            focusBtn = UIButton.init(frame: CGRect(x: WIDTH/4.0, y: noteLab.frame.maxY+20, width: WIDTH/2.0, height: 50))
//            focusBtn.layer.borderWidth = 1
//            focusBtn.layer.borderColor = UIColor.white.cgColor
            focusBtn.layer.cornerRadius = 25
            focusBtn.layer.backgroundColor = UIColor(white: 0.25, alpha: 0.25).cgColor
            focusBtn.setImage(UIImage(named: "关注"), for: .normal)
            focusBtn.setImage(UIImage(named: "已加入"), for: .selected)
            focusBtn.setTitleColor(UIColor.white, for: UIControlState())
            focusBtn.setTitle("关注Ta", for: .normal)
            focusBtn.setTitle("已关注", for: .selected)
            if followFlag == "1" {
                focusBtn.isSelected = true
            }else{
                focusBtn.isSelected = false
            }
            focusBtn.addTarget(self, action: #selector(followBtnClick(_:)), for: .touchUpInside)
            bgImageView.addSubview(focusBtn)
            
            bgImageView.frame = CGRect(x: 0, y: 0, width: WIDTH, height: focusBtn.frame.maxY+20)
            gradientLayer.frame = CGRect(x: 0, y: 0, width: WIDTH, height: focusBtn.frame.maxY+20)
            
            
            if communityModelArray.count > 0 {
                
                // 他加入的圈子
                let recommendBgView = UIView(frame: CGRect(x: 0, y: bgImageView.frame.maxY, width: WIDTH, height: 35+8))
                recommendBgView.backgroundColor = UIColor.white
                bgView.addSubview(recommendBgView)
                
                let recommendLab = UILabel(frame: CGRect(x: 8, y: 0, width: WIDTH-16, height: 35))
                recommendLab.backgroundColor = UIColor.white
                recommendLab.textAlignment = .left
                recommendLab.font = UIFont.systemFont(ofSize: 16)
                recommendLab.textColor = UIColor.lightGray
                recommendLab.text = "他加入的圈子"
                recommendBgView.addSubview(recommendLab)
                
                let line = UIView(frame: CGRect(x: 8, y: recommendBgView.frame.height-8, width: WIDTH-16, height: 1/UIScreen.main.scale))
                line.backgroundColor = UIColor.lightGray
                recommendBgView.addSubview(line)
                
                // 他加入的圈子
                let btn2ScrollView = UIScrollView(frame: CGRect(x: 0, y: recommendBgView.frame.maxY, width: WIDTH, height: 0))
                btn2ScrollView.backgroundColor = UIColor.white
                btn2ScrollView.showsVerticalScrollIndicator = false
                btn2ScrollView.showsHorizontalScrollIndicator = false
                bgView.addSubview(btn2ScrollView)
                
                let btn2Width = WIDTH/375*108
                var btn2Height:CGFloat = 0
                
                for (i,communityModel) in communityModelArray.enumerated() {
                    let btn2 = UIView(frame: CGRect(x: 8+(btn2Width+8)*CGFloat(i), y: 0, width: btn2Width, height: 0))
                    
                    btn2ScrollView.addSubview(btn2)
                    
//                    let imgBgView = UIView(frame: CGRect(x: 0, y: 0, width: btn2Width, height: WIDTH/375*72))
//                    imgBgView.backgroundColor = UIColor(red: 243/255.0, green: 229/255.0, blue: 240/255.0, alpha: 1)
//                    btn2.addSubview(imgBgView)
                    
                    let img = UIImageView(frame: CGRect(x: 0, y: 0, width: btn2Width, height: WIDTH/375*72))
                    //            img.backgroundColor = UIColor(red: 243/255.0, green: 229/255.0, blue: 240/255.0, alpha: 1)
                    img.isUserInteractionEnabled = true
                    img.contentMode = .scaleAspectFit
                    img.sd_setImage(with: URL(string: SHOW_IMAGE_HEADER+communityModel.photo), placeholderImage: nil)
                    btn2.addSubview(img)
                    
//                    let img = UIImageView(frame: CGRect(x: 0, y: 0, width: btn2Width, height: WIDTH/375*72))
//                    img.backgroundColor = UIColor(red: 243/255.0, green: 229/255.0, blue: 240/255.0, alpha: 1)
//                    img.contentMode = .center
//                    img.sd_setImage(with: URL(string: SHOW_IMAGE_HEADER+communityModel.photo), placeholderImage: nil)
//                    btn2.addSubview(img)
                    
                    let nameLab = UILabel(frame: CGRect(x: 0, y: img.frame.maxY, width: btn2Width, height: WIDTH/375*22))
                    nameLab.textAlignment = .left
                    nameLab.font = UIFont.systemFont(ofSize: 14)
                    nameLab.textColor = COLOR
                    nameLab.text = communityModel.community_name
                    nameLab.adjustsFontSizeToFitWidth = true
                    btn2.addSubview(nameLab)
                    
                    btn2.frame.size.height = nameLab.frame.maxY+8
                    
                    let btn3 = UIButton(frame: CGRect(x: 0, y: 0, width: btn2.frame.size.width, height: btn2.frame.size.height))
                    btn3.tag = 200+i
                    
                    btn3.addTarget(self, action: #selector(btn2Click(_:)), for: .touchUpInside)
                    btn2.addSubview(btn3)
                    
                    btn2Height = btn2.frame.size.height
                    
                    btn2ScrollView.frame.size.height = btn2.frame.size.height
                    
                }
                
                btn2ScrollView.contentSize = CGSize(width: 8+(btn2Width+8)*CGFloat(communityModelArray.count), height: 0)
                
                let tagBgView = UIView.init(frame: CGRect(x: 0, y: recommendBgView.frame.maxY+btn2Height+8, width: WIDTH, height: 40))
                tagBgView.backgroundColor = UIColor.white
                bgView.addSubview(tagBgView)

                let label = UILabel.init(frame: CGRect(x: 10, y: 10, width: WIDTH-20, height: 28))
                //        label.textColor = UIColor.init(red: 145/255.0, green: 0, blue: 105/255.0, alpha: 1)
                label.textColor = UIColor.lightGray
                label.font = UIFont.systemFont(ofSize: 14)
                label.text = "他/她的贴子"
                tagBgView.addSubview(label)
                
                let lineView = UIView.init(frame: CGRect(x: 10, y: label.frame.maxY, width: label.frame.width, height: 1/UIScreen.main.scale))
                lineView.backgroundColor = UIColor.lightGray
                tagBgView.addSubview(lineView)
                
                bgView.frame.size.height = tagBgView.frame.maxY
                
            }else{
                
                let tagBgView = UIView.init(frame: CGRect(x: 0, y: bgImageView.frame.maxY, width: WIDTH, height: 40))
                tagBgView.backgroundColor = UIColor.white
                bgView.addSubview(tagBgView)
                
                let label = UILabel.init(frame: CGRect(x: 10, y: 10, width: WIDTH-20, height: 28))
                //        label.textColor = UIColor.init(red: 145/255.0, green: 0, blue: 105/255.0, alpha: 1)
                label.textColor = UIColor.lightGray
                label.font = UIFont.systemFont(ofSize: 14)
                label.text = "他/她的贴子"
                tagBgView.addSubview(label)
                
                let lineView = UIView.init(frame: CGRect(x: 10, y: label.frame.maxY, width: label.frame.width, height: 1/UIScreen.main.scale))
                lineView.backgroundColor = UIColor.lightGray
                tagBgView.addSubview(lineView)
                
                bgView.frame.size.height = tagBgView.frame.maxY

            }
            self.rootTableView.tableHeaderView = bgView
            
        }
        
    }
    
    // MARK: - btn2 点击事件
    func btn2Click(_ btn2:UIButton) {
        
        print("点击热门圈子推荐 之 \(btn2.tag-200)")
        
        let circleDetailController = NSCircleDetailViewController()
        circleDetailController.communityModel = communityModelArray[btn2.tag-200]
        circleDetailController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(circleDetailController, animated: true)
        
    }
    
    // MARK: - 关注按钮 点击事件
    func followBtnClick(_ followBtn:UIButton) {
        
        if requiredLogin(self.navigationController, previousViewController: self, hiddenNavigationBar: false) {
            
        }else{
            return
        }
        
        if userid == QCLoginUserInfo.currentInfo.userid {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.removeFromSuperViewOnHide = true
            hud.mode = .text
            hud.label.text = "不能关注自己哦~"
            hud.hide(animated: true, afterDelay: 1)
            return
        }
        
        if followBtn.isSelected {
            
            let alert = UIAlertView.init(title: "取消关注？", message: "确定要取消关注 \((self.userInfo?.name)!) 吗？", delegate: self, cancelButtonTitle: "不再关注", otherButtonTitles: "点错了")
            alert.tag = 4000
            alert.show()
        }else{
            CircleNetUtil.addfollow_fans(follow_id: userid, fans_id: QCLoginUserInfo.currentInfo.userid, handle: { (success, response) in
                if success {
                    DispatchQueue.main.async(execute: {
                        
                        let alert = UIAlertView.init(title: "关注成功", message: "成功关注 \((self.userInfo?.name)!)", delegate: nil, cancelButtonTitle: "确定")
                        self.followFlag = "1"
                        self.followFansNum.fans_count = String(NSString(string: self.followFansNum.fans_count).integerValue+1)
                        self.setTableHeaderView()
                        
                        let result = response as! Follow_fansDataModel
                        
                        if result.event != "" {
                            NursePublicAction.showScoreTips(self.view, nameString: result.event, score: result.score)
                        }else{
                            alert.show()
                        }

                    })
                }else{
                    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hud.removeFromSuperViewOnHide = true
                    hud.mode = .text
                    hud.label.text = "关注失败"
                    hud.hide(animated: true, afterDelay: 1)
                }
            })
        }
    }
    
    // MARK: - alertView delegate
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if alertView.tag == 4000 {
            
            if buttonIndex == 0 {
                
                CircleNetUtil.delFollow_fans(follow_id: userid, fans_id: QCLoginUserInfo.currentInfo.userid, handle: { (success, response) in
                    if success {
                        DispatchQueue.main.async(execute: {
                            //                        print("--===   ",success)
                            let alert = UIAlertView.init(title: "已成功取消关注", message: "已成功取消关注 \((self.userInfo?.name)!)", delegate: nil, cancelButtonTitle: "确定")
                            alert.show()
                            self.followFlag = "0"
                            self.followFansNum.fans_count = String(NSString(string: self.followFansNum.fans_count).integerValue-1)
                            self.setTableHeaderView()
                        })
                    }else{
                        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                        hud.removeFromSuperViewOnHide = true
                        hud.mode = .text
                        hud.label.text = "取消关注失败"
                        hud.hide(animated: true, afterDelay: 1)
                    }
                })
                
            }
            print("点击了 \(buttonIndex)")
        }
    }
    
    // MARK: - moreBtnClick
    fileprivate var currentForumModel = ForumListDataModel()
    func moreBtnClick(_ moreBtn:UIButton) {
        print(moreBtn.tag)
                
        currentForumModel = self.forumModelArray[moreBtn.tag-100]
        
        var labelTextArray = [String]()
        var labelTextColorArray = [UIColor]()
        
        CircleNetUtil.judge_apply_community(userid: QCLoginUserInfo.currentInfo.userid, cid: forumModelArray[moreBtn.tag-100].id) { (success, response) in
            if success {
                if (response as! String) == "yes" {

                    labelTextArray = ["加精","置顶","删除","取消"]
                    labelTextColorArray = [COLOR,COLOR,UIColor.black,UIColor.lightGray]
                    
                }else{
                    if QCLoginUserInfo.currentInfo.userid == self.forumModelArray[moreBtn.tag-100].userid {
                        labelTextArray = ["删除","取消"]
                        labelTextColorArray = [UIColor.black,UIColor.lightGray]
                    }else{
                        labelTextArray = ["举报","取消"]
                        labelTextColorArray = [UIColor.black,UIColor.lightGray]
                    }
                }
                self.showSheet(with: labelTextArray, buttonTitleColorArray: labelTextColorArray, forumId: self.forumModelArray[moreBtn.tag-100].id)
            }
        }
        
//        NSCirclePublicAction.showSheet(with: labelTextArray, buttonTitleColorArray: labelTextColorArray)
        
    }
    
    // MARK: tableView 代理方法
    func numberOfSections(in tableView: UITableView) -> Int {
        return forumModelArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "circleDetailCell", for: indexPath) as! NSCircleDetailTableViewCell
        
        cell.selectionStyle = .none
        
        cell.setCellWith(forumModelArray[indexPath.section])
        
        cell.moreBtn.tag = 100+indexPath.row
        cell.moreBtn.addTarget(self, action: #selector(moreBtnClick(_:)), for: .touchUpInside)
        
        return cell
    }
    
    // MARK: uitableview delegate
    fileprivate let titleSize:CGFloat = 17
    fileprivate let contentSize:CGFloat = 14
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let forum = forumModelArray[indexPath.section]
        
        if forum.photo.count == 0 {
            
            let height = calculateHeight((forum.title), size: titleSize, width: WIDTH-16)
            
            
            var contentHeight = calculateHeight((forum.content), size: contentSize, width: WIDTH-16)
            if contentHeight >= UIFont.systemFont(ofSize: contentSize).lineHeight*3 {
                contentHeight = UIFont.systemFont(ofSize: contentSize).lineHeight*2
            }
            
            return 55+8+height+8+contentHeight+8+8+8+5// 个人信息高+上边距+标题高+间距+内容高+间距+点赞评论按钮高+下边距
        }else if forum.photo.count < 3 {
            let height = calculateHeight((forum.title), size: titleSize, width: WIDTH-16-110-8)
            
            
            var contentHeight = calculateHeight((forum.content), size: contentSize, width: WIDTH-16-110-8)
            if contentHeight >= UIFont.systemFont(ofSize: contentSize).lineHeight*3 {
                contentHeight = UIFont.systemFont(ofSize: contentSize).lineHeight*2
            }
            
            let cellHeight1:CGFloat = 80+8+8+8// 上边距+图片高+下边距
            let cellHeight2 = 8+height+8+contentHeight+8+8+8// 上边距+标题高+间距+内容高+间距+点赞评论按钮高+下边距
            
            
            return max(cellHeight1, cellHeight2)+55+5
        }else{
            let height = calculateHeight((forum.title), size: titleSize, width: WIDTH-16)
            
            
            var contentHeight = calculateHeight((forum.content), size: contentSize, width: WIDTH-16)
            if contentHeight >= UIFont.systemFont(ofSize: contentSize).lineHeight*3 {
                contentHeight = UIFont.systemFont(ofSize: contentSize).lineHeight*2
            }
            
            let imgHeight = (WIDTH-16-15*2)/3.0*2/3.0
            
            return 55+8+height+8+contentHeight+8+imgHeight+8+8+8+5// 个人信息高+上边距+标题高+间距+内容高+间距+图片高+间距+点赞评论按钮高+下边距
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0001
        }
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if forumModelArray.count != 0 {
            
            let footerView = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 40))
            footerView.tag = 100 + section
            footerView.addTarget(self, action: #selector(footerViewClick(footerBtn:)), for: .touchUpInside)
            footerView.backgroundColor = UIColor.white
            
            let img = UIImageView(frame: CGRect(x: 8, y: 8, width: 25, height: 24))
            img.sd_setImage(with: URL(string: SHOW_IMAGE_HEADER+forumModelArray[section].community_photo), placeholderImage: nil)
            img.contentMode = .scaleAspectFit
            img.clipsToBounds = true
            footerView.addSubview(img)
            
            let nameBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
            nameBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            nameBtn.setTitleColor(COLOR, for: UIControlState())
            nameBtn.setTitle(forumModelArray[section].community_name, for: UIControlState())
            nameBtn.sizeToFit()
            nameBtn.frame.origin = CGPoint(x: img.frame.maxX+5, y: (40-nameBtn.frame.height)/2.0)
            footerView.addSubview(nameBtn)
            
            let comeinLab = UILabel(frame: CGRect(x: nameBtn.frame.maxX, y: 0, width: WIDTH-nameBtn.frame.maxX-8, height: 40))
            comeinLab.textAlignment = .right
            comeinLab.font = UIFont.systemFont(ofSize: 12)
            comeinLab.textColor = COLOR
            comeinLab.text = "进入圈子"
            footerView.addSubview(comeinLab)
            
            let lineView = UIView(frame: CGRect(
                x: 0,
                y: 0,
                width: WIDTH,
                height: 1/UIScreen.main.scale))
            lineView.tag = 1000
            lineView.backgroundColor = UIColor.lightGray
            footerView.addSubview(lineView)
            
            return footerView
        }else{
            let noReply:UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 200))
            noReply.textAlignment = NSTextAlignment.center
            noReply.text = "暂无贴子"
            return noReply
        }
        
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if forumModelArray.count == 0 {
            return 200
        }else{
            return 40
        }
    }
    
    // footerView 点击事件
    func footerViewClick(footerBtn:UIButton)  {
        print("进入圈子")
        
        let circleDetailController = NSCircleDetailViewController()
        circleDetailController.hidesBottomBarWhenPushed = true
        circleDetailController.communityId = forumModelArray[footerBtn.tag-100].community_id
        self.navigationController?.pushViewController(circleDetailController, animated: true)
    }
    
    // MARK: - 数据
    func getReportArray() -> [String] {
        let reportArray = ["诽谤辱骂","淫秽色情","垃圾广告","血腥暴力","欺诈（酒托、话费托等行为）","违法行为（涉毒、暴恐、违禁品等行为）"]
        return reportArray
    }
    func getRewardArray() -> [String] {
        let rewardArray = ["1","2","5","10"]
        return rewardArray
    }
    
    // MARK: - 显示举报弹窗
    func showReportAlert(with forumId:String) {
        
        let buttonFontSize:CGFloat = 14
        let animateWithDuration = 0.3
        
        let bgView = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT))
        bgView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        bgView.addTarget(self, action: #selector(alertCancel(_:)), for: .touchUpInside)
        UIApplication.shared.keyWindow?.addSubview(bgView)
        
        let alert = UIView(frame: CGRect(x: WIDTH*0.06, y: HEIGHT, width: WIDTH*0.88, height: 0))
        alert.backgroundColor = UIColor.white
        alert.layer.cornerRadius = 8
        bgView.addSubview(alert)
        
        let titleLab = UILabel(frame: CGRect(x: 0, y: 20, width: alert.frame.width, height: UIFont.systemFont(ofSize: 18).lineHeight))
        titleLab.font = UIFont.systemFont(ofSize: 18)
        titleLab.textAlignment = .center
        titleLab.textColor = UIColor.black
        titleLab.text = "请告诉我们您举报的理由"
        alert.addSubview(titleLab)
        
        let buttonHeight:CGFloat = 30
        let buttonMargin:CGFloat = 10
        var buttonWidth:CGFloat = (alert.frame.width-116-buttonMargin)/2.0
        var buttonX:CGFloat = 58
        var buttonY = titleLab.frame.maxY+25
        
        for (i,buttonTitle) in getReportArray().enumerated() {
            switch i {
            case 0:
                buttonX = 58
                buttonWidth = 125
                
            case 1:
                buttonX = 58+(buttonWidth+buttonMargin)
                buttonWidth = 125
                
            case 2:
                buttonY = buttonY+buttonHeight+buttonMargin
                buttonX = 58
                buttonWidth = 125
                
            case 3:
                buttonX = 58+(buttonWidth+buttonMargin)
                buttonWidth = 125
                
            case 4:
                buttonY = buttonY+buttonHeight+buttonMargin
                buttonX = 58
                buttonWidth = alert.frame.width-116
                
            case 5:
                buttonY = buttonY+buttonHeight+buttonMargin
                buttonX = 58
                buttonWidth = alert.frame.width-116
                
            default:
                break
            }
            
            let button = UIButton(frame: CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight))
            button.tag = 1000+i
            button.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.layer.cornerRadius = 3
            button.layer.borderColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1).cgColor
            button.layer.borderWidth = 1/UIScreen.main.scale
            
            button.setTitleColor(UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1), for: UIControlState())
            button.setTitleColor(UIColor.white, for: .selected)
            
            button.setTitle(buttonTitle, for: UIControlState())
            
            button.backgroundColor = i == 0 ? COLOR:UIColor.clear
            button.isSelected = i == 0 ? true:false
            
            button.addTarget(self, action: #selector(chooseReportType(_:)), for: .touchUpInside)
            
            alert.addSubview(button)
            
        }
        
        let reportBtn = UIButton(frame: CGRect(x: 35, y: buttonY+buttonHeight+35, width: alert.frame.width-70, height: 40))
        reportBtn.tag = NSString(string: forumId).integerValue
        reportBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        reportBtn.layer.cornerRadius = 6
        reportBtn.setTitle("确认举报", for: UIControlState())
        
        reportBtn.setTitleColor(UIColor.white, for: UIControlState())
        reportBtn.backgroundColor = COLOR
        
        reportBtn.addTarget(self, action: #selector(sureReportBtnClick(_:)), for: .touchUpInside)
        
        alert.addSubview(reportBtn)
        
        alert.frame.size.height = reportBtn.frame.maxY+25
        
        UIView.animate(withDuration: animateWithDuration, animations: {
            
            alert.frame.origin.y = (HEIGHT-alert.frame.size.height)/2.0
        })
    }
    
    // MARK: - 选择举报理由
    func chooseReportType(_ typeBtn:UIButton) {
        
        for subView in (typeBtn.superview?.subviews ?? [UIView]())! {
            if subView.tag >= 1000 && subView.tag <= 2000 {
                if subView is UIButton {
                    let button = subView as! UIButton
                    button.isSelected = false
                    button.backgroundColor = UIColor.clear
                    
                }
            }
        }
        
        typeBtn.isSelected = true
        typeBtn.backgroundColor = COLOR
        
        //        reportType = reportArray[typeBtn.tag-1000]
        //        print(reportType)
        print(getReportArray()[typeBtn.tag-1000])
        
    }
    
    // MARK: - 确认举报
    var reportType = "1"
    func sureReportBtnClick(_ rewardBtn:UIButton) {
        
        for subView in (rewardBtn.superview?.subviews ?? [UIView]())! {
            if (subView.tag >= 1000 && subView.tag <= 2000) && subView is UIButton {
                let button = subView as! UIButton
                if button.isSelected {
                    
                    print(button.tag,getReportArray()[button.tag-1000])
                    CircleNetUtil.addReport(userid: QCLoginUserInfo.currentInfo.userid, t_id: String(rewardBtn.tag), score: getReportArray()[button.tag-1000], type: reportType, handle: { (success, response) in
                        
                        self.alertCancel(rewardBtn)
                    })
                }
            }
        }
    }
    
    // MARK: - 显示打赏弹窗
    func showAlert() {
        
        let buttonFontSize:CGFloat = 24
        let animateWithDuration = 0.3
        
        let bgView = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT))
        bgView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        bgView.addTarget(self, action: #selector(alertCancel(_:)), for: .touchUpInside)
        UIApplication.shared.keyWindow?.addSubview(bgView)
        
        let alert = UIView(frame: CGRect(x: WIDTH*0.06, y: HEIGHT, width: WIDTH*0.88, height: 0))
        alert.backgroundColor = UIColor.white
        alert.layer.cornerRadius = 8
        bgView.addSubview(alert)
        
        let titleLab = UILabel(frame: CGRect(x: 0, y: 20, width: alert.frame.width, height: UIFont.systemFont(ofSize: 18).lineHeight))
        titleLab.font = UIFont.systemFont(ofSize: 18)
        titleLab.textAlignment = .center
        titleLab.textColor = UIColor.black
        titleLab.text = "好的文章，就是要打赏"
        alert.addSubview(titleLab)
        
        let noteLab = UILabel(frame: CGRect(x: 0, y: titleLab.frame.maxY+8, width: alert.frame.width, height: UIFont.systemFont(ofSize: 12).lineHeight))
        noteLab.font = UIFont.systemFont(ofSize: 12)
        noteLab.textAlignment = .center
        noteLab.textColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1)
        noteLab.text = "可用护士币：1324"
        alert.addSubview(noteLab)
        
        let buttonWidth:CGFloat = 50
        let buttonMargin = (alert.frame.width-70-buttonWidth*4)/3.0
        
        for (i,buttonTitle) in getRewardArray().enumerated() {
            
            let button = UIButton(frame: CGRect(x: 35+(buttonWidth+buttonMargin)*CGFloat(i), y: noteLab.frame.maxY+25, width: buttonWidth, height: buttonWidth))
            button.tag = 1000+i
            button.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize)
            button.layer.cornerRadius = buttonWidth/2.0
            button.setTitle(buttonTitle, for: UIControlState())
            
            button.setTitleColor(UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1), for: UIControlState())
            button.setTitleColor(UIColor.white, for: .selected)
            
            button.backgroundColor = i == 0 ? COLOR:UIColor(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1)
            button.isSelected = i == 0 ? true:false
            
            button.addTarget(self, action: #selector(chooseRewardCount(_:)), for: .touchUpInside)
            
            alert.addSubview(button)
            
        }
        
        let rewardBtn = UIButton(frame: CGRect(x: 35, y: noteLab.frame.maxY+25+buttonWidth+25, width: alert.frame.width-70, height: 40))
        rewardBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        rewardBtn.layer.cornerRadius = 6
        rewardBtn.setTitle("打赏", for: UIControlState())
        
        rewardBtn.setTitleColor(UIColor.white, for: UIControlState())
        rewardBtn.backgroundColor = COLOR
        
        rewardBtn.addTarget(self, action: #selector(sureRewardBtnClick(_:)), for: .touchUpInside)
        
        alert.addSubview(rewardBtn)
        
        alert.frame.size.height = rewardBtn.frame.maxY+25
        
        UIView.animate(withDuration: animateWithDuration, animations: {
            
            alert.frame.origin.y = (HEIGHT-alert.frame.size.height)/2.0
        })
    }
    
    // MARK: - 选择打赏护士币数量
    func chooseRewardCount(_ countBtn:UIButton) {
        
        for subView in (countBtn.superview?.subviews ?? [UIView]())! {
            if subView.tag >= 1000 && subView.tag <= 2000 {
                if subView is UIButton {
                    let button = subView as! UIButton
                    button.isSelected = false
                    button.backgroundColor = UIColor(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1)
                    
                }
            }
        }
        
        countBtn.isSelected = true
        countBtn.backgroundColor = COLOR
        
        //        rewardCount = rewardArray[countBtn.tag-1000]
        //        print(rewardCount)
        print(countBtn.tag-1000)
        print(getRewardArray()[countBtn.tag-1000])
    }
    
    // MARK: - 确认打赏
    func sureRewardBtnClick(_ rewardBtn:UIButton) {
        
        for subView in (rewardBtn.superview?.subviews ?? [UIView]())! {
            if (subView.tag >= 1000 && subView.tag <= 2000) && subView is UIButton {
                let button = subView as! UIButton
                if button.isSelected {
                    
                    print(button.tag,getRewardArray()[button.tag-1000])
                    alertCancel(rewardBtn)
                    
                }
            }
        }
    }
    
    // MARK: - 显示加精置顶等弹出 sheet
    func showSheet(with buttonTitleArray:[String], buttonTitleColorArray:[UIColor], forumId:String) {
        
        let buttonFontSize:CGFloat = 15
        let buttonTitleDefaultColor = UIColor.black
        let animateWithDuration = 0.3
        
        let bgView = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT))
        bgView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        bgView.addTarget(self, action: #selector(alertCancel(_:)), for: .touchUpInside)
        UIApplication.shared.keyWindow?.addSubview(bgView)
        
        let alert = UIView(frame: CGRect(x: 0, y: HEIGHT, width: WIDTH, height: 0))
        alert.backgroundColor = UIColor.white
        bgView.addSubview(alert)
        
        for (i,buttonTitle) in buttonTitleArray.enumerated() {
            let button = UIButton(frame: CGRect(x: 0, y: 44*CGFloat(i), width: WIDTH, height: 44))
            
            button.tag = NSString(string: forumId).integerValue*100+i
            button.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize)
            button.setTitle(buttonTitle, for: UIControlState())
            
            button.setTitleColor((i<buttonTitleColorArray.count ? buttonTitleColorArray[i]:buttonTitleDefaultColor), for: UIControlState())
            if i == buttonTitleArray.count-1 {
                button.addTarget(self, action: #selector(alertCancel(_:)), for: .touchUpInside)
            }else{
                button.addTarget(self, action: #selector(alertActionClick(_:)), for: .touchUpInside)
            }
            alert.addSubview(button)
            
            let line = UIView(frame: CGRect(x: 0, y: button.frame.height-1/UIScreen.main.scale, width: button.frame.width, height: 1/UIScreen.main.scale))
            line.backgroundColor = UIColor.lightGray
            button.addSubview(line)
        }
        
        UIView.animate(withDuration: animateWithDuration, animations: {
            
            alert.frame = CGRect(x: 0, y: HEIGHT-44*CGFloat(buttonTitleArray.count), width: WIDTH, height: 44*CGFloat(buttonTitleArray.count))
        })
    }
    
    // MARK: - 弹出 sheet 点击选项
    func alertActionClick(_ action:UIButton) {
        print(action.tag)
        
        if action.currentTitle == "置顶" {
            alertCancel(action)
            if currentForumModel.istop == "1" {
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.removeFromSuperViewOnHide = true
                hud.mode = .text
                hud.label.text = "贴子已置顶"
                hud.hide(animated: true, afterDelay: 1.5)
                return
            }
            CircleNetUtil.forumSetTop(tid: String(action.tag/100), handle: { (success, response) in
                if success {
                    print("置顶贴子成功")
                }else{
                    print("置顶贴子失败")
                }
            })
        }else if action.currentTitle == "加精" {
            alertCancel(action)
            if currentForumModel.isbest == "1" {
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.removeFromSuperViewOnHide = true
                hud.mode = .text
                hud.label.text = "贴子已加精"
                hud.hide(animated: true, afterDelay: 1.5)
                return
            }
            CircleNetUtil.forumSetTop(tid: String(action.tag/100), handle: { (success, response) in
                if success {
                    print("加精贴子成功")
                }else{
                    print("加精贴子失败")
                }
            })
        }else if action.currentTitle == "举报" {
            alertCancel(action)
            reportType = "1"
            self.showReportAlert(with: String(action.tag/100))
        }else if action.currentTitle == "删除" {
            alertCancel(action)
            self.showSheet(with: ["删除贴子","取消"], buttonTitleColorArray: [UIColor.black,UIColor.lightGray], forumId: String(action.tag/100))
        }else if action.currentTitle == "删除贴子" {
            alertCancel(action)
            print("删除贴子")
            CircleNetUtil.DeleteForum(tid: String(action.tag/100), handle: { (success, response) in
                if success {
                    print("删除贴子成功")
                    self.loadData()
                }else{
                    print("删除贴子失败")
                }
            })
        }
    }
    
    func alertCancel(_ action:UIView) {
        if action.superview == UIApplication.shared.keyWindow {
            action.removeFromSuperview()
        }else{
            alertCancel(action.superview!)
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
