//
//  editResumeViewController.swift
//  HSHW_2016
//
//  Created by zhang on 16/8/5.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class editResumeViewController: UIViewController {

    var height = HEIGHT-64
    
    var resumeView = HSPostResumeView()
    
    var flag = true
    
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
        self.title = "我的简历"
        
        let line = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)

        resumeView = Bundle.main.loadNibNamed("HSPostResumeView", owner: nil, options: nil)?.first as! HSPostResumeView
        resumeView.frame = CGRect(x: 0, y: 1, width: WIDTH, height: height)
        self.view.addSubview(resumeView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getMyResume), name: NSNotification.Name(rawValue: "willMoveToEditResumeViewController"), object: nil)
        if flag {
            
            getMyResume()
        }
    }
    
    func getMyResume() {
        
        let hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
        hud.label.text = "正在获取简历"
        hud.margin = 10.0
        hud.removeFromSuperViewOnHide = true
        
//        let view = NSBundle.mainBundle().loadNibNamed("HSPostResumeView", owner: nil, options: nil).first as! HSPostResumeView
        HSNurseStationHelper().getResumeInfo(QCLoginUserInfo.currentInfo.userid) { (success, response) in
            
            hud.hide(animated: true)
            if success {
                self.resumeView.alreadyHasResume = true
                
                let model = response as! CVModel
                                
                if  !NurseUtil.net.isWifi() && loadPictureOnlyWiFi {
                    self.resumeView.headerImg.image = UIImage.init(named: "img_head_nor")
                }else{
                     self.resumeView.headerImg.sd_setImage(with: URL.init(string: SHOW_IMAGE_HEADER+model.avatar), placeholderImage: UIImage.init(named: "img_head_nor"))
                }
//                self.resumeView.headerImg.sd_setImageWithURL(NSURL.init(string: SHOW_IMAGE_HEADER+model.avatar), placeholderImage: UIImage.init(named: "img_head_nor"))
                self.resumeView.headerBtn.tintColor = UIColor.clear
                self.resumeView.headerLab.isHidden = true
                self.resumeView.imageName = model.avatar.components(separatedBy: ".png").first!
                
                self.resumeView.nameTF.text = model.name
                
                let btn = UIButton()
                btn.tag = model.sex == "0" ? 12:11
                self.resumeView.sexBtnClick(btn)
                self.resumeView.sexFinishStr = model.sex
                
                let birthArray = model.birthday.components(separatedBy: "-")
                self.resumeView.birth_year_Lab.text = birthArray[0]
                self.resumeView.birth_month_Lab.text = birthArray[1]
                self.resumeView.birth_day_Lab.text = birthArray[2]
                self.resumeView.birthFinishArr = [self.resumeView.birth_year_Lab.text!, self.resumeView.birth_month_Lab.text!, self.resumeView.birth_day_Lab.text!]
                
                self.resumeView.eduLab.text = model.education
                self.resumeView.dropDownFinishDic["edu"] = model.education
                
                let homeArray = model.address.components(separatedBy: "-")
                self.resumeView.homeLab_1.text = homeArray[0] 
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

                let targetCityArray = model.wantcity.components(separatedBy: "-")
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
                if String(describing: (response ?? ("" as AnyObject))!) == "no data" {
                    // 没有简历
                    self.resumeView.alreadyHasResume = false
                }else{
                    // 获取失败
                    let alert = UIAlertController(title: "简历获取失败", message: "请重试", preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                    
                    let replyAction = UIAlertAction(title: "重试", style: .default, handler: { (action) in
                        self.getMyResume()
                    })
                    alert.addAction(replyAction)
                    
                    let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                        _ = self.navigationController?.popViewController(animated: true)
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
