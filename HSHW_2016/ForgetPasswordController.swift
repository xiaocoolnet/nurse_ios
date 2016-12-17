//
//  ForgetPasswordController.swift
//  HSHW_2016
//
//  Created by JQ on 16/6/17.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

protocol ForgetPasswordDelegate {
    func changeNavigation(_ flag:Bool)
}

class ForgetPasswordController: UIViewController {
    
    var flag = true
    
    var phoneLabel:UILabel!
    var checkLabel:UILabel!
    var passWordLabel:UILabel!
    var passCheckLabel:UILabel!
    
    var phoneNumFiled:UITextField!
    var checkNumFiled:UITextField!
    var passWordFiled:UITextField!
    var passNumCheckFiled:UITextField!
    
    var checkNumBtn:UIButton!
    var showPassWordBtn:UIButton!
    var showPassCheckBtn:UIButton!
    var successBtn:UIButton!
    
    var backView:UIView!
    
    var numView:UIView!
    var phoneNumView:UIView!
    var checkView:UIView!
    var passWordView:UIView!
    var checkPassView:UIView!
    
    var delegate:ForgetPasswordDelegate?
    
    //  注册功能
    var changeVM:LoginModel?
    //  倒计时功能
    var processHandle:TimerHandle?
    var finishHandle:TimerHandle?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightGray
        //  显示导航控制器
        self.navigationController?.navigationBar.isHidden = false
        self.title = "修改密码"
        
        
        changeVM = LoginModel()
        
