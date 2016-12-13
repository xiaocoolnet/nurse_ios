//
//  NSPersonalInfoDetailViewController.swift
//  HSHW_2016
//
//  Created by zhang on 2016/10/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class NSPersonalInfoDetailViewController: UIViewController, HSFindPersonDetailViewDelegate {
    
    let pageControl = SMPageControl()
    //    var picArr = Array<String>()
    //    var titArr = Array<String>()
    var imageArr = Array<NewsInfo>()
    var timer = NSTimer()
    var times = Int()
    let employment = UIView()
    let employmentMessage = UIView()
    let resumeDetail = NSBundle.mainBundle().loadNibNamed("HSFindPersonDetailView", owner: nil, options: nil).first as! HSFindPersonDetailView
//    let sendPostion = NSBundle.mainBundle().loadNibNamed("PostVacancies", owner: nil, options: nil).first as! PostVacancies
    let sendResume = NSBundle.mainBundle().loadNibNamed("HSPostResumeView", owner: nil, options: nil).first as! HSPostResumeView
    //    var employmentdataSource=NSMutableArray()
    let jobHelper = HSNurseStationHelper()
    var jobDataSource:Array<JobModel>?
    var currentJobModel:JobModel?
    var CVDataSource:Array<CVModel>?
    
    var requestHelper = NewsPageHelper()
    
    var strId = "1"
    
    var showType = 1
    var num = 1
    var selfNav:UINavigationController?
    var btnTag = 1

    var count = NSString()
    var linkman = NSString()
    var tit = NSString()

    
    var cvModel: CVModel?
    
    weak var superViewController:NurseStationViewController?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.defaultStat().pageviewStartWithName("护士站 招聘 " + (self.title ?? "")!)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.defaultStat().pageviewEndWithName("护士站 招聘 " + (self.title ?? "")!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        self.title = "简历详情"
        
        resumeDetail.delegate = self

        let model = self.cvModel!

        self.count = model.count
        self.linkman = model.linkman
        self.tit = model.title
        
        self.makeCVMessage(model)
        
    }
    
    
    //  简历详情
    func makeCVMessage(model:CVModel){
        resumeDetail.frame = CGRectMake(0, 1, WIDTH, HEIGHT-1)
        resumeDetail.model = model
        resumeDetail.cvModel = model
        self.view.addSubview(resumeDetail)
    }
    
    func contactClick() {
        // MARK:要求登录
        if !requiredLogin(self.navigationController!, previousViewController: self, hiddenNavigationBar: false) {
            return
        }
        canLookTel = true
        
    }
    
    func lookContectBtnClick(lookContectBtn: UIButton, phoneNumber: UILabel, email: UILabel) {
        
        // MARK:要求登录
        if !requiredLogin(self.navigationController!, previousViewController: self, hiddenNavigationBar: false) {
            return
        }
        
        if QCLoginUserInfo.currentInfo.usertype == "1" {
            
            let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("您是个人用户，不能查看个人联系方式", comment: "empty message"), preferredStyle: .Alert)
            self.presentViewController(alertController, animated: true, completion: nil)
            
            let cancelAction = UIAlertAction(title: "好的", style: .Cancel, handler: { (action) in
                return
            })
            alertController.addAction(cancelAction)
        }else{
            HSMineHelper().getCompanyCertify({ (success, response) in
                if success {
                    
                    let companyInfo = response as! CompanyInfo
                    
                    if companyInfo.status == "1" {
                        lookContectBtn.hidden = true
                        phoneNumber.hidden = false
                        email.hidden = false
                    }else{
                        
                        let alertController = UIAlertController(title: NSLocalizedString("您尚未通过企业认证，不能查看个人联系方式", comment: "Warn"), message: NSLocalizedString("请先到 我的招聘-企业认证 中 认证", comment: "empty message"), preferredStyle: .Alert)
                        self.presentViewController(alertController, animated: true, completion: nil)
                        
                        let cancelAction = UIAlertAction(title: "好的", style: .Cancel, handler: { (action) in
                            return
                        })
                        alertController.addAction(cancelAction)
                    }
                    return
                }else{
                    let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("获取企业认证状态失败，请稍后再试", comment: "empty message"), preferredStyle: .Alert)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                    let cancelAction = UIAlertAction(title: "好的", style: .Cancel, handler: { (action) in
                        return
                    })
                    alertController.addAction(cancelAction)
                    return
                }
            })
        }
    }
    
    // MARK:邀请面试
    func invited(btn:UIButton) {
        inviteJob(self.CVDataSource![btn.tag])
    }
    
    func inviteJob(model:CVModel) {
        
        // MARK:要求登录
        if !requiredLogin(self.navigationController!, previousViewController: self, hiddenNavigationBar: false) {
            return
        }
        
        if QCLoginUserInfo.currentInfo.usertype == "1" {
            
            let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("您是个人用户，不能发布面试邀请", comment: "empty message"), preferredStyle: .Alert)
            self.presentViewController(alertController, animated: true, completion: nil)
            
            let cancelAction = UIAlertAction(title: "好的", style: .Cancel, handler: { (action) in
                return
            })
            alertController.addAction(cancelAction)
        }else{
            let url = PARK_URL_Header+"getMyPublishJobList"
            let param = ["userid":QCLoginUserInfo.currentInfo.userid]
            NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in
                if(error != nil){
                    
                }else{
                    let status = MineJobModel(JSONDecoder(json!))
                    // print("状态是")
                    // print(status.status)
                    if(status.status == "error"){
                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        if status.data == nil {
                            hud.labelText = "您还没有发布职位，请先发布职位"
                        }
                        //hud.labelText = status.errorData
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                    }else if(status.status == "success"){
                        // print(status)
                        self.inviteJob_1(model, status: status)
                        
                    }
                }
                
            }
        }
    }
    
    func inviteJob_1(model:CVModel, status:MineJobModel) {
        let arr = MineJobList(status.data!)
        
        let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("请选择您要邀请的职位", comment: "empty message"), preferredStyle: .Alert)
        self.presentViewController(alertController, animated: true, completion: nil)
        
        for job in arr.objectlist {
            let doneAction = UIAlertAction(title: job.title, style: .Default, handler: { (cancelAction) in
                
                let inviteHud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                inviteHud.labelText = "正在获取邀请状态"
                inviteHud.removeFromSuperViewOnHide = true
                inviteHud.margin = 10.0
                
                self.jobHelper.InviteJob_judge(model.userid, companyid: QCLoginUserInfo.currentInfo.userid, jobid: job.id) { (success, response) in
                    
                    if success {
                        inviteHud.hide(true)
                        if String((response ?? "")!) == "1" {
                            
                            let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("您已邀请过 \(model.name) 面试该职位，无需再次邀请", comment: "empty message"), preferredStyle: .Alert)
                            self.presentViewController(alertController, animated: true, completion: nil)
                            let doneAction = UIAlertAction(title: "好的", style: .Default, handler: nil)
                            alertController.addAction(doneAction)
                        }else{
                            
                            let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("你确定要向 \(model.name) 发送邀请吗？", comment: "empty message"), preferredStyle: .Alert)
                            self.presentViewController(alertController, animated: true, completion: nil)
                            
                            let doneAction = UIAlertAction(title: "确定", style: .Cancel, handler: { (cancelAction) in
                                
                                let sendInviteHud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                                sendInviteHud.labelText = "正在发送邀请"
                                sendInviteHud.removeFromSuperViewOnHide = true
                                sendInviteHud.margin = 10.0
                                
                                let url = PARK_URL_Header+"InviteJob"
                                let param = [
                                    "userid":model.userid,
                                    "jobid":model.id,
                                    "companyid":QCLoginUserInfo.currentInfo.userid
                                ]
                                NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in
                                    // print(request)
                                    if(error != nil){
                                        sendInviteHud.mode = MBProgressHUDMode.Text;
                                        sendInviteHud.labelText = "发送邀请失败 \(error?.domain)"
                                        sendInviteHud.hide(true, afterDelay: 1)
                                    }else{
                                        let result = Http(JSONDecoder(json!))
                                        if(result.status == "success"){
                                            //  菊花加载
                                            //                                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                                            sendInviteHud.mode = MBProgressHUDMode.Text;
                                            sendInviteHud.labelText = "发送邀请成功"
                                            //                                    hud.margin = 10.0
                                            //                                    hud.removeFromSuperViewOnHide = true
                                            sendInviteHud.hide(true, afterDelay: 1)
                                            // print(111111)
                                        }else{
                                            //  菊花加载
                                            //                                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                                            sendInviteHud.mode = MBProgressHUDMode.Text;
                                            sendInviteHud.labelText = "发送邀请失败"
                                            //                                    hud.margin = 10.0
                                            //                                    hud.removeFromSuperViewOnHide = true
                                            sendInviteHud.hide(true, afterDelay: 1)
                                            // print(2222222)
                                        }
                                    }
                                }
                                
                            })
                            alertController.addAction(doneAction)
                            
                            let cancelAction = UIAlertAction(title: "取消", style: .Default, handler: { (cancelAction) in
                                return
                            })
                            alertController.addAction(cancelAction)
                        }
                    }else{
                        inviteHud.mode = MBProgressHUDMode.Text
                        inviteHud.labelText = "获取邀请状态失败"
                        inviteHud.hide(true, afterDelay: 1)
                    }
                }
            })
            
            alertController.addAction(doneAction)
        }
        
        
        let cancelAction = UIAlertAction(title: "取消", style: .Destructive, handler: { (cancelAction) in
            return
        })
        alertController.addAction(cancelAction)
    }
    
    func postedTheView() {
        
        // MARK:要求登录
        if !requiredLogin(self.navigationController!, previousViewController: self, hiddenNavigationBar: false) {
            return
        }
        
        if showType == 2 {
            //            sendPostion.frame = CGRectMake(0, 0.5, WIDTH, HEIGHT-113)
            //            self.view.addSubview(sendPostion)
            //            superViewController?.showRightBtn()
            
            if QCLoginUserInfo.currentInfo.usertype == "1" {
                
                let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("您是个人用户，不能发布招聘信息", comment: "empty message"), preferredStyle: .Alert)
                self.presentViewController(alertController, animated: true, completion: nil)
                
                let cancelAction = UIAlertAction(title: "好的", style: .Cancel, handler: { (action) in
                    return
                })
                alertController.addAction(cancelAction)
            }else{
                self.navigationController?.pushViewController(PostVacanciewViewController(), animated: true)
            }
        } else if showType == 1 {
            //            sendResume.frame = CGRectMake(0, 0.5, WIDTH, HEIGHT-113)
            //            self.view.addSubview(sendResume)
            //
            //            superViewController?.showRightBtn()
            
            if QCLoginUserInfo.currentInfo.usertype == "2" {
                
                let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("您是企业用户，不能编辑简历", comment: "empty message"), preferredStyle: .Alert)
                self.presentViewController(alertController, animated: true, completion: nil)
                
                let cancelAction = UIAlertAction(title: "好的", style: .Cancel, handler: { (action) in
                    return
                })
                alertController.addAction(cancelAction)
            }else{
                self.navigationController?.pushViewController(editResumeViewController(), animated: true)
            }
        }
    }
    
    
    //MARK:delegate-find
    func sendInvite(model:CVModel){
        inviteJob(model)
    }

    // Linux时间戳转标准时间
    func timeStampToString(timeStamp:String)->String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:NSTimeInterval = string.doubleValue
        let dfmatter = NSDateFormatter()
        dfmatter.dateFormat="yyyy-MM-dd"
        
        let date = NSDate(timeIntervalSince1970: timeSta)
        
        //        print(dfmatter.stringFromDate(date))
        return dfmatter.stringFromDate(date)
    }
}
