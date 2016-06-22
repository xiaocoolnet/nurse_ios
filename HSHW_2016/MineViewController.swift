//
//  MineViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MineViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var myTableView = UITableView()
    let numArr:[String] = ["1384","2587","2349"]
    let numNameArr:[String] = ["粉丝","关注","护士币"]
    
    let titLabArr:[String] = ["我的帖子","我的消息","我的收藏"]
    let titImgArr:[String] = ["ic_liuyan.png","ic_message.png","ic_fangkuai.png"]
    
    let titImage = UIButton()
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        self.navigationController?.navigationBar.hidden = true
        self.tabBarController?.tabBar.hidden = false
        myTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = COLOR
        
        myTableView.frame = CGRectMake(0, -20, WIDTH, HEIGHT+20)
        myTableView.bounces = false
        myTableView.backgroundColor = RGREY
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerClass(MineTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(myTableView)
        myTableView.separatorStyle = .None
        

        // Do any additional setup after loading the view.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return WIDTH
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
            return 3
        }else if section == 3 {
            return 1
        }else{
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
                cell.backgroundColor = COLOR
                for i in 0...2 {
                    let number = UILabel(frame: CGRectMake(WIDTH/3*CGFloat(i), WIDTH-60, WIDTH/3, 20))
                    number.textColor = UIColor.whiteColor()
                    number.textAlignment = .Center
                    number.text = numArr[i]
                    cell.addSubview(number)
                    let numName = UILabel(frame: CGRectMake(WIDTH/3*CGFloat(i), WIDTH-40, WIDTH/3, 20))
                    numName.textColor = UIColor(red: 250/255.0, green: 118/255.0, blue: 210/255.0, alpha: 1.0)
                    numName.textAlignment = .Center
                    numName.font = UIFont.systemFontOfSize(12)
                    numName.text = numNameArr[i]
                    cell.addSubview(numName)
                    let line = UILabel(frame: CGRectMake(WIDTH/3*CGFloat(i)-0.5, WIDTH-50, 0.5, 20))
                    line.backgroundColor = UIColor(red: 250/255.0, green: 118/255.0, blue: 210/255.0, alpha: 1.0)
                    cell.addSubview(line)
                    let btn = UIButton(frame: CGRectMake(WIDTH/3*CGFloat(i), WIDTH-60, WIDTH/3, 40))
                    btn.addTarget(self, action: #selector(self.fineAndContact(_:)), forControlEvents: .TouchUpInside)
                    btn.tag = i+1
                    cell.addSubview(btn)
                }
                titImage.frame = CGRectMake(WIDTH*128/375, WIDTH*74/375, WIDTH*120/375, WIDTH*120/375)
                titImage.setBackgroundImage(UIImage(named: "6.png"), forState: .Normal)
                titImage.addTarget(self, action: #selector(MineViewController.changeTitImage), forControlEvents: .TouchUpInside)
                titImage.layer.cornerRadius = WIDTH*120/375/2
                titImage.clipsToBounds = true
                titImage.layer.borderWidth = 3
                titImage.layer.borderColor = UIColor.whiteColor().CGColor
                cell.addSubview(titImage)
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
                
                let signImg = UIImageView(frame: CGRectMake(WIDTH*137/375, WIDTH-WIDTH*111/375, WIDTH*22/375, WIDTH*22/375))
                signImg.image = UIImage(named: "ic_lalendar.png")
                cell.addSubview(signImg)
                let signLab = UILabel(frame: CGRectMake(WIDTH*169/375, WIDTH-WIDTH*111/375,WIDTH*120/375, WIDTH*22/375))
                signLab.font = UIFont.systemFontOfSize(18)
                signLab.textColor = UIColor.yellowColor()
                signLab.text = "每日签到"
                cell.addSubview(signLab)
                
                let signBtn = UIButton()
                signBtn.frame = CGRectMake(WIDTH*68/375, WIDTH-WIDTH*121/375, WIDTH*240/375, WIDTH*42/375)
                signBtn.layer.cornerRadius = WIDTH*42/375/2
                signBtn.layer.borderColor = UIColor.yellowColor().CGColor
                signBtn.layer.borderWidth = 2
                signBtn.addTarget(self, action: #selector(MineViewController.signInToday), forControlEvents: .TouchUpInside)
                cell.addSubview(signBtn)
                let name = UILabel()
                name.frame = CGRectMake(WIDTH*160/375, WIDTH*205/375, WIDTH*55/375, 30)
                name.textAlignment = .Center
                name.font = UIFont.systemFontOfSize(18)
                name.textColor = UIColor.whiteColor()
                name.text = "张晓萍"
                name.sizeToFit()
                name.frame = CGRectMake(WIDTH/2-name.bounds.size.width/2, WIDTH*205/375, name.bounds.size.width, name.bounds.size.height)
                cell.addSubview(name)
                let btn = UIButton(frame: CGRectMake(name.bounds.size.width/2+5+WIDTH/2, WIDTH*205/375, 20, 19))
                btn.setBackgroundImage(UIImage(named: "ic_shield_yellow.png"), forState: .Normal)
                btn.setTitleColor(UIColor.yellowColor(), forState: .Normal)
                btn.setTitle("25", forState: .Normal)
                btn.titleLabel?.font = UIFont.systemFontOfSize(9)
                cell.addSubview(btn)
                
                
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
                if indexPath.row == 2 {
                    line.removeFromSuperview()
                }
             }else if indexPath.section == 3 {
                cell.titImage.setImage(UIImage(named: "ic_xie.png"), forState: .Normal)
                cell.titLab.text = "我的招聘"
            }else{
                cell.titImage.setImage(UIImage(named: "ic_singal.png"), forState: .Normal)
                cell.titLab.text = "仅WiFi下载图片"
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
        }
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                let next = MinePostViewController()
                self.navigationController?.pushViewController(next, animated: true)
                next.title = "我的帖子"
            }
            if indexPath.row == 1 {
                let next = MineMessageViewController()
                self.navigationController?.pushViewController(next, animated: true)
                next.title = "我的消息"
            }
            if indexPath.row == 2 {
                let next = MineCollectionViewController()
                self.navigationController?.pushViewController(next, animated: true)
                next.title = "我的收藏"
            }
        }
        if indexPath.section == 3 {
            let next = MineRecruitViewController()
            self.navigationController?.pushViewController(next, animated: true)
            next.title = "我的招聘"
        }
    }

    func changeTitImage() {
        print("头像")
        
    }
    func fineAndContact(btn:UIButton) {
        print("粉丝与管理")
        if btn.tag == 1 {
            let next = FinesViewController()
            self.navigationController?.pushViewController(next, animated: true)
            next.title = "粉丝与关注"
        }
        if btn.tag == 2 {
            let next = FinesViewController()
            self.navigationController?.pushViewController(next, animated: true)
            next.title = "粉丝与关注"
        }
    }
    func setUpData() {
        print("设置")
        let next = SetDataViewController()
        self.navigationController?.pushViewController(next, animated: true)
        next.title = "个人资料编辑"
    }

    func signInToday() {
        print("签到")
    }

}
