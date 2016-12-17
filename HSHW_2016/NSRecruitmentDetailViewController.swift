//
//  NSRecruitmentDetailViewController.swift
//  HSHW_2016
//
//  Created by zhang on 2016/10/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class NSRecruitmentDetailViewController: UIViewController,UIScrollViewDelegate {
    

    var times = Int()
    let employment = UIView()
    let employmentMessage = UIView()
//    let sendPostion = NSBundle.mainBundle().loadNibNamed("PostVacancies", owner: nil, options: nil).first as! PostVacancies
    var jobDataSource:Array<JobModel>?
    var currentJobModel:JobModel?
    var CVDataSource:Array<CVModel>?
    
//    var requestHelper = NewsPageHelper()
    
    var strId = "1"
    
    var showType = 1
    var num = 1
    var selfNav:UINavigationController?
    var btnTag = 1

    let contactTelBtn = UIButton()
    
    weak var superViewController:NurseStationViewController?
    
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
        
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "招聘详情"
        
        self.setSubViews()
        
    }
    
    func setSubViews() {
        let line = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.white
        
        let jobModel = currentJobModel
        
        strId = jobModel!.id
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        let rootScrollView = UIScrollView(frame: CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-64-1-WIDTH*59/375))
        rootScrollView.backgroundColor = UIColor.white
        self.view.addSubview(rootScrollView)
        
        let title = UILabel()
        let height = calculateHeight(jobModel!.title, size: 18, width: WIDTH-20)
        title.frame = CGRect(x: 10, y: 10, width: WIDTH-20, height: height)
        title.text = jobModel!.title
        title.font = UIFont.systemFont(ofSize: 22)
        title.textColor = COLOR
        title.numberOfLines = 0
        title.sizeToFit()
        rootScrollView.addSubview(title)
        
        let eyeImage = UIImageView(image: UIImage(named: "ic_eye_purple.png"))
        eyeImage.frame = CGRect(x: 10,y: title.frame.maxY+10,width: 8,height: 8)
        eyeImage.contentMode = .scaleAspectFit
        rootScrollView.addSubview(eyeImage)
        
        let lookCount = UILabel(frame: CGRect(x: eyeImage.frame.maxX+5,y: title.frame.maxY+10,width: 30,height: 10))
        lookCount.font = UIFont.systemFont(ofSize: 10)
        lookCount.text = (jobModel?.hits ?? "0")!
        lookCount.sizeToFit()
        lookCount.center.y = eyeImage.center.y
        rootScrollView.addSubview(lookCount)
        
        let timeImage = UIImageView(image: UIImage(named: "ic_time_purple.png"))
        timeImage.frame = CGRect(x: lookCount.frame.maxX+18, y: title.frame.maxY+10, width: 8, height: 8)
