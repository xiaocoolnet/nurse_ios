//
//  ViewController.swift
//  HSHW_2016
//  Created by apple on 16/5/13.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol ViewControllerDelegate:NSObjectProtocol {
    func viewcontrollerDesmiss()
}
class ViewController: UIViewController,UITextFieldDelegate,ForgetPasswordDelegate, UIAlertViewDelegate {
    
    var hasBackBarButtonItem = true
    var previousViewcontroller = UIViewController()
    var scrollView = UIScrollView()
    var backView = UIView()
    let LOGO = UIImageView()
    var click = Bool()
    let line = UILabel()
    let btnOne = UIButton()
    let btnTwo = UIButton()
    let register = UIView()
    let login = UIView()
    
    let phoneNumber = UITextField()
    let passwordNumber = UITextField()
    let loginBtn = UIButton()
    //  忘记密码按钮
    let forgetPwdBtn = UIButton()
    let phoneNum = UITextField()
    let yanzheng = UITextField()
    let password = UITextField()
    
    // 个人
    let personalBtn = UIButton()
    let personalImg = UIImageView()
    let personalLab = UILabel()
    
    // 企业
    let businessBtn = UIButton()
    let businessImg = UIImageView()
    let businessLab = UILabel()
    
    // 1 用户  2 企业
    var usertype = "1"
    
    let acquire = UIButton()
    let gain = UILabel()
    let submit = UIButton()
    
