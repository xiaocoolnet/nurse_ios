//
//  HSUserPageViewController.swift
//  HSHW_2016
//
//  Created by DreamCool on 16/7/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class HSUserPageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate {

    var userTableView = UITableView()
    
    var headerView:UIImageView = UIImageView()//头像
    var nameLabel:UILabel = UILabel()//用户名
    var leavel:UIButton = UIButton()//等级
    var noteLab:UILabel = UILabel()//简介
    var focusBtn:UIButton = UIButton()//关注按钮
    
    var userid:String = "578"
    
    var helper = HSMineHelper()
    var hszHelper = HSNurseStationHelper()
    
    var userInfo:HSFansAndFollowModel?
    
    var dataSource = Array<PostModel>()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setSubviews()

        helper.getUserInfo(userid) { (success, response) in
            self.userInfo = (response as! HSFansAndFollowModel)
            dispatch_async(dispatch_get_main_queue(), {
                self.title = self.userInfo?.name
                self.setTableHeaderView()
            })
            
        }
        
        // TODO: type 是什么意思
        hszHelper.getList(userid, type: "1", isHot: false) { (success, response) in
            self.dataSource = response as? Array<PostModel> ?? []
            dispatch_async(dispatch_get_main_queue(), {
                self.userTableView.reloadData()
            })
        }
        
        
        
    }
    
    func setSubviews() {
        userTableView = UITableView.init(frame: CGRectMake(0, 0, WIDTH, HEIGHT-64), style: .Grouped)
        userTableView.registerNib(UINib(nibName: "HSComTableCell",bundle: nil), forCellReuseIdentifier: "cell")
        userTableView.rowHeight = UITableViewAutomaticDimension
        userTableView.delegate = self
        userTableView.dataSource = self
        self.view.addSubview(userTableView)
    }
    
    func setTableHeaderView() {
            if self.userInfo != nil {
                
                let bgImageView = UIImageView.init(frame: CGRectMake(0, 0, WIDTH, WIDTH*0.9))
                bgImageView.backgroundColor = COLOR
                bgImageView.userInteractionEnabled = true
                
                // 头像
                headerView = UIImageView.init(frame: CGRectMake(WIDTH/3.0, 30, WIDTH/3.0, WIDTH/3.0))
                headerView.backgroundColor = UIColor.cyanColor()
                let str = SHOW_IMAGE_HEADER+(userInfo?.photo)!
                headerView.sd_setImageWithURL(NSURL.init(string: str))
                headerView.layer.cornerRadius = WIDTH/6.0
                headerView.clipsToBounds = true
                headerView.layer.borderWidth = 3
                headerView.layer.borderColor = UIColor.whiteColor().CGColor
                print(str)
                
                bgImageView.addSubview(headerView)
                
                // 用户名
                nameLabel = UILabel.init(frame: CGRectMake(self.view.center.x, CGRectGetMaxY(headerView.frame)+30, 100, 30))
                nameLabel.textColor = UIColor.whiteColor()
                nameLabel.text = userInfo!.name
                nameLabel.sizeToFit()
                nameLabel.frame = CGRectMake((WIDTH-nameLabel.frame.size.width)/2.0-10, nameLabel.frame.origin.y, nameLabel.frame.size.width, nameLabel.frame.size.height)
                bgImageView.addSubview(nameLabel)
                
                // 等级
                let leavel = UIButton.init(frame: CGRectMake(CGRectGetMaxX(nameLabel.frame)+2, CGRectGetMinY(nameLabel.frame), 18, 20))
                leavel.setBackgroundImage(UIImage.init(named: "ic_shield_yellow.png"), forState: .Normal)
                leavel.titleLabel?.font = UIFont.systemFontOfSize(9)
                leavel.setTitleColor(UIColor.yellowColor(), forState: .Normal)
                leavel.setTitle(userInfo?.level, forState: .Normal)
                bgImageView.addSubview(leavel)
                
                // 简介
                noteLab = UILabel.init(frame: CGRectMake(0, CGRectGetMaxY(leavel.frame)+20, WIDTH, 50))
                noteLab.numberOfLines = 0
                noteLab.textAlignment = NSTextAlignment.Center
                noteLab.textColor = UIColor.init(red: 248/255.0, green: 122/255.0, blue: 215/255.0, alpha: 1)
                
                var sex:String = "未知"
                if userInfo?.sex == "0" {
                    sex = "女"
                }else if userInfo?.sex == "1"{
                    sex = "男"
                }
                
                noteLab.text = "性别：\(sex)    学历：\(userInfo?.major)\n医院：北京大学第二附属医院"
                bgImageView.addSubview(noteLab)
                
                // 关注按钮
                focusBtn = UIButton.init(frame: CGRectMake(WIDTH/4.0, CGRectGetMaxY(noteLab.frame)+20, WIDTH/2.0, 50))
                focusBtn.layer.borderWidth = 1
                focusBtn.layer.borderColor = UIColor.whiteColor().CGColor
                focusBtn.layer.cornerRadius = 25
                focusBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                focusBtn.setTitle("关注Ta", forState: .Normal)
                focusBtn.setTitle("已关注", forState: .Selected)
                focusBtn.addTarget(self, action: #selector(followBtnClick(_:)), forControlEvents: .TouchUpInside)
                bgImageView.addSubview(focusBtn)
                
                bgImageView.frame = CGRectMake(0, 0, WIDTH, CGRectGetMaxY(focusBtn.frame)+20)
                
                self.userTableView.tableHeaderView = bgImageView
                
            }

    }
    
    // 关注按钮 点击事件
    func followBtnClick(followBtn:UIButton) {
        if followBtn.selected {

                let alert = UIAlertView.init(title: "取消关注？", message: "确定要取消关注 \((self.userInfo?.name)!) 吗？", delegate: self, cancelButtonTitle: "不再关注", otherButtonTitles: "点错了")
                alert.tag = 4000
                alert.show()
        }else{
            helper.addFavorite(QCLoginUserInfo.currentInfo.userid, refid: (userInfo?.userid)!, type: "6", title: "", description: "") { (success, response) in
                if success {
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        let alert = UIAlertView.init(title: "关注成功", message: "成功关注 \((self.userInfo?.name)!)", delegate: nil, cancelButtonTitle: "确定")
                        alert.show()
                        followBtn.selected = true
                        
                    })
                }
            }
        }
    }
    
    // alertView delegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView.tag == 4000 {
            
            if buttonIndex == 0 {
                
                helper.cancelFavorite(QCLoginUserInfo.currentInfo.userid, refid: (userInfo?.userid)!, type: "6", handle: { (success, response) in
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                    let alert = UIAlertView.init(title: "已成功取消关注", message: "已成功取消关注 \((self.userInfo?.name)!)", delegate: nil, cancelButtonTitle: "确定")
                    alert.show()
                    self.focusBtn.selected = false
                    })
                })
            }
            print("点击了 \(buttonIndex)")
        }
    }
    
    // MARK: tableView 代理方法
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! HSComTableCell

        cell.showForForumModel(dataSource[indexPath.row])
        cell.selectionStyle = .None
        
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let bgView = UIView.init(frame: CGRectMake(0, 0, WIDTH, 40))
        bgView.backgroundColor = UIColor.whiteColor()
        
        let label = UILabel.init(frame: CGRectMake(20, 10, WIDTH-40, 28))
        label.textColor = UIColor.init(red: 145/255.0, green: 0, blue: 105/255.0, alpha: 1)
        label.text = "他的帖子"
        bgView.addSubview(label)
        
        let lineView = UIView.init(frame: CGRectMake(20, CGRectGetMaxY(label.frame), CGRectGetWidth(label.frame), 2))
        lineView.backgroundColor = UIColor.init(red: 145/255.0, green: 0, blue: 105/255.0, alpha: 1)
        bgView.addSubview(lineView)
        
        return bgView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if dataSource.count == 0 {
            let noReply:UILabel = UILabel.init(frame: CGRectMake(0, 0, WIDTH, 200))
            noReply.textAlignment = NSTextAlignment.Center
            noReply.text = "暂无帖子"
            return noReply
        }else{
            return nil
        }
        
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
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
