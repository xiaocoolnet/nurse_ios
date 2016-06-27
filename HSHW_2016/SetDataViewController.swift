//
//  SetDataViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class SetDataViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let myTableView = UITableView()
    var oneArr:[String] = ["头像","用户名","性别","手机","邮箱"]
    var onedeArr:[String] = [QCLoginUserInfo.currentInfo.avatar,QCLoginUserInfo.currentInfo.userName,QCLoginUserInfo.currentInfo.sex,QCLoginUserInfo.currentInfo.phoneNumber,QCLoginUserInfo.currentInfo.email]
    
    var twoArr:[String] = ["姓名","出生日期","地址"]
    var twodeArr:[String] = [QCLoginUserInfo.currentInfo.realName ,QCLoginUserInfo.currentInfo.birthday,QCLoginUserInfo.currentInfo.city]
    
    var threeArr:[String] = ["学校","专业","学历"]
    var threedeArr:[String] = [QCLoginUserInfo.currentInfo.school,QCLoginUserInfo.currentInfo.major,QCLoginUserInfo.currentInfo.education]
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.navigationBar.hidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-115)
        myTableView.backgroundColor = RGREY
        myTableView.delegate = self
        myTableView.dataSource = self
        self.view.addSubview(myTableView)
        
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let one = UIView()
        one.backgroundColor = UIColor.clearColor()
        return one
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 72
            }else{
                return 60
            }
        }else{
            return 60
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }else if section == 1 {
            return 3
        }else{
            return 3
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "cell")
        cell.selectionStyle = .None
        cell.accessoryType = .DisclosureIndicator
        cell.textLabel?.font = UIFont.systemFontOfSize(18)
        cell.detailTextLabel?.font = UIFont.systemFontOfSize(14)
        if indexPath.section == 0 {
            cell.textLabel?.text = oneArr[indexPath.row]
            cell.detailTextLabel?.text = onedeArr[indexPath.row]
            if indexPath.row == 0 {
                let titImage = UIImageView(frame: CGRectMake(WIDTH-86, 11, 50, 50))
                titImage.layer.cornerRadius = 25
                titImage.clipsToBounds = true
                titImage.image = UIImage(named: "6.png")
                cell.addSubview(titImage)
            }
        }else if indexPath.section == 1 {
            cell.textLabel?.text = twoArr[indexPath.row]
            cell.detailTextLabel?.text = twodeArr[indexPath.row]
        }else{
            cell.textLabel?.text = threeArr[indexPath.row]
            cell.detailTextLabel?.text = threedeArr[indexPath.row]
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let changeNameVC = ChangeName()
        changeNameVC.handle = {[unowned self] (type,value) in
            dispatch_async(dispatch_get_main_queue(), {
                if indexPath.section == 0 {
                    self.onedeArr[indexPath.row] = value
                }else if indexPath.section == 1{
                    self.twodeArr[indexPath.row] = value
                }else if indexPath.section == 2{
                    self.threedeArr[indexPath.row] = value
                }
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            })
//            switch type {
//            case .UserName:
//            case .Sex:
//            case .PhoneNumber:
//            case .Email:
//            case .RealName:
//            case .BirthDay:
//            case .Address:
//            case .School:
//            case .Major:
//            case .Education:
//            default:
//                
//            }
        }
        switch (indexPath.section,indexPath.row) {
        case (0,0):
            changeNameVC.showType = .Avatar
            changeNameVC.title = "编辑头像"
        case (0,1):
            changeNameVC.showType = .UserName
            changeNameVC.title = "编辑用户名"
            changeNameVC.text1 = onedeArr[indexPath.row]
        case (0,2):
            changeNameVC.showType = HSEditUserInfo.Sex
            changeNameVC.title = "编辑性别"
        case (0,3):
            changeNameVC.showType = HSEditUserInfo.PhoneNumber
            changeNameVC.title = "编辑手机号"
            changeNameVC.text1 = onedeArr[indexPath.row]
        case (0,4):
            changeNameVC.showType = HSEditUserInfo.Email
            changeNameVC.title = "编辑邮箱"
            changeNameVC.text1 = onedeArr[indexPath.row]
        case (1,0):
            changeNameVC.showType = HSEditUserInfo.RealName
            changeNameVC.title = "编辑真实姓名"
            changeNameVC.text1 = twodeArr[indexPath.row]
        case (1,1):
            changeNameVC.showType = HSEditUserInfo.BirthDay
            changeNameVC.title = "编辑出生日期"
            changeNameVC.text1 = twodeArr[indexPath.row]
        case (1,2):
            changeNameVC.showType = HSEditUserInfo.Address
            changeNameVC.title = "编辑地址"
            changeNameVC.text1 = twodeArr[indexPath.row]
        case (2,0):
            changeNameVC.showType = HSEditUserInfo.School
            changeNameVC.title = "编辑学校"
            changeNameVC.text1 = threedeArr[indexPath.row]
        case (2,1):
            changeNameVC.showType = HSEditUserInfo.Major
            changeNameVC.title = "编辑专业"
            changeNameVC.text1 = threedeArr[indexPath.row]
        case (2,2):
            changeNameVC.showType = HSEditUserInfo.Education
            changeNameVC.title = "编辑学历"
            changeNameVC.text1 = threedeArr[indexPath.row]
        default:
            changeNameVC.showType = HSEditUserInfo.Default
            changeNameVC.title = "默认"
        }
        self.navigationController?.pushViewController(changeNameVC, animated: true)
    }
}
