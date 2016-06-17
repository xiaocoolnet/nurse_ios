
//
//  ViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    
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
    let acquire = UIButton()
    let gain = UILabel()
    let submit = UIButton()
    
    var logVM = LoginModel?()
    
    var processHandle:TimerHandle?
    var finishHandle:TimerHandle?


    
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        self.navigationController?.navigationBar.hidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  添加一个导航控制器
        //  获取验证码倒计时
        processHandle = {[unowned self] (timeInterVal) in
            dispatch_async(dispatch_get_main_queue(), {
                //                self.acquire.backgroundColor = COLOR
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
                //                self.acquire.backgroundColor = COLOR
                self.acquire.setTitleColor(COLOR, forState: .Normal)
                
                self.acquire.setTitle("获取验证码", forState: .Normal)
                self.gain.text = nil

            })
        }
        
   
        // Do any additional setup after loading the view, typically from a nib.
        logVM = LoginModel()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        scrollView.frame = CGRectMake(0, -20, WIDTH, HEIGHT+20)
        scrollView.contentSize = CGSizeMake(0, WIDTH*655/375)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        self.view.addSubview(scrollView)
        print(HEIGHT)
        
        backView.frame = CGRectMake(0, 0, WIDTH, WIDTH*363/375)
        backView.backgroundColor = COLOR
        scrollView.addSubview(backView)
        LOGO.frame = CGRectMake(WIDTH*109/375, WIDTH*107/375, WIDTH*157/375, WIDTH*155/375)
        LOGO.image = UIImage(named: "LOGO.png")
        scrollView.addSubview(LOGO)
        
        let btnTit:[String] = ["登录","注册"]
        click = true
        
        //  登录按钮
        btnOne.frame = CGRectMake(0, WIDTH*363/375-45, WIDTH/2, 45)
        btnOne.titleLabel?.font = UIFont.systemFontOfSize(18)
        btnOne.setTitle(btnTit[0], forState: .Normal)
        btnOne.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnOne.addTarget(self, action: #selector(self.loginTheView), forControlEvents: .TouchUpInside)
        backView.addSubview(btnOne)
        //  注册按钮
        btnTwo.frame = CGRectMake(WIDTH/2, WIDTH*363/375-45, WIDTH/2, 45)
        btnTwo.titleLabel?.font = UIFont.systemFontOfSize(18)
        btnTwo.setTitle(btnTit[1], forState: .Normal)
        btnTwo.setTitleColor(GREY, forState: .Normal)
        btnTwo.addTarget(self, action: #selector(self.registerTheView), forControlEvents: .TouchUpInside)
        backView.addSubview(btnTwo)
        
        self.loginView()
        self.registerView()
        
        line.frame = CGRectMake(0, WIDTH*363/375-4, WIDTH/2, 4)
        line.backgroundColor = UIColor(red: 250/255.0, green: 118/255.0, blue: 210/255.0, alpha: 1.0)
        scrollView.addSubview(line)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyBoardChangFrame(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        
        autoLogin()

    }
    //  登录界面
    func loginTheView() {
        print("登录")

        btnOne.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnTwo.setTitleColor(GREY, forState: .Normal)
        UIView.animateWithDuration(0.2) {
            self.line.frame = CGRectMake(0, WIDTH*363/375-4, WIDTH/2, 4)
            self.register.frame = CGRectMake(WIDTH, WIDTH*363/375, WIDTH, HEIGHT-WIDTH*363/375)
            self.login.frame = CGRectMake(0, WIDTH*363/375, WIDTH, HEIGHT-WIDTH*363/375)
        }
        password.resignFirstResponder()
        yanzheng.resignFirstResponder()
        phoneNum.resignFirstResponder()
    }
    //  注册界面
    func registerTheView() {
        print("注册")
        btnOne.setTitleColor(GREY, forState: .Normal)
        btnTwo.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        UIView.animateWithDuration(0.2) {
            self.line.frame = CGRectMake(WIDTH/2, WIDTH*363/375-4, WIDTH/2, 4)
            self.register.frame = CGRectMake(0, WIDTH*363/375, WIDTH, HEIGHT-WIDTH*363/375)
            self.login.frame = CGRectMake(-WIDTH, WIDTH*363/375, WIDTH, HEIGHT-WIDTH*363/375)
        }
        phoneNumber.resignFirstResponder()
        passwordNumber.resignFirstResponder()
    }
    //  KVO（通知中心）监测键盘
    func keyBoardChangFrame(info:NSNotification) {
        let infoDic = info.userInfo
        let keyBoardRect = infoDic!["UIKeyboardFrameEndUserInfoKey"]?.CGRectValue()
        let keyBoardTranslate = CGFloat((keyBoardRect?.origin.y)!-HEIGHT)
        
        UIView.animateWithDuration((infoDic!["UIKeyboardAnimationCurveUserInfoKey"]?.doubleValue)!, delay: 0, options: .TransitionNone, animations: {
            var rect:CGRect = self.view.frame
            rect.origin.y = keyBoardTranslate
            self.view.frame = rect
            
            }, completion: nil)
    }
    //  登录界面UI的搭建
    func loginView() {
        
        login.frame = CGRectMake(0, WIDTH*363/375, WIDTH, HEIGHT-WIDTH*363/375)
        login.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(login)
        
        phoneNumber.frame = CGRectMake(35, WIDTH*40/375, WIDTH-60, WIDTH*50/375)
        phoneNumber.placeholder = "手机号"
        phoneNumber.font = UIFont.systemFontOfSize(16)
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
        
    }
    //  修改密码
    func changePassWord(){
        print("修改密码")
        //  跳转页面 
        let forGetVC = ForgetPasswordController()
        
        self.navigationController?.pushViewController(forGetVC, animated: true)
    }
    //  注册界面UI的搭建
    func registerView() {
        register.frame = CGRectMake(WIDTH, WIDTH*363/375, WIDTH, HEIGHT-WIDTH*363/375)
        register.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(register)
        
        phoneNum.frame = CGRectMake(35, WIDTH*15/375, WIDTH-60, WIDTH*50/375)
        phoneNum.placeholder = "手机号"
        phoneNum.font = UIFont.systemFontOfSize(16)
        register.addSubview(phoneNum)
        phoneNum.delegate = self
        
        yanzheng.frame = CGRectMake(35, WIDTH*75/375, 150, WIDTH*50/375)
        yanzheng.placeholder = "验证码"
        yanzheng.font = UIFont.systemFontOfSize(16)
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
        register.addSubview(password)
        password.delegate = self
        
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
  
        submit.frame = CGRectMake(25, WIDTH*212/375, WIDTH-50, WIDTH*50/375)
        submit.layer.cornerRadius = WIDTH*25/375
        submit.layer.borderWidth = 1.5
        submit.layer.borderColor = COLOR.CGColor
        submit.titleLabel?.font = UIFont.systemFontOfSize(18)
        submit.setTitle("提交", forState: .Normal)
        submit.setTitle("", forState: .Highlighted)
        submit.setTitleColor(COLOR, forState: .Normal)
        submit.addTarget(self, action: #selector(self.submitTheUser), forControlEvents: .TouchUpInside)
        register.addSubview(submit)


    }
    //  点击短信获取验证码
    func gainTheCard() {
        print("获取验证码")
        phoneNum.resignFirstResponder()
        yanzheng.resignFirstResponder()
        password.resignFirstResponder()
        if phoneNum.text!.isEmpty {
//            SVProgressHUD.showErrorWithStatus("请输入手机号！")
            let alert = UIAlertView(title:"提示信息",message: "请输入手机号！",delegate: self,cancelButtonTitle: "确定")
            
            alert.show()
            return
        }
//        logVM?.register(phoneNum.text!, password: password.text!, code: yanzheng.text!, usertype: "1", devicestate: "1", handle: { (success, response) in
//            
//        })
        logVM?.comfirmPhoneHasRegister(phoneNum.text!, handle: {[unowned self](success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                //  不管填什么内容都走了这个方法
                if success {
                    

                    let alert = UIAlertView(title:"提示信息",message: "手机已注册",delegate: self,cancelButtonTitle: "确定")
                    
                    alert.show()
                }else{
                    //  单例进行倒计时
                    TimeManager.shareManager.begainTimerWithKey("register", timeInterval: 30, process: self.processHandle!, finish: self.finishHandle!)
                    self.logVM?.sendMobileCodeWithPhoneNumber(self.phoneNum.text!)
                }
            })
            
            })
        print("get identify")

        
        
    }
    //  注册提交事件
    func submitTheUser() {
        print("提交")
        phoneNum.resignFirstResponder()
        yanzheng.resignFirstResponder()
        password.resignFirstResponder()
        if phoneNum.text!.isEmpty {
//            SVProgressHUD.showErrorWithStatus("请输入手机号！")
            let alert = UIAlertView(title: "提示信息",message: "请输入手机号",delegate: self,cancelButtonTitle: "确定")
            alert.show()
            return
        }
        
        if yanzheng.text!.isEmpty {
//            SVProgressHUD.showErrorWithStatus("请输入验证码!")
            let alert = UIAlertView(title: "提示信息",message: "请输入验证码",delegate: self,cancelButtonTitle: "确定")
            alert.show()
            return
        }
        
        if password.text!.isEmpty {
//            SVProgressHUD.showErrorWithStatus("请输入密码!")
            let alert = UIAlertView(title: "提示信息",message: "请输入密码",delegate: self,cancelButtonTitle: "确定")
            alert.show()
            return
        }
        

        logVM?.register(phoneNum.text!,password:password.text!,
                        code:yanzheng.text!,usertype:"1",devicestate:"1", handle: { [unowned self] (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if success {
                    
                    self.phoneNum.text = nil
                    self.password.text = nil
                    self.yanzheng.text = nil
                    let alert = UIAlertView(title: "提示信息",message: "注册成功",delegate: self,cancelButtonTitle: "确定")
                    alert.show()
//                    SVProgressHUD.showSuccessWithStatus("注册成功")
                    self.navigationController?.popViewControllerAnimated(true)
                }else{
                    let alert = UIAlertView(title: "提示信息",message: response as? String,delegate: self,cancelButtonTitle: "确定")
                    alert.show()
//                    SVProgressHUD.showErrorWithStatus(response as! String)
                }
            })
            })

        
        
    }
    //  用来收起键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        phoneNum.resignFirstResponder()
        yanzheng.resignFirstResponder()
        password.resignFirstResponder()
        passwordNumber.resignFirstResponder()
        phoneNumber.resignFirstResponder()
        print("触摸")
        
    }
    //  键盘完成编辑
    func textFieldDidBeginEditing(textField: UITextField) {
        let next = ViewController()
        next.backView.frame = CGRectMake(0, 0, self.view.bounds.width, 100)
    }
    //  成为第一响应
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //  自动登录
    func autoLogin(){
        let logInfo = NSUserDefaults.standardUserDefaults().objectForKey("logInfo") as? Dictionary<String,String>
        if logInfo != nil {
            let usernameStr = logInfo!["username"]!
            let passwordStr = logInfo!["password"]!
            phoneNumber.text = usernameStr
            password.text = passwordStr
            loginWithNum(usernameStr , pwd: passwordStr)
        }
    }
    //  点击事件的登录
    func goToMain() {
        print("登录")
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
        
//        SVProgressHUD.show()
        
        logVM?.login(num, passwordNumber: pwd, handle: { [unowned self] (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if success == false {
                    if response != nil {
//                        SVProgressHUD.showErrorWithStatus(response as! String)
                        let string = response as! String
                        if string == "密码错误！" || string == "用户不存在"{
                        let alert = UIAlertView(title:"提示信息",message: string,delegate: self,cancelButtonTitle: "确定")
                        
                        alert.show()
                    }
                        print(response as! String)
                    }else{
//                        SVProgressHUD.showErrorWithStatus("登录失败")
                        let alert = UIAlertView(title:"提示信息",message: "登录失败",delegate: self,cancelButtonTitle: "确定")
                        alert.show()
                    }
                    return
                }else{
                    //  改为新的方法
//                     let alert = UIAlertView(title:"提示信息",message: "登录成功",delegate: self,cancelButtonTitle: "确定")
//                    SVProgressHUD.showSuccessWithStatus("登录成功")
                    
//                    alert.show()
                    let ud = NSUserDefaults.standardUserDefaults()
//<<<<<<< Updated upstream
                    //  把得到的用户信息存入到沙盒
                    //  得到 useID
                    //
                        ud.setObject(["username":self.phoneNumber.text!,"password":self.password.text!], forKey: "logInfo")
                        ud.setObject(QCLoginUserInfo.currentInfo.userid, forKey: "userid")
                    //登录成功
                    
                    print(LoginUserInfo)
//=======
                    
                    ud.setObject(["username":self.phoneNumber.text!,"password":self.password.text!], forKey: "logInfo")
                    
                    //登录成功                    
//>>>>>>> Stashed changes
                    self.loginSuccess()
                }
            })
            })
        
    }
    //  登录成功
    func loginSuccess(){
        
        
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //  得到分栏控制器
            let vc : UITabBarController = mainStoryboard.instantiateViewControllerWithIdentifier("MainView") as! UITabBarController
        //  选择被选中的界面
            vc.selectedIndex = 4
            print(vc)
//<<<<<<< Updated upstream
        //  模态出个人界面
//=======
//>>>>>>> Stashed changes
            self.presentViewController(vc, animated: true, completion: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

