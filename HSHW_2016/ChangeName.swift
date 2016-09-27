//
//  ChangeName.swift
//  HSHW_2016
//
//  Created by JQ on 16/6/16.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

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
    
    let dataBtn = UIButton(frame: CGRectMake(20,15,200,30))
    let addressBtn = UIButton(frame: CGRectMake(20,15,200,30))
    var picker:DatePickerView?
    var pick:AdressPickerView?
    var array = NSArray()
    var id = String()
    var dateSource = EduList()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let line = UIView(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        //tableview
        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-64-1)
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
        myTableView.tableFooterView = UIView()
        view.addSubview(myTableView)
            
        if showType == .Education || showType == .Sex || showType == .Major {
            self.dataGet()
        }else{
            //nav
            let navBtn = UIButton(type: .Custom)
            navBtn.frame = CGRectMake(0, 0, 50, 30)
            navBtn.setTitleColor(COLOR, forState: .Normal)
            navBtn.setTitle("保存", forState: .Normal)
            navBtn.addTarget(self, action: #selector(saveInfo), forControlEvents: .TouchUpInside)
            let navItem = UIBarButtonItem(customView: navBtn)
            self.navigationItem.rightBarButtonItem = navItem
        }
        
        array = ["北京市","北京市","朝阳区"]

    }
    
    func saveInfo(){
        if handle != nil {
            if showType == .BirthDay {
                handle!(changeType: showType,value: (dataBtn.titleLabel?.text!)!)
            }else if showType == .Address{
                handle!(changeType: showType,value: (addressBtn.titleLabel?.text!)!)
            }else{
                handle!(changeType: showType,value: textFeild.text!)
            }
        }
        if showType == .UserName {
            mineHelper.changeUserName(textFeild.text!, handle: {[unowned self] (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if success {
                        QCLoginUserInfo.currentInfo.userName = self.textFeild.text!
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                })
            })
        }else if showType == .PhoneNumber {
            mineHelper.changePhoneNumber(textFeild.text!, handle: {[unowned self] (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if success {
                        QCLoginUserInfo.currentInfo.phoneNumber = self.textFeild.text!
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                })
                })
        }else if showType == .RealName {
            mineHelper.changeUserRealName(textFeild.text!, handle: {[unowned self] (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if success {
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
         }else if showType == .School {
            mineHelper.changeSchool(textFeild.text!, handle: {[unowned self] (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if success {
                        QCLoginUserInfo.currentInfo.school = self.textFeild.text!
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                })
            })
        }
//        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showType == .Education || showType == .Sex || showType == .Major {
            return self.dateSource.objectlist.count
        }else{
            return 1
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 60
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        switch showType {
        case .UserName,.PhoneNumber,.Email,.RealName,.School:
            textFeild.text = text1
            cell?.addSubview(textFeild)
        default:
            break
        }
        if showType == .BirthDay {
            dataBtn.titleLabel?.text = text1
            dataBtn.addTarget(self, action: #selector(self.dataClick), forControlEvents: .TouchUpInside)
            cell?.addSubview(dataBtn)
        }else if showType == .Address{
            addressBtn.titleLabel?.text = text1
            addressBtn.addTarget(self, action: #selector(self.addressClick), forControlEvents: .TouchUpInside)
            cell?.addSubview(addressBtn)
        }else if showType == .Education || showType == .Sex || showType == .Major{
            let eduInfo  = self.dateSource.objectlist[indexPath.row]
            if eduInfo.name == "1" {
                cell?.textLabel?.text = "男"
            }else if eduInfo.name == "0"{
                cell?.textLabel?.text = "女"
            }else{
                cell?.textLabel?.text = eduInfo.name
            }
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if showType == .Education {
            handle!(changeType: showType,value: self.dateSource.objectlist[indexPath.row].name)
            mineHelper.changeEducation(self.dateSource.objectlist[indexPath.row].name, handle: {[unowned self] (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if success {
                        QCLoginUserInfo.currentInfo.education = self.dateSource.objectlist[indexPath.row].name
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                })
            })
        }else if showType == .Sex{
            if self.dateSource.objectlist[indexPath.row].name == "1" {
                handle!(changeType: showType,value: "男")
            }else{
                handle!(changeType: showType,value: "女")
            }
            mineHelper.changeUserSex(self.dateSource.objectlist[indexPath.row].name, handle: {[unowned self] (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if success {
                        QCLoginUserInfo.currentInfo.sex = self.dateSource.objectlist[indexPath.row].name
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                })
            })
        }else if showType == .Major {
            handle!(changeType: showType,value: self.dateSource.objectlist[indexPath.row].name)
            mineHelper.changeMajor(self.dateSource.objectlist[indexPath.row].name, handle: {[unowned self] (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if success {
                        QCLoginUserInfo.currentInfo.major = self.dateSource.objectlist[indexPath.row].name
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                })
            })
        }
        
    }
    
    func dataClick(){
        picker = DatePickerView.getShareInstance()
        picker!.textColor = UIColor.redColor()
        picker!.showWithDate(NSDate())
        picker?.block = {
            (date:NSDate)->() in
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd zzz"
            let string = formatter.stringFromDate(date)
            let range:Range = string.rangeOfString(" ")!
            let time = string.substringToIndex(range.endIndex)
            self.dataBtn.setTitle(time, forState: .Normal)
            self.dataBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
//            self.mineHelper.changeBirthday(self.dataBtn.currentTitle!, handle: { (success, response) in
//                dispatch_async(dispatch_get_main_queue(), { 
//                    QCLoginUserInfo.currentInfo.birthday = self.dataBtn.currentTitle!
//                })
//            })
        }
    }
    
    func addressClick(){
        let pick = AdressPickerView.shareInstance
        pick.showTown=true
        pick.pickArray=array
        pick.show((UIApplication.sharedApplication().keyWindow)!)
        pick.selectAdress { (dressArray) in
            self.array=dressArray
            self.addressBtn.setTitle("\(dressArray[0])-\(dressArray[1])-\(dressArray[2])", forState: .Normal)
            self.addressBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
            
        }
    }
    
    func dataGet(){
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.margin = 10.0
        hud.removeFromSuperViewOnHide = true
        
        let url = PARK_URL_Header+"getDictionaryList"
        let param = ["type":id]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            if(error != nil){
                hud.mode = MBProgressHUDMode.Text;
                hud.labelText = "数据获取失败"
                hud.hide(true, afterDelay: 1)
            }else{
                let status = EduModel(JSONDecoder(json!))
                // print("状态是")
                // print(status.status)
                if(status.status == "error"){
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = "数据获取失败"
                    hud.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){

                    hud.hide(true)
                    // print(status)
                    self.dateSource = EduList(status.data!)
                    
                    self.myTableView .reloadData()
                }
            }
        }
    }
}
