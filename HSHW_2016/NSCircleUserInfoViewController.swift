//
//  NSCircleUserInfoViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/26.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class NSCircleUserInfoViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
    
    var rootTableView = UITableView()
    
    var headerView:UIImageView = UIImageView()//头像
    var nameLabel:UILabel = UILabel()//用户名
    var leavel:UIButton = UIButton()//等级
    var noteLab:UILabel = UILabel()//简介
    var focusBtn:UIButton = UIButton()//关注按钮
    
    var userid:String = "639"
    
    var helper = HSMineHelper()
    
    var userInfo:HSFansAndFollowModel?
    
    var dataSource = Array<PostModel>()
    var focusArray = Array<HSFansAndFollowModel>()
    
    var forumModelArray = [ForumListDataModel]()

    var communityModelArray = [CommunityListDataModel]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setSubviews()
        
        helper.getUserInfo(userid) { (success, response) in
            self.userInfo = (response as! HSFansAndFollowModel)
            DispatchQueue.main.async(execute: {
                self.title = self.userInfo?.name
                self.setTableHeaderView()
            })
            
        }
        
        // TODO: type 是什么意思
        HSNurseStationHelper().getList(userid, type: "1", isHot: false) { (success, response) in
            self.dataSource = response as? Array<PostModel> ?? []
            DispatchQueue.main.async(execute: {
                self.rootTableView.reloadData()
            })
        }
        
        CircleNetUtil.getCommunityList(userid: QCLoginUserInfo.currentInfo.userid, term_id: "", best: "", hot: "1", pager: "1") { (success, response) in
            if success {
                self.communityModelArray = response as! [CommunityListDataModel]
                self.setTableHeaderView()
            }
        }
        
    }
    
    // 设置子视图
    func setSubviews() {
        
        // 导航栏
        let rightBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 80, height: 44))
        rightBtn.addTarget(self, action: #selector(rightBarButtonClick), for: .touchUpInside)
        
        let rightImg = UIImageView.init(frame: CGRect(x: 0, y: 12, width: 12, height: 20))
        rightImg.image = UIImage(named: "ic_back")
        rightImg.isUserInteractionEnabled = true
        rightBtn.addSubview(rightImg)
        
        let rightLab = UILabel.init(frame: CGRect(x: 20, y: 7, width: 60, height: 30))
        rightLab.textColor = COLOR
        rightLab.text = "返回"
        rightBtn.addSubview(rightLab)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        let shareBtn:UIButton = UIButton.init(frame: CGRect(x: 0, y: 7, width: 30, height: 30))
        shareBtn.setImage(UIImage.init(named: "ic_fenxiang"), for: UIControlState())
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: shareBtn)
        
        // 主 tableView
        rootTableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT-64), style: .grouped)
        rootTableView.register(UINib(nibName: "HSComTableCell",bundle: nil), forCellReuseIdentifier: "cell")
        rootTableView.rowHeight = UITableViewAutomaticDimension
        rootTableView.delegate = self
        rootTableView.dataSource = self
        self.view.addSubview(rootTableView)
        
        rootTableView.register(NSCircleDetailTableViewCell.self, forCellReuseIdentifier: "circleDetailCell")

    }
    
    func rightBarButtonClick() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // 设置 tableView HeaderView
    func setTableHeaderView() {
        if self.userInfo != nil {
            
            let bgView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 0))
            
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
            headerView = UIImageView.init(frame: CGRect(x: WIDTH/3.0, y: 30, width: WIDTH/3.0, height: WIDTH/3.0))
            headerView.backgroundColor = UIColor.cyan
            let str = SHOW_IMAGE_HEADER+(userInfo?.photo)!
            
            if  !NurseUtil.net.isWifi() && loadPictureOnlyWiFi {
                headerView.image = UIImage.init(named: "defaultImage.png")
            }else{
                headerView.sd_setImage(with: URL.init(string: str), placeholderImage: UIImage.init(named: "defaultImage.png"))
            }
            //                headerView.sd_setImageWithURL(NSURL.init(string: str))
            headerView.layer.cornerRadius = WIDTH/6.0
            headerView.clipsToBounds = true
            headerView.layer.borderWidth = 3
            headerView.layer.borderColor = UIColor.white.cgColor
            print(str)
            
            bgImageView.addSubview(headerView)
            
            // 用户名
            nameLabel = UILabel.init(frame: CGRect(x: self.view.center.x, y: headerView.frame.maxY+30, width: 100, height: 30))
            nameLabel.textColor = UIColor.white
            nameLabel.text = userInfo!.name
            nameLabel.sizeToFit()
            nameLabel.frame = CGRect(x: (WIDTH-nameLabel.frame.size.width)/2.0-10, y: nameLabel.frame.origin.y, width: nameLabel.frame.size.width, height: nameLabel.frame.size.height)
            bgImageView.addSubview(nameLabel)
            
            // 性别
            let sexImg = UIImageView(frame: CGRect(x: nameLabel.frame.maxX+2, y: nameLabel.frame.minY, width: 100, height: nameLabel.frame.height))
            sexImg.backgroundColor = UIColor.yellow
            var sex:String = "未知"
            if userInfo?.sex == "0" {
                sex = "女"
            }else if userInfo?.sex == "1"{
                sex = "男"
            }
            bgImageView.addSubview(sexImg)

            
            // 等级
            let leavel = UIButton.init(frame: CGRect(x: sexImg.frame.maxX+2, y: nameLabel.frame.minY, width: 18, height: 20))
            leavel.setBackgroundImage(UIImage.init(named: "ic_shield_yellow.png"), for: UIControlState())
            leavel.titleLabel?.font = UIFont.systemFont(ofSize: 9)
            leavel.setTitleColor(UIColor.yellow, for: UIControlState())
            leavel.setTitle(userInfo?.level, for: UIControlState())
            bgImageView.addSubview(leavel)
            
            // 认证类型
            let authTypeStr = "学生"
            let authType = UILabel(frame: CGRect(x: leavel.frame.maxX+2, y: nameLabel.frame.minY, width: calculateWidth(authTypeStr, size: 8, height: nameLabel.frame.height)+UIFont.systemFont(ofSize: 8).lineHeight, height: UIFont.systemFont(ofSize: 8).lineHeight))
            authType.layer.cornerRadius = UIFont.systemFont(ofSize: 8).lineHeight/2.0
            authType.backgroundColor = COLOR
            authType.font = UIFont.systemFont(ofSize: 8)
            authType.textColor = UIColor.white
            authType.text = authTypeStr
            bgImageView.addSubview(authType)
            
            // 关注 粉丝
            noteLab = UILabel.init(frame: CGRect(x: 0, y: leavel.frame.maxY+20, width: WIDTH, height: UIFont.systemFont(ofSize: 12).lineHeight))
            noteLab.font = UIFont.systemFont(ofSize: 12)
            noteLab.textAlignment = NSTextAlignment.center
            noteLab.textColor = UIColor.init(red: 248/255.0, green: 122/255.0, blue: 215/255.0, alpha: 1)
            noteLab.text = "关注：\("985")    粉丝：\("3268")"
            bgImageView.addSubview(noteLab)
            
            // 关注按钮
            focusBtn = UIButton.init(frame: CGRect(x: WIDTH/4.0, y: noteLab.frame.maxY+20, width: WIDTH/2.0, height: 50))
            focusBtn.layer.borderWidth = 1
            focusBtn.layer.borderColor = UIColor.white.cgColor
            focusBtn.layer.cornerRadius = 25
            focusBtn.setTitleColor(UIColor.white, for: UIControlState())
            focusBtn.setTitle("关注Ta", for: UIControlState())
            focusBtn.setTitle("已关注", for: .selected)
            var flag = true
            for obj in focusArray {
                if obj.id == userid {
                    focusBtn.isSelected = true
                    flag = false
                }
            }
            if flag {
                focusBtn.isSelected = false
            }
            focusBtn.addTarget(self, action: #selector(followBtnClick(_:)), for: .touchUpInside)
            bgImageView.addSubview(focusBtn)
            
            bgImageView.frame = CGRect(x: 0, y: 0, width: WIDTH, height: focusBtn.frame.maxY+20)
            gradientLayer.frame = CGRect(x: 0, y: 0, width: WIDTH, height: focusBtn.frame.maxY+20)
            
            // 他加入的圈子
            let recommendBgView = UIView(frame: CGRect(x: 0, y: bgImageView.frame.maxY, width: WIDTH-16, height: 35))
            recommendBgView.backgroundColor = UIColor.white
            bgView.addSubview(recommendBgView)

            let recommendLab = UILabel(frame: CGRect(x: 8, y: 0, width: WIDTH-16, height: 35))
            recommendLab.backgroundColor = UIColor.white
            recommendLab.textAlignment = .left
            recommendLab.font = UIFont.systemFont(ofSize: 14)
            recommendLab.textColor = UIColor.lightGray
            recommendLab.text = "他加入的圈子"
            recommendBgView.addSubview(recommendLab)
            
            // 他加入的圈子
            let btn2ScrollView = UIScrollView(frame: CGRect(x: 0, y: recommendBgView.frame.maxY, width: WIDTH, height: 0))
            btn2ScrollView.backgroundColor = UIColor.white
            btn2ScrollView.showsVerticalScrollIndicator = false
            btn2ScrollView.showsHorizontalScrollIndicator = false
            bgView.addSubview(btn2ScrollView)
            
            let btn2Width = WIDTH/375*100
            var btn2Height:CGFloat = 0
            
            for (i,communityModel) in communityModelArray.enumerated() {
                let btn2 = UIButton(frame: CGRect(x: 8+(btn2Width+8)*CGFloat(i), y: 0, width: btn2Width, height: 0))
                btn2.tag = 200+i
                
                //            btn2.setImage(UIImage(named: btn2NameArray[i]), forState: .Normal)
                btn2.addTarget(self, action: #selector(btn2Click(_:)), for: .touchUpInside)
                btn2ScrollView.addSubview(btn2)
                
                let img = UIImageView(frame: CGRect(x: 0, y: 0, width: btn2Width, height: WIDTH/375*72))
                img.backgroundColor = UIColor(red: 243/255.0, green: 229/255.0, blue: 240/255.0, alpha: 1)
                img.contentMode = .center
                img.sd_setImage(with: URL(string: SHOW_IMAGE_HEADER+communityModel.photo), placeholderImage: nil)
                btn2.addSubview(img)
                
                let nameLab = UILabel(frame: CGRect(x: 0, y: img.frame.maxY, width: btn2Width, height: WIDTH/375*22))
                nameLab.textAlignment = .left
                nameLab.font = UIFont.systemFont(ofSize: 14)
                nameLab.textColor = COLOR
                nameLab.text = communityModel.community_name
                nameLab.adjustsFontSizeToFitWidth = true
                btn2.addSubview(nameLab)
                
                let countLab = UILabel(frame: CGRect(x: 0, y: nameLab.frame.maxY, width: btn2Width, height: WIDTH/375*15))
                countLab.textAlignment = .left
                countLab.font = UIFont.systemFont(ofSize: 10)
                countLab.textColor = UIColor.lightGray
                countLab.adjustsFontSizeToFitWidth = true
                var personNum = "\(communityModel.person_num)人"
                
                if NSString(string: communityModel.person_num).doubleValue >= 10000 {
                    personNum = NSString(format: "%.2f万人", NSString(string: communityModel.person_num).doubleValue/10000.0) as String
                }
                
                var forumNum = "\(communityModel.f_count)贴子"
                
                if NSString(string: communityModel.f_count).doubleValue >= 10000 {
                    forumNum = NSString(format: "%.2f万贴子", NSString(string: communityModel.f_count).doubleValue/10000.0) as String
                }
                
                countLab.text = "\(personNum) \(forumNum)"
                btn2.addSubview(countLab)
                
                btn2.frame.size.height = countLab.frame.maxY
                btn2Height = btn2.frame.size.height
                
                btn2ScrollView.frame.size.height = btn2.frame.size.height
                
            }
            
            btn2ScrollView.contentSize = CGSize(width: 8+(btn2Width+8)*CGFloat(communityModelArray.count), height: 0)
            
            
            bgView.frame.size.height = recommendLab.frame.maxY+btn2Height+8
            
            self.rootTableView.tableHeaderView = bgView
            
        }
        
    }
    
    // btn2 点击事件
    func btn2Click(_ btn2:UIButton) {
        
        print("点击热门圈子推荐 之 \(btn2.tag-200)")
        
        let circleDetailController = NSCircleDetailViewController()
        circleDetailController.communityModel = communityModelArray[btn2.tag-200]
        circleDetailController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(circleDetailController, animated: true)
        
    }
    
    // 关注按钮 点击事件
    func followBtnClick(_ followBtn:UIButton) {
        if followBtn.isSelected {
            
            let alert = UIAlertView.init(title: "取消关注？", message: "确定要取消关注 \((self.userInfo?.name)!) 吗？", delegate: self, cancelButtonTitle: "不再关注", otherButtonTitles: "点错了")
            alert.tag = 4000
            alert.show()
        }else{
            helper.addFavorite(QCLoginUserInfo.currentInfo.userid, refid: (userInfo?.userid)!, type: "6", title: "", description: "") { (success, response) in
                if success {
                    DispatchQueue.main.async(execute: {
                        
                        let alert = UIAlertView.init(title: "关注成功", message: "成功关注 \((self.userInfo?.name)!)", delegate: nil, cancelButtonTitle: "确定")
                        alert.show()
                        followBtn.isSelected = true
                        
                    })
                }
            }
        }
    }
    
    // alertView delegate
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if alertView.tag == 4000 {
            
            if buttonIndex == 0 {
                
                helper.cancelFavorite((userInfo?.userid)!, refid: (userInfo?.object_id)!, type: "6", handle: { (success, response) in
                    
                    DispatchQueue.main.async(execute: {
                        //                        print("--===   ",success)
                        let alert = UIAlertView.init(title: "已成功取消关注", message: "已成功取消关注 \((self.userInfo?.name)!)", delegate: nil, cancelButtonTitle: "确定")
                        alert.show()
                        self.focusBtn.isSelected = false
                    })
                })
            }
            print("点击了 \(buttonIndex)")
        }
    }
    
    // MARK: - moreBtnClick
    func moreBtnClick(_ moreBtn:UIButton) {
        print(moreBtn.tag)
        
        let labelTextArray = ["删除","取消"]
        let labelTextColorArray = [UIColor.black,UIColor.lightGray]
        
//        NSCirclePublicAction.showSheet(with: labelTextArray, buttonTitleColorArray: labelTextColorArray)
        
    }
    
    // MARK: tableView 代理方法
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "circleDetailCell", for: indexPath) as! NSCircleDetailTableViewCell
        
        cell.selectionStyle = .none
        
        cell.setCellWith(forumModelArray[indexPath.section])
        
        cell.moreBtn.tag = 100+indexPath.row
        cell.moreBtn.addTarget(self, action: #selector(moreBtnClick(_:)), for: .touchUpInside)
        
        return cell
    }
    //    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! HSComTableCell
    //
    //        cell.showForForumModel(dataSource[indexPath.row])
    //        cell.selectionStyle = .None
    //
    //        return cell
    //    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let bgView = UIView.init(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 40))
        bgView.backgroundColor = UIColor.white
        
        let label = UILabel.init(frame: CGRect(x: 20, y: 10, width: WIDTH-40, height: 28))
        label.textColor = UIColor.init(red: 145/255.0, green: 0, blue: 105/255.0, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "他/她的帖子"
        bgView.addSubview(label)
        
        let lineView = UIView.init(frame: CGRect(x: 20, y: label.frame.maxY, width: label.frame.width, height: 1/UIScreen.main.scale))
        lineView.backgroundColor = UIColor.lightGray
        bgView.addSubview(lineView)
        
        return bgView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if forumModelArray.count > section {
            
            let footerView = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 35))
            footerView.addTarget(self, action: #selector(footerViewClick), for: .touchUpInside)
            
            let nameBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
            nameBtn.setImage(UIImage(named: "精华帖"), for: UIControlState())
            nameBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            nameBtn.setTitleColor(COLOR, for: UIControlState())
            nameBtn.setTitle("内科", for: UIControlState())
            nameBtn.sizeToFit()
            nameBtn.frame.origin = CGPoint(x: 8, y: (35-nameBtn.frame.height)/2.0)
            footerView.addSubview(nameBtn)
            
            let comeinLab = UILabel(frame: CGRect(x: nameBtn.frame.maxX, y: 0, width: WIDTH-nameBtn.frame.maxX-8, height: 35))
            comeinLab.textAlignment = .right
            comeinLab.font = UIFont.systemFont(ofSize: 12)
            comeinLab.textColor = COLOR
            comeinLab.text = "进入圈子"
            footerView.addSubview(comeinLab)
            
            return footerView
        }else{
            let noReply:UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 200))
            noReply.textAlignment = NSTextAlignment.center
            noReply.text = "暂无帖子"
            return noReply
        }
        
    }
//    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        if dataSource.count == 0 {
//            let noReply:UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 200))
//            noReply.textAlignment = NSTextAlignment.center
//            noReply.text = "暂无帖子"
//            return noReply
//        }else{
//            return nil
//        }
//        
//    }
//    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if dataSource.count == 0 {
            return 200
        }else{
            return 0.0001
        }
    }
    
    // footerView 点击事件
    func footerViewClick()  {
        print("进入圈子")
        
        let circleDetailController = NSCircleDetailViewController()
        circleDetailController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(circleDetailController, animated: true)
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
