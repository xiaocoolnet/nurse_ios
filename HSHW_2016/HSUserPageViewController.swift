//
//  HSUserPageViewController.swift
//  HSHW_2016
//
//  Created by DreamCool on 16/7/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class HSUserPageViewController: UIViewController,UITableViewDelegate,UIAlertViewDelegate {//UITableViewDataSource

    var userTableView = UITableView()
    
    var headerView:UIImageView = UIImageView()//头像
    var nameLabel:UILabel = UILabel()//用户名
    var leavel:UIButton = UIButton()//等级
    var noteLab:UILabel = UILabel()//简介
    var focusBtn:UIButton = UIButton()//关注按钮
    
    var userid:String = "578"
    
    var helper = HSMineHelper()
    
    var userInfo:HSFansAndFollowModel?
    
    var dataSource = Array<PostModel>()
    var focusArray = Array<HSFansAndFollowModel>()

    
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
                self.userTableView.reloadData()
            })
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
        userTableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT-64), style: .grouped)
        userTableView.register(UINib(nibName: "HSComTableCell",bundle: nil), forCellReuseIdentifier: "cell")
        userTableView.rowHeight = UITableViewAutomaticDimension
        userTableView.delegate = self
//        userTableView.dataSource = self
        self.view.addSubview(userTableView)
    }
    
    func rightBarButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // 设置 tableView HeaderView
    func setTableHeaderView() {
            if self.userInfo != nil {
                
                let bgImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: WIDTH, height: WIDTH*0.9))
                bgImageView.isUserInteractionEnabled = true
                
                // 创建渐变色图层
                let gradientLayer = CAGradientLayer.init()
                gradientLayer.frame = CGRect(x: 0, y: 0, width: WIDTH, height: WIDTH*0.9)
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
                
                // 等级
                let leavel = UIButton.init(frame: CGRect(x: nameLabel.frame.maxX+2, y: nameLabel.frame.minY, width: 18, height: 20))
                leavel.setBackgroundImage(UIImage.init(named: "ic_shield_yellow.png"), for: UIControlState())
                leavel.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                leavel.setTitleColor(UIColor.yellow, for: UIControlState())
                leavel.setTitle(userInfo?.level, for: UIControlState())
                bgImageView.addSubview(leavel)
                
                // 简介
                noteLab = UILabel.init(frame: CGRect(x: 0, y: leavel.frame.maxY+20, width: WIDTH, height: 50))
                noteLab.numberOfLines = 0
                noteLab.textAlignment = NSTextAlignment.center
                noteLab.textColor = UIColor.init(red: 248/255.0, green: 122/255.0, blue: 215/255.0, alpha: 1)
                
                var sex:String = "未知"
                if userInfo?.sex == "0" {
                    sex = "女"
                }else if userInfo?.sex == "1"{
                    sex = "男"
                }
                
                noteLab.text = "性别：\(sex)    学历：\((userInfo?.major)!)\n医院：北京大学第二附属医院"
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
                
                self.userTableView.tableHeaderView = bgImageView
                
            }

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
    
    // MARK: tableView 代理方法
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
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
        label.text = "他的帖子"
        bgView.addSubview(label)
        
        let lineView = UIView.init(frame: CGRect(x: 20, y: label.frame.maxY, width: label.frame.width, height: 2))
        lineView.backgroundColor = UIColor.init(red: 145/255.0, green: 0, blue: 105/255.0, alpha: 1)
        bgView.addSubview(lineView)
        
        return bgView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if dataSource.count == 0 {
            let noReply:UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 200))
            noReply.textAlignment = NSTextAlignment.center
            noReply.text = "暂无帖子"
            return noReply
        }else{
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if dataSource.count == 0 {
            return 200
        }else{
            return 0.0001
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
