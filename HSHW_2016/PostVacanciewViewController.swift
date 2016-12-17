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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "护士站 招聘 " + (self.title ?? "")!)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "护士站 招聘 " + (self.title ?? "")!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "发布招聘"
        
        let line = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        postView = Bundle.main.loadNibNamed("PostVacancies", owner: nil, options: nil)?.first as! PostVacancies
        postView.frame = CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-64)
        self.view.addSubview(postView)
        
        getCompanyCertify()
    }
    
    func getCompanyCertify() {
        
        let hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
        hud.label.text = "正在获取企业信息"
        hud.removeFromSuperViewOnHide = true
        // MARK: 获取企业认证状态
        HSMineHelper().getCompanyCertify({ (success, response) in
            
            print("1234567890====== \((String(describing: (response ?? ("" as AnyObject))!) ))")
            if success {
                hud.mode = MBProgressHUDMode.text
                hud.label.text = "获取企业信息成功"
                let companyInfo = response as! CompanyInfo
                
//                print(companyInfo.status)
                if companyInfo.status == "1" {
                    
                    hud.hide(animated: true, afterDelay: 0.5)
                    
                    self.postView.alreadyCertify = true
                    
                    self.postView.firmNameField.text = companyInfo.companyname
                    self.postView.resumeFeild.text = companyInfo.companyinfo
                    self.postView.linkmanField.text = companyInfo.linkman
                    self.postView.phoneField.text = companyInfo.phone
                    self.postView.mailboxField.text = companyInfo.email
                }else{
                    self.postView.alreadyCertify = false
                    
                    hud.label.text = "尚未通过企业认证"
                    hud.hide(animated: true, afterDelay: 1)

                }
                
            }else{
                hud.mode = MBProgressHUDMode.text
                hud.label.text = "获取企业信息失败"
                hud.hide(animated: true)
                
                let alert = UIAlertController(title: nil, message: "获取企业信息失败", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                    _ = self.navigationController?.popViewController(animated: false)
                })
                alert.addAction(cancelAction)
                
                let replyAction = UIAlertAction(title: "重试", style: .default, handler: { (action) in
                    
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
