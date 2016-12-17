//
//  PostVacancies.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/30.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


protocol PostVacanciesDelegate:NSObjectProtocol{
    func clickedSendBtn()
}

class PostVacancies: UIView,UITextViewDelegate,UITextFieldDelegate{
    
    weak var delegate:PostVacanciesDelegate?
    
    
    @IBOutlet weak var myScrollview: UIScrollView!
    @IBOutlet weak var bordView:UIView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var postNameField: UITextField!
    @IBOutlet weak var firmNameView: UIView!
    @IBOutlet weak var firmNameField: UITextField!
    @IBOutlet weak var resumeFeild: UITextField!
    @IBOutlet weak var linkmanField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var mailboxField: UITextField!
    @IBOutlet weak var workplaceBtn: UIButton!
    @IBOutlet weak var positionBtn: UIButton!
    var positionDrop = DropDown()
    @IBOutlet weak var conditionBtn: UIButton!
    
    var expDrop = DropDown()
    @IBOutlet weak var expBtn: UIButton!
    
    var coditionDrop = DropDown()
    @IBOutlet weak var treatmentBtn: UIButton!
    var treatmentDrop = DropDown()
    @IBOutlet weak var personBtn: UIButton!
    var personDrop = DropDown()
    @IBOutlet weak var moneyBtn: UIButton!
    var moneyDrop = DropDown()
    @IBOutlet weak var requestField: UITextView!
    @IBOutlet weak var requestLabel: UILabel!
    var selfNav:UINavigationController?
    
    @IBOutlet weak var placeLab_1: UILabel!
    @IBOutlet weak var placeImg_1: UIImageView!
    
    @IBOutlet weak var placeLab_2: UILabel!
    @IBOutlet weak var placeImg_2: UIImageView!
    
    @IBOutlet weak var placeLab_3: UILabel!
    @IBOutlet weak var placeImg_3: UIImageView!
    
    @IBOutlet weak var detailPlaceTF: UITextField!
    
    @IBOutlet weak var positionLab: UILabel!
    @IBOutlet weak var positionImg: UIImageView!
    
    @IBOutlet weak var conditionLab: UILabel!
    @IBOutlet weak var conditionImg: UIImageView!
    
    
    @IBOutlet weak var expLab: UILabel!
    @IBOutlet weak var expImg: UIImageView!
    
    @IBOutlet weak var treatmentLab: UILabel!
    @IBOutlet weak var treatmentImg: UIImageView!
    
    @IBOutlet weak var personLab: UILabel!
    @IBOutlet weak var personImg: UIImageView!
    
    @IBOutlet weak var moneyLab: UILabel!
    
    @IBOutlet weak var moneyImg: UIImageView!
    
    var dropDownDic = [String:Array<String>]()

    var array = NSArray()
    
    let coverView = UIButton()
    
    var getDicFlag = 0
    var getDicCheckFlag = 0
    
    var mainHud = MBProgressHUD()
    