    var logVM = LoginModel?()
    var processHandle:TimerHandle?
    var finishHandle:TimerHandle?
    weak var delegate:ViewControllerDelegate?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        //UIApplication.sharedApplication().backgroundRefreshStatus = true
                navigationController?.navigationBar.hidden = hasBackBarButtonItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  添加一个导航控制器
        //  获取验证码倒计时
        processHandle = {[unowned self] (timeInterVal) in
            dispatch_async(dispatch_get_main_queue(), {
                //    self.acquire.backgroundColor = COLOR
                self.acquire.userInteractionEnabled = false
                let btnTitle = String(timeInterVal) + "秒后重新获取"
                self.acquire.titleLabel?.font = UIFont.systemFontOfSize(12)
                self.acquire.setTitleColor(COLOR, forState: .Normal)
                self.acquire.setTitle(btnTitle, forState: .Normal)
                self.gain.text = nil
            })
        }
        //  获取验证码
        finishHandle = {[unowned self] (timeInterVal) in
            dispatch_async(dispatch_get_main_queue(), {
                self.acquire.userInteractionEnabled = true
                // self.acquire.backgroundColor = COLOR
                self.acquire.setTitleColor(COLOR, forState: .Normal)
                self.acquire.setTitle("获取验证码", forState: .Normal)
                self.gain.text = nil
            })
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        logVM = LoginModel()
        self.view.backgroundColor = UIColor.whiteColor()
        //        self.view.backgroundColor = COLOR
        
        if navigationController?.navigationBarHidden == true {
            scrollView.frame = CGRectMake(0, -20, WIDTH, HEIGHT-49+20)
        }else{
            scrollView.frame = CGRectMake(0, -20-64, WIDTH, HEIGHT-49+20)
        }
        
        scrollView.backgroundColor = COLOR
        scrollView.contentSize = CGSizeMake(0, 0)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        self.view.addSubview(scrollView)
        // print(HEIGHT)
        
        backView.frame = CGRectMake(0, 0, WIDTH, WIDTH*333/375)
        backView.backgroundColor = COLOR
        scrollView.addSubview(backView)
        LOGO.frame = CGRectMake(WIDTH*109/375, WIDTH*107/375, WIDTH*157/375, WIDTH*155/375)
        LOGO.image = UIImage(named: "LOGO.png")
        scrollView.addSubview(LOGO)
        let btnTit:[String] = ["登录","注册"]
        click = true
        //  登录按钮
        btnOne.frame = CGRectMake(0, WIDTH*333/375-45, WIDTH/2, 45)
        btnOne.titleLabel?.font = UIFont.systemFontOfSize(18)
        btnOne.setTitle(btnTit[0], forState: .Normal)
        btnOne.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnOne.addTarget(self, action: #selector(self.loginTheView), forControlEvents: .TouchUpInside)
        backView.addSubview(btnOne)
        //  注册按钮
        btnTwo.frame = CGRectMake(WIDTH/2, WIDTH*333/375-45, WIDTH/2, 45)
        btnTwo.titleLabel?.font = UIFont.systemFontOfSize(18)
        btnTwo.setTitle(btnTit[1], forState: .Normal)
        btnTwo.setTitleColor(GREY, forState: .Normal)
        btnTwo.addTarget(self, action: #selector(self.registerTheView), forControlEvents: .TouchUpInside)
        backView.addSubview(btnTwo)
        
        self.loginView()
        self.registerView()
        
        line.frame = CGRectMake(0, WIDTH*333/375-4, WIDTH/2, 4)
        line.backgroundColor = UIColor(red: 250/255.0, green: 118/255.0, blue: 210/255.0, alpha: 1.0)
        scrollView.addSubview(line)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyBoardChangFrame(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        autoLogin()
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        if delegate != nil {
            delegate?.viewcontrollerDesmiss()
        }
    }
    //  登录界面
    func loginTheView() {
        // print("登录")
        
        
        
        btnOne.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnTwo.setTitleColor(GREY, forState: .Normal)
        UIView.animateWithDuration(0.2) {
            self.line.frame = CGRectMake(0, WIDTH*333/375-4, WIDTH/2, 4)
            self.register.frame = CGRectMake(WIDTH, WIDTH*333/375, WIDTH, HEIGHT-WIDTH*333/375)
            self.login.frame = CGRectMake(0, WIDTH*333/375, WIDTH, HEIGHT-WIDTH*333/375)
        }
        password.resignFirstResponder()
        yanzheng.resignFirstResponder()
        phoneNum.resignFirstResponder()
    }
    
    //  注册界面
    func registerTheView() {
        // print("注册")
        btnOne.setTitleColor(GREY, forState: .Normal)
        btnTwo.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        UIView.animateWithDuration(0.2) {
            self.line.frame = CGRectMake(WIDTH/2, WIDTH*333/375-4, WIDTH/2, 4)
            self.register.frame = CGRectMake(0, WIDTH*333/375, WIDTH, HEIGHT-WIDTH*333/375)
            self.login.frame = CGRectMake(-WIDTH, WIDTH*333/375, WIDTH, HEIGHT-WIDTH*333/375)
        }
        phoneNumber.resignFirstResponder()
        passwordNumber.resignFirstResponder()
    }
    
    //  KVO（通知中心）监测键盘
    func keyBoardChangFrame(info:NSNotification) {
        let infoDic = info.userInfo
        let keyBoardRect = infoDic!["UIKeyboardFrameEndUserInfoKey"]?.CGRectValue()
        let keyBoardTranslate = CGFloat((keyBoardRect?.origin.y)!-HEIGHT)
        
        var rect:CGRect = self.view.frame
        //        rect.origin.y = keyBoardTranslate
        
        if navigationController?.navigationBarHidden == true {
            rect.origin.y = keyBoardTranslate
        }else{
            rect.origin.y = keyBoardTranslate+64
        }
        
        UIView.animateWithDuration(0.3) {
            
            self.view.frame = rect
        }
    }
    
    //  登录界面UI的搭建
    func loginView() {
        
        login.frame = CGRectMake(0, WIDTH*333/375, WIDTH, HEIGHT-WIDTH*333/375)
        login.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(login)
        
        phoneNumber.frame = CGRectMake(35, WIDTH*40/375, WIDTH-60, WIDTH*50/375)
        phoneNumber.placeholder = "手机号"
        phoneNumber.font = UIFont.systemFontOfSize(16)
        phoneNumber.keyboardType = .NumberPad
        phoneNumber.clearButtonMode = .WhileEditing
        phoneNumber.returnKeyType = .Next
        login.addSubview(phoneNumber)
        phoneNumber.delegate = self
        
        for i in 0...1 {
            let border = UILabel(frame: CGRectMake(25, WIDTH*40/375+WIDTH*60/375*CGFloat(i), WIDTH-50, WIDTH*50/375))
            border.layer.borderWidth = 1
            border.layer.borderColor = GREY.CGColor
            login.addSubview(border)
        }
        
        passwordNumber.frame = CGRectMake(35, WIDTH*100/375, WIDTH-60, WIDTH*50/375)
        passwordNumber.placeholder = "密码"
        passwordNumber.font = UIFont.systemFontOfSize(16)
        passwordNumber.secureTextEntry = true
        let rightView = UIView(frame: CGRectMake(0, 0, 37, 20))
        let rightBtn = UIButton(frame: CGRectMake(0, 2, 22, 16))
        rightBtn.setImage(UIImage(named: "btn_eye_sel"), forState: .Selected)
        rightBtn.setImage(UIImage(named: "btn_eye"), forState: .Normal)
        rightBtn.tag = 101
        rightBtn.addTarget(self, action: #selector(showOrHiddenPWD(_:)), forControlEvents: .TouchUpInside)
        rightView.addSubview(rightBtn)
        passwordNumber.rightView = rightView
        passwordNumber.rightViewMode = .WhileEditing
        passwordNumber.returnKeyType = .Done
        login.addSubview(passwordNumber)
        passwordNumber.delegate = self
        
        loginBtn.frame = CGRectMake(25, WIDTH*180/375, WIDTH-50, WIDTH*50/375)
        loginBtn.layer.cornerRadius = WIDTH*25/375
        loginBtn.layer.borderWidth = 1.5
        loginBtn.layer.borderColor = COLOR.CGColor
        loginBtn.titleLabel?.font = UIFont.systemFontOfSize(18)
        loginBtn.setTitle("登录", forState: .Normal)
        loginBtn.setTitle("", forState: .Highlighted)
        loginBtn.setTitleColor(COLOR, forState: .Normal)
        loginBtn.addTarget(self, action: #selector(self.goToMain), forControlEvents: .TouchUpInside)
        login.addSubview(loginBtn)
        
        //  忘记密码的按钮
        forgetPwdBtn.frame = CGRectMake(25, WIDTH*235/375, WIDTH-50, WIDTH*50/375)
        forgetPwdBtn.setTitle("忘记密码?", forState: .Normal)
        forgetPwdBtn.setTitleColor(COLOR, forState: .Normal)
        //  设置字体大小
        forgetPwdBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
        forgetPwdBtn.addTarget(self, action: #selector(self.changePassWord), forControlEvents: .TouchUpInside)
        login.addSubview(forgetPwdBtn)
        
        //        scrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMinY(login.frame)+CGRectGetMaxY(forgetPwdBtn.frame)+10-20)
        
    }
    
    func showOrHiddenPWD(btn:UIButton) {
        if btn.tag == 101 {
            passwordNumber.secureTextEntry = !passwordNumber.secureTextEntry
        }else{
            password.secureTextEntry = !password.secureTextEntry
        }
        btn.selected = !btn.selected
    }
    
    //  修改密码
    func changePassWord(){
        // print("修改密码")
        //  跳转页面
        let forGetVC = ForgetPasswordController()
        forGetVC.delegate = self
        forGetVC.flag = (navigationController?.navigationBar.hidden)!
        self.navigationController?.pushViewController(forGetVC, animated: true)
    }
    
    func changeNavigation(flag:Bool) {
        navigationController?.navigationBar.hidden = flag
    }
    
    //  MARK:注册界面UI的搭建
    func registerView() {
        register.frame = CGRectMake(WIDTH, WIDTH*333/375, WIDTH, HEIGHT-WIDTH*333/375)
        register.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(register)
        
        phoneNum.frame = CGRectMake(35, WIDTH*15/375, WIDTH-60, WIDTH*50/375)
        phoneNum.placeholder = "手机号"
        phoneNum.font = UIFont.systemFontOfSize(16)
        phoneNum.keyboardType = .NumberPad
        phoneNum.clearButtonMode = .WhileEditing
        phoneNum.returnKeyType = .Next
        register.addSubview(phoneNum)
        phoneNum.delegate = self
        
        yanzheng.frame = CGRectMake(35, WIDTH*75/375, 150, WIDTH*50/375)
        yanzheng.placeholder = "验证码"
        yanzheng.font = UIFont.systemFontOfSize(16)
        yanzheng.returnKeyType = .Next
        register.addSubview(yanzheng)
        yanzheng.delegate = self
        
        for i in 0...2 {
            let border = UILabel(frame: CGRectMake(25, WIDTH*15/375+WIDTH*60/375*CGFloat(i), WIDTH-50, WIDTH*50/375))
            border.layer.borderWidth = 1
            border.layer.borderColor = GREY.CGColor
            register.addSubview(border)
        }
        
        password.frame = CGRectMake(35, WIDTH*135/375, WIDTH-60, WIDTH*50/375)
        password.placeholder = "密码"
        password.font = UIFont.systemFontOfSize(16)
        let rightView = UIView(frame: CGRectMake(0, 0, 37, 20))
        let rightBtn = UIButton(frame: CGRectMake(0, 2, 22, 16))
        rightBtn.setImage(UIImage(named: "btn_eye_sel"), forState: .Selected)
        rightBtn.setImage(UIImage(named: "btn_eye"), forState: .Normal)
        rightBtn.tag = 102
        rightBtn.addTarget(self, action: #selector(showOrHiddenPWD(_:)), forControlEvents: .TouchUpInside)
        rightView.addSubview(rightBtn)
        password.rightView = rightView
        password.rightViewMode = .WhileEditing
        password.returnKeyType = .Done
        register.addSubview(password)
        password.delegate = self
        
        let btnWidth:CGFloat = 60
        let btnHeight:CGFloat = 20
        let margin:CGFloat = 10
        
        // 个人
        personalBtn.frame = CGRectMake(WIDTH/2.0-margin-btnWidth, CGRectGetMaxY(password.frame)+10, btnWidth, btnHeight)
        personalBtn.addTarget(self, action: #selector(personalOrBusinessBtnClick(_:)), forControlEvents: .TouchUpInside)
        register.addSubview(personalBtn)
        
        personalImg.frame = CGRectMake(0, 2, btnHeight-4, btnHeight-4)
        personalImg.image = UIImage.init(named: "ic_gou_sel")
        personalBtn.addSubview(personalImg)
        
        personalLab.frame = CGRectMake(btnHeight+5, 0, btnWidth-btnHeight-5, btnHeight)
        personalLab.textColor = COLOR
        personalLab.font = UIFont.systemFontOfSize(14)
        personalLab.text = "个人"
        personalBtn.addSubview(personalLab)
        
        // 企业
        businessBtn.frame = CGRectMake(WIDTH/2.0+margin, CGRectGetMaxY(password.frame)+10, btnWidth, btnHeight)
        businessBtn.addTarget(self, action: #selector(personalOrBusinessBtnClick(_:)), forControlEvents: .TouchUpInside)
        register.addSubview(businessBtn)
        
        businessImg.frame = CGRectMake(0, 2, btnHeight-4, btnHeight-4)
        businessImg.image = UIImage.init(named: "ic_kuang")
        businessBtn.addSubview(businessImg)
        
        businessLab.frame = CGRectMake(btnHeight+5, 0, btnWidth-btnHeight-5, btnHeight)
        businessLab.textColor = GREY
        businessLab.font = UIFont.systemFontOfSize(14)
        businessLab.text = "企业"
        businessBtn.addSubview(businessLab)
        
        gain.frame = CGRectMake(WIDTH-130, WIDTH*75/375+(WIDTH*50/375-30)/2, 95, 30)
        gain.text = "获取验证码"
        gain.font = UIFont.systemFontOfSize(14)
        gain.textColor = COLOR
        gain.textAlignment = .Center
        register.addSubview(gain)
        
        //  获取验证码的button
        acquire.frame = CGRectMake(WIDTH-130, WIDTH*75/375+(WIDTH*50/375-30)/2, 95, 30)
        acquire.layer.cornerRadius = 13
        acquire.layer.borderColor = COLOR.CGColor
        acquire.addTarget(self, action: #selector(self.gainTheCard), forControlEvents: .TouchUpInside)
        acquire.layer.borderWidth = 1.5
        register.addSubview(acquire)
        
        submit.frame = CGRectMake(25, WIDTH*212/375+btnHeight, WIDTH-50, WIDTH*50/375)
        submit.layer.cornerRadius = WIDTH*25/375
        submit.layer.borderWidth = 1.5
        submit.layer.borderColor = COLOR.CGColor
        submit.titleLabel?.font = UIFont.systemFontOfSize(18)
        submit.setTitle("提交", forState: .Normal)
        submit.setTitle("", forState: .Highlighted)
        submit.setTitleColor(COLOR, forState: .Normal)
        submit.addTarget(self, action: #selector(self.submitTheUser), forControlEvents: .TouchUpInside)
        register.addSubview(submit)
        
        //        scrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMinY(register.frame)+CGRectGetMaxY(submit.frame)+10-20)
    }
    
    func personalOrBusinessBtnClick(button:UIButton) {
        if button == personalBtn {
            
            personalImg.image = UIImage.init(named: "ic_gou_sel")
            personalLab.textColor = COLOR
            
            businessImg.image = UIImage.init(named: "ic_kuang")
            businessLab.textColor = GREY
            
            usertype = "1"
        }else if button == businessBtn {
            
            businessImg.image = UIImage.init(named: "ic_gou_sel")
            businessLab.textColor = COLOR
            
            personalImg.image = UIImage.init(named: "ic_kuang")
            personalLab.textColor = GREY
            
            usertype = "2"
        }
    }
    
    //  点击短信获取验证码
    func gainTheCard() {
        // print("获取验证码")
        phoneNum.resignFirstResponder()
        yanzheng.resignFirstResponder()
        password.resignFirstResponder()
        if phoneNum.text!.isEmpty {
            let alert = UIAlertView(title:"提示信息",message: "请输入手机号！",delegate: self,cancelButtonTitle: "确定")
            
            alert.show()
            return
        }
        if !validationEmailFormat(phoneNum.text!) {
            let alert = UIAlertView(title:"提示信息",message: "手机号格式有误！",delegate: self,cancelButtonTitle: "确定")
            
            alert.show()
            return
        }
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        //            hud.mode = MBProgressHUDMode.Text;
        //        hud.labelText = "正在发送邀请"
        hud.margin = 10.0
        hud.removeFromSuperViewOnHide = true
        
        logVM?.comfirmPhoneHasRegister(phoneNum.text!, handle: {[unowned self](success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                //  不管填什么内容都走了这个方法
                if success {
                    hud.hide(true)
                    let alert = UIAlertView(title:"提示信息",message: "手机已注册",delegate: self,cancelButtonTitle: "确定")
                    
                    alert.show()
                }else{
                    hud.hide(true)
                    //  单例进行倒计时
                    TimeManager.shareManager.begainTimerWithKey("register", timeInterval: 30, process: self.processHandle!, finish: self.finishHandle!)
                    self.logVM?.sendMobileCodeWithPhoneNumber(self.phoneNum.text!)
                }
            })
            
            })
        // print("get identify")
    }
    
    // 验证手机号是否正确
    func validationEmailFormat(string:String) -> Bool {
        
        let mobileRegex = "^((13[0-9])|(147)|(170)|(15[^4,\\D])|(18[0-9]))\\d{8}$"
        let mobileTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@",mobileRegex)
        return mobileTest.evaluateWithObject(string)
        
    }
    
    //  注册提交事件
    func submitTheUser() {
        // print("提交")
        //        phoneNum.resignFirstResponder()
        //        yanzheng.resignFirstResponder()
        //        password.resignFirstResponder()
        if phoneNum.text!.isEmpty {
            let alert = UIAlertView(title: "提示信息",message: "请输入手机号",delegate: self,cancelButtonTitle: "确定")
            alert.show()
            return
        }
        
        if yanzheng.text!.isEmpty {
            let alert = UIAlertView(title: "提示信息",message: "请输入验证码",delegate: self,cancelButtonTitle: "确定")
            alert.show()
            return
        }
        
        if password.text!.isEmpty {
            let alert = UIAlertView(title: "提示信息",message: "请输入密码",delegate: self,cancelButtonTitle: "确定")
            alert.show()
            return
        }
        
        
        logVM?.register(phoneNum.text!,password:password.text!,
                        code:yanzheng.text!,usertype:usertype,devicestate:"1", handle: { [unowned self] (success, response) in
                            dispatch_async(dispatch_get_main_queue(), {
                                if success {
                                    
                                    self.phoneNum.text = nil
                                    self.password.text = nil
                                    self.yanzheng.text = nil
                                    let alert = UIAlertView(title: "提示信息",message: "注册成功",delegate: self,cancelButtonTitle: "确定")
                                    alert.show()
                                    let result = response as! addScore_ReadingInformationDataModel
                                    self.showScoreTips(result.event, score: result.score)
//                                    self.navigationController?.popViewControllerAnimated(true)
                                }else{
                                    let alert = UIAlertView(title: "提示信息",message: response as? String,delegate: self,cancelButtonTitle: "确定")
                                    alert.show()
                                }
                            })
            })
    }
    
    // MARK: 显示积分提示
    func showScoreTips(name:String, score:String) {
        let hud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
        hud.opacity = 0.3
        hud.margin = 10
        hud.color = UIColor(red: 145/255.0, green: 26/255.0, blue: 107/255.0, alpha: 0.3)
        hud.mode = .CustomView
        let customView = UIImageView(frame: CGRectMake(0, 0, WIDTH*0.8, WIDTH*0.8*238/537))
        customView.image = UIImage(named: "scorePopImg.png")
        let titLab = UILabel(frame: CGRectMake(
            CGRectGetWidth(customView.frame)*351/537,
            CGRectGetHeight(customView.frame)*30/238,
            CGRectGetWidth(customView.frame)*174/537,
            CGRectGetHeight(customView.frame)*50/238))
        titLab.textColor = UIColor(red: 140/255.0, green: 39/255.0, blue: 90/255.0, alpha: 1)
        titLab.textAlignment = .Left
        titLab.font = UIFont.systemFontOfSize(16)
        titLab.text = name
        titLab.adjustsFontSizeToFitWidth = true
        customView.addSubview(titLab)
        
        let scoreLab = UILabel(frame: CGRectMake(
            CGRectGetWidth(customView.frame)*351/537,
            CGRectGetHeight(customView.frame)*100/238,
            CGRectGetWidth(customView.frame)*174/537,
            CGRectGetHeight(customView.frame)*50/238))
        scoreLab.textColor = UIColor(red: 252/255.0, green: 13/255.0, blue: 27/255.0, alpha: 1)
        
        scoreLab.textAlignment = .Left
        scoreLab.font = UIFont.systemFontOfSize(24)
        scoreLab.text = "+\(score)"
        scoreLab.adjustsFontSizeToFitWidth = true
        scoreLab.sizeToFit()
        customView.addSubview(scoreLab)
        
        let jifenLab = UILabel(frame: CGRectMake(
            CGRectGetMaxX(scoreLab.frame)+5,
            CGRectGetHeight(customView.frame)*100/238,
            CGRectGetWidth(customView.frame)-CGRectGetMaxX(scoreLab.frame)-5-CGRectGetWidth(customView.frame)*13/537,
            CGRectGetHeight(customView.frame)*50/238))
        jifenLab.textColor = UIColor(red: 107/255.0, green: 106/255.0, blue: 106/255.0, alpha: 1)
        jifenLab.textAlignment = .Center
        jifenLab.font = UIFont.systemFontOfSize(16)
        jifenLab.text = "护士币"
        jifenLab.adjustsFontSizeToFitWidth = true
        jifenLab.center.y = scoreLab.center.y
        customView.addSubview(jifenLab)
        
        hud.customView = customView
        hud.hide(true, afterDelay: 3)
    }
    
    //  用来收起键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        phoneNum.resignFirstResponder()
        yanzheng.resignFirstResponder()
        password.resignFirstResponder()
        passwordNumber.resignFirstResponder()
        phoneNumber.resignFirstResponder()
        // print("触摸")
    }
    //  键盘完成编辑
    func textFieldDidBeginEditing(textField: UITextField) {
        let next = ViewController()
        next.backView.frame = CGRectMake(0, 0, self.view.bounds.width, 100)
    }
    //  成为第一响应
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        switch textField {
        case phoneNumber:
            passwordNumber.becomeFirstResponder()
        case passwordNumber:
            goToMain()
        case phoneNum:
            yanzheng.becomeFirstResponder()
        case yanzheng:
            password.becomeFirstResponder()
        case password:
            submitTheUser()
        default:
            textField.resignFirstResponder()
        }
        
        return true
    }
    //  自动登录
    func autoLogin(){
        
        let logInfo = NSUserDefaults.standardUserDefaults().objectForKey(LOGINFO_KEY) as? Dictionary<String,String>
        
        if logInfo != nil {
            let usernameStr = logInfo![USER_NAME] ?? ""
            let passwordStr = logInfo![USER_PWD] ?? ""
            phoneNumber.text = usernameStr
            passwordNumber.text = passwordStr
            loginWithNum(usernameStr , pwd: passwordStr)
        }
    }
    //  点击事件的登录
    func goToMain() {
        // print("登录")
        if phoneNumber.text!.isEmpty {
            //  弹出请输入手机号
            let alert = UIAlertView(title: "提示信息", message: "请输入手机号！", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            
            return
        }
        
        if passwordNumber.text!.isEmpty{
            //  弹出请输入密码
            let  alert = UIAlertView(title: "提示信息", message: "请输入密码！",delegate: self, cancelButtonTitle: "确定")
            alert.show()
            
            return
        }
        //  self.法方  和 方法的区别
        loginWithNum(phoneNumber.text!, pwd: passwordNumber.text!)
    }
    // 通过手机号和密码进行登录操作
    func loginWithNum(num:String,pwd:String){
        //   SVProgressHUD.show()
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        logVM?.login(num, passwordNumber: pwd, handle: { [unowned self] (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if success == false {
                    if response != nil {
                        hud.hide(true)
                        let string = response as! String
                        if string == "密码错误！" || string == "用户不存在"{
                            let alert = UIAlertView(title:"提示信息",message: string,delegate: self,cancelButtonTitle: "确定")
                            alert.show()
                        }else {
                            let alert = UIAlertView(title: "提示信息", message: string, delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "重试")
                            alert.tag = 100
                            alert.show()
                        }
                        // print(response as! String)
                    }else{
                        let alert = UIAlertView(title:"提示信息",message: "登录失败",delegate: self,cancelButtonTitle: "确定")
                        alert.show()
                    }
                    return
                }else{
                    hud.hide(true)
                    
                    let ud = NSUserDefaults.standardUserDefaults()
                    //  把得到的用户信息存入到沙盒
                    //  得到 useID
                    ud.setObject([USER_NAME:self.phoneNumber.text!,USER_PWD:self.passwordNumber.text!], forKey: LOGINFO_KEY)
                    ud.setObject(QCLoginUserInfo.currentInfo.userid, forKey: "userid")
                    //登录成功
                    LOGIN_STATE = true
                    // print(LoginUserInfo)
                    //登录成功
                    self.loginSuccess()
                }
            })
            })
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView.tag == 100 && buttonIndex == 1 {
            self.goToMain()
        }
    }
    
    
    //  MARK:登录成功
    func loginSuccess(){
        //        self.navigationController?.popViewControllerAnimated(true)
        
        getInvitedUrl()
        
        CloudPushSDK.bindAccount(QCLoginUserInfo.currentInfo.usertype) { (result) in
            
        }
        
        CloudPushSDK.bindTag(1, withTags: [QCLoginUserInfo.currentInfo.userid], withAlias: "") { (result) in
            
        }
        
        CloudPushSDK.addAlias(QCLoginUserInfo.currentInfo.phoneNumber) { (result) in
            
        }
        
        if previousViewcontroller.isKindOfClass(MineViewController) {
            self.navigationController?.pushViewController(MineViewController(), animated: true)
        }else{
            self.navigationController?.popViewControllerAnimated(true)
        }

        
        //        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //  得到分栏控制器
        //            let vc : UITabBarController = mainStoryboard.instantiateViewControllerWithIdentifier("MainView") as! UITabBarController
        //  选择被选中的界面
        //            vc.selectedIndex = 4
        //            // print(vc)
        //            self.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        TimeManager.shareManager.taskDic["register"]?.FHandle = nil
        TimeManager.shareManager.taskDic["register"]?.PHandle = nil
        
        phoneNum.resignFirstResponder()
        yanzheng.resignFirstResponder()
        password.resignFirstResponder()
        passwordNumber.resignFirstResponder()
        phoneNumber.resignFirstResponder()
    }
}

