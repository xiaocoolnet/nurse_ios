//
//  MiFeedbackViewController.swift
//  HSHW_2016
//
//  Created by zhang on 2016/10/24.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class MiFeedbackViewController: UIViewController {

    let feedbackTv = UITextView()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.title = "意见反馈"
        
        feedbackTv.frame = CGRectMake(10, 10, WIDTH-20, 100)
        feedbackTv.layer.cornerRadius = 8
        feedbackTv.layer.borderWidth = 1
        feedbackTv.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.view.addSubview(feedbackTv)
        
        let submitBtn = UIButton(frame: CGRectMake(10, CGRectGetMaxY(feedbackTv.frame)+10, WIDTH-20, 50))
        submitBtn.layer.cornerRadius = 25
        submitBtn.backgroundColor = COLOR
        submitBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        submitBtn.setTitle("提交", forState: .Normal)
        submitBtn.addTarget(self, action: #selector(submitBtnClick), forControlEvents: .TouchUpInside)
        self.view.addSubview(submitBtn)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
    }
    
    func submitBtnClick() {
        
        let checkCodeHud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        checkCodeHud.removeFromSuperViewOnHide = true
        
        if feedbackTv.text!.isEmpty {
            checkCodeHud.mode = .Text
            checkCodeHud.labelText = "请输入反馈内容"
            checkCodeHud.hide(true, afterDelay: 1)
        }else{

            let feedback = BmobObject(className: "feedback")
            feedback.setObject(QCLoginUserInfo.currentInfo.userid, forKey: "userid")
            feedback.setObject(feedbackTv.text, forKey: "content")
            feedback.setObject(UIDevice.currentDevice().systemVersion, forKey: "systemVersion")
            feedback.setObject(MyUtil.getCurrentDeviceModel(), forKey: "DeviceModel")
            feedback.setObject(NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"], forKey: "appVersion")

            feedback.saveInBackgroundWithResultBlock { (isSuccessful, error) in
                if isSuccessful{
                    
                    checkCodeHud.mode = .Text
                    checkCodeHud.labelText = "反馈成功"
                    checkCodeHud.hide(true, afterDelay: 1)
                    
                    print("反馈成功")
                    
                    let time: NSTimeInterval = 1.0
                    let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC)))
                    
                    dispatch_after(delay, dispatch_get_main_queue()) {
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                }else{
                    
                    checkCodeHud.mode = .Text
                    checkCodeHud.labelText = "反馈失败，请稍后再试"
                    checkCodeHud.hide(true, afterDelay: 1)
                    
                    
                    print("反馈失败")
                }
            }
        }
        
//        BmobObject *gameScore = [BmobObject objectWithClassName:@"GameScore"];
//        [gameScore setObject:@"小明" forKey:@"playerName"];
//        [gameScore setObject:@78 forKey:@"score"];
//        [gameScore setObject:[NSNumber numberWithBool:YES] forKey:@"cheatMode"];
//        [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//        //进行操作
//        }];
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