    var alreadyCertify = true {
        didSet {
            if alreadyCertify {
                coverView.frame = CGRect(x: 0, y: 90, width: WIDTH, height: 45*4)
                coverView.addTarget(self, action: #selector(coverBtnClick), for: .touchUpInside)
                self.myScrollview.addSubview(coverView)
                
            }else{
                coverView.removeFromSuperview()
            }
        }
    }
    
    func coverBtnClick() {
        // 重新认证
        let alert = UIAlertController(title: "您已进行企业认证", message: "如需修改企业信息，请到我的招聘中重新认证", preferredStyle: .alert)
        UIApplication.shared.keyWindow?.rootViewController!.present(alert, animated: true, completion: nil)
        
        let doneAction = UIAlertAction(title: "确定", style: .default, handler: nil)
        alert.addAction(doneAction)
        

    }
   
    @IBAction func sendBtnClicked(_ sender: AnyObject) {
        //        if delegate != nil {
        
        if postNameField.text != "" && firmNameField.text != "" && resumeFeild.text != "" && linkmanField.text != "" && phoneField.text != "" && workplaceBtn.isSelected && detailPlaceTF.text != "" && positionBtn.isSelected && conditionBtn.isSelected &&  expBtn.isSelected && treatmentBtn.isSelected && personBtn.isSelected && moneyBtn.isSelected && requestField.text != "" {
            
            
            if !PhoneNumberIsValidated(phoneField.text!) {
                
                var messageStr = "请填写正确的电话号码"
                
                if phoneField.text!.hasPrefix("0") {
                    messageStr = "请填写正确的电话号码\n区号与座机号之间用-隔开"
                }else if 7 <= phoneField.text!.characters.count && phoneField.text!.characters.count <= 8 && phoneField.text?.trimmingCharacters(in: CharacterSet.decimalDigits).characters.count <= 0 {
                    messageStr = "请填写正确的电话号码\n（包含区号）"
                }
                
                
                
                let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString(messageStr, comment: "empty message"), preferredStyle: .alert)
                let doneAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                alertController.addAction(doneAction)
                
                UIApplication.shared.keyWindow?.rootViewController!.present(alertController, animated: true, completion: nil)

                return
            }
            if !EmailIsValidated(mailboxField.text!) {
                let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("请填写正确的邮箱地址", comment: "empty message"), preferredStyle: .alert)
                let doneAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                alertController.addAction(doneAction)
                
                UIApplication.shared.keyWindow?.rootViewController!.present(alertController, animated: true, completion: nil)

                return
            }

            
            let hud = MBProgressHUD.showAdded(to: self, animated: true)
            //                hud.mode = MBProgressHUDMode.Text;
            hud?.labelText = "正在提交"
            hud?.margin = 10.0
            hud?.removeFromSuperViewOnHide = true
            hud?.hide(true, afterDelay: 1)
            
            HSNurseStationHelper().publishJob(firmNameField.text!, companyinfo: resumeFeild.text!, linkman: linkmanField.text!, phone: phoneField.text!, email: mailboxField.text!, title: postNameField.text!, jobtype: positionLab.text!, education: conditionLab.text!, experience: expLab.text!, welfare: treatmentLab.text!, address: placeLab_1.text!+"-"+placeLab_2.text!+"-"+placeLab_3.text!+" "+detailPlaceTF.text!, count: personLab.text!, salary: moneyLab.text!, description: requestField.text) { (success, response) in
                // print(success)
                
                if success {
                    
                    hud?.mode = MBProgressHUDMode.text;
                    hud?.labelText = "提交成功"
                    hud?.hide(true, afterDelay: 1)
                    
                    self.selfNav?.popViewController(animated: true)
                    //                        self.delegate?.clickedSendBtn()
                    
                    
                    //提交后还原表格样式
                    self.firmNameField.text = nil
                    self.resumeFeild.text = nil
                    self.linkmanField.text = nil
                    self.phoneField.text = nil
                    self.mailboxField.text = nil
                    self.postNameField.text = nil
                    
                    //        positionBtn.setTitle("请选择工作地点", forState: .Normal)
                    //        conditionBtn.setTitle("请选择招聘职位", forState: .Normal)
                    //        treatmentBtn.setTitle("请选择招聘条件", forState: .Normal)
                    //        workplaceBtn.setTitle("请选择福利待遇", forState: .Normal)
                    //        personBtn.setTitle("请选择招聘人数", forState: .Normal)
                    //        moneyBtn.setTitle("请选择薪资待遇", forState: .Normal)
                    
                    self.positionLab.text = "主管护士"
                    self.conditionLab.text = "研究生"
                    self.expLab.text = "不限"
                    self.treatmentLab.text = "五险一金"
                    self.placeLab_1.text = "北京市"
                    self.placeLab_2.text = "北京市"
                    self.placeLab_3.text = "朝阳区"
                    self.personLab.text = "10人以上"
                    self.moneyLab.text = "面议"
                    self.requestField.text = nil
                    self.requestLabel.text = "职位要求"
                }else {
                    hud?.hide(true)
                    let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("网络错误，请重试", comment: "empty message"), preferredStyle: .alert)
                    let doneAction = UIAlertAction(title: "重试", style: .default, handler: { (action) in
                        self.sendBtnClicked(sender)
                    })
                    alertController.addAction(doneAction)
                    
                    let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    
                    let vc = self.responderVC()
                    vc!.present(alertController, animated: true, completion: nil)
                }
                
            }
            
            
        }else{
            
            //                if postNameField.text == "" {
            //                    postNameField.layer.borderColor = UIColor.redColor().CGColor
            //                    postNameField.layer.masksToBounds = true
            //                    postNameField.layer.borderWidth = 1.0
            //                    postNameField.layer.cornerRadius = 2
            //                }
            //                if firmNameField.text == "" {
            //                    firmNameField.layer.borderColor = UIColor.redColor().CGColor
            //                    firmNameField.layer.masksToBounds = true
            //                    firmNameField.layer.borderWidth = 1.0
            //                    firmNameField.layer.cornerRadius = 2
            //
            //                }
            //                if resumeFeild.text == "" {
            //                    resumeFeild.layer.borderColor = UIColor.redColor().CGColor
            //                    resumeFeild.layer.masksToBounds = true
            //                    resumeFeild.layer.borderWidth = 1.0
            //                    resumeFeild.layer.cornerRadius = 2
            //                }
            //                if phoneField.text == "" {
            //                    phoneField.layer.borderColor = UIColor.redColor().CGColor
            //                    phoneField.layer.masksToBounds = true
            //                    phoneField.layer.borderWidth = 1.0
            //                    phoneField.layer.cornerRadius = 2
            //                }
            //                if mailboxField.text == "" {
            //                    mailboxField.layer.borderColor = UIColor.redColor().CGColor
            //                    mailboxField.layer.masksToBounds = true
            //                    mailboxField.layer.borderWidth = 1.0
            //                    mailboxField.layer.cornerRadius = 2
            //                }
            
            let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("请完善招聘信息", comment: "empty message"), preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertController.addAction(doneAction)
            
            let vc = responderVC()
            vc!.present(alertController, animated: true, completion: nil)
        }

    }
    
    func responderVC() -> (UIViewController?) {
        var temp:AnyObject
        temp = next!
        while ((temp is UIViewController) != true) {
            temp = temp.next!!
        }
        return temp as? UIViewController
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //        getCompanyStatus()
        // 设置下拉列表样式
        customizeDropDown()
        
        sendBtn.layer.borderColor = COLOR.cgColor
        sendBtn.layer.borderWidth = 1
        sendBtn.layer.cornerRadius = sendBtn.frame.height/2
        
        bordView.layer.borderColor = UIColor.init(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1).cgColor
        bordView.layer.borderWidth = 1
        
        
        array = ["北京市","北京市","朝阳区"]
        
        requestField.delegate = self
        
        firmNameField.delegate = self
        resumeFeild.delegate = self
        linkmanField.delegate = self
        phoneField.delegate = self
        mailboxField.delegate = self
        postNameField.delegate = self
        
        //        dropDownDic = ["position":["职位1","职位2"],"condition":["条件1","条件2"],"treatment":["福利1","福利2"],"person":["人数1","人数2"],"money":["薪资1","薪资2"]]
        //        setDropDownMenu()
        
        if (UIApplication.shared.keyWindow != nil) {
            
            let tabBar = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
            selfNav = tabBar.selectedViewController as? UINavigationController
            
            mainHud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow, animated: true)
            mainHud.labelText = "正在获取招聘信息"
            mainHud.removeFromSuperViewOnHide = true
        }
        
        getDictionaryList("7", key: "position")
        getDictionaryList("8", key: "condition")
        getDictionaryList("9", key: "treatment")
        getDictionaryList("10", key: "person")
        getDictionaryList("11", key: "money")
        getDictionaryList("15", key: "experience")
        
        firmNameField.borderStyle = .none
        resumeFeild.borderStyle = .none
        linkmanField.borderStyle = .none
        phoneField.borderStyle = .none
        mailboxField.borderStyle = .none
        postNameField.borderStyle = .none
        
        detailPlaceTF.borderStyle = .none
        
        
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HSPostDetailViewController.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        //
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HSPostDetailViewController.keyboardWillDisappear(_:)), name:UIKeyboardWillHideNotification, object: nil)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        print("1234567890-")

    }
    
    func getDictionaryList(_ type:String, key:String) {
        
        dropDownDic[key] = Array<String>()
        
        let url = PARK_URL_Header+"getDictionaryList"
        let param = ["type":type]
        // print(param)
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            self.getDicCheckFlag += 1
            // print("self.getDicCheckFlag  ===  ",self.getDicCheckFlag)
            if(error != nil){
                
            }else{
                let status = EduModel(JSONDecoder(json!))
                // print("状态是")
                // print(status.status)
                if(status.status == "error"){
                    
                }
                if(status.status == "success"){
                    // print(status)
                    self.getDicFlag += 1
                    for obj in EduList(status.data!).objectlist {
                        self.dropDownDic[key]!.append(obj.name)
                    }
                    if self.getDicCheckFlag == 6 {
                        // print("self.getDicFlag  ===  ",self.getDicFlag)
                        
                        if self.getDicFlag == 6 {
                            self.setDropDownMenu()
                            self.getDicFlag = 0
                            self.getDicCheckFlag = 0
                        }else{
                            self.getDicFlag = 0
                            self.getDicCheckFlag = 0
                            self.getDictionaryList("7", key: "position")
                            self.getDictionaryList("8", key: "condition")
                            self.getDictionaryList("9", key: "treatment")
                            self.getDictionaryList("10", key: "person")
                            self.getDictionaryList("11", key: "money")
                            self.getDictionaryList("15", key: "experience")

                        }
                    }
                }else{
                }
            }
            
        }
    }
    
    // MARK: 获取企业认证状态
    func getCompanyStatus() {
        HSMineHelper().getCompanyCertify { (success, response) in
            // print("1234567890====== \(String(describing: response))")
            if success {
//                hud.mode = MBProgressHUDMode.Text
//                hud.labelText = "获取企业认证状态成功"
//                hud.hide(true, afterDelay: 0.5)
                let companyInfo = response as! CompanyInfo
                switch companyInfo.status! {
                case "1":
                    self.firmNameField.text = companyInfo.companyname
                    self.resumeFeild.text = companyInfo.companyinfo
                    self.linkmanField.text = companyInfo.linkman
                    self.phoneField.text = companyInfo.phone
                    self.mailboxField.text = companyInfo.email
                    
                default:
                    break
                }
            }else{
//                hud.mode = MBProgressHUDMode.Text
//                hud.labelText = "获取企业认证状态失败"
//                hud.hide(true)
                
//                let alert = UIAlertController(title: nil, message: "获取企业认证状态失败", preferredStyle: .Alert)
//                self.presentViewController(alert, animated: true, completion: nil)
//                
//                let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: { (action) in
//                    //                        self.presentViewController(previousMenuController, animated: true, completion: nil)
//                    //                        self.willMoveToPageMenuController(previousMenuController, previousMenuController: menuController)
//                })
//                alert.addAction(cancelAction)
//                
//                let replyAction = UIAlertAction(title: "重试", style: .Default, handler: { (action) in
//                    self.willMoveToPageMenuController(menuController, previousMenuController: previousMenuController)
//                })
//                alert.addAction(replyAction)
            }
        }
    }
    
    // MARK:设置下拉列表
    func setDropDownMenu() {
        
        // 职位
        positionDrop.anchorView = positionBtn
        
        positionDrop.bottomOffset = CGPoint(x: 0, y: positionBtn.bounds.height)
        positionDrop.width = 200
        positionDrop.direction = .bottom
        
        positionDrop.dataSource = dropDownDic["position"]!
//        self.positionLab.text = dropDownDic["position"]?.first
//        self.positionLab.sizeToFit()
//        self.positionLab.center.y = self.positionBtn.center.y
//        self.positionImg.frame.origin.x = CGRectGetMaxX(self.positionLab.frame)+5
        
        // 下拉列表选中后的回调方法
        positionDrop.selectionAction = { (index, item) in
            
            self.positionLab.text = item
            self.positionLab.sizeToFit()
            self.positionLab.center.y = self.positionBtn.center.y
            self.positionImg.frame.origin.x = self.positionLab.frame.maxX+5
            
//            self.eduLab.text = item
//            self.eduLab.sizeToFit()
//            self.eduImg.frame.origin.x = CGRectGetMaxX(self.eduLab.frame)+5
//            
//            self.dropDownFinishDic["edu"] = item
        }
        
        // 条件
        coditionDrop.anchorView = conditionBtn
        
        coditionDrop.bottomOffset = CGPoint(x: 0, y: conditionBtn.bounds.height)
        coditionDrop.width = 200
        coditionDrop.direction = .bottom
        
        coditionDrop.dataSource = dropDownDic["condition"]!
//        self.conditionLab.text = dropDownDic["condition"]?.first
//        self.conditionLab.sizeToFit()
//        self.conditionLab.center.y = self.conditionBtn.center.y
//        self.conditionImg.frame.origin.x = CGRectGetMaxX(self.conditionLab.frame)+5
        
        // 下拉列表选中后的回调方法
        coditionDrop.selectionAction = { (index, item) in
            
            self.conditionBtn.isSelected = true
            self.conditionLab.text = item
            self.conditionLab.sizeToFit()
            self.conditionLab.center.y = self.conditionBtn.center.y
            self.conditionImg.frame.origin.x = self.conditionLab.frame.maxX+5
        }
        
        // 经验
        expDrop.anchorView = expBtn
        
        expDrop.bottomOffset = CGPoint(x: 0, y: expBtn.bounds.height)
        expDrop.width = 200
        expDrop.direction = .bottom
        
        expDrop.dataSource = dropDownDic["experience"]!
        //        self.conditionLab.text = dropDownDic["condition"]?.first
        //        self.conditionLab.sizeToFit()
        //        self.conditionLab.center.y = self.conditionBtn.center.y
        //        self.conditionImg.frame.origin.x = CGRectGetMaxX(self.conditionLab.frame)+5
        
        // 下拉列表选中后的回调方法
        expDrop.selectionAction = { (index, item) in
            
            self.expBtn.isSelected = true
            self.expLab.text = item
            self.expLab.sizeToFit()
            self.expLab.center.y = self.expBtn.center.y
            self.expImg.frame.origin.x = self.expLab.frame.maxX+5
        }

        // 福利待遇
        treatmentDrop.anchorView = treatmentBtn
        
        treatmentDrop.bottomOffset = CGPoint(x: 0, y: treatmentBtn.bounds.height)
        treatmentDrop.width = 200
        treatmentDrop.direction = .bottom
        
        treatmentDrop.dataSource = dropDownDic["treatment"]!
//        self.treatmentLab.text = dropDownDic["treatment"]?.first
//        self.treatmentLab.sizeToFit()
//        self.treatmentLab.center.y = self.treatmentBtn.center.y
//        self.treatmentImg.frame.origin.x = CGRectGetMaxX(self.treatmentLab.frame)+5
        
        // 下拉列表选中后的回调方法
        treatmentDrop.selectionAction = { (index, item) in
            
            self.treatmentBtn.isSelected = true
            
            self.treatmentLab.text = item
            self.treatmentLab.sizeToFit()
            self.treatmentLab.center.y = self.treatmentBtn.center.y
            self.treatmentImg.frame.origin.x = self.treatmentLab.frame.maxX+5
        }
        
        // 招聘人数
        personDrop.anchorView = personBtn
        
        personDrop.bottomOffset = CGPoint(x: 0, y: personBtn.bounds.height)
        personDrop.width = 200
        personDrop.direction = .bottom
        
        personDrop.dataSource = dropDownDic["person"]!
//        self.personLab.text = dropDownDic["person"]?.first
//        self.personLab.sizeToFit()
//        self.personLab.center.y = self.personBtn.center.y
//        self.personImg.frame.origin.x = CGRectGetMaxX(self.personLab.frame)+5

        // 下拉列表选中后的回调方法
        personDrop.selectionAction = { (index, item) in
            
            self.personBtn.isSelected = true
            
            self.personLab.text = item
            self.personLab.sizeToFit()
            self.personLab.center.y = self.personBtn.center.y
            self.personImg.frame.origin.x = self.personLab.frame.maxX+5
        }
        
        // 薪资待遇
        moneyDrop.anchorView = moneyBtn
        
        moneyDrop.bottomOffset = CGPoint(x: 0, y: moneyBtn.bounds.height)
        moneyDrop.width = 200
        moneyDrop.direction = .bottom
        
        moneyDrop.dataSource = dropDownDic["money"]!
//        self.moneyLab.text = dropDownDic["money"]?.first
//        self.moneyLab.sizeToFit()
//        self.moneyLab.center.y = self.moneyBtn.center.y
//        self.moneyImg.frame.origin.x = CGRectGetMaxX(self.moneyLab.frame)+5

        // 下拉列表选中后的回调方法
        moneyDrop.selectionAction = { (index, item) in
            
            self.moneyBtn.isSelected = true
            
            self.moneyLab.text = item
            self.moneyLab.sizeToFit()
            self.moneyLab.center.y = self.moneyBtn.center.y
            self.moneyImg.frame.origin.x = self.moneyLab.frame.maxX+5
        }
        
        mainHud.hide(true)
    }
    
    // MARK:自定义下拉列表样式
    func customizeDropDown() {
        let appearance = DropDown.appearance()
        
        appearance.cellHeight = 60
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        //		appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.cornerRadiu = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = .darkGray
        //		appearance.textFont = UIFont(name: "Georgia", size: 14)
    }

    @IBAction func workplaceBtnClick(_ sender: AnyObject) {

        
        postNameField.resignFirstResponder()
        firmNameField.resignFirstResponder()
        resumeFeild.resignFirstResponder()
        linkmanField.resignFirstResponder()
        phoneField.resignFirstResponder()
        mailboxField.resignFirstResponder()
        requestField.resignFirstResponder()
        
        // 初始化
        
        let pick = AdressPickerView.shareInstance
        
        // 设置是否显示区县等，默认为false不显示
        pick.showTown=true
        pick.pickArray=array // 设置第一次加载时需要跳转到相对应的地址

        pick.show((UIApplication.shared.keyWindow)!)
        // 选择完成之后回调
        pick.selectAdress { (dressArray) in
            
            self.array=dressArray
            // print("选择的地区是: \(dressArray)")

            self.placeLab_1.text =  (dressArray[0] as! String)
            self.placeLab_2.text =  (dressArray[1] as! String)
            self.placeLab_3.text =  (dressArray[2] as! String)
            
//            self.placeLab_1.enabled = true
//            self.placeLab_2.enabled = true
//            self.placeLab_3.enabled = true
            
            self.placeLab_1.sizeToFit()
            self.placeLab_1.center.y = self.placeImg_1.center.y
            self.placeImg_1.frame.origin.x = self.placeLab_1.frame.maxX+5
            
            
            self.placeLab_2.frame.origin.x = self.placeImg_1.frame.maxX+5
//            self.placeLab_2.adjustsFontSizeToFitWidth = true
            self.placeLab_2.sizeToFit()
            self.placeLab_2.center.y = self.placeLab_1.center.y
            self.placeImg_2.frame.origin.x = self.placeLab_2.frame.maxX+5
            
            self.placeLab_3.frame.origin.x = self.placeImg_2.frame.maxX+5
//            self.placeLab_3.adjustsFontSizeToFitWidth = true
            self.placeLab_3.sizeToFit()
            self.placeLab_3.center.y = self.placeLab_1.center.y
            self.placeImg_3.frame.origin.x = self.placeLab_3.frame.maxX+5
            
            (sender as! UIButton).isSelected = true
        }
        
    }
    
