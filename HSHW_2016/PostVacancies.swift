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

class PostVacancies: UIView,UITextViewDelegate,UITableViewDelegate, UITableViewDataSource{
    
    weak var delegate:PostVacanciesDelegate?
    
    
    @IBOutlet weak var myScrollview: UIScrollView!
    @IBOutlet weak var bordView:UIView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var postNameField: UITextField!
    @IBOutlet weak var firmNameField: UITextField!
    @IBOutlet weak var resumeFeild: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var mailboxField: UITextField!
    @IBOutlet weak var workplaceBtn: UIButton!
    @IBOutlet weak var positionBtn: UIButton!
    @IBOutlet weak var conditionBtn: UIButton!
    @IBOutlet weak var treatmentBtn: UIButton!
    @IBOutlet weak var personBtn: UIButton!
    @IBOutlet weak var moneyBtn: UIButton!
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
    
    var array = NSArray()
   
    @IBAction func sendBtnClicked(sender: AnyObject) {
        if delegate != nil {
            if firmNameField.text != "" && resumeFeild.text != "" && phoneField.text != "" && postNameField.text != "" && conditionBtn.currentTitle != "" && treatmentBtn.currentTitle != "" && workplaceBtn.currentTitle != "" && personBtn.currentTitle != "" && moneyBtn.currentTitle != "" {
                
                delegate?.clickedSendBtn()
            }else{
                let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("请完善招聘信息", comment: "empty message"), preferredStyle: .Alert)
                let doneAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
                alertController.addAction(doneAction)
                
                let vc = responderVC()
                vc!.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        
//        print(firmNameField.text!,resumeFeild.text!,phoneField.text!,mailboxField.text!,postNameField.text!,"1",conditionBtn.currentTitle!,treatmentBtn.currentTitle!,workplaceBtn.currentTitle!,personBtn.currentTitle!,moneyBtn.currentTitle!,requestField.text)
        
        if firmNameField.text != "" && resumeFeild.text != "" && phoneField.text != "" && postNameField.text != "" && conditionBtn.currentTitle != "" && treatmentBtn.currentTitle != "" && workplaceBtn.currentTitle != "" && personBtn.currentTitle != "" && moneyBtn.currentTitle != "" {

            helper.publishJob(firmNameField.text!, companyinfo: resumeFeild.text!, phone: phoneField.text!, email: mailboxField.text!, title: postNameField.text!, jobtype: positionLab.text!, education: conditionLab.text!, welfare: treatmentLab.text!, address: placeLab_1.text!+placeLab_2.text!+placeLab_3.text!, count: personLab.text!, salary: moneyLab.text!, description: requestField.text) { (success, response) in
                print(success)
           }
        }
        
        //提交后还原表格样式
        firmNameField.text = nil
        resumeFeild.text = nil
        phoneField.text = nil
        mailboxField.text = nil
        postNameField.text = nil
//        positionBtn.setTitle("请选择工作地点", forState: .Normal)
//        conditionBtn.setTitle("请选择招聘职位", forState: .Normal)
//        treatmentBtn.setTitle("请选择招聘条件", forState: .Normal)
//        workplaceBtn.setTitle("请选择福利待遇", forState: .Normal)
//        personBtn.setTitle("请选择招聘人数", forState: .Normal)
//        moneyBtn.setTitle("请选择薪资待遇", forState: .Normal)
        
        positionLab.text = "主管护士"
        conditionLab.text = "研究生"
        treatmentLab.text = "五险一金"
        placeLab_1.text = "北京市"
        placeLab_2.text = "北京市"
        placeLab_3.text = "朝阳区"
        personLab.text = "10人以上"
        moneyLab.text = "面议"
        requestField.text = nil
        requestLabel.text = "职位要求"
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
        sendBtn.layer.borderColor = COLOR.CGColor
        sendBtn.layer.borderWidth = 1
        sendBtn.layer.cornerRadius = sendBtn.frame.height/2
        
        bordView.layer.borderColor = UIColor.lightGrayColor().CGColor
        bordView.layer.borderWidth = 1
        
        let tabBar = UIApplication.sharedApplication().keyWindow?.rootViewController as! UITabBarController
        selfNav = tabBar.selectedViewController as? UINavigationController
        
        array = ["北京市","北京市","朝阳区"]

        requestField.delegate = self
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HSPostDetailViewController.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HSPostDetailViewController.keyboardWillDisappear(_:)), name:UIKeyboardWillHideNotification, object: nil)
        

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
//        self.view.addSubview(pick)
//        self.addSubview(pick)
        pick.show((UIApplication.sharedApplication().keyWindow)!)
        // 选择完成之后回调
        pick.selectAdress { (dressArray) in
            
            self.array=dressArray
            print("选择的地区是: \(dressArray)")
//            self.workplaceBtn.setTitle("\(dressArray[0])  \(dressArray[1])  \(dressArray[2])", forState: .Normal)

            self.placeLab_1.text =  (dressArray[0] as! String)
            self.placeLab_2.text =  (dressArray[1] as! String)
            self.placeLab_3.text =  (dressArray[2] as! String)
            
            self.placeLab_1.enabled = true
            self.placeLab_2.enabled = true
            self.placeLab_3.enabled = true
            
            self.placeLab_1.sizeToFit()
            self.placeImg_1.frame = CGRectMake(CGRectGetMaxX(self.placeLab_1.frame), self.placeImg_1.frame.origin.y, 12, 12)
            
            
            self.placeLab_2.frame = CGRectMake(CGRectGetMaxX(self.placeImg_1.frame)+5, self.placeLab_2.frame.origin.y, self.placeLab_2.frame.size.width, 12)
            self.placeLab_2.adjustsFontSizeToFitWidth = true
            self.placeLab_2.sizeToFit()
            self.placeImg_2.frame = CGRectMake(CGRectGetMaxX(self.placeLab_2.frame), self.placeImg_2.frame.origin.y, 12, 12)
            
            self.placeLab_3.frame = CGRectMake(CGRectGetMaxX(self.placeImg_2.frame)+5, self.placeLab_3.frame.origin.y, self.placeLab_3.frame.size.width, 12)
            self.placeLab_3.adjustsFontSizeToFitWidth = true
            self.placeLab_3.sizeToFit()
            self.placeImg_3.frame = CGRectMake(CGRectGetMaxX(self.placeLab_3.frame), self.placeImg_3.frame.origin.y, 12, 12)
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

        listShow(sender as! UIView, andType: PortType.position)
    }
    