        //  1.验证码倒计时
        time()
        //  2.创建视图
        createView()
        //  3.搭建UI
        createUI()


    }
    func time(){
        processHandle = {(timeInterVal) in
            DispatchQueue.main.async(execute: {
                self.checkNumBtn.isUserInteractionEnabled = false
                let btnTitle = String(timeInterVal) + "秒后重新获取"
                self.checkNumBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                self.checkNumBtn.setTitleColor(COLOR, for: UIControlState())
                
                self.checkNumBtn.setTitle(btnTitle, for: UIControlState())
                
                
                
            })
        }
        
        finishHandle = {(timeInterVal) in
            DispatchQueue.main.async(execute: {
                self.checkNumBtn.isUserInteractionEnabled = true
                self.checkNumBtn.setTitleColor(COLOR, for: UIControlState())
                self.checkNumBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                self.checkNumBtn.setTitle("获取验证码", for: UIControlState())
            })
        }
        TimeManager.shareManager.taskDic["forget"]?.FHandle = finishHandle
        TimeManager.shareManager.taskDic["forget"]?.PHandle = processHandle
    }
    
    // MARK: - createView(创建视图)
    func createView(){
        //  创建五个视图
        numView = UIView()
        numView.frame = CGRect(x: 0, y: 40, width: 80, height: 60)
        numView.backgroundColor = UIColor.white
        self.view.addSubview(numView)
        
        phoneNumView = UIView()
        phoneNumView.frame = CGRect(x: 81, y: 40, width: WIDTH - 81, height: 60)
        phoneNumView.backgroundColor = UIColor.white
        self.view.addSubview(phoneNumView)
    
        checkView = UIView()
        checkView.frame = CGRect(x: 0, y: 101, width: WIDTH, height: 60)
        checkView.backgroundColor = UIColor.white
        self.view.addSubview(checkView)
        
        passWordView = UIView()
        passWordView.frame = CGRect(x: 0, y: 162, width: WIDTH, height: 60)
        passWordView.backgroundColor = UIColor.white
        self.view.addSubview(passWordView)
        
        checkPassView = UIView()
        checkPassView.frame = CGRect(x: 0, y: 223 , width: WIDTH, height: 60)
        checkPassView.backgroundColor = UIColor.white
        self.view.addSubview(checkPassView)
    }
        // MARK: - createUI(创建界面控件)
    func createUI(){

        //  四个label
        phoneLabel = UILabel()
        phoneLabel.frame = CGRect(x: 20, y: 15, width: 60, height: 30)
        phoneLabel.text = "+86"
        phoneLabel.font = UIFont.systemFont(ofSize: 16)
        numView.addSubview(phoneLabel)
        
        checkLabel = UILabel()
        checkLabel.frame = CGRect(x: 20, y: 15, width: 70, height: 30)
        checkLabel.text = "验证码"
        checkLabel.font = UIFont.systemFont(ofSize: 16)
        checkView.addSubview(checkLabel)
        
        passWordLabel = UILabel()
        passWordLabel.frame = CGRect(x: 20, y: 15, width: 70, height: 30)
        passWordLabel.text = "输入密码"
        passWordLabel.font = UIFont.systemFont(ofSize: 16)
        passWordView.addSubview(passWordLabel)
        
        passCheckLabel = UILabel()
        passCheckLabel.frame = CGRect(x: 20, y: 15, width: 70, height: 30)
        passCheckLabel.text = "确认密码"
        passCheckLabel.font = UIFont.systemFont(ofSize: 16)
        checkPassView.addSubview(passCheckLabel)
        
        //  四个textFiled
        phoneNumFiled = UITextField()
        phoneNumFiled.frame = CGRect(x: 19, y: 15, width: WIDTH * 0.4, height: 30)
        phoneNumFiled.font = UIFont.systemFont(ofSize: 14)
        phoneNumFiled.placeholder = "请输入手机号"
        phoneNumView.addSubview(phoneNumFiled)
        
        checkNumFiled = UITextField()
        checkNumFiled.frame = CGRect(x: 100, y: 15, width: WIDTH * 0.4, height: 30)
        checkNumFiled.font = UIFont.systemFont(ofSize: 14)
        checkNumFiled.placeholder = "请输入验证码"
        checkView.addSubview(checkNumFiled)
        
        passWordFiled = UITextField()
        passWordFiled.frame = CGRect(x: 100, y: 15, width: WIDTH * 0.4, height: 30)
        passWordFiled.font = UIFont.systemFont(ofSize: 14)
        passWordFiled.placeholder = "请输入密码"
        //  密文输入
        passWordFiled.isSecureTextEntry = true
        passWordView.addSubview(passWordFiled)
        
        passNumCheckFiled = UITextField()
        passNumCheckFiled.frame = CGRect(x: 100, y: 15, width: WIDTH * 0.4, height: 30)
        passNumCheckFiled.font = UIFont.systemFont(ofSize: 14)
        passNumCheckFiled.placeholder = "请确认密码"
        passNumCheckFiled.isSecureTextEntry = true
        checkPassView.addSubview(passNumCheckFiled)
        
        //  四个button
    
        checkNumBtn = UIButton()
        checkNumBtn.frame = CGRect(x: WIDTH - 191, y: 15, width: 100, height: 30)
        checkNumBtn.layer.cornerRadius = 13
        checkNumBtn.layer.borderColor = COLOR.cgColor
        checkNumBtn.layer.borderWidth = 1.5
        checkNumBtn.setTitle("获取验证码", for: UIControlState())
        checkNumBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        checkNumBtn.setTitleColor(COLOR, for: UIControlState())
        checkNumBtn.addTarget(self, action: #selector(self.getCheckNum), for: .touchUpInside)
        phoneNumView.addSubview(checkNumBtn)
        
        showPassWordBtn = UIButton()
        showPassWordBtn.frame = CGRect(x: WIDTH - 40, y: 15, width: 30, height: 30)
        showPassWordBtn.setImage(UIImage(named: "btn_eye_sel"), for: UIControlState())
        showPassWordBtn.setTitleColor(COLOR, for: UIControlState())
        showPassWordBtn.addTarget(self, action: #selector(self.showPassWord(_:)), for: .touchUpInside)
        passWordView.addSubview(showPassWordBtn)
        
        showPassCheckBtn = UIButton()
        showPassCheckBtn.frame = CGRect(x: WIDTH - 40, y: 15, width: 30, height: 30)
        showPassCheckBtn.setImage(UIImage(named: "btn_eye_sel"), for: UIControlState())
        showPassCheckBtn.setTitleColor(COLOR, for: UIControlState())
        showPassCheckBtn.addTarget(self, action: #selector(self.showCheckPassWord(_:)), for: .touchUpInside)
        checkPassView.addSubview(showPassCheckBtn)
        
        successBtn = UIButton()
        successBtn.frame = CGRect(x: 20, y: 320, width: WIDTH - 40, height: 40)
        successBtn.setTitle("完成", for: UIControlState())
        successBtn.setTitleColor(COLOR, for: UIControlState())
        successBtn.backgroundColor = UIColor.white
        successBtn.addTarget(self, action: #selector(self.changeSuccsee), for: .touchUpInside)
        self.view.addSubview(successBtn)
 
        
        
    }
    
    // MARK: - 点击事件
    
    func getCheckNum() {
        //  获取验证码
        //  1.判断手机号是否为空
        if phoneNumFiled.text!.isEmpty {
            alert("请输入手机号", delegate: self)
            return
        }
        //  2.通过上传url获取验证码（检测手机是否已经注册）
//        print(phoneNumFiled.text!)
        
        //  [unowned self]什么意思   dispatch_async(dispatch_get_main_queue() 这里为什么需要加一个主线程
        changeVM?.comfirmPhoneHasRegister(phoneNumFiled.text!, handle: {(success, response) in
            DispatchQueue.main.async(execute: {
                if success {
                    //  2.1成功,验证码传到手机,执行倒计时操作
                    TimeManager.shareManager.begainTimerWithKey("forget", timeInterval: 30, process: self.processHandle!, finish: self.finishHandle!)
                    self.changeVM?.sendMobileCodeWithPhoneNumber(self.phoneNumFiled.text!)
                }else{
                    //  2.2失败,手机号没有注册
                    alert("手机没有注册", delegate: self)
                }
            })
        })
    }
    func showPassWord(_ btn:UIButton) {
        //  显示输入密码
        if passWordFiled.isSecureTextEntry == true {
            passWordFiled.isSecureTextEntry = false
            btn.setImage(UIImage(named: "btn_eye"), for: UIControlState())
        }else{
            passWordFiled.isSecureTextEntry = true
            btn.setImage(UIImage(named: "btn_eye_sel"), for: UIControlState())
        }
    }
    func showCheckPassWord(_ btn:UIButton) {
        //  显示确认密码
        if passNumCheckFiled.isSecureTextEntry == true {
            passNumCheckFiled.isSecureTextEntry = false
            btn.setImage(UIImage(named: "btn_eye"), for: UIControlState())
        }else{
            passNumCheckFiled.isSecureTextEntry = true
            btn.setImage(UIImage(named: "btn_eye_sel"), for: UIControlState())
        }
    }
    func changeSuccsee() {
            if phoneNumFiled.text!.isEmpty {
                alert("请输入手机号", delegate: self)
                return
            }
            if checkNumFiled.text!.isEmpty {
                alert("请输入验证码", delegate: self)
                return
            }
            if passWordFiled.text!.isEmpty {
                alert("请输入密码", delegate: self)
                return
            }
            if passNumCheckFiled.text!.isEmpty {
                alert("请确认密码", delegate: self)
                return
            }
            if passWordFiled.text != passNumCheckFiled.text {
                alert("两次输入密码不一致", delegate: self)
                return
            }
            changeVM?.forgetPassword(phoneNumFiled.text!, code: checkNumFiled.text!, password: passWordFiled.text!, handle: {(success, response) in
                DispatchQueue.main.async(execute: {
                    
                    if success {
                        alert("修改成功", delegate: self)
                        _ = self.navigationController?.popViewController(animated: true)
                    }else{
                        let string = response as! String
                        alert(string, delegate: self)
                    }
                })
                })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.delegate?.changeNavigation(flag)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TimeManager.shareManager.taskDic["forget"]?.FHandle = nil
        TimeManager.shareManager.taskDic["forget"]?.PHandle = nil
    }
}