//    // 招聘职位等选择完成后的回调
//    func  changeWord(controller:HSStateEditResumeController,string:String){
//        switch controller.portType {
//            case PortType.position:
//                positionLab.text = string
//                positionLab.enabled = true
//                positionLab.sizeToFit()
//                positionImg.frame = CGRectMake(CGRectGetMaxX(positionLab.frame), positionImg.frame.origin.y, 12, 12)
//            case PortType.condition:
//                conditionLab.text = string
//                conditionLab.enabled = true
//                conditionLab.sizeToFit()
//                conditionImg.frame = CGRectMake(CGRectGetMaxX(conditionLab.frame), conditionImg.frame.origin.y, 12, 12)
//            case PortType.welfare:
//                treatmentLab.text = string
//                treatmentLab.enabled = true
//                treatmentLab.sizeToFit()
//                treatmentImg.frame = CGRectMake(CGRectGetMaxX(treatmentLab.frame), treatmentImg.frame.origin.y, 12, 12)
//            case PortType.number:
//                personLab.text = string
//                personLab.enabled = true
//                personLab.sizeToFit()
//                personImg.frame = CGRectMake(CGRectGetMaxX(personLab.frame), personImg.frame.origin.y, 12, 12)
//            case PortType.money:
//                moneyLab.text = string
//                moneyLab.enabled = true
//                moneyLab.sizeToFit()
//                moneyImg.frame = CGRectMake(CGRectGetMaxX(moneyLab.frame), moneyImg.frame.origin.y, 12, 12)
//            default:
//                // print("defaut")
//        }
//    }

    
    @IBAction func positionBtnClick(_ sender: AnyObject) {
        
        resignTextFieldFirstResponder()

//        listShow(sender as! UIView, andType: PortType.position)
        positionDrop.show()
        positionBtn.isSelected = true
        positionBtn.tintColor = UIColor.clear
    }
    
    @IBAction func conditionBtnClick(_ sender: AnyObject) {
        
        resignTextFieldFirstResponder()

//        listShow(sender as! UIView, andType: PortType.condition)
        coditionDrop.show()
        conditionBtn.isSelected = true
        conditionBtn.tintColor = UIColor.clear
    }
    
    @IBAction func expBtnClick(_ sender: AnyObject) {
        
        resignTextFieldFirstResponder()
        
        //        listShow(sender as! UIView, andType: PortType.condition)
        expDrop.show()
        expBtn.isSelected = true
        expBtn.tintColor = UIColor.clear
    }
    @IBAction func treatmentBtnClick(_ sender: AnyObject) {
        
        resignTextFieldFirstResponder()

//        listShow(sender as! UIView, andType: PortType.welfare)
        treatmentDrop.show()
        treatmentBtn.isSelected = true
        treatmentBtn.tintColor = UIColor.clear
    }
    
    @IBAction func personBtnClick(_ sender: AnyObject) {
        
        resignTextFieldFirstResponder()

//        listShow(sender as! UIView, andType: PortType.number)
        personDrop.show()
        personBtn.isSelected = true
        personBtn.tintColor = UIColor.clear
    }
    
    @IBAction func moneyBtnClick(_ sender: AnyObject) {
        
        resignTextFieldFirstResponder()
        
//        listShow(sender as! UIView, andType: PortType.money)
        moneyDrop.show()
        moneyBtn.isSelected = true
        moneyBtn.tintColor = UIColor.clear
    }
    
    // 放弃textField的第一响应
    func resignTextFieldFirstResponder() {
        postNameField.resignFirstResponder()
        firmNameField.resignFirstResponder()
        resumeFeild.resignFirstResponder()
        linkmanField.resignFirstResponder()
        phoneField.resignFirstResponder()
        mailboxField.resignFirstResponder()
        requestField.resignFirstResponder()
    }
    
    var bgView = UIView()
    
