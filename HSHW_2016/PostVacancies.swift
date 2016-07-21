//
//  PostVacancies.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/30.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

protocol PostVacanciesDelegate:NSObjectProtocol{
    func clickedSendBtn()
}

class PostVacancies: UIView , ChangeWordDelegate,UITextViewDelegate{
    
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
    
    @IBOutlet weak var placeLab_2: UILabel!
    
    @IBOutlet weak var placeLab_3: UILabel!
    
    @IBOutlet weak var positionLab: UILabel!
    
    @IBOutlet weak var conditionLab: UILabel!
    
    @IBOutlet weak var treatmentLab: UILabel!
    
    @IBOutlet weak var personLab: UILabel!
    
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

            helper.publishJob(firmNameField.text!, companyinfo: resumeFeild.text!, phone: phoneField.text!, email: mailboxField.text!, title: postNameField.text!, jobtype: positionBtn.currentTitle!, education: conditionBtn.currentTitle!, welfare: treatmentBtn.currentTitle!, address: workplaceBtn.currentTitle!, count: personBtn.currentTitle!, salary: moneyBtn.currentTitle!, description: requestField.text) { (success, response) in
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
            
        }
        
    }
    
    // 招聘职位等选择完成后的回调
    func  changeWord(controller:HSStateEditResumeController,string:String){
        switch controller.portType {
            case PortType.position:
                positionLab.text = string
            positionLab.enabled = true
            case PortType.condition:
                conditionLab.text = string
            conditionLab.enabled = true
            case PortType.welfare:
                treatmentLab.text = string
            treatmentLab.enabled = true
            case PortType.number:
                personLab.text = string
            personLab.enabled = true
            case PortType.money:
                moneyLab.text = string
                moneyLab.enabled = true
            moneyLab.sizeToFit()
            moneyImg.frame = CGRectMake(CGRectGetMaxX(moneyLab.frame), moneyImg.frame.origin.y, 12, 12)
            default:
                print("defaut")
        }
    }

    
    @IBAction func positionBtnClick(sender: AnyObject) {
        let vc = HSStateEditResumeController()
        vc.portType = PortType.position
        vc.delegate = self
        selfNav?.pushViewController(vc, animated: true)
    }
    
    @IBAction func conditionBtnClick(sender: AnyObject) {
        let vc = HSStateEditResumeController()
        vc.portType = PortType.condition
        vc.delegate = self
        selfNav?.pushViewController(vc, animated: true)
    }
    
    @IBAction func treatmentBtnClick(sender: AnyObject) {
        let vc = HSStateEditResumeController()
        vc.portType = PortType.welfare
        vc.delegate = self
        selfNav?.pushViewController(vc, animated: true)
    }
    
    @IBAction func personBtnClick(sender: AnyObject) {
        let vc = HSStateEditResumeController()
        vc.portType = PortType.number
        vc.delegate = self
        selfNav?.pushViewController(vc, animated: true)
    }
    
    @IBAction func moneyBtnClick(sender: AnyObject) {
        let vc = HSStateEditResumeController()
        vc.portType = PortType.money
        vc.delegate = self
        selfNav?.pushViewController(vc, animated: true)
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