//        timeImage.frame = CGRectMake(10, CGRectGetMaxY(title.frame)+10, 8, 8)
        timeImage.contentMode = .scaleAspectFit
        rootScrollView.addSubview(timeImage)
        
        let timeLabel = UILabel(frame: CGRect(x: timeImage.frame.maxX+5,y: title.frame.maxY+10,width: 100,height: 10))
        timeLabel.font = UIFont.systemFont(ofSize: 10)
        timeLabel.text = self.timeStampToString((jobModel?.create_time)!)
        timeLabel.sizeToFit()
        timeLabel.center.y = timeImage.center.y
        rootScrollView.addSubview(timeLabel)
        
        
        
        let nameLabel = UILabel(frame: CGRect(x: 10,y: timeLabel.frame.maxY+10,width: 100,height: 25))
        nameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        nameLabel.text = "企业名称:"
        nameLabel.sizeToFit()
        rootScrollView.addSubview(nameLabel)
        
        let name = UILabel(frame: CGRect(x: nameLabel.frame.maxX+8,y: timeLabel.frame.maxY+10,width: 200,height: 25))
        name.font = UIFont.systemFont(ofSize: 14)
        name.text = jobModel!.companyname
        name.sizeToFit()
        name.center.y = nameLabel.center.y
        rootScrollView.addSubview(name)
        
        
        
        let descripTagLab = UILabel(frame: CGRect(x: 10,y: name.frame.maxY+10,width: WIDTH-20,height: 0))
        descripTagLab.font = UIFont.boldSystemFont(ofSize: 15)
        descripTagLab.textColor = UIColor.black
        descripTagLab.text = "企业简介:"
        descripTagLab.sizeToFit()
        rootScrollView.addSubview(descripTagLab)
        
        let descripStr = jobModel!.companyinfo
        let attrStr = NSMutableAttributedString(string: descripStr)
        //                    attrStr.addAttributes([NSFontAttributeName:UIFont.boldSystemFontOfSize(15)], range: NSMakeRange(0, 5))
        attrStr.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 14)], range: NSMakeRange(0, attrStr.length))
        attrStr.addAttributes([NSForegroundColorAttributeName:UIColor.lightGray], range: NSMakeRange(0, attrStr.length))
        
        let descript = UILabel(frame: CGRect(
            x: descripTagLab.frame.maxX+8,
            y: name.frame.maxY+10,
            width: WIDTH-descripTagLab.frame.maxX-10,
            height: attrStr.boundingRect(with: CGSize(width: WIDTH-descripTagLab.frame.maxX-10, height: 0), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).size.height))
        descript.font = UIFont.boldSystemFont(ofSize: 15)
        descript.numberOfLines = 0
        descript.attributedText = attrStr
        descript.sizeToFit()
        rootScrollView.addSubview(descript)
        
        
        
        let criteria = UILabel(frame: CGRect(x: 10,y: descript.frame.maxY+10,width: 70,height: 25))
        criteria.font = UIFont.boldSystemFont(ofSize: 15)
        criteria.text = "招聘条件:"
        criteria.sizeToFit()
        rootScrollView.addSubview(criteria)
        
        let criteriaLabel = UILabel(frame: CGRect(x: criteria.frame.maxX+8,y: descript.frame.maxY+10,width: 75,height: 25))
        criteriaLabel.font = UIFont.systemFont(ofSize: 14)
        criteriaLabel.textColor = UIColor.lightGray
        criteriaLabel.text = jobModel!.education
        criteriaLabel.sizeToFit()
        rootScrollView.addSubview(criteriaLabel)

        
        let personalNumTagLab = UILabel(frame: CGRect(x: 10,y: criteriaLabel.frame.maxY+10,width: 70,height: 25))
        personalNumTagLab.font = UIFont.boldSystemFont(ofSize: 15)
        personalNumTagLab.text = "招聘人数:"
        personalNumTagLab.sizeToFit()
        rootScrollView.addSubview(personalNumTagLab)

        let personalNumLab = UILabel(frame: CGRect(x: personalNumTagLab.frame.maxX+8,y: criteriaLabel.frame.maxY+10,width: 75,height: 25))
        personalNumLab.font = UIFont.systemFont(ofSize: 14)
        personalNumLab.textColor = UIColor.lightGray
        personalNumLab.text = jobModel!.count
        personalNumLab.sizeToFit()
        rootScrollView.addSubview(personalNumLab)
        
        let salaryTagLab = UILabel(frame: CGRect(x: 170,y: criteriaLabel.frame.maxY+10,width: 70,height: 25))
        salaryTagLab.font = UIFont.boldSystemFont(ofSize: 15)
        salaryTagLab.text = "薪资待遇:"
        salaryTagLab.sizeToFit()
        rootScrollView.addSubview(salaryTagLab)
        
        let salaryLab = UILabel(frame: CGRect(x: salaryTagLab.frame.maxX+8,y: criteriaLabel.frame.maxY+10,width: WIDTH-240,height: 25))
        salaryLab.font = UIFont.systemFont(ofSize: 14)
        salaryLab.textColor = UIColor.lightGray
        salaryLab.text = currentJobModel!.salary
        salaryLab.sizeToFit()
        rootScrollView.addSubview(salaryLab)
        
        let expTagLab = UILabel(frame: CGRect(x: 10,y: personalNumLab.frame.maxY+10,width: 70,height: 25))
        expTagLab.font = UIFont.boldSystemFont(ofSize: 15)
        expTagLab.text = "工作年限:"
        expTagLab.sizeToFit()
        rootScrollView.addSubview(expTagLab)
        
        let expLab = UILabel(frame: CGRect(x: expTagLab.frame.maxX+8,y: personalNumLab.frame.maxY+10,width: WIDTH-240,height: 25))
        expLab.font = UIFont.systemFont(ofSize: 14)
        expLab.textColor = UIColor.lightGray
        expLab.text = currentJobModel!.experience
        expLab.sizeToFit()
        rootScrollView.addSubview(expLab)

        let welfareTagLab = UILabel(frame: CGRect(x: 170,y: personalNumLab.frame.maxY+10,width: 70,height: 25))
        welfareTagLab.font = UIFont.boldSystemFont(ofSize: 15)
        welfareTagLab.text = "福利待遇:"
        welfareTagLab.sizeToFit()
        rootScrollView.addSubview(welfareTagLab)

        let welfareLab = UILabel(frame: CGRect(x: welfareTagLab.frame.maxX+8,y: personalNumLab.frame.maxY+10,width: WIDTH-240,height: 25))
        welfareLab.font = UIFont.systemFont(ofSize: 14)
        welfareLab.textColor = UIColor.lightGray
        welfareLab.text = jobModel!.welfare
        welfareLab.sizeToFit()
        rootScrollView.addSubview(welfareLab)
        
        
        
        let addressTagLab = UILabel(frame: CGRect(x: 10,y: welfareLab.frame.maxY+10,width: 70,height: 25))
        addressTagLab.font = UIFont.boldSystemFont(ofSize: 15)
        addressTagLab.text = "工作地点:"
        addressTagLab.sizeToFit()
        rootScrollView.addSubview(addressTagLab)
        
        let addressLab = UILabel(frame: CGRect(x: addressTagLab.frame.maxX+8,y: welfareLab.frame.maxY+10,width: WIDTH-240,height: 25))
        addressLab.font = UIFont.systemFont(ofSize: 14)
        addressLab.textColor = UIColor.lightGray
        addressLab.text = currentJobModel!.address
        addressLab.sizeToFit()
        addressLab.center.y = addressTagLab.center.y
        rootScrollView.addSubview(addressLab)
        
        
        
        let positionDescript = UILabel(frame: CGRect(x: 10,y: addressLab.frame.maxY+10,width: 100,height: 25))
        positionDescript.font = UIFont.boldSystemFont(ofSize: 15)
        positionDescript.text = "职位描述:"
        positionDescript.sizeToFit()
        rootScrollView.addSubview(positionDescript)
        
        let descripDetail = UILabel(frame: CGRect(x: 10,y: addressLab.frame.maxY+40,width: WIDTH-20,height: 200))
        descripDetail.font = UIFont.systemFont(ofSize: 14)
        descripDetail.textColor = UIColor.lightGray
        descripDetail.numberOfLines = 0
        descripDetail.text = jobModel!.description
        descripDetail.frame.size.height = calculateHeight((jobModel?.description)!, size: 14, width: WIDTH-20)
        descripDetail.sizeToFit()
        rootScrollView.addSubview(descripDetail)
        
        
        
        let contactTagLab = UILabel(frame: CGRect(x: 10,y: descripDetail.frame.maxY+10,width: 80,height: 25))
        contactTagLab.font = UIFont.boldSystemFont(ofSize: 15)
        contactTagLab.text = "联系方式:"
        contactTagLab.sizeToFit()
        rootScrollView.addSubview(contactTagLab)
        
        let contactNameLab = UILabel(frame: CGRect(x: contactTagLab.frame.maxX+8,y: descripDetail.frame.maxY+10,width: 80,height: 25))
        contactNameLab.font = UIFont.boldSystemFont(ofSize: 14)
        contactNameLab.textColor = UIColor.lightGray
        contactNameLab.text = jobModel?.linkman
        contactNameLab.sizeToFit()
        contactNameLab.center.y = contactTagLab.center.y
        rootScrollView.addSubview(contactNameLab)
        
        contactTelBtn.frame = CGRect(x: contactTagLab.frame.maxX+8, y: contactNameLab.frame.maxY+8, width: 10, height: 25)
        contactTelBtn.setTitleColor(COLOR, for: UIControlState())
        contactTelBtn.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        if !canLookTel {
            contactTelBtn.setTitle("查看联系方式", for: UIControlState())
            contactTelBtn.addTarget(self, action: #selector(contactClick), for: .touchUpInside)
        }else {
            contactTelBtn.setTitle(jobModel!.phone, for: UIControlState())
        }
        contactTelBtn.sizeToFit()
//        contactTelBtn.center.y = contactNameLab.center.y
        rootScrollView.addSubview(contactTelBtn)
        
        rootScrollView.contentSize = CGSize(width: 0, height: contactTelBtn.frame.maxY+10)
        
        let tack = UIButton(frame: CGRect(
            x: WIDTH*35/375,
            y: rootScrollView.frame.maxY+WIDTH*2/375,
            width: WIDTH*305/375,
            height: WIDTH*45/375))
        tack.layer.cornerRadius = WIDTH*22.5/375
        tack.layer.borderColor = COLOR.cgColor
        tack.layer.borderWidth = 1
        tack.setTitle("投递简历", for: UIControlState())
        tack.setTitleColor(COLOR, for: UIControlState())
        tack.addTarget(self, action: #selector(self.resumeOnline(_:)), for: .touchUpInside)
        self.view.addSubview(tack)
    }
    

    
    func contactClick() {
        // MARK:要求登录
        if !requiredLogin(self.navigationController!, previousViewController: self, hiddenNavigationBar: false) {
            return
        }
        
        if QCLoginUserInfo.currentInfo.usertype == "2" {
            
            let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("您是企业用户，不能查看企业联系方式", comment: "empty message"), preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            
            let cancelAction = UIAlertAction(title: "好的", style: .cancel, handler: { (action) in
                return
            })
            alertController.addAction(cancelAction)
            return
        }
        
        canLookTel = true
        
        contactTelBtn.setTitle(currentJobModel?.phone, for: UIControlState())
        contactTelBtn.sizeToFit()
    }
    
    // MARK: 投递简历
    func resumeOnline(_ btn:UIButton) {
        
        // MARK:要求登录
        if !requiredLogin(self.navigationController!, previousViewController: self, hiddenNavigationBar: false) {
            return
        }
        
        if QCLoginUserInfo.currentInfo.usertype == "2" {
            
            let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("您是企业用户，不能投递简历", comment: "empty message"), preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            
            let cancelAction = UIAlertAction(title: "好的", style: .cancel, handler: { (action) in
                return
            })
            alertController.addAction(cancelAction)
        }else{
            
            let resumeHud = MBProgressHUD.showAdded(to: self.view, animated: true)
            resumeHud?.labelText = "正在获取简历信息"
            resumeHud?.removeFromSuperViewOnHide = true
            resumeHud?.margin = 10.0
            
            HSNurseStationHelper().getResumeInfo(QCLoginUserInfo.currentInfo.userid) { (success, response) in
                if success {
                    
                    // 判断是否已投递简历
                    resumeHud?.labelText = "正在获取简历投递状态"
                    
                    HSNurseStationHelper().ApplyJob_judge(QCLoginUserInfo.currentInfo.userid, companyid: self.jobDataSource![btn.tag].companyid, jobid: self.jobDataSource![btn.tag].id, handle: { (success, response) in
                        if success {
                            resumeHud?.hide(true)
                            if String(describing: response) == "1" {
                                let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("您已投递过该职位，无需再次投递", comment: "empty message"), preferredStyle: .alert)
                                self.present(alertController, animated: true, completion: nil)
                                let doneAction = UIAlertAction(title: "好的", style: .default, handler: nil)
                                alertController.addAction(doneAction)
                            }else{
                                
                                // print("投递简历")
                                let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("你确定要投递该职位吗？", comment: "empty message"), preferredStyle: .alert)
                                self.present(alertController, animated: true, completion: nil)
                                
                                let doneAction = UIAlertAction(title: "确定", style: .cancel, handler: { (doneAction) in
                                    
                                    let applyJobHud = MBProgressHUD.showAdded(to: self.view, animated: true)
                                    applyJobHud?.labelText = "正在投递简历"
                                    applyJobHud?.removeFromSuperViewOnHide = true
                                    applyJobHud?.margin = 10.0
                                    
                                    let url = PARK_URL_Header+"ApplyJob"
                                    let param = [
                                        "userid":QCLoginUserInfo.currentInfo.userid,
                                        "jobid":self.jobDataSource![btn.tag].id,
                                        "companyid":self.jobDataSource![btn.tag].companyid
                                    ]
                                    NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
                                        // print(request)
                                        if(error != nil){
                                            
                                        }else{
                                            let result = Http(JSONDecoder(json!))
                                            if(result.status == "success"){
                                                //  菊花加载
                                                //                                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                                                applyJobHud?.mode = MBProgressHUDMode.text;
                                                applyJobHud?.labelText = "投递简历成功"
                                                //                                            hud.margin = 10.0
                                                //                                            hud.removeFromSuperViewOnHide = true
                                                applyJobHud?.hide(true, afterDelay: 1)
                                                // print(111111)
                                            }else{
                                                //  菊花加载
                                                //                                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                                                applyJobHud?.mode = MBProgressHUDMode.text;
                                                applyJobHud?.labelText = "投递简历失败"
                                                //                                            hud.margin = 10.0
                                                //                                            hud.removeFromSuperViewOnHide = true
                                                applyJobHud?.hide(true, afterDelay: 1)
                                                // print(2222222)
                                            }
                                        }
                                    }
                                    
                                    
                                })
                                alertController.addAction(doneAction)
                                
                                let cancelAction = UIAlertAction(title: "取消", style: .default, handler: { (cancelAction) in
                                    return
                                })
                                alertController.addAction(cancelAction)
                            }
                        }else{
                            resumeHud?.mode = MBProgressHUDMode.text
                            resumeHud?.labelText = "获取简历投递状态失败"
                            resumeHud?.hide(true, afterDelay: 1)
                        }
                    })
                    
                    
                }else{
                    
                    if String(describing: response) == "no data" {
                        
                        DispatchQueue.main.async(execute: {
                            resumeHud?.hide(true)
                            let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("您还没有简历，请上传简历后投递？", comment: "empty message"), preferredStyle: .alert)
                            self.present(alertController, animated: true, completion: nil)
                            let doneAction = UIAlertAction(title: "现在就去", style: .default, handler: { (action) in
                                if QCLoginUserInfo.currentInfo.usertype == "2" {
                                    
                                    let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("您是企业用户，不能编辑简历", comment: "empty message"), preferredStyle: .alert)
                                    self.present(alertController, animated: true, completion: nil)
                                    
                                    let cancelAction = UIAlertAction(title: "好的", style: .cancel, handler: { (action) in
                                        return
                                    })
                                    alertController.addAction(cancelAction)
                                }else{
                                    self.navigationController?.pushViewController(editResumeViewController(), animated: true)
                                }
                            })
                            alertController.addAction(doneAction)
                            
                            let cancelAction = UIAlertAction(title: "先不投了", style: .cancel, handler: { (action) in
                                
                            })
                            alertController.addAction(cancelAction)
                        })
                    }else{
                        resumeHud?.mode = MBProgressHUDMode.text
                        resumeHud?.labelText = "获取简历信息失败"
                        resumeHud?.hide(true, afterDelay: 1)
                    }
                }
            }
        }
        
    }
    
    // Linux时间戳转标准时间
    func timeStampToString(_ timeStamp:String)->String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy-MM-dd"
        
        let date = Date(timeIntervalSince1970: timeSta)
        
        //        print(dfmatter.stringFromDate(date))
        return dfmatter.string(from: date)
    }
}
