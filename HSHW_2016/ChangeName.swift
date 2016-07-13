//
//  ChangeName.swift
//  HSHW_2016
//
//  Created by JQ on 16/6/16.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

enum HSEditUserInfo {
    case Avatar
    case UserName
    case Sex
    case PhoneNumber
    case Email
    case RealName
    case BirthDay
    case Address
    case School
    case Major
    case Education
    case Default
}

typealias ChangeUserItemHandle = (changeType:HSEditUserInfo,value:String)->()

class ChangeName: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var myTableView = UITableView()
    var mineHelper = HSMineHelper()
    var showType:HSEditUserInfo = .Default
    var text1 = ""
    let textFeild = UITextField(frame: CGRectMake(20,15,200,30))
    var handle:ChangeUserItemHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //nav
        let navBtn = UIButton(type: .Custom)
        navBtn.frame = CGRectMake(0, 0, 50, 30)
        navBtn.setTitleColor(COLOR, forState: .Normal)
        navBtn.setTitle("保存", forState: .Normal)
        navBtn.addTarget(self, action: #selector(saveInfo), forControlEvents: .TouchUpInside)
        let navItem = UIBarButtonItem(customView: navBtn)
        self.navigationItem.rightBarButtonItem = navItem
        //tableview
        myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
        myTableView.tableFooterView = UIView()
        view.addSubview(myTableView)
    }
    
    func saveInfo(){
        if handle != nil {
            handle!(changeType: showType,value: textFeild.text!)
        }
        if showType == .UserName||showType == .RealName {
            mineHelper.changeUserName(textFeild.text!, handle: {[unowned self] (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if success {
                        QCLoginUserInfo.currentInfo.userName = self.textFeild.text!
                        QCLoginUserInfo.currentInfo.realName = self.textFeild.text!
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                })
            })
        }else if showType == .Email {
            mineHelper.changeEmail(textFeild.text!, handle: { [unowned self] (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if success {
                        QCLoginUserInfo.currentInfo.email = self.textFeild.text!
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                })
            })
        }else if showType == .BirthDay {
            mineHelper.changeBirthday(textFeild.text!, handle: {[unowned self] (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if success {
                        QCLoginUserInfo.currentInfo.birthday = self.textFeild.text!
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                })
            })
        }else if showType == .Address {
            mineHelper.changeAddress(textFeild.text!, handle: {[unowned self] (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if success {
                        QCLoginUserInfo.currentInfo.city = self.textFeild.text!
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                })
            })
        }else if showType == .School {
            mineHelper.changeSchool(textFeild.text!, handle: {[unowned self] (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if success {
                        QCLoginUserInfo.currentInfo.school = self.textFeild.text!
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                })
            })
        }else if showType == .Major {
            mineHelper.changeEducation(textFeild.text!, handle: {[unowned self] (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if success {
                        QCLoginUserInfo.currentInfo.education = self.textFeild.text!
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                })
            })
        }else if showType == .Sex {
            mineHelper.changeUserSex(textFeild.text!, handle: {[unowned self] (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if success {
                        QCLoginUserInfo.currentInfo.sex = self.textFeild.text!
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                })
            })
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 60
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        switch showType {
        case .UserName,.PhoneNumber,.Sex,.Email,.RealName,.BirthDay,.Address,.School,.Major,.Education:
            textFeild.text = text1
            cell?.addSubview(textFeild)
        default:
            cell?.textLabel?.text = "?"
        }
        return cell!
    }
}
