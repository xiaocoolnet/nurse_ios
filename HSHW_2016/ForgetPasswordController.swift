//
//  ForgetPasswordController.swift
//  HSHW_2016
//
//  Created by JQ on 16/6/17.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class ForgetPasswordController: UIViewController {
    
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
    
    //  注册功能
    var changeVM:LoginModel?
    //  倒计时功能
    var processHandle:TimerHandle?
    var finishHandle:TimerHandle?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        
        //  显示导航控制器
        self.navigationController?.navigationBar.hidden = false
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
        processHandle = {[unowned self] (timeInterVal) in
            dispatch_async(dispatch_get_main_queue(), {
                self.checkNumBtn.userInteractionEnabled = false
                let btnTitle = String(timeInterVal) + "秒后重新获取"
                self.checkNumBtn.titleLabel?.font = UIFont.systemFontOfSize(12)
                self.checkNumBtn.setTitleColor(COLOR, forState: .Normal)
                
                self.checkNumBtn.setTitle(btnTitle, forState: .Normal)
                
                
                
            })
        }
        
        finishHandle = {[unowned self] (timeInterVal) in
            dispatch_async(dispatch_get_main_queue(), {
                self.checkNumBtn.userInteractionEnabled = true
                self.checkNumBtn.setTitleColor(COLOR, forState: .Normal)
                self.checkNumBtn.titleLabel?.font = UIFont.systemFontOfSize(12)
                self.checkNumBtn.setTitle("获取验证码", forState: .Normal)
            })
        }
        TimeManager.shareManager.taskDic["forget"]?.FHandle = finishHandle
        TimeManager.shareManager.taskDic["forget"]?.PHandle = processHandle
    }
    
    // MARK: - createView(创建视图)
    func createView(){
        //  创建五个视图
        numView = UIView()
        numView.frame = CGRectMake(0, 40, 80, 60)
        numView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(numView)
        
        phoneNumView = UIView()
        phoneNumView.frame = CGRectMake(81, 40, WIDTH - 81, 60)
        phoneNumView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(phoneNumView)
    
        checkView = UIView()
        checkView.frame = CGRectMake(0, 101, WIDTH, 60)
        checkView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(checkView)
        
        passWordView = UIView()
        passWordView.frame = CGRectMake(0, 162, WIDTH, 60)
        passWordView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(passWordView)
        
        checkPassView = UIView()
        checkPassView.frame = CGRectMake(0, 223 , WIDTH, 60)
        checkPassView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(checkPassView)
    }
        // MARK: - createUI(创建界面控件)
    func createUI(){

        //  四个label
        phoneLabel = UILabel()
        phoneLabel.frame = CGRectMake(20, 15, 60, 30)
        phoneLabel.text = "+86"
        phoneLabel.font = UIFont.systemFontOfSize(16)
        numView.addSubview(phoneLabel)
        
        checkLabel = UILabel()
        checkLabel.frame = CGRectMake(20, 15, 70, 30)
        checkLabel.text = "验证码"
        checkLabel.font = UIFont.systemFontOfSize(16)
        checkView.addSubview(checkLabel)
        
        passWordLabel = UILabel()
        passWordLabel.frame = CGRectMake(20, 15, 70, 30)
        passWordLabel.text = "输入密码"
        passWordLabel.font = UIFont.systemFontOfSize(16)
        passWordView.addSubview(passWordLabel)
        
        passCheckLabel = UILabel()
        passCheckLabel.frame = CGRectMake(20, 15, 70, 30)
        passCheckLabel.text = "确认密码"
        passCheckLabel.font = UIFont.systemFontOfSize(16)
        checkPassView.addSubview(passCheckLabel)
        
        //  四个textFiled
        phoneNumFiled = UITextField()
        phoneNumFiled.frame = CGRectMake(19, 15, WIDTH * 0.4, 30)
        phoneNumFiled.font = UIFont.systemFontOfSize(14)
        phoneNumFiled.placeholder = "请输入手机号"
        phoneNumView.addSubview(phoneNumFiled)
        
        checkNumFiled = UITextField()
        checkNumFiled.frame = CGRectMake(100, 15, WIDTH * 0.4, 30)
        checkNumFiled.font = UIFont.systemFontOfSize(14)
        checkNumFiled.placeholder = "请输入验证码"
        checkView.addSubview(checkNumFiled)
        
        passWordFiled = UITextField()
        passWordFiled.frame = CGRectMake(100, 15, WIDTH * 0.4, 30)
        passWordFiled.font = UIFont.systemFontOfSize(14)
        passWordFiled.placeholder = "请输入密码"
        //  密文输入
        passWordFiled.secureTextEntry = true
        passWordView.addSubview(passWordFiled)
        
        passNumCheckFiled = UITextField()
        passNumCheckFiled.frame = CGRectMake(100, 15, WIDTH * 0.4, 30)
        passNumCheckFiled.font = UIFont.systemFontOfSize(14)
        passNumCheckFiled.placeholder = "请确认密码"
        passNumCheckFiled.secureTextEntry = true
        checkPassView.addSubview(passNumCheckFiled)
        
        //  四个button
    
        checkNumBtn = UIButton()
        checkNumBtn.frame = CGRectMake(WIDTH * 0.4 + 120, 15, 100, 30)
        checkNumBtn.layer.cornerRadius = 13
        checkNumBtn.layer.borderColor = COLOR.CGColor
        checkNumBtn.layer.borderWidth = 1.5
        checkNumBtn.setTitle("获取验证码", forState: .Normal)
        checkNumBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        checkNumBtn.setTitleColor(COLOR, forState: .Normal)
        checkNumBtn.addTarget(self, action: #selector(self.getCheckNum), forControlEvents: .TouchUpInside)
        checkView.addSubview(checkNumBtn)
        
        showPassWordBtn = UIButton()
        showPassWordBtn.frame = CGRectMake(WIDTH * 0.4 + 120, 15, WIDTH * 0.6 - 150, 30)
        showPassWordBtn.setImage(UIImage(named: "1"), forState: .Normal)
        showPassWordBtn.setTitleColor(COLOR, forState: .Normal)
        showPassWordBtn.addTarget(self, action: #selector(self.showPassWord), forControlEvents: .TouchUpInside)
        passWordView.addSubview(showPassWordBtn)
        
        showPassCheckBtn = UIButton()
        showPassCheckBtn.frame = CGRectMake(WIDTH * 0.4 + 120, 15, WIDTH * 0.6 - 150, 30)
        showPassCheckBtn.setImage(UIImage(named: "1"), forState: .Normal)
        showPassCheckBtn.setTitleColor(COLOR, forState: .Normal)
        showPassCheckBtn.addTarget(self, action: #selector(self.showCheckPassWord), forControlEvents: .TouchUpInside)
        checkPassView.addSubview(showPassCheckBtn)
        
        successBtn = UIButton()
        successBtn.frame = CGRectMake(20, 320, WIDTH - 40, 40)
        successBtn.setTitle("完成", forState: .Normal)
        successBtn.setTitleColor(COLOR, forState: .Normal)
        successBtn.backgroundColor = UIColor.whiteColor()
        successBtn.addTarget(self, action: #selector(self.changeSuccsee), forControlEvents: .TouchUpInside)
        self.view.addSubview(successBtn)
 
        
        
    }
    
    // MARK: - 点击事件
    
    func getCheckNum() {
        //  获取验证码
        print("获取验证码")
        //  1.判断手机号是否为空
        if phoneNumFiled.text!.isEmpty {
            let alert = UIAlertView(title: "提示信息",message: "请输入手机号",delegate: self,cancelButtonTitle: "确定")
            alert.show()
            return
        }
        //  2.通过上传url获取验证码（检测手机是否已经注册）
        print(phoneNumFiled.text!)
        
        //  [unowned self]什么意思   dispatch_async(dispatch_get_main_queue() 这里为什么需要加一个主线程
        changeVM?.comfirmPhoneHasRegister(phoneNumFiled.text!, handle: {[unowned self](success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                //  不管填什么内容都走了这个方法
                if success {
                    
                    TimeManager.shareManager.begainTimerWithKey("forget", timeInterval: 30, process: self.processHandle!, finish: self.finishHandle!)
                    self.changeVM?.sendMobileCodeWithPhoneNumber(self.phoneNumFiled.text!)
                }else{
             let alert = UIAlertView(title:"提示信息",message: "手机没有注册",delegate: self,cancelButtonTitle: "确定")
                    alert.show()
                }
            })
            
            })
        
        //  2.1成功,验证码传到手机,执行倒计时操作
        //  2.2失败,手机号没有注册
    }
    func showPassWord() {
        //  显示输入密码
        print("显示输入密码")
        if passWordFiled.secureTextEntry == true {
            passWordFiled.secureTextEntry = false
        }else{
            passWordFiled.secureTextEntry = true
        }
    }
    func showCheckPassWord() {
        //  显示确认密码
        print("显示确认密码")
        if passNumCheckFiled.secureTextEntry == true {
            passNumCheckFiled.secureTextEntry = false
        }else{
            passNumCheckFiled.secureTextEntry = true
        }
    }
    func changeSuccsee() {
        //  修改完成
        print("修改完成")
        //  调一个接口传数据
        
        
        
            if phoneNumFiled.text!.isEmpty {
//                SVProgressHUD.showErrorWithStatus("请输入手机号")
                return
            }
            if checkNumFiled.text!.isEmpty {
//                SVProgressHUD.showErrorWithStatus("请输入验证码")
                return
            }
            if passWordFiled.text!.isEmpty {
//                SVProgressHUD.showErrorWithStatus("请输入密码")
                return
            }
            if passNumCheckFiled.text!.isEmpty {
//                SVProgressHUD.showErrorWithStatus("请确认密码")
                return
            }
            if passWordFiled.text != passNumCheckFiled.text {
//                SVProgressHUD.showErrorWithStatus("两次输入密码不一致")
                return
            }
            changeVM?.forgetPassword(phoneNumFiled.text!, code: checkNumFiled.text!, password: passWordFiled.text!, handle: { [unowned self] (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    
                    if success {
                        let alert = UIAlertView(title:"提示信息",message: "修改成功",delegate: self,cancelButtonTitle: "确定")
                        alert.show()
//                        SVProgressHUD.showSuccessWithStatus("修改成功")
                        self.navigationController?.popViewControllerAnimated(true)
                    }else{
                        let string = response as! String
                        let alert = UIAlertView(title:"提示信息",message: string,delegate: self,cancelButtonTitle: "确定")
                        alert.show()
//                        SVProgressHUD.showErrorWithStatus(response as! String)
                    }
                    
                })
                })
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        TimeManager.shareManager.taskDic["forget"]?.FHandle = nil
        TimeManager.shareManager.taskDic["forget"]?.PHandle = nil
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