    @IBAction func conditionBtnClick(sender: AnyObject) {
        
        resignTextFieldFirstResponder()

        listShow(sender as! UIView, andType: PortType.condition)
    }
    
    @IBAction func treatmentBtnClick(sender: AnyObject) {
        
        resignTextFieldFirstResponder()

        listShow(sender as! UIView, andType: PortType.welfare)
    }
    
    @IBAction func personBtnClick(sender: AnyObject) {
        
        resignTextFieldFirstResponder()

        listShow(sender as! UIView, andType: PortType.number)
    }
    
    @IBAction func moneyBtnClick(sender: AnyObject) {
        
        resignTextFieldFirstResponder()
        
        listShow(sender as! UIView, andType: PortType.money)
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
    
    var chooseTableView = UITableView()
    var chooseList = EduList()
    
    var portType: PortType = .defaut
    
    func listShow(onView:UIView, andType type:PortType) {
        portType = type
        dataGet(type)
        bgView.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        self.myScrollview.addSubview(bgView)
        
        chooseTableView = UITableView.init(frame: CGRectMake(CGRectGetMinX(onView.frame)+20, CGRectGetMaxY(onView.superview!.frame), CGRectGetWidth(onView.frame)-20, 108), style: .Plain)
        chooseTableView.backgroundColor = UIColor.whiteColor()
        chooseTableView.layer.borderWidth = 1
        chooseTableView.layer.borderColor = UIColor.lightGrayColor().CGColor
        chooseTableView.delegate = self
        chooseTableView.dataSource = self
        chooseTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        chooseTableView.bounces = false
        self.myScrollview.addSubview(chooseTableView)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chooseList.objectlist.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
//        cell.selectionStyle = .None
        
        let eduInfo  = self.chooseList.objectlist[indexPath.row]
        cell.textLabel?.text = eduInfo.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(1111)
        let eduInfo = self.chooseList.objectlist[indexPath.row]
        QCLoginUserInfo.currentInfo.education = eduInfo.name
        print(eduInfo.name)
        chooseTableView.removeFromSuperview()
        bgView.removeFromSuperview()
        
        let string = eduInfo.name
        
        switch portType {
        case PortType.position:
            positionLab.text = string
            positionLab.enabled = true
            positionLab.sizeToFit()
            positionImg.frame = CGRectMake(CGRectGetMaxX(positionLab.frame), positionImg.frame.origin.y, 12, 12)
        case PortType.condition:
            conditionLab.text = string
            conditionLab.enabled = true
            conditionLab.sizeToFit()
            conditionImg.frame = CGRectMake(CGRectGetMaxX(conditionLab.frame), conditionImg.frame.origin.y, 12, 12)
        case PortType.welfare:
            treatmentLab.text = string
            treatmentLab.enabled = true
            treatmentLab.sizeToFit()
            treatmentImg.frame = CGRectMake(CGRectGetMaxX(treatmentLab.frame), treatmentImg.frame.origin.y, 12, 12)
        case PortType.number:
            personLab.text = string
            personLab.enabled = true
            personLab.sizeToFit()
            personImg.frame = CGRectMake(CGRectGetMaxX(personLab.frame), personImg.frame.origin.y, 12, 12)
        case PortType.money:
            moneyLab.text = string
            moneyLab.enabled = true
            moneyLab.sizeToFit()
            moneyImg.frame = CGRectMake(CGRectGetMaxX(moneyLab.frame), moneyImg.frame.origin.y, 12, 12)
        default:
            print("defaut")
        }
    }
    
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
                    
                    self.chooseTableView .reloadData()
                }
            }
            
        }
        
    }
    
    
    
    func keyboardWillAppear(notification: NSNotification) {
        
        // 获取键盘信息
        let keyboardinfo = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]
        
        let keyboardheight:CGFloat = (keyboardinfo?.CGRectValue.size.height)!
        
        UIView.animateWithDuration(0.3) {
            self.myScrollview.contentOffset = CGPoint.init(x: 0, y: self.myScrollview.contentSize.height-self.myScrollview.frame.size.height+keyboardheight)
        }
        
        print("键盘弹起")
        print(keyboardheight)
        
    }
    
    func keyboardWillDisappear(notification:NSNotification){
        UIView.animateWithDuration(0.3) {
             self.myScrollview.contentOffset = CGPoint.init(x: 0, y: self.myScrollview.contentSize.height-self.myScrollview.frame.size.height)
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
    
}
