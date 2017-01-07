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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        //UIApplication.sharedApplication().backgroundRefreshStatus = true
                navigationController?.navigationBar.isHidden = hasBackBarButtonItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  添加一个导航控制器
        //  获取验证码倒计时
        processHandle = {(timeInterVal) in
            DispatchQueue.main.async(execute: {
                //    self.acquire.backgroundColor = COLOR
                self.acquire.isUserInteractionEnabled = false
                let btnTitle = String(timeInterVal) + "秒后重新获取"
                self.acquire.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                self.acquire.setTitleColor(COLOR, for: UIControlState())
                self.acquire.setTitle(btnTitle, for: UIControlState())
                self.gain.text = nil
            })
        }
        //  获取验证码
        finishHandle = {(timeInterVal) in
            DispatchQueue.main.async(execute: {
                self.acquire.isUserInteractionEnabled = true
                // self.acquire.backgroundColor = COLOR
                self.acquire.setTitleColor(COLOR, for: UIControlState())
                self.acquire.setTitle("获取验证码", for: UIControlState())
                self.gain.text = nil
            })
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        logVM = LoginModel()
        self.view.backgroundColor = UIColor.white
        //        self.view.backgroundColor = COLOR
        
        if navigationController?.isNavigationBarHidden == true {
            scrollView.frame = CGRect(x: 0, y: -20, width: WIDTH, height: HEIGHT-49+20)
        }else{
            scrollView.frame = CGRect(x: 0, y: -20-64, width: WIDTH, height: HEIGHT-49+20)
        }
        
        scrollView.backgroundColor = COLOR
        scrollView.contentSize = CGSize(width: 0, height: 0)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        self.view.addSubview(scrollView)
        // print(HEIGHT)
        
        backView.frame = CGRect(x: 0, y: 0, width: WIDTH, height: WIDTH*333/375)
        backView.backgroundColor = COLOR
        scrollView.addSubview(backView)
        LOGO.frame = CGRect(x: WIDTH*109/375, y: WIDTH*107/375, width: WIDTH*157/375, height: WIDTH*155/375)
        LOGO.image = UIImage(named: "LOGO.png")
        scrollView.addSubview(LOGO)
        let btnTit:[String] = ["登录","注册"]
        click = true
        //  登录按钮
        btnOne.frame = CGRect(x: 0, y: WIDTH*333/375-45, width: WIDTH/2, height: 45)
        btnOne.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btnOne.setTitle(btnTit[0], for: UIControlState())
        btnOne.setTitleColor(UIColor.white, for: UIControlState())
        btnOne.addTarget(self, action: #selector(self.loginTheView), for: .touchUpInside)
        backView.addSubview(btnOne)
        //  注册按钮
        btnTwo.frame = CGRect(x: WIDTH/2, y: WIDTH*333/375-45, width: WIDTH/2, height: 45)
        btnTwo.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btnTwo.setTitle(btnTit[1], for: UIControlState())
        btnTwo.setTitleColor(GREY, for: UIControlState())
        btnTwo.addTarget(self, action: #selector(self.registerTheView), for: .touchUpInside)
        backView.addSubview(btnTwo)
        
        self.loginView()
        self.registerView()
        
        line.frame = CGRect(x: 0, y: WIDTH*333/375-4, width: WIDTH/2, height: 4)
        line.backgroundColor = UIColor(red: 250/255.0, green: 118/255.0, blue: 210/255.0, alpha: 1.0)
        scrollView.addSubview(line)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardChangFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        autoLogin()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if delegate != nil {
            delegate?.viewcontrollerDesmiss()
        }
    }
    //  登录界面
    func loginTheView() {
        // print("登录")
        
        
        
        btnOne.setTitleColor(UIColor.white, for: UIControlState())
        btnTwo.setTitleColor(GREY, for: UIControlState())
        UIView.animate(withDuration: 0.2, animations: {
            self.line.frame = CGRect(x: 0, y: WIDTH*333/375-4, width: WIDTH/2, height: 4)
            self.register.frame = CGRect(x: WIDTH, y: WIDTH*333/375, width: WIDTH, height: HEIGHT-WIDTH*333/375)
            self.login.frame = CGRect(x: 0, y: WIDTH*333/375, width: WIDTH, height: HEIGHT-WIDTH*333/375)
        }) 
        password.resignFirstResponder()
        yanzheng.resignFirstResponder()
        phoneNum.resignFirstResponder()
    }
    
    //  注册界面
    func registerTheView() {
        // print("注册")
        btnOne.setTitleColor(GREY, for: UIControlState())
        btnTwo.setTitleColor(UIColor.white, for: UIControlState())
        UIView.animate(withDuration: 0.2, animations: {
            self.line.frame = CGRect(x: WIDTH/2, y: WIDTH*333/375-4, width: WIDTH/2, height: 4)
            self.register.frame = CGRect(x: 0, y: WIDTH*333/375, width: WIDTH, height: HEIGHT-WIDTH*333/375)
            self.login.frame = CGRect(x: -WIDTH, y: WIDTH*333/375, width: WIDTH, height: HEIGHT-WIDTH*333/375)
        }) 
        phoneNumber.resignFirstResponder()
        passwordNumber.resignFirstResponder()
    }
    
    //  KVO（通知中心）监测键盘
    func keyBoardChangFrame(_ info:Notification) {
        let infoDic = info.userInfo
        let keyBoardRect = (infoDic!["UIKeyboardFrameEndUserInfoKey"] as AnyObject).cgRectValue
        let keyBoardTranslate = CGFloat((keyBoardRect?.origin.y)!-HEIGHT)
        
        var rect:CGRect = self.view.frame
        //        rect.origin.y = keyBoardTranslate
        
        if navigationController?.isNavigationBarHidden == true {
            rect.origin.y = keyBoardTranslate
        }else{
            rect.origin.y = keyBoardTranslate+64
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.view.frame = rect
        }) 
    }
    
    //  登录界面UI的搭建
    func loginView() {
        
        login.frame = CGRect(x: 0, y: WIDTH*333/375, width: WIDTH, height: HEIGHT-WIDTH*333/375)
        login.backgroundColor = UIColor.white
        scrollView.addSubview(login)
        
        phoneNumber.frame = CGRect(x: 35, y: WIDTH*40/375, width: WIDTH-60, height: WIDTH*50/375)
        phoneNumber.placeholder = "手机号"
        phoneNumber.font = UIFont.systemFont(ofSize: 16)
        phoneNumber.keyboardType = .numberPad
        phoneNumber.clearButtonMode = .whileEditing
        phoneNumber.returnKeyType = .next
        login.addSubview(phoneNumber)
        phoneNumber.delegate = self
        
        for i in 0...1 {
            let border = UILabel(frame: CGRect(x: 25, y: WIDTH*40/375+WIDTH*60/375*CGFloat(i), width: WIDTH-50, height: WIDTH*50/375))
            border.layer.borderWidth = 1
            border.layer.borderColor = GREY.cgColor
            login.addSubview(border)
        }
        
        passwordNumber.frame = CGRect(x: 35, y: WIDTH*100/375, width: WIDTH-60, height: WIDTH*50/375)
        passwordNumber.placeholder = "密码"
        passwordNumber.font = UIFont.systemFont(ofSize: 16)
        passwordNumber.isSecureTextEntry = true
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 37, height: 20))
        let rightBtn = UIButton(frame: CGRect(x: 0, y: 2, width: 22, height: 16))
        rightBtn.setImage(UIImage(named: "btn_eye_sel"), for: .selected)
        rightBtn.setImage(UIImage(named: "btn_eye"), for: UIControlState())
        rightBtn.tag = 101
        rightBtn.addTarget(self, action: #selector(showOrHiddenPWD(_:)), for: .touchUpInside)
        rightView.addSubview(rightBtn)
        passwordNumber.rightView = rightView
        passwordNumber.rightViewMode = .whileEditing
        passwordNumber.returnKeyType = .done
        login.addSubview(passwordNumber)
        passwordNumber.delegate = self
        
        loginBtn.frame = CGRect(x: 25, y: WIDTH*180/375, width: WIDTH-50, height: WIDTH*50/375)
        loginBtn.layer.cornerRadius = WIDTH*25/375
        loginBtn.layer.borderWidth = 1.5
        loginBtn.layer.borderColor = COLOR.cgColor
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        loginBtn.setTitle("登录", for: UIControlState())
        loginBtn.setTitle("", for: .highlighted)
        loginBtn.setTitleColor(COLOR, for: UIControlState())
        loginBtn.addTarget(self, action: #selector(self.goToMain), for: .touchUpInside)
        login.addSubview(loginBtn)
        
        //  忘记密码的按钮
        forgetPwdBtn.frame = CGRect(x: 25, y: WIDTH*235/375, width: WIDTH-50, height: WIDTH*50/375)
        forgetPwdBtn.setTitle("忘记密码?", for: UIControlState())
        forgetPwdBtn.setTitleColor(COLOR, for: UIControlState())
        //  设置字体大小
        forgetPwdBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        forgetPwdBtn.addTarget(self, action: #selector(self.changePassWord), for: .touchUpInside)
        login.addSubview(forgetPwdBtn)
        
        //        scrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMinY(login.frame)+CGRectGetMaxY(forgetPwdBtn.frame)+10-20)
        
    }
    
    func showOrHiddenPWD(_ btn:UIButton) {
        if btn.tag == 101 {
            passwordNumber.isSecureTextEntry = !passwordNumber.isSecureTextEntry
        }else{
            password.isSecureTextEntry = !password.isSecureTextEntry
        }
        btn.isSelected = !btn.isSelected
    }
    
    //  修改密码
    func changePassWord(){
        // print("修改密码")
        //  跳转页面
        let forGetVC = ForgetPasswordController()
        forGetVC.delegate = self
        forGetVC.flag = (navigationController?.navigationBar.isHidden)!
        self.navigationController?.pushViewController(forGetVC, animated: true)
    }
    
    func changeNavigation(_ flag:Bool) {
        navigationController?.navigationBar.isHidden = flag
    }
    
    //  MARK:注册界面UI的搭建
    func registerView() {
        register.frame = CGRect(x: WIDTH, y: WIDTH*333/375, width: WIDTH, height: HEIGHT-WIDTH*333/375)
        register.backgroundColor = UIColor.white
        scrollView.addSubview(register)
        
        phoneNum.frame = CGRect(x: 35, y: WIDTH*15/375, width: WIDTH-60, height: WIDTH*50/375)
        phoneNum.placeholder = "手机号"
        phoneNum.font = UIFont.systemFont(ofSize: 16)
        phoneNum.keyboardType = .numberPad
        phoneNum.clearButtonMode = .whileEditing
        phoneNum.returnKeyType = .next
        register.addSubview(phoneNum)
        phoneNum.delegate = self
        
        yanzheng.frame = CGRect(x: 35, y: WIDTH*75/375, width: 150, height: WIDTH*50/375)
        yanzheng.placeholder = "验证码"
        yanzheng.font = UIFont.systemFont(ofSize: 16)
        yanzheng.returnKeyType = .next
        register.addSubview(yanzheng)
        yanzheng.delegate = self
        
        for i in 0...2 {
            let border = UILabel(frame: CGRect(x: 25, y: WIDTH*15/375+WIDTH*60/375*CGFloat(i), width: WIDTH-50, height: WIDTH*50/375))
            border.layer.borderWidth = 1
            border.layer.borderColor = GREY.cgColor
            register.addSubview(border)
        }
        
        password.frame = CGRect(x: 35, y: WIDTH*135/375, width: WIDTH-60, height: WIDTH*50/375)
        password.placeholder = "密码"
        password.font = UIFont.systemFont(ofSize: 16)
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 37, height: 20))
        let rightBtn = UIButton(frame: CGRect(x: 0, y: 2, width: 22, height: 16))
        rightBtn.setImage(UIImage(named: "btn_eye_sel"), for: .selected)
        rightBtn.setImage(UIImage(named: "btn_eye"), for: UIControlState())
        rightBtn.tag = 102
        rightBtn.addTarget(self, action: #selector(showOrHiddenPWD(_:)), for: .touchUpInside)
        rightView.addSubview(rightBtn)
        password.rightView = rightView
        password.rightViewMode = .whileEditing
        password.returnKeyType = .done
        register.addSubview(password)
        password.delegate = self
        
        let btnWidth:CGFloat = 60
        let btnHeight:CGFloat = 20
        let margin:CGFloat = 10
        
        // 个人
        personalBtn.frame = CGRect(x: WIDTH/2.0-margin-btnWidth, y: password.frame.maxY+10, width: btnWidth, height: btnHeight)
        personalBtn.addTarget(self, action: #selector(personalOrBusinessBtnClick(_:)), for: .touchUpInside)
        register.addSubview(personalBtn)
        
        personalImg.frame = CGRect(x: 0, y: 2, width: btnHeight-4, height: btnHeight-4)
        personalImg.image = UIImage.init(named: "ic_gou_sel")
        personalBtn.addSubview(personalImg)
        
        personalLab.frame = CGRect(x: btnHeight+5, y: 0, width: btnWidth-btnHeight-5, height: btnHeight)
        personalLab.textColor = COLOR
        personalLab.font = UIFont.systemFont(ofSize: 14)
        personalLab.text = "个人"
        personalBtn.addSubview(personalLab)
        
        // 企业
        businessBtn.frame = CGRect(x: WIDTH/2.0+margin, y: password.frame.maxY+10, width: btnWidth, height: btnHeight)
        businessBtn.addTarget(self, action: #selector(personalOrBusinessBtnClick(_:)), for: .touchUpInside)
        register.addSubview(businessBtn)
        
        businessImg.frame = CGRect(x: 0, y: 2, width: btnHeight-4, height: btnHeight-4)
        businessImg.image = UIImage.init(named: "ic_kuang")
        businessBtn.addSubview(businessImg)
        
        businessLab.frame = CGRect(x: btnHeight+5, y: 0, width: btnWidth-btnHeight-5, height: btnHeight)
        businessLab.textColor = GREY
        businessLab.font = UIFont.systemFont(ofSize: 14)
        businessLab.text = "企业"
        businessBtn.addSubview(businessLab)
        
        gain.frame = CGRect(x: WIDTH-130, y: WIDTH*75/375+(WIDTH*50/375-30)/2, width: 95, height: 30)
        gain.text = "获取验证码"
        gain.font = UIFont.systemFont(ofSize: 14)
        gain.textColor = COLOR
        gain.textAlignment = .center
        register.addSubview(gain)
        
        //  获取验证码的button
        acquire.frame = CGRect(x: WIDTH-130, y: WIDTH*75/375+(WIDTH*50/375-30)/2, width: 95, height: 30)
        acquire.layer.cornerRadius = 13
        acquire.layer.borderColor = COLOR.cgColor
        acquire.addTarget(self, action: #selector(self.gainTheCard), for: .touchUpInside)
        acquire.layer.borderWidth = 1.5
        register.addSubview(acquire)
        
        submit.frame = CGRect(x: 25, y: WIDTH*212/375+btnHeight, width: WIDTH-50, height: WIDTH*50/375)
        submit.layer.cornerRadius = WIDTH*25/375
        submit.layer.borderWidth = 1.5
        submit.layer.borderColor = COLOR.cgColor
        submit.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        submit.setTitle("提交", for: UIControlState())
        submit.setTitle("", for: .highlighted)
        submit.setTitleColor(COLOR, for: UIControlState())
        submit.addTarget(self, action: #selector(self.submitTheUser), for: .touchUpInside)
        register.addSubview(submit)
        
        //        scrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMinY(register.frame)+CGRectGetMaxY(submit.frame)+10-20)
    }
    
    func personalOrBusinessBtnClick(_ button:UIButton) {
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
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        //            hud.mode = MBProgressHUDMode.Text;
        //        hud.label.text = "正在发送邀请"
        hud.margin = 10.0
        hud.removeFromSuperViewOnHide = true
        
        logVM?.comfirmPhoneHasRegister(phoneNum.text!, handle: {(success, response) in
            DispatchQueue.main.async(execute: {
                //  不管填什么内容都走了这个方法
                if success {
                    hud.hide(animated: true)
                    let alert = UIAlertView(title:"提示信息",message: "手机已注册",delegate: self,cancelButtonTitle: "确定")
                    
                    alert.show()
                }else{
                    hud.hide(animated: true)
                    //  单例进行倒计时
                    TimeManager.shareManager.begainTimerWithKey("register", timeInterval: 30, process: self.processHandle!, finish: self.finishHandle!)
                    self.logVM?.sendMobileCodeWithPhoneNumber(self.phoneNum.text!)
                }
            })
            
            })
        // print("get identify")
    }
    
    // 验证手机号是否正确
    func validationEmailFormat(_ string:String) -> Bool {
        
//        let mobileRegex = "^((13[0-9])|(147)|(170)|(15[^4,\\D])|(18[0-9]))\\d{8}$"
        let mobileRegex = "(^(13[0-9]|14[0-9]|15[0-9]|17[0-9]|18[0-9])\\d{8}$)"

        let mobileTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@",mobileRegex)
        return mobileTest.evaluate(with: string)
        
    }
    
    // MARK: - 注册提交事件
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
                        code:yanzheng.text!,usertype:usertype,devicestate:"1", handle: {(success, response) in
                            DispatchQueue.main.async(execute: {
                                if success {
                                    
                                    
                                    
                                    let alertVC = UIAlertController(title: "提示信息", message: "注册成功", preferredStyle: .alert)
                                    self.present(alertVC, animated: true, completion: nil)
                                    
                                    let alertAction = UIAlertAction(title: "确定", style: .default, handler: { (action) in
                                        self.loginWithNum(self.phoneNum.text!, pwd: self.password.text!)
                                        
                                        self.phoneNum.text = nil
                                        self.password.text = nil
                                        self.yanzheng.text = nil
                                    })
                                    alertVC.addAction(alertAction)
//                                    let alert = UIAlertView(title: "提示信息",message: "注册成功",delegate: self,cancelButtonTitle: "确定")
//                                    alert.show()
                                    let result = response as! addScore_ReadingInformationDataModel
                                    NursePublicAction.showScoreTips(UIApplication.shared.keyWindow!, nameString: result.event, score: result.score)
                                    
//                                    _ = self.navigationController?.popViewControllerAnimated(true)
                                }else{
                                    let alert = UIAlertView(title: "提示信息",message: response as? String,delegate: self,cancelButtonTitle: "确定")
                                    alert.show()
                                }
                            })
            })
    }
    
    //  用来收起键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        phoneNum.resignFirstResponder()
        yanzheng.resignFirstResponder()
        password.resignFirstResponder()
        passwordNumber.resignFirstResponder()
        phoneNumber.resignFirstResponder()
        // print("触摸")
    }
    //  键盘完成编辑
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let next = ViewController()
        next.backView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 100)
    }
    //  成为第一响应
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
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
        
        let logInfo = UserDefaults.standard.object(forKey: LOGINFO_KEY) as? Dictionary<String,String>
        
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
    func loginWithNum(_ num:String,pwd:String){
        //   SVProgressHUD.show()
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        logVM?.login(num, passwordNumber: pwd, handle: {(success, response) in
            DispatchQueue.main.async(execute: {
                if success == false {
                    if response != nil {
                        hud.hide(animated: true)
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
                    hud.hide(animated: true)
                    
                    let ud = UserDefaults.standard
                    //  把得到的用户信息存入到沙盒
                    //  得到 useID
                    ud.set([USER_NAME:num,USER_PWD:pwd], forKey: LOGINFO_KEY)
                    ud.set(QCLoginUserInfo.currentInfo.userid, forKey: "userid")
                    //登录成功
                    LOGIN_STATE = true
                    // print(LoginUserInfo)
                    //登录成功
                    self.loginSuccess()
                }
            })
            })
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if alertView.tag == 100 && buttonIndex == 1 {
            self.goToMain()
        }
    }
    
    
    //  MARK:登录成功
    func loginSuccess(){
        //        _ = self.navigationController?.popViewControllerAnimated(true)
        
        getInvitedUrl()
        
        CloudPushSDK.bindAccount(QCLoginUserInfo.currentInfo.usertype) { (result) in
            
        }
        
        CloudPushSDK.bindTag(1, withTags: [QCLoginUserInfo.currentInfo.userid], withAlias: "") { (result) in
            
        }
        
        CloudPushSDK.addAlias(QCLoginUserInfo.currentInfo.phoneNumber) { (result) in
            
        }
        
        if previousViewcontroller.isKind(of: MineViewController.self) {
            self.navigationController?.pushViewController(MineViewController(), animated: true)
        }else{
            _ = self.navigationController?.popViewController(animated: true)
        }

        
        //        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //  得到分栏控制器
        //            let vc : UITabBarController = mainStoryboard.instantiateViewControllerWithIdentifier("MainView") as! UITabBarController
        //  选择被选中的界面
        //            vc.selectedIndex = 4
        //            // print(vc)
        //            self.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        TimeManager.shareManager.taskDic["register"]?.FHandle = nil
        TimeManager.shareManager.taskDic["register"]?.PHandle = nil
        
        phoneNum.resignFirstResponder()
        yanzheng.resignFirstResponder()
        password.resignFirstResponder()
        passwordNumber.resignFirstResponder()
        phoneNumber.resignFirstResponder()
    }
}