//    var chooseTableView = UITableView()
    var chooseList = EduList()
    
    var portType: PortType = .defaut
    
    func listShow(_ onView:UIView, andType type:PortType) {
        portType = type
        dataGet(type)
        bgView.frame = CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT)
        self.myScrollview.addSubview(bgView)
        
//        chooseTableView = UITableView.init(frame: CGRectMake(CGRectGetMinX(onView.frame)+20, CGRectGetMaxY(onView.superview!.frame), CGRectGetWidth(onView.frame)-20, 108), style: .Plain)
//        chooseTableView.backgroundColor = UIColor.whiteColor()
//        chooseTableView.layer.borderWidth = 1
//        chooseTableView.layer.borderColor = UIColor.lightGrayColor().CGColor
//        chooseTableView.delegate = self
//        chooseTableView.dataSource = self
//        chooseTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        chooseTableView.bounces = false
//        self.myScrollview.addSubview(chooseTableView)
    }
    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return chooseList.objectlist.count
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell  {
//        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
////        cell.selectionStyle = .None
//        
//        let eduInfo  = self.chooseList.objectlist[indexPath.row]
//        cell.textLabel?.text = eduInfo.name
//        
//        return cell
//    }
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        // print(1111)
//        let eduInfo = self.chooseList.objectlist[indexPath.row]
//        QCLoginUserInfo.currentInfo.education = eduInfo.name
//        // print(eduInfo.name)
//        chooseTableView.removeFromSuperview()
//        bgView.removeFromSuperview()
//        
//        let string = eduInfo.name
//        
//        switch portType {
//        case PortType.position:
//            positionLab.text = string
//            positionLab.enabled = true
//            positionLab.sizeToFit()
//            positionImg.frame = CGRectMake(CGRectGetMaxX(positionLab.frame), positionImg.frame.origin.y, 12, 12)
//        case PortType.condition:
//            conditionLab.text = string
//            conditionLab.enabled = true
//            conditionLab.sizeToFit()
//            conditionImg.frame = CGRectMake(CGRectGetMaxX(conditionLab.frame), conditionImg.frame.origin.y, 12, 12)
//        case PortType.welfare:
//            treatmentLab.text = string
//            treatmentLab.enabled = true
//            treatmentLab.sizeToFit()
//            treatmentImg.frame = CGRectMake(CGRectGetMaxX(treatmentLab.frame), treatmentImg.frame.origin.y, 12, 12)
//        case PortType.number:
//            personLab.text = string
//            personLab.enabled = true
//            personLab.sizeToFit()
//            personImg.frame = CGRectMake(CGRectGetMaxX(personLab.frame), personImg.frame.origin.y, 12, 12)
//        case PortType.money:
//            moneyLab.text = string
//            moneyLab.enabled = true
//            moneyLab.sizeToFit()
//            moneyImg.frame = CGRectMake(CGRectGetMaxX(moneyLab.frame), moneyImg.frame.origin.y, 12, 12)
//        default:
//            // print("defaut")
//        }
//    }
    
    func dataGet(_ portType:PortType){
        
        let url = PARK_URL_Header+"getDictionaryList"
        var param = ["type":"1"]
        
        switch portType {
        case .position:
            param = ["type":"7"]
        case .condition:
            param = ["type":"8"]
        case .welfare:
            param = ["type":"9"]
        case .number:
            param = ["type":"10"]
        case .money:
            param = ["type":"11"]
        default: break
            // print("defaut")
        }
        // print(param)
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            if(error != nil){
                
            }else{
                let status = EduModel(JSONDecoder(json!))
                // print("状态是")
                // print(status.status)
                if(status.status == "error"){
                    let hud = MBProgressHUD.showAdded(to: self, animated: true)
                    hud?.mode = MBProgressHUDMode.text;
                    hud?.margin = 10.0
                    hud?.removeFromSuperViewOnHide = true
                    hud?.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                    // print(status)
                    self.chooseList = EduList(status.data!)
                    
//                    self.chooseTableView .reloadData()
                }
            }
            
        }
        
    }
    
    
    
    // MARK: 监控键盘弹起落下
    var keyboardHeight:CGFloat = 0.0
    var flag = true // 防止键盘弹起方法走两次
    
    func keyboardWillAppear(_ notification: Notification) {
        
        // 获取键盘信息
        let keyboardinfo = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]
        
        let keyboardheight:CGFloat = ((keyboardinfo as AnyObject).cgRectValue.size.height)
        if requestField.isFirstResponder && flag {
            
            UIView.animate(withDuration: 0.3, animations: {
                //                self.myScrollView.contentOffset = CGPoint.init(x: 0, y: self.myScrollView.contentSize.height-self.myScrollView.frame.size.height+keyboardheight)
                //                self.myScrollView.frame = CGRectMake(self.myScrollView.frame.origin.x, self.myScrollView.frame.origin.y, self.myScrollView.frame.size.width, self.myScrollView.frame.size.height-keyboardheight)
                self.myScrollview.frame.size.height = self.myScrollview.frame.size.height-keyboardheight
                self.myScrollview.contentOffset.y = self.myScrollview.contentSize.height-self.myScrollview.frame.size.height
                self.keyboardHeight = keyboardheight
                self.flag = false
            }) 
        }
        
        // print("键盘弹起")
        // print(keyboardheight)
        
    }
    
    func keyboardWillDisappear(_ notification:Notification){
        
        if self.myScrollview.frame.size.height<=HEIGHT-64-keyboardHeight {
            
            UIView.animate(withDuration: 0.3, animations: {
                //            self.myScrollview.contentOffset = CGPoint.init(x: 0, y: self.myScrollview.contentSize.height-self.myScrollview.frame.size.height)
                
                self.myScrollview.frame.size.height = self.myScrollview.frame.size.height+self.keyboardHeight
                self.flag = true
            }) 
        }
        // print("键盘落下")
    }

    
    //MARK:UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        if (textView.text == "") {
            requestLabel.text = "职位要求"
        }else{
            requestLabel.text = ""
        }
    }
    
//    // MARK: uitextfiled  delegate
//    func textFieldDidBeginEditing(textField: UITextField) {
//        textField.layer.borderColor = UIColor.clearColor().CGColor
//    }
    
}
