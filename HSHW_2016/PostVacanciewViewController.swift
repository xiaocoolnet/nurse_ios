//
//  PostVacanciewViewController.swift
//  HSHW_2016
//
//  Created by zhang on 16/8/5.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class PostVacanciewViewController: UIViewController {

    var postView = PostVacancies()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "发布招聘"
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        postView = NSBundle.mainBundle().loadNibNamed("PostVacancies", owner: nil, options: nil).first as! PostVacancies
        postView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-64)
        self.view.addSubview(postView)
        
        getCompanyCertify()
    }
    
    func getCompanyCertify() {
        
        let hud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
        hud.labelText = "正在获取企业信息"
        hud.removeFromSuperViewOnHide = true
        // MARK: 获取企业认证状态
        HSMineHelper().getCompanyCertify({ (success, response) in
            
            print("1234567890====== \(String(response!))")
            if success {
                hud.mode = MBProgressHUDMode.Text
                hud.labelText = "获取企业信息成功"
                let companyInfo = response as! CompanyInfo
                
//                print(companyInfo.status)
                if companyInfo.status == "1" {
                    
                    hud.hide(true, afterDelay: 0.5)
                    
                    self.postView.alreadyCertify = true
                    
                    self.postView.firmNameField.text = companyInfo.companyname
                    self.postView.resumeFeild.text = companyInfo.companyinfo
                    self.postView.linkmanField.text = companyInfo.linkman
                    self.postView.phoneField.text = companyInfo.phone
                    self.postView.mailboxField.text = companyInfo.email
                }else{
                    self.postView.alreadyCertify = false
                    
                    hud.labelText = "尚未通过企业认证"
                    hud.hide(true, afterDelay: 1)

                }
                
            }else{
                hud.mode = MBProgressHUDMode.Text
                hud.labelText = "获取企业信息失败"
                hud.hide(true)
                
                let alert = UIAlertController(title: nil, message: "获取企业信息失败", preferredStyle: .Alert)
                self.presentViewController(alert, animated: true, completion: nil)
                
                let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: { (action) in
                    self.navigationController?.popViewControllerAnimated(false)
                })
                alert.addAction(cancelAction)
                
                let replyAction = UIAlertAction(title: "重试", style: .Default, handler: { (action) in
                    
                    self.getCompanyCertify()
                })
                alert.addAction(replyAction)
            }
        })
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
