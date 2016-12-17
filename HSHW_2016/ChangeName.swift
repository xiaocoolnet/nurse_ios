//
//  ChangeName.swift
//  HSHW_2016
//
//  Created by JQ on 16/6/16.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
//import Alamofire

enum HSEditUserInfo {
    case avatar
    case userName
    case sex
    case phoneNumber
    case email
    case realName
    case birthDay
    case address
    case school
    case major
    case education
    case `default`
}

typealias ChangeUserItemHandle = (_ changeType:HSEditUserInfo,_ value:String)->()

class ChangeName: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var myTableView = UITableView()
    var mineHelper = HSMineHelper()
    var showType:HSEditUserInfo = .default
    var text1 = ""
    let textFeild = UITextField(frame: CGRect(x: 20,y: 15,width: 200,height: 30))
    var handle:ChangeUserItemHandle?
    
    let dataBtn = UIButton(frame: CGRect(x: 20,y: 15,width: 200,height: 30))
    let addressBtn = UIButton(frame: CGRect(x: 20,y: 15,width: 200,height: 30))
    var picker:DatePickerView?
    var pick:AdressPickerView?
    var array = NSArray()
    var id = String()
    var dateSource = EduList()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let line = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        //tableview
        myTableView.frame = CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-64-1)
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
        myTableView.tableFooterView = UIView()
        view.addSubview(myTableView)
            
        if showType == .education || showType == .sex || showType == .major {
            self.dataGet()
        }else{
            //nav
            let navBtn = UIButton(type: .custom)
            navBtn.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
            navBtn.setTitleColor(COLOR, for: UIControlState())
            navBtn.setTitle("保存", for: UIControlState())
            navBtn.addTarget(self, action: #selector(saveInfo), for: .touchUpInside)
            let navItem = UIBarButtonItem(customView: navBtn)
            self.navigationItem.rightBarButtonItem = navItem
        }
        
        array = ["北京市","北京市","朝阳区"]

    }
    
    func saveInfo(){
        if handle != nil {
            if showType == .birthDay {
                handle!(showType,(dataBtn.titleLabel?.text!)!)
            }else if showType == .address{
                handle!(showType,(addressBtn.titleLabel?.text!)!)
            }else{
                handle!(showType,textFeild.text!)
            }
        }
        if showType == .userName {
            
            if textFeild.text! == QCLoginUserInfo.currentInfo.userName {
                _ = self.navigationController?.popViewController(animated: true)
                return
            }else if unicodeLengthOfString(self.textFeild.text!) < 4 {
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.mode = .text
                hud.removeFromSuperViewOnHide = true

                hud.label.text = "用户名要大于4个字母或者2个汉字"
                
                hud.hide(animated: true, afterDelay: 1)
                return
            }
            mineHelper.changeUserName(textFeild.text!, handle: { (success, response) in
                DispatchQueue.main.async(execute: {
                    if success {
                        QCLoginUserInfo.currentInfo.userName = self.textFeild.text!
                        _ = self.navigationController?.popViewController(animated: true)
                    }else{
                        let responseStr = response as! String
                        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                        hud.mode = .text
                        hud.removeFromSuperViewOnHide = true
                        if responseStr == "用户名重复" {
                            hud.label.text = "用户名重复，请重新输入"
                        }else{
                            hud.label.text = responseStr
                        }
                        
                        hud.hide(animated: true, afterDelay: 1)
                    }
                })
            })
        }else if showType == .phoneNumber {
            mineHelper.changePhoneNumber(textFeild.text!, handle: { (success, response) in
                DispatchQueue.main.async(execute: {
                    if success {
                        QCLoginUserInfo.currentInfo.phoneNumber = self.textFeild.text!
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                })
                })
        }else if showType == .realName {
            mineHelper.changeUserRealName(textFeild.text!, handle: {(success, response) in
                DispatchQueue.main.async(execute: {
                    if success {
                        QCLoginUserInfo.currentInfo.realName = self.textFeild.text!
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                })
            })
        }else if showType == .email {
            mineHelper.changeEmail(textFeild.text!, handle: { (success, response) in
                DispatchQueue.main.async(execute: {
                    if success {
                        QCLoginUserInfo.currentInfo.email = self.textFeild.text!
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                })
            })
         }else if showType == .school {
            mineHelper.changeSchool(textFeild.text!, handle: {(success, response) in
                DispatchQueue.main.async(execute: {
                    if success {
                        QCLoginUserInfo.currentInfo.school = self.textFeild.text!
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                })
            })
        }
//        _ = self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: 限制输入字数
    func textFieldTextCount(_ textField: UITextField) -> Int {
        
        let lang = textInputMode?.primaryLanguage
        if lang == "zh-Hans" {
            return (textField.text?.characters.count ?? 0)!*2
        }
        else {
            return (textField.text?.characters.count ?? 0)!
        }

    }
    func unicodeLengthOfString(_ str:String) -> Int {
        
        let text = NSString(string: str)
        
        var asciiLength = 0
        
        for i in 0 ..< text.length {
            let uc = text.character(at: i)

            asciiLength += isascii(Int32(uc)) != 0 ? 1 : 2
        }
        
//        var unicodeLength = asciiLength/2
//        if asciiLength%2 != 0 {
//            unicodeLength += 1
//        }
        
        return asciiLength
    }
//    -(NSUInteger) unicodeLengthOfString: (NSString *) text {
//    NSUInteger asciiLength = 0;
//    
//    for (NSUInteger i = 0; i < text.length; i++) {
//    
//    
//    unichar uc = [text characterAtIndex: i];
//    
//    asciiLength += isascii(uc) ? 1 : 2;
//    }
//    
//    NSUInteger unicodeLength = asciiLength / 2;
//    
//    if(asciiLength % 2) {
//    unicodeLength++;
//    }
//    
//    return unicodeLength;
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showType == .education || showType == .sex || showType == .major {
            return self.dateSource.objectlist.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        switch showType {
        case .userName,.phoneNumber,.email,.realName,.school:
            textFeild.text = text1
            cell?.addSubview(textFeild)
        default:
            break
        }
        if showType == .birthDay {
            dataBtn.titleLabel?.text = text1
            dataBtn.addTarget(self, action: #selector(self.dataClick), for: .touchUpInside)
            cell?.addSubview(dataBtn)
        }else if showType == .address{
            addressBtn.titleLabel?.text = text1
            addressBtn.addTarget(self, action: #selector(self.addressClick), for: .touchUpInside)
            cell?.addSubview(addressBtn)
        }else if showType == .education || showType == .sex || showType == .major{
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if showType == .education {
            handle!(showType,self.dateSource.objectlist[indexPath.row].name)
            mineHelper.changeEducation(self.dateSource.objectlist[indexPath.row].name, handle: { (success, response) in
                DispatchQueue.main.async(execute: {
                    if success {
                        QCLoginUserInfo.currentInfo.education = self.dateSource.objectlist[indexPath.row].name
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                })
            })
        }else if showType == .sex{
            if self.dateSource.objectlist[indexPath.row].name == "1" {
                handle!(showType,"男")
            }else{
                handle!(showType,"女")
            }
            mineHelper.changeUserSex(self.dateSource.objectlist[indexPath.row].name, handle: { (success, response) in
                DispatchQueue.main.async(execute: {
                    if success {
                        QCLoginUserInfo.currentInfo.sex = self.dateSource.objectlist[indexPath.row].name
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                })
            })
        }else if showType == .major {
            handle!(showType,self.dateSource.objectlist[indexPath.row].name)
            mineHelper.changeMajor(self.dateSource.objectlist[indexPath.row].name, handle: { (success, response) in
                DispatchQueue.main.async(execute: {
                    if success {
                        QCLoginUserInfo.currentInfo.major = self.dateSource.objectlist[indexPath.row].name
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                })
            })
        }
        
    }
    
    func dataClick(){
        picker = DatePickerView.getShareInstance()
        picker!.textColor = UIColor.red
        picker!.showWithDate(Date())
        picker?.block = {
            (date:Date)->() in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd zzz"
            let string = formatter.string(from: date)
            let range:Range = string.range(of: " ")!
            let time = string.substring(to: range.upperBound)
            self.dataBtn.setTitle(time, for: UIControlState())
            self.dataBtn.setTitleColor(UIColor.black, for: UIControlState())
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
        pick.show((UIApplication.shared.keyWindow)!)
        pick.selectAdress { (dressArray) in
            self.array=dressArray
            self.addressBtn.setTitle("\(dressArray[0])-\(dressArray[1])-\(dressArray[2])", for: UIControlState())
            self.addressBtn.setTitleColor(UIColor.black, for: UIControlState())
            
        }
    }
    
    func dataGet(){
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.margin = 10.0
        hud.removeFromSuperViewOnHide = true
        
        let url = PARK_URL_Header+"getDictionaryList"
        let param = ["type":id]
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
//
//        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            if(error != nil){
                hud.mode = MBProgressHUDMode.text;
                hud.label.text = "数据获取失败"
                hud.hide(animated: true, afterDelay: 1)
            }else{
                let status = EduModel(JSONDecoder(json!))
                // print("状态是")
                // print(status.status)
                if(status.status == "error"){
                    hud.mode = MBProgressHUDMode.text;
                    hud.label.text = "数据获取失败"
                    hud.hide(animated: true, afterDelay: 1)
                }
                if(status.status == "success"){

                    hud.hide(animated: true)
                    // print(status)
                    self.dateSource = EduList(status.data!)
                    
                    self.myTableView .reloadData()
                }
            }
        }
    }
}
