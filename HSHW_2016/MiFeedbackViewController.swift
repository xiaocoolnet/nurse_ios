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
        
        let line = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.white
        
        self.title = "意见反馈"
                
        feedbackTv.frame = CGRect(x: 10, y: 10, width: WIDTH-20, height: 100)
        feedbackTv.layer.cornerRadius = 8
        feedbackTv.layer.borderWidth = 1
        feedbackTv.layer.borderColor = UIColor.lightGray.cgColor
        self.view.addSubview(feedbackTv)
        
        let submitBtn = UIButton(frame: CGRect(x: 10, y: feedbackTv.frame.maxY+10, width: WIDTH-20, height: 50))
        submitBtn.layer.cornerRadius = 25
        submitBtn.backgroundColor = COLOR
        submitBtn.setTitleColor(UIColor.white, for: UIControlState())
        submitBtn.setTitle("提交", for: UIControlState())
        submitBtn.addTarget(self, action: #selector(submitBtnClick), for: .touchUpInside)
        self.view.addSubview(submitBtn)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func submitBtnClick() {
        
        let checkCodeHud = MBProgressHUD.showAdded(to: self.view, animated: true)
        checkCodeHud?.removeFromSuperViewOnHide = true
        
        if feedbackTv.text!.isEmpty {
            checkCodeHud?.mode = .text
            checkCodeHud?.labelText = "请输入反馈内容"
            checkCodeHud?.hide(true, afterDelay: 1)
        }else{

//            feedback.setObject(UIDevice.currentDevice().systemVersion, forKey: "systemVersion")
//            feedback.setObject(MyUtil.getCurrentDeviceModel(), forKey: "DeviceModel")
//            feedback.setObject(NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"], forKey: "appVersion")
            
            let devicestate:String = "\(MyUtil.getCurrentDeviceModel()) - \(UIDevice.current.systemVersion) - Version:\(Bundle.main.infoDictionary!["CFBundleShortVersionString"]!) Build:\(Bundle.main.infoDictionary!["CFBundleVersion"]!)"
            HSMineHelper().addfeedback(feedbackTv.text, devicestate: devicestate, handle: { (success, response) in

                if success {
                    checkCodeHud?.mode = .text
                    checkCodeHud?.labelText = "反馈成功"
                    checkCodeHud?.hide(true, afterDelay: 1)
                    
                    print("反馈成功")
                    
                    let time: TimeInterval = 1.0
                    let delay = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    
                    DispatchQueue.main.asyncAfter(deadline: delay) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }else{
                    
                    checkCodeHud?.mode = .text
                    checkCodeHud?.labelText = "反馈失败，请稍后再试"
                    checkCodeHud?.hide(true, afterDelay: 1)
                    
                    
                    print("反馈失败")
                }
            })
            
            let feedback = BmobObject(className: "feedback")
            feedback?.setObject(QCLoginUserInfo.currentInfo.userid, forKey: "userid")
            feedback?.setObject(feedbackTv.text, forKey: "content")
            feedback?.setObject(UIDevice.current.systemVersion, forKey: "systemVersion")
            feedback?.setObject(MyUtil.getCurrentDeviceModel(), forKey: "DeviceModel")
            feedback?.setObject(Bundle.main.infoDictionary!["CFBundleShortVersionString"], forKey: "appVersion")

            feedback?.saveInBackground { (isSuccessful, error) in
//                if isSuccessful{
//                    
//                    checkCodeHud.mode = .Text
//                    checkCodeHud.labelText = "反馈成功"
//                    checkCodeHud.hide(true, afterDelay: 1)
//                    
//                    print("反馈成功")
//                    
//                    let time: NSTimeInterval = 1.0
//                    let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC)))
//                    
//                    dispatch_after(delay, dispatch_get_main_queue()) {
//                        self.navigationController?.popViewControllerAnimated(true)
//                    }
//                }else{
//                    
//                    checkCodeHud.mode = .Text
//                    checkCodeHud.labelText = "反馈失败，请稍后再试"
//                    checkCodeHud.hide(true, afterDelay: 1)
//                    
//                    
//                    print("反馈失败")
//                }
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
