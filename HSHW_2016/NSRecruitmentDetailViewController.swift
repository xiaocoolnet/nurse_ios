//
//  NSRecruitmentDetailViewController.swift
//  HSHW_2016
//
//  Created by zhang on 2016/10/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class NSRecruitmentDetailViewController: UIViewController,UIScrollViewDelegate {
    

    var times = Int()
    let employment = UIView()
    let employmentMessage = UIView()
//    let sendPostion = NSBundle.mainBundle().loadNibNamed("PostVacancies", owner: nil, options: nil).first as! PostVacancies
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

    let contactTelBtn = UIButton()
    
    weak var superViewController:NurseStationViewController?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "招聘详情"
        
        self.setSubViews()
        
    }
    
    func setSubViews() {
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let jobModel = currentJobModel
        
        strId = jobModel!.id
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        let rootScrollView = UIScrollView(frame: CGRectMake(0, 1, WIDTH, HEIGHT-64-1-WIDTH*59/375))
        rootScrollView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(rootScrollView)
        
        let title = UILabel()
        let height = calculateHeight(jobModel!.title, size: 18, width: WIDTH-20)
        title.frame = CGRectMake(10, 10, WIDTH-20, height)
        title.text = jobModel!.title
        title.font = UIFont.systemFontOfSize(22)
        title.textColor = COLOR
        title.numberOfLines = 0
        title.sizeToFit()
        rootScrollView.addSubview(title)
        
//        let eyeImage = UIImageView(image: UIImage(named: "ic_eye_purple.png"))
//        eyeImage.frame = CGRectMake(10,CGRectGetMaxY(title.frame)+10,8,8)
//        eyeImage.contentMode = .ScaleAspectFit
//        rootScrollView.addSubview(eyeImage)
//        
//        let lookCount = UILabel(frame: CGRectMake(CGRectGetMaxX(eyeImage.frame)+5,CGRectGetMaxY(title.frame)+10,30,10))
//        lookCount.font = UIFont.systemFontOfSize(10)
//        lookCount.text = "3346"
//        lookCount.sizeToFit()
//        lookCount.center.y = eyeImage.center.y
//        rootScrollView.addSubview(lookCount)
        
        let timeImage = UIImageView(image: UIImage(named: "ic_time_purple.png"))
//        timeImage.frame = CGRectMake(CGRectGetMaxX(lookCount.frame)+18, CGRectGetMaxY(title.frame)+10, 8, 8)
        timeImage.frame = CGRectMake(10, CGRectGetMaxY(title.frame)+10, 8, 8)
        timeImage.contentMode = .ScaleAspectFit
        rootScrollView.addSubview(timeImage)
        
        let timeLabel = UILabel(frame: CGRectMake(CGRectGetMaxX(timeImage.frame)+5,CGRectGetMaxY(title.frame)+10,100,10))
        timeLabel.font = UIFont.systemFontOfSize(10)
        timeLabel.text = self.timeStampToString((jobModel?.create_time)!)
        timeLabel.sizeToFit()
        timeLabel.center.y = timeImage.center.y
        rootScrollView.addSubview(timeLabel)
        
        
        
        let nameLabel = UILabel(frame: CGRectMake(10,CGRectGetMaxY(timeLabel.frame)+10,100,25))
        nameLabel.font = UIFont.boldSystemFontOfSize(15)
        nameLabel.text = "企业名称:"
        nameLabel.sizeToFit()
        rootScrollView.addSubview(nameLabel)
        
        let name = UILabel(frame: CGRectMake(CGRectGetMaxX(nameLabel.frame)+8,CGRectGetMaxY(timeLabel.frame)+10,200,25))
        name.font = UIFont.systemFontOfSize(14)
        name.text = jobModel!.companyname
        name.sizeToFit()
        name.center.y = nameLabel.center.y
        rootScrollView.addSubview(name)
        
        
        
        let descripTagLab = UILabel(frame: CGRectMake(10,CGRectGetMaxY(name.frame)+10,WIDTH-20,0))
        descripTagLab.font = UIFont.boldSystemFontOfSize(15)
        descripTagLab.textColor = UIColor.blackColor()
        descripTagLab.text = "企业简介:"
        descripTagLab.sizeToFit()
        rootScrollView.addSubview(descripTagLab)
        
        let descripStr = jobModel!.companyinfo
        let attrStr = NSMutableAttributedString(string: descripStr)
        //                    attrStr.addAttributes([NSFontAttributeName:UIFont.boldSystemFontOfSize(15)], range: NSMakeRange(0, 5))
        attrStr.addAttributes([NSFontAttributeName:UIFont.systemFontOfSize(14)], range: NSMakeRange(0, attrStr.length))
        attrStr.addAttributes([NSForegroundColorAttributeName:UIColor.lightGrayColor()], range: NSMakeRange(0, attrStr.length))
        
        let descript = UILabel(frame: CGRectMake(
            CGRectGetMaxX(descripTagLab.frame)+8,
            CGRectGetMaxY(name.frame)+10,
            WIDTH-CGRectGetMaxX(descripTagLab.frame)-10,
            attrStr.boundingRectWithSize(CGSizeMake(WIDTH-CGRectGetMaxX(descripTagLab.frame)-10, 0), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil).size.height))
        descript.font = UIFont.boldSystemFontOfSize(15)
        descript.numberOfLines = 0
        descript.attributedText = attrStr
        descript.sizeToFit()
        rootScrollView.addSubview(descript)
        
        
        
        let criteria = UILabel(frame: CGRectMake(10,CGRectGetMaxY(descript.frame)+10,70,25))
        criteria.font = UIFont.boldSystemFontOfSize(15)
        criteria.text = "招聘条件:"
        criteria.sizeToFit()
        rootScrollView.addSubview(criteria)
        
        let criteriaLabel = UILabel(frame: CGRectMake(CGRectGetMaxX(criteria.frame)+8,CGRectGetMaxY(descript.frame)+10,75,25))
        criteriaLabel.font = UIFont.systemFontOfSize(14)
        criteriaLabel.textColor = UIColor.lightGrayColor()
        criteriaLabel.text = jobModel!.education
        criteriaLabel.sizeToFit()
        rootScrollView.addSubview(criteriaLabel)

        let salaryTagLab = UILabel(frame: CGRectMake(170,CGRectGetMaxY(descript.frame)+10,70,25))
        salaryTagLab.font = UIFont.boldSystemFontOfSize(15)
        salaryTagLab.text = "薪资待遇:"
        salaryTagLab.sizeToFit()
        rootScrollView.addSubview(salaryTagLab)

        let salaryLab = UILabel(frame: CGRectMake(CGRectGetMaxX(salaryTagLab.frame)+8,CGRectGetMaxY(descript.frame)+10,WIDTH-240,25))
        salaryLab.font = UIFont.systemFontOfSize(14)
        salaryLab.textColor = UIColor.lightGrayColor()
        salaryLab.text = currentJobModel!.salary
        salaryLab.sizeToFit()
        rootScrollView.addSubview(salaryLab)
        
        
        
        let personalNumTagLab = UILabel(frame: CGRectMake(10,CGRectGetMaxY(salaryLab.frame)+10,70,25))
        personalNumTagLab.font = UIFont.boldSystemFontOfSize(15)
        personalNumTagLab.text = "招聘人数:"
        personalNumTagLab.sizeToFit()
        rootScrollView.addSubview(personalNumTagLab)

        let personalNumLab = UILabel(frame: CGRectMake(CGRectGetMaxX(personalNumTagLab.frame)+8,CGRectGetMaxY(salaryLab.frame)+10,75,25))
        personalNumLab.font = UIFont.systemFontOfSize(14)
        personalNumLab.textColor = UIColor.lightGrayColor()
        personalNumLab.text = jobModel!.count
        personalNumLab.sizeToFit()
        rootScrollView.addSubview(personalNumLab)

        let welfareTagLab = UILabel(frame: CGRectMake(170,CGRectGetMaxY(salaryLab.frame)+10,70,25))
        welfareTagLab.font = UIFont.boldSystemFontOfSize(15)
        welfareTagLab.text = "福利待遇:"
        welfareTagLab.sizeToFit()
        rootScrollView.addSubview(welfareTagLab)

        let welfareLab = UILabel(frame: CGRectMake(CGRectGetMaxX(welfareTagLab.frame)+8,CGRectGetMaxY(salaryLab.frame)+10,WIDTH-240,25))
        welfareLab.font = UIFont.systemFontOfSize(14)
        welfareLab.textColor = UIColor.lightGrayColor()
        welfareLab.text = jobModel!.welfare
        welfareLab.sizeToFit()
        rootScrollView.addSubview(welfareLab)
        
        
        
        let addressTagLab = UILabel(frame: CGRectMake(10,CGRectGetMaxY(welfareLab.frame)+10,70,25))
        addressTagLab.font = UIFont.boldSystemFontOfSize(15)
        addressTagLab.text = "工作地点:"
        addressTagLab.sizeToFit()
        rootScrollView.addSubview(addressTagLab)
        
        let addressLab = UILabel(frame: CGRectMake(CGRectGetMaxX(addressTagLab.frame)+8,CGRectGetMaxY(welfareLab.frame)+10,WIDTH-240,25))
        addressLab.font = UIFont.systemFontOfSize(14)
        addressLab.textColor = UIColor.lightGrayColor()
        addressLab.text = currentJobModel!.address
        addressLab.sizeToFit()
        addressLab.center.y = addressTagLab.center.y
        rootScrollView.addSubview(addressLab)
        
        
        
        let positionDescript = UILabel(frame: CGRectMake(10,CGRectGetMaxY(addressLab.frame)+10,100,25))
        positionDescript.font = UIFont.boldSystemFontOfSize(15)
        positionDescript.text = "职位描述:"
        positionDescript.sizeToFit()
        rootScrollView.addSubview(positionDescript)
        
        let descripDetail = UILabel(frame: CGRectMake(10,CGRectGetMaxY(addressLab.frame)+40,WIDTH-20,200))
        descripDetail.font = UIFont.systemFontOfSize(14)
        descripDetail.textColor = UIColor.lightGrayColor()
        descripDetail.numberOfLines = 0
        descripDetail.text = jobModel!.description
        descripDetail.frame.size.height = calculateHeight((jobModel?.description)!, size: 14, width: WIDTH-20)
        descripDetail.sizeToFit()
        rootScrollView.addSubview(descripDetail)
        
        
        
        let contactTagLab = UILabel(frame: CGRectMake(10,CGRectGetMaxY(descripDetail.frame)+10,80,25))
        contactTagLab.font = UIFont.boldSystemFontOfSize(15)
        contactTagLab.text = "联系方式:"
        contactTagLab.sizeToFit()
        rootScrollView.addSubview(contactTagLab)
        
        let contactNameLab = UILabel(frame: CGRectMake(CGRectGetMaxX(contactTagLab.frame)+8,CGRectGetMaxY(descripDetail.frame)+10,80,25))
        contactNameLab.font = UIFont.boldSystemFontOfSize(14)
        contactNameLab.textColor = UIColor.lightGrayColor()
        contactNameLab.text = jobModel?.linkman
        contactNameLab.sizeToFit()
        contactNameLab.center.y = contactTagLab.center.y
        rootScrollView.addSubview(contactNameLab)
        
        contactTelBtn.frame = CGRectMake(CGRectGetMaxX(contactTagLab.frame)+8, CGRectGetMaxY(contactNameLab.frame)+8, 10, 25)
        contactTelBtn.setTitleColor(COLOR, forState: .Normal)
        contactTelBtn.titleLabel!.font = UIFont.systemFontOfSize(14)
        if !canLookTel {
            contactTelBtn.setTitle("查看联系方式", forState: .Normal)
            contactTelBtn.addTarget(self, action: #selector(contactClick), forControlEvents: .TouchUpInside)
        }else {
            contactTelBtn.setTitle(jobModel!.phone, forState: .Normal)
        }
        contactTelBtn.sizeToFit()
//        contactTelBtn.center.y = contactNameLab.center.y
        rootScrollView.addSubview(contactTelBtn)
        
        rootScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(contactTelBtn.frame)+10)
        
        let tack = UIButton(frame: CGRectMake(
            WIDTH*35/375,
            CGRectGetMaxY(rootScrollView.frame)+WIDTH*2/375,
            WIDTH*305/375,
            WIDTH*45/375))
        tack.layer.cornerRadius = WIDTH*22.5/375
        tack.layer.borderColor = COLOR.CGColor
        tack.layer.borderWidth = 1
        tack.setTitle("投递简历", forState: .Normal)
        tack.setTitleColor(COLOR, forState: .Normal)
        tack.addTarget(self, action: #selector(self.resumeOnline(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(tack)
    }
    

    
    func contactClick() {
        // MARK:要求登录
        if !requiredLogin(self.navigationController!, previousViewController: self, hiddenNavigationBar: false) {
            return
        }
        
        if QCLoginUserInfo.currentInfo.usertype == "2" {
            
            let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("您是企业用户，不能查看企业联系方式", comment: "empty message"), preferredStyle: .Alert)
            self.presentViewController(alertController, animated: true, completion: nil)
            
            let cancelAction = UIAlertAction(title: "好的", style: .Cancel, handler: { (action) in
                return
            })
            alertController.addAction(cancelAction)
            return
        }
        
        canLookTel = true
        
        contactTelBtn.setTitle(currentJobModel?.phone, forState: .Normal)
        contactTelBtn.sizeToFit()
    }
    
    // MARK: 投递简历
    func resumeOnline(btn:UIButton) {
        
        // MARK:要求登录
        if !requiredLogin(self.navigationController!, previousViewController: self, hiddenNavigationBar: false) {
            return
        }
        
        if QCLoginUserInfo.currentInfo.usertype == "2" {
            
            let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("您是企业用户，不能投递简历", comment: "empty message"), preferredStyle: .Alert)
            self.presentViewController(alertController, animated: true, completion: nil)
            
            let cancelAction = UIAlertAction(title: "好的", style: .Cancel, handler: { (action) in
                return
            })
            alertController.addAction(cancelAction)
        }else{
            
            let resumeHud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            resumeHud.labelText = "正在获取简历信息"
            resumeHud.removeFromSuperViewOnHide = true
            resumeHud.margin = 10.0
            
            jobHelper.getResumeInfo(QCLoginUserInfo.currentInfo.userid) { (success, response) in
                if success {
                    
                    // 判断是否已投递简历
                    resumeHud.labelText = "正在获取简历投递状态"
                    
                    self.jobHelper.ApplyJob_judge(QCLoginUserInfo.currentInfo.userid, companyid: self.jobDataSource![btn.tag].companyid, jobid: self.jobDataSource![btn.tag].id, handle: { (success, response) in
                        if success {
                            resumeHud.hide(true)
                            if String(response!) == "1" {
                                let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("您已投递过该职位，无需再次投递", comment: "empty message"), preferredStyle: .Alert)
                                self.presentViewController(alertController, animated: true, completion: nil)
                                let doneAction = UIAlertAction(title: "好的", style: .Default, handler: nil)
                                alertController.addAction(doneAction)
                            }else{
                                
                                // print("投递简历")
                                let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("你确定要投递该职位吗？", comment: "empty message"), preferredStyle: .Alert)
                                self.presentViewController(alertController, animated: true, completion: nil)
                                
                                let doneAction = UIAlertAction(title: "确定", style: .Cancel, handler: { (doneAction) in
                                    
                                    let applyJobHud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                                    applyJobHud.labelText = "正在投递简历"
                                    applyJobHud.removeFromSuperViewOnHide = true
                                    applyJobHud.margin = 10.0
                                    
                                    let url = PARK_URL_Header+"ApplyJob"
                                    let param = [
                                        "userid":QCLoginUserInfo.currentInfo.userid,
                                        "jobid":self.jobDataSource![btn.tag].id,
                                        "companyid":self.jobDataSource![btn.tag].companyid
                                    ]
                                    Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
                                        // print(request)
                                        if(error != nil){
                                            
                                        }else{
                                            let result = Http(JSONDecoder(json!))
                                            if(result.status == "success"){
                                                //  菊花加载
                                                //                                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                                                applyJobHud.mode = MBProgressHUDMode.Text;
                                                applyJobHud.labelText = "投递简历成功"
                                                //                                            hud.margin = 10.0
                                                //                                            hud.removeFromSuperViewOnHide = true
                                                applyJobHud.hide(true, afterDelay: 1)
                                                // print(111111)
                                            }else{
                                                //  菊花加载
                                                //                                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                                                applyJobHud.mode = MBProgressHUDMode.Text;
                                                applyJobHud.labelText = "投递简历失败"
                                                //                                            hud.margin = 10.0
                                                //                                            hud.removeFromSuperViewOnHide = true
                                                applyJobHud.hide(true, afterDelay: 1)
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
                            resumeHud.mode = MBProgressHUDMode.Text
                            resumeHud.labelText = "获取简历投递状态失败"
                            resumeHud.hide(true, afterDelay: 1)
                        }
                    })
                    
                    
                }else{
                    if String(response!) == "no data" {
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            resumeHud.hide(true)
                            let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("您还没有简历，请上传简历后投递？", comment: "empty message"), preferredStyle: .Alert)
                            self.presentViewController(alertController, animated: true, completion: nil)
                            let doneAction = UIAlertAction(title: "现在就去", style: .Default, handler: { (action) in
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
                            })
                            alertController.addAction(doneAction)
                            
                            let cancelAction = UIAlertAction(title: "先不投了", style: .Cancel, handler: { (action) in
                                
                            })
                            alertController.addAction(cancelAction)
                        })
                    }else{
                        resumeHud.mode = MBProgressHUDMode.Text
                        resumeHud.labelText = "获取简历信息失败"
                        resumeHud.hide(true, afterDelay: 1)
                    }
                }
            }
        }
        
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
