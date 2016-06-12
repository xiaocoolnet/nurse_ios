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
    
    let phoneNum = UITextField()
    let yanzheng = UITextField()
    let password = UITextField()
    let acquire = UIButton()
    let gain = UILabel()
    let submit = UIButton()
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        self.navigationController?.navigationBar.hidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        
        
        btnOne.frame = CGRectMake(0, WIDTH*363/375-45, WIDTH/2, 45)
        btnOne.titleLabel?.font = UIFont.systemFontOfSize(18)
        btnOne.setTitle(btnTit[0], forState: .Normal)
        btnOne.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnOne.addTarget(self, action: #selector(self.loginTheView), forControlEvents: .TouchUpInside)
        backView.addSubview(btnOne)
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

    }
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
        
        loginBtn.frame = CGRectMake(25, WIDTH*212/375, WIDTH-50, WIDTH*50/375)
        loginBtn.layer.cornerRadius = WIDTH*25/375
        loginBtn.layer.borderWidth = 1.5
        loginBtn.layer.borderColor = COLOR.CGColor
        loginBtn.titleLabel?.font = UIFont.systemFontOfSize(18)
        loginBtn.setTitle("登录", forState: .Normal)
        loginBtn.setTitle("", forState: .Highlighted)
        loginBtn.setTitleColor(COLOR, forState: .Normal)
        loginBtn.addTarget(self, action: #selector(self.goToMain), forControlEvents: .TouchUpInside)
        login.addSubview(loginBtn)

    }
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
    func gainTheCard() {
        print("获取验证码")
        phoneNum.resignFirstResponder()
        yanzheng.resignFirstResponder()
        password.resignFirstResponder()
        
        
    }
    func submitTheUser() {
        print("提交")
        phoneNum.resignFirstResponder()
        yanzheng.resignFirstResponder()
        password.resignFirstResponder()
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        phoneNum.resignFirstResponder()
        yanzheng.resignFirstResponder()
        password.resignFirstResponder()
        passwordNumber.resignFirstResponder()
        phoneNumber.resignFirstResponder()
        print("触摸")
        
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        let next = ViewController()
        next.backView.frame = CGRectMake(0, 0, self.view.bounds.width, 100)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    func goToMain() {
        print("登录")
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MainView")
        vc.tabBarController?.selectedIndex = 4
        self.presentViewController(vc, animated: true, completion: nil)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

