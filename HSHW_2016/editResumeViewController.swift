//
//  editResumeViewController.swift
//  HSHW_2016
//
//  Created by zhang on 16/8/5.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

class editResumeViewController: UIViewController {

    var height = HEIGHT-64
    
    var resumeView = HSPostResumeView()
    
    var flag = true
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "我的简历"
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)

        resumeView = NSBundle.mainBundle().loadNibNamed("HSPostResumeView", owner: nil, options: nil).first as! HSPostResumeView
        resumeView.frame = CGRectMake(0, 1, WIDTH, height)
        self.view.addSubview(resumeView)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(getMyResume), name: "willMoveToEditResumeViewController", object: nil)
        if flag {
            
            getMyResume()
        }
    }
    
    func getMyResume() {
        
        let hud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
        hud.labelText = "正在获取简历"
        hud.margin = 10.0
        hud.removeFromSuperViewOnHide = true
        
//        let view = NSBundle.mainBundle().loadNibNamed("HSPostResumeView", owner: nil, options: nil).first as! HSPostResumeView
        HSNurseStationHelper().getResumeInfo(QCLoginUserInfo.currentInfo.userid) { (success, response) in
            
            hud.hide(true)
            if success {
                self.resumeView.alreadyHasResume = true
                
                let model = response as! CVModel
                
//                self.resumeView.headerImg.sd_setImageWithURL(NSURL.init(string: SHOW_IMAGE_HEADER+model.avatar))
                if  !(NetworkReachabilityManager()?.isReachableOnEthernetOrWiFi)! && loadPictureOnlyWiFi {
                    self.resumeView.headerImg.image = UIImage.init(named: "img_head_nor")
                }else{
                     self.resumeView.headerImg.sd_setImageWithURL(NSURL.init(string: SHOW_IMAGE_HEADER+model.avatar), placeholderImage: UIImage.init(named: "img_head_nor"))
                }
//                self.resumeView.headerImg.sd_setImageWithURL(NSURL.init(string: SHOW_IMAGE_HEADER+model.avatar), placeholderImage: UIImage.init(named: "img_head_nor"))
                self.resumeView.headerBtn.tintColor = UIColor.clearColor()
                self.resumeView.headerLab.hidden = true
                self.resumeView.imageName = model.avatar.componentsSeparatedByString(".png").first!
                
                self.resumeView.nameTF.text = model.name
                
                let btn = UIButton()
                btn.tag = model.sex == "0" ? 12:11
                self.resumeView.sexBtnClick(btn)
                self.resumeView.sexFinishStr = model.sex
                
                let birthArray = model.birthday.componentsSeparatedByString("-")
                self.resumeView.birth_year_Lab.text = birthArray[0]
                self.resumeView.birth_month_Lab.text = birthArray[1]
                self.resumeView.birth_day_Lab.text = birthArray[2]
                self.resumeView.birthFinishArr = [self.resumeView.birth_year_Lab.text!, self.resumeView.birth_month_Lab.text!, self.resumeView.birth_day_Lab.text!]
                
                self.resumeView.eduLab.text = model.education
                self.resumeView.dropDownFinishDic["edu"] = model.education
                
                let homeArray = model.address.componentsSeparatedByString("-")
                self.resumeView.homeLab_1.text = homeArray[0] ?? ""
                self.resumeView.homeLab_2.text = homeArray.count>=2 ? homeArray[1]:""
                self.resumeView.homeLab_3.text = homeArray.count>=3 ? homeArray[2]:""
                self.resumeView.homeFinishArr = [self.resumeView.homeLab_1.text!, self.resumeView.homeLab_2.text!, self.resumeView.homeLab_3.text!]
                
                self.resumeView.expLab.text = model.experience
                self.resumeView.dropDownFinishDic["exp"] = model.experience
                
                self.resumeView.professionalLab.text = model.certificate
                self.resumeView.dropDownFinishDic["professional"] = model.certificate
                
                self.resumeView.salaryLab.text = model.currentsalary
                self.resumeView.dropDownFinishDic["salary"] = model.currentsalary
                
                let jobStatusbtn = UIButton()
                jobStatusbtn.tag = model.jobstate == "在职" ? 101:model.jobstate == "离职" ? 102:103
                self.resumeView.jobStatusBtnClick(jobStatusbtn)
                self.resumeView.jobStatusStr = model.jobstate
                
                self.resumeView.telTF.text = model.phone
                
                self.resumeView.mailTF.text = model.email
                
                self.resumeView.jobTimeLab.text = model.hiredate
                self.resumeView.dropDownFinishDic["jobTime"] = model.hiredate

                let targetCityArray = model.wantcity.componentsSeparatedByString("-")
                self.resumeView.targetCityLab_1.text = targetCityArray.count>=1 ? targetCityArray[0]:""
                self.resumeView.targetCityLab_2.text = targetCityArray.count>=2 ? targetCityArray[1]:""
                self.resumeView.targetCityFinishArr = [self.resumeView.targetCityLab_1.text!, self.resumeView.targetCityLab_2.text!]
                
                self.resumeView.expectedSalaryLab.text = model.wantsalary
                self.resumeView.dropDownFinishDic["expectedSalary"] = model.wantsalary

                self.resumeView.expectedPositionLab.text = model.wantposition
                self.resumeView.dropDownFinishDic["expectedPosition"] = model.wantposition

                self.resumeView.selfEvaluate.text = model.description
                self.resumeView.selfEvaluateLab.text = ""
                
            }else{
                if String((response ?? "")!) == "no data" {
                    // 没有简历
                    self.resumeView.alreadyHasResume = false
                }else{
                    // 获取失败
                    let alert = UIAlertController(title: "简历获取失败", message: "请重试", preferredStyle: .Alert)
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    let replyAction = UIAlertAction(title: "重试", style: .Default, handler: { (action) in
                        self.getMyResume()
                    })
                    alert.addAction(replyAction)
                    
                    let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: { (action) in
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                    alert.addAction(cancelAction)
                }
            }
        }
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
