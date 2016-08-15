//
//  PostVacancies.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/30.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

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
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var mailboxField: UITextField!
    @IBOutlet weak var workplaceBtn: UIButton!
    @IBOutlet weak var positionBtn: UIButton!
    var positionDrop = DropDown()
    @IBOutlet weak var conditionBtn: UIButton!
    var coditionDrop = DropDown()
    @IBOutlet weak var treatmentBtn: UIButton!
    var treatmentDrop = DropDown()
    @IBOutlet weak var personBtn: UIButton!
    var personDrop = DropDown()
    @IBOutlet weak var moneyBtn: UIButton!
    var moneyDrop = DropDown()
    @IBOutlet weak var requestField: UITextView!
    @IBOutlet weak var requestLabel: UILabel!
    let helper = HSNurseStationHelper()
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
    
    @IBOutlet weak var treatmentLab: UILabel!
    @IBOutlet weak var treatmentImg: UIImageView!
    
    @IBOutlet weak var personLab: UILabel!
    @IBOutlet weak var personImg: UIImageView!
    
    @IBOutlet weak var moneyLab: UILabel!
    
    @IBOutlet weak var moneyImg: UIImageView!
    
    var dropDownDic = [String:Array<String>]()

    var array = NSArray()
    
    let coverView = UIButton()
    
    var alreadyCertify = true {
        didSet {
            if alreadyCertify {
                coverView.frame = CGRectMake(0, 90, WIDTH, 45*4)
                coverView.addTarget(self, action: #selector(coverBtnClick), forControlEvents: .TouchUpInside)
                self.myScrollview.addSubview(coverView)
                
            }else{
                coverView.removeFromSuperview()
            }
        }
    }
    
    func coverBtnClick() {
        // 重新认证
        let alert = UIAlertController(title: "您已进行企业认证", message: "如需修改企业信息，请到我的招聘中重新认证", preferredStyle: .Alert)
        UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(alert, animated: true, completion: nil)
        
        let doneAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
        alert.addAction(doneAction)
        

    }
   
    @IBAction func sendBtnClicked(sender: AnyObject) {
//        if delegate != nil {
        
            if postNameField.text != "" && firmNameField.text != "" && resumeFeild.text != "" && phoneField.text != "" && mailboxField.text != "" && workplaceBtn.selected && detailPlaceTF.text != "" && positionBtn.selected && conditionBtn.selected && treatmentBtn.selected && personBtn.selected && moneyBtn.selected && requestField.text != "" {
                
                let hud = MBProgressHUD.showHUDAddedTo(self, animated: true)
//                hud.mode = MBProgressHUDMode.Text;
                hud.labelText = "正在提交"
                hud.margin = 10.0
                hud.removeFromSuperViewOnHide = true
                hud.hide(true, afterDelay: 1)
                
                helper.publishJob(firmNameField.text!, companyinfo: resumeFeild.text!, phone: phoneField.text!, email: mailboxField.text!, title: postNameField.text!, jobtype: positionLab.text!, education: conditionLab.text!, welfare: treatmentLab.text!, address: placeLab_1.text!+placeLab_2.text!+placeLab_3.text!+detailPlaceTF.text!, count: personLab.text!, salary: moneyLab.text!, description: requestField.text) { (success, response) in
                    print(success)
                    
                    if success {
                        
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = "提交成功"
                        hud.hide(true, afterDelay: 1)
                        
                        self.selfNav?.popViewControllerAnimated(true)
//                        self.delegate?.clickedSendBtn()
                        
                        
                        //提交后还原表格样式
                        self.firmNameField.text = nil
                        self.resumeFeild.text = nil
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
                        self.treatmentLab.text = "五险一金"
                        self.placeLab_1.text = "北京市"
                        self.placeLab_2.text = "北京市"
                        self.placeLab_3.text = "朝阳区"
                        self.personLab.text = "10人以上"
                        self.moneyLab.text = "面议"
                        self.requestField.text = nil
                        self.requestLabel.text = "职位要求"
                    }else {
                        hud.hide(true)
                        let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("网络错误，请重试", comment: "empty message"), preferredStyle: .Alert)
                        let doneAction = UIAlertAction(title: "重试", style: .Default, handler: { (action) in
                            self.sendBtnClicked(sender)
                        })
                        alertController.addAction(doneAction)
                        
                        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        
                        let vc = self.responderVC()
                        vc!.presentViewController(alertController, animated: true, completion: nil)
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
                
                let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("请完善招聘信息", comment: "empty message"), preferredStyle: .Alert)
                let doneAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
                alertController.addAction(doneAction)
                
                let vc = responderVC()
                vc!.presentViewController(alertController, animated: true, completion: nil)
            }
//        }
        
//        print(firmNameField.text!,resumeFeild.text!,phoneField.text!,mailboxField.text!,postNameField.text!,"1",conditionBtn.currentTitle!,treatmentBtn.currentTitle!,workplaceBtn.currentTitle!,personBtn.currentTitle!,moneyBtn.currentTitle!,requestField.text)
        
//        if firmNameField.text != "" && resumeFeild.text != "" && phoneField.text != "" && postNameField.text != "" && conditionBtn.currentTitle != "" && treatmentBtn.currentTitle != "" && workplaceBtn.currentTitle != "" && personBtn.currentTitle != "" && moneyBtn.currentTitle != "" {
//
//            helper.publishJob(firmNameField.text!, companyinfo: resumeFeild.text!, phone: phoneField.text!, email: mailboxField.text!, title: postNameField.text!, jobtype: positionLab.text!, education: conditionLab.text!, welfare: treatmentLab.text!, address: placeLab_1.text!+placeLab_2.text!+placeLab_3.text!, count: personLab.text!, salary: moneyLab.text!, description: requestField.text) { (success, response) in
//                print(success)
//           }
//        }

    }
    
    func responderVC() -> (UIViewController?) {
        var temp:AnyObject
        temp = nextResponder()!
        while ((temp.isKindOfClass(UIViewController)) != true) {
            temp = temp.nextResponder()!
        }
        return temp as? UIViewController
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        getCompanyStatus()
        
        sendBtn.layer.borderColor = COLOR.CGColor
        sendBtn.layer.borderWidth = 1
        sendBtn.layer.cornerRadius = sendBtn.frame.height/2
        
        bordView.layer.borderColor = UIColor.init(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1).CGColor
        bordView.layer.borderWidth = 1
        
        let tabBar = UIApplication.sharedApplication().keyWindow?.rootViewController as! UITabBarController
        selfNav = tabBar.selectedViewController as? UINavigationController
        
        array = ["北京市","北京市","朝阳区"]

        requestField.delegate = self
        
        firmNameField.delegate = self
        resumeFeild.delegate = self
        phoneField.delegate = self
        mailboxField.delegate = self
        postNameField.delegate = self
        
        dropDownDic = ["position":["职位1","职位2"],"condition":["条件1","条件2"],"treatment":["福利1","福利2"],"person":["人数1","人数2"],"money":["薪资1","薪资2"]]
        setDropDownMenu()
        
        firmNameField.borderStyle = .None
        resumeFeild.borderStyle = .None
        phoneField.borderStyle = .None
        mailboxField.borderStyle = .None
        postNameField.borderStyle = .None
        
        detailPlaceTF.borderStyle = .None
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HSPostDetailViewController.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HSPostDetailViewController.keyboardWillDisappear(_:)), name:UIKeyboardWillHideNotification, object: nil)
        

    }
    
    // MARK: 获取企业认证状态
    func getCompanyStatus() {
        HSMineHelper().getCompanyCertify { (success, response) in
            print("1234567890====== \(String(response!))")
            if success {
//                hud.mode = MBProgressHUDMode.Text
//                hud.labelText = "获取企业认证状态成功"
//                hud.hide(true, afterDelay: 0.5)
                let companyInfo = response as! CompanyInfo
                switch companyInfo.status! {
                case "1":
                    self.firmNameField.text = companyInfo.companyname
                    self.resumeFeild.text = companyInfo.companyinfo
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
        
        // 设置下拉列表样式
        customizeDropDown()
        
        // 职位
        positionDrop.anchorView = positionBtn
        
        positionDrop.bottomOffset = CGPoint(x: 0, y: positionBtn.bounds.height)
        positionDrop.width = 200
        positionDrop.direction = .Bottom
        
        positionDrop.dataSource = dropDownDic["position"]!
        
        // 下拉列表选中后的回调方法
        positionDrop.selectionAction = { [unowned self] (index, item) in
            
            self.positionLab.text = item
            self.positionLab.sizeToFit()
            self.positionImg.frame.origin.x = CGRectGetMaxX(self.positionLab.frame)+5
            
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
        coditionDrop.direction = .Bottom
        
        coditionDrop.dataSource = dropDownDic["condition"]!
        
        // 下拉列表选中后的回调方法
        coditionDrop.selectionAction = { [unowned self] (index, item) in
            
            self.conditionBtn.selected = true
            self.conditionLab.text = item
            self.conditionLab.sizeToFit()
            self.conditionImg.frame.origin.x = CGRectGetMaxX(self.conditionLab.frame)+5
        }

        // 福利待遇
        treatmentDrop.anchorView = treatmentBtn
        
        treatmentDrop.bottomOffset = CGPoint(x: 0, y: treatmentBtn.bounds.height)
        treatmentDrop.width = 200
        treatmentDrop.direction = .Bottom
        
        treatmentDrop.dataSource = dropDownDic["treatment"]!
        
        // 下拉列表选中后的回调方法
        treatmentDrop.selectionAction = { [unowned self] (index, item) in
            
            self.conditionBtn.selected = true
            
            self.treatmentLab.text = item
            self.treatmentLab.sizeToFit()
            self.treatmentImg.frame.origin.x = CGRectGetMaxX(self.treatmentLab.frame)+5
        }
        
        // 招聘人数
        personDrop.anchorView = personBtn
        
        personDrop.bottomOffset = CGPoint(x: 0, y: personBtn.bounds.height)
        personDrop.width = 200
        personDrop.direction = .Bottom
        
        personDrop.dataSource = dropDownDic["person"]!
        
        // 下拉列表选中后的回调方法
        personDrop.selectionAction = { [unowned self] (index, item) in
            
            self.conditionBtn.selected = true
            
            self.personLab.text = item
            self.personLab.sizeToFit()
            self.personImg.frame.origin.x = CGRectGetMaxX(self.personLab.frame)+5
        }
        
        // 薪资待遇
        moneyDrop.anchorView = moneyBtn
        
        moneyDrop.bottomOffset = CGPoint(x: 0, y: moneyBtn.bounds.height)
        moneyDrop.width = 200
        moneyDrop.direction = .Bottom
        
        moneyDrop.dataSource = dropDownDic["money"]!
        
        // 下拉列表选中后的回调方法
        moneyDrop.selectionAction = { [unowned self] (index, item) in
            
            self.conditionBtn.selected = true
            
            self.moneyLab.text = item
            self.moneyLab.sizeToFit()
            self.moneyImg.frame.origin.x = CGRectGetMaxX(self.moneyLab.frame)+5
        }
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
        appearance.textColor = .darkGrayColor()
        //		appearance.textFont = UIFont(name: "Georgia", size: 14)
    }

    @IBAction func workplaceBtnClick(sender: AnyObject) {

        
        postNameField.resignFirstResponder()
        firmNameField.resignFirstResponder()
        resumeFeild.resignFirstResponder()
        phoneField.resignFirstResponder()
        mailboxField.resignFirstResponder()
        requestField.resignFirstResponder()
        
        // 初始化
        
        let pick = AdressPickerView.shareInstance
        
        // 设置是否显示区县等，默认为false不显示
        pick.showTown=true
        pick.pickArray=array // 设置第一次加载时需要跳转到相对应的地址

        pick.show((UIApplication.sharedApplication().keyWindow)!)
        // 选择完成之后回调
        pick.selectAdress { (dressArray) in
            
            self.array=dressArray
            print("选择的地区是: \(dressArray)")

            self.placeLab_1.text =  (dressArray[0] as! String)
            self.placeLab_2.text =  (dressArray[1] as! String)
            self.placeLab_3.text =  (dressArray[2] as! String)
            
//            self.placeLab_1.enabled = true
//            self.placeLab_2.enabled = true
//            self.placeLab_3.enabled = true
            
            self.placeLab_1.sizeToFit()
            self.placeLab_1.center.y = self.placeImg_1.center.y
            self.placeImg_1.frame.origin.x = CGRectGetMaxX(self.placeLab_1.frame)+5
            
            
            self.placeLab_2.frame.origin.x = CGRectGetMaxX(self.placeImg_1.frame)+5
//            self.placeLab_2.adjustsFontSizeToFitWidth = true
            self.placeLab_2.sizeToFit()
            self.placeLab_2.center.y = self.placeLab_1.center.y
            self.placeImg_2.frame.origin.x = CGRectGetMaxX(self.placeLab_2.frame)+5
            
            self.placeLab_3.frame.origin.x = CGRectGetMaxX(self.placeImg_2.frame)+5
//            self.placeLab_3.adjustsFontSizeToFitWidth = true
            self.placeLab_3.sizeToFit()
            self.placeLab_3.center.y = self.placeLab_1.center.y
            self.placeImg_3.frame.origin.x = CGRectGetMaxX(self.placeLab_3.frame)+5
            
            (sender as! UIButton).selected = true
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
//                print("defaut")
//        }
//    }

    
    @IBAction func positionBtnClick(sender: AnyObject) {
        
        resignTextFieldFirstResponder()

//        listShow(sender as! UIView, andType: PortType.position)
        positionDrop.show()
        positionBtn.selected = true
        positionBtn.tintColor = UIColor.clearColor()
    }
    
    @IBAction func conditionBtnClick(sender: AnyObject) {
        
        resignTextFieldFirstResponder()

//        listShow(sender as! UIView, andType: PortType.condition)
        coditionDrop.show()
        conditionBtn.selected = true
        conditionBtn.tintColor = UIColor.clearColor()
    }
    
    @IBAction func treatmentBtnClick(sender: AnyObject) {
        
        resignTextFieldFirstResponder()

//        listShow(sender as! UIView, andType: PortType.welfare)
        treatmentDrop.show()
        treatmentBtn.selected = true
        treatmentBtn.tintColor = UIColor.clearColor()
    }
    
    @IBAction func personBtnClick(sender: AnyObject) {
        
        resignTextFieldFirstResponder()

//        listShow(sender as! UIView, andType: PortType.number)
        personDrop.show()
        personBtn.selected = true
        personBtn.tintColor = UIColor.clearColor()
    }
    
    @IBAction func moneyBtnClick(sender: AnyObject) {
        
        resignTextFieldFirstResponder()
        
//        listShow(sender as! UIView, andType: PortType.money)
        moneyDrop.show()
        moneyBtn.selected = true
        moneyBtn.tintColor = UIColor.clearColor()
    }
    
    // 放弃textField的第一响应
    func resignTextFieldFirstResponder() {
        postNameField.resignFirstResponder()
        firmNameField.resignFirstResponder()
        resumeFeild.resignFirstResponder()
        phoneField.resignFirstResponder()
        mailboxField.resignFirstResponder()
        requestField.resignFirstResponder()
    }
    
    var bgView = UIView()
    
//    var chooseTableView = UITableView()
    var chooseList = EduList()
    
    var portType: PortType = .defaut
    
    func listShow(onView:UIView, andType type:PortType) {
        portType = type
        dataGet(type)
        bgView.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
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
//        print(1111)
//        let eduInfo = self.chooseList.objectlist[indexPath.row]
//        QCLoginUserInfo.currentInfo.education = eduInfo.name
//        print(eduInfo.name)
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
//            print("defaut")
//        }
//    }
    
    func dataGet(portType:PortType){
        
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
        default:
            print("defaut")
        }
        print(param)
        
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            if(error != nil){
                
            }else{
                let status = EduModel(JSONDecoder(json!))
                print("状态是")
                print(status.status)
                if(status.status == "error"){
                    let hud = MBProgressHUD.showHUDAddedTo(self, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                    print(status)
                    self.chooseList = EduList(status.data!)
                    
//                    self.chooseTableView .reloadData()
                }
            }
            
        }
        
    }
    
    
    
    // MARK: 监控键盘弹起落下
    var keyboardHeight:CGFloat = 0.0
    var flag = true // 防止键盘弹起方法走两次
    
    func keyboardWillAppear(notification: NSNotification) {
        
        // 获取键盘信息
        let keyboardinfo = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]
        
        let keyboardheight:CGFloat = (keyboardinfo?.CGRectValue.size.height)!
        if requestField.isFirstResponder() && flag {
            
            UIView.animateWithDuration(0.3) {
                //                self.myScrollView.contentOffset = CGPoint.init(x: 0, y: self.myScrollView.contentSize.height-self.myScrollView.frame.size.height+keyboardheight)
                //                self.myScrollView.frame = CGRectMake(self.myScrollView.frame.origin.x, self.myScrollView.frame.origin.y, self.myScrollView.frame.size.width, self.myScrollView.frame.size.height-keyboardheight)
                self.myScrollview.frame.size.height = self.myScrollview.frame.size.height-keyboardheight
                self.myScrollview.contentOffset.y = self.myScrollview.contentSize.height-self.myScrollview.frame.size.height
                self.keyboardHeight = keyboardheight
                self.flag = false
            }
        }
        
        print("键盘弹起")
        print(keyboardheight)
        
    }
    
    func keyboardWillDisappear(notification:NSNotification){
        
        if self.myScrollview.frame.size.height<=HEIGHT-64-keyboardHeight {
            
            UIView.animateWithDuration(0.3) {
                //            self.myScrollview.contentOffset = CGPoint.init(x: 0, y: self.myScrollview.contentSize.height-self.myScrollview.frame.size.height)
                
                self.myScrollview.frame.size.height = self.myScrollview.frame.size.height+self.keyboardHeight
                self.flag = true
            }
        }
        print("键盘落下")
    }

    
    //MARK:UITextViewDelegate
    func textViewDidChange(textView: UITextView) {
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
