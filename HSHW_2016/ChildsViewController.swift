//
//  ChildsViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
//import Alamofire
import MBProgressHUD

class ChildsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var type = 1 // 1 个人 2 企业
    
    let myTableView = UITableView()
    let resumeDetail = NSBundle.mainBundle().loadNibNamed("HSFindPersonDetailView", owner: nil, options: nil).first as! HSFindPersonDetailView
    let employmentMessageTableView = UITableView()
    let employmentMessage = UIView()
    var num = 1
    var currentJobModel:InvitedInfo?
    var CVDataSource:Array<CVModel>?
//    let jobHelper = HSNurseStationHelper()
    var dataSource = Array<CVModel>()
    var myInvitedList = InvitedList()
    
    weak var superViewController:MineRecruitViewController?
    
    var str = NSString()
    
    var name = NSString()
    var sex = NSString()
    var avatar = NSString()
    var birthday = NSString()
    var address = NSString()
    var education = NSString()
    var certificate = NSString()
    var currentsalary = NSString()
    var count = NSString()
    var descrip = NSString()
    var linkman = NSString()
    var phone = NSString()
    var experience = NSString()
    var wantposition = NSString()
    var tit = NSString()
    var jobstate = NSString()
    var wantsalary = NSString()
    var ema = NSString()
    var hiredate = NSString()
    var wantcity = NSString()
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.navigationBar.hidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        resumeDetail.delegate = self
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)

        self.view.backgroundColor = UIColor.whiteColor()
        
        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-115)
        myTableView.backgroundColor = UIColor.clearColor()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .None
        myTableView.registerClass(MineRecruitTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(myTableView)
        myTableView.rowHeight = 72
        
        myTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(GetDate))
        myTableView.mj_header.beginRefreshing()
        
        employmentMessageTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "employmentMessage")
        employmentMessageTableView.delegate = self
        employmentMessageTableView.dataSource = self
        employmentMessageTableView.tag = 1
        employmentMessageTableView.separatorStyle = .None
        
        //        self.GetDate()
        
        // Do any additional setup after loading the view.
    }
    
    func lookContectBtnClick(lookContectBtn: UIButton, phoneNumber: UILabel, email: UILabel) {
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
    
    func hiddenResumeDetail() {
        resumeDetail.removeFromSuperview()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if tableView.tag == 1 {
            
            if indexPath.row == 0 {
                let jobModel = myInvitedList.data[indexPath.row]
                let height = calculateHeight(jobModel.title, size: 18, width: WIDTH-20)
                return 20+height
            }else if indexPath.row == 1 {
                return 20
            }else if indexPath.row == 2 {
                return 35
            }else if indexPath.row == 3 {
                return 50
            }else if indexPath.row == 4 {
                return 35
            }else if indexPath.row == 5 {
                return 35
            }else if indexPath.row == 6 {
                return 300
            }else if indexPath.row == 7 {
                return 35
            }
            else{
                return 100
            }
        }else{
            return 72
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return CVDataSource?.count ?? 0
        if tableView.tag == 1 {
            return 8
        }else{
            
            if type == 1 {
                // print(self.myInvitedList.data.count)
                return self.myInvitedList.data.count
            }else{
                return self.dataSource.count
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView.tag == 1 {
            let cell1 = UITableViewCell()
            //            // print(employmentdataSource)
            //            let jobModel = employmentdataSource[0]as! JobModel
            let jobModel = currentJobModel
            
            // print(jobModel!.title)
            cell1.selectionStyle = .None
            cell1.textLabel?.numberOfLines = 0
            //            strId = jobModel!.id
            //            // print(jobModel.id)
            // print(indexPath.row)
            if indexPath.row==0 {
                let title = UILabel()
                let height = calculateHeight(jobModel!.title, size: 18, width: WIDTH-20)
                title.frame = CGRectMake(10, 10, WIDTH-20, height)
                title.text = jobModel!.title
                title.font = UIFont.systemFontOfSize(20)
                title.textColor = COLOR
                title.numberOfLines = 0
                cell1.addSubview(title)
            }else if indexPath.row == 1 {
                let eyeImage = UIImageView(image: UIImage(named: "ic_eye_purple.png"))
                eyeImage.frame = CGRectMake(10,10,13,9)
                let lookCount = UILabel(frame: CGRectMake(20,10,30,10))
                lookCount.font = UIFont.systemFontOfSize(10)
                lookCount.text = "3346"
                let timeImage = UIImageView(image: UIImage(named: "ic_time_purple.png"))
                timeImage.frame = CGRectMake(10, 10, 8, 8)
                let timeLabel = UILabel(frame: CGRectMake(CGRectGetMaxX(timeImage.frame)+5,10,100,10))
                timeLabel.font = UIFont.systemFontOfSize(10)
                timeLabel.text = self.timeStampToString(jobModel!.create_time)
                
                //                cell1.addSubview(eyeImage)
                //                cell1.addSubview(lookCount)
                cell1.addSubview(timeImage)
                cell1.addSubview(timeLabel)
                
            }else if indexPath.row == 2 {
                let nameLabel = UILabel(frame: CGRectMake(10,10,100,25))
                nameLabel.font = UIFont.boldSystemFontOfSize(15)
                nameLabel.text = "企业名称:"
                nameLabel.sizeToFit()
                let name = UILabel(frame: CGRectMake(CGRectGetMaxX(nameLabel.frame)+8,10,200,25))
                name.font = UIFont.systemFontOfSize(14)
                name.text = jobModel!.companyname
                name.sizeToFit()
                name.center.y = nameLabel.center.y
                
                cell1.addSubview(nameLabel)
                cell1.addSubview(name)
            }else if indexPath.row == 3 {
                let descript = UILabel(frame: CGRectMake(10,10,WIDTH-20,50))
                descript.font = UIFont.boldSystemFontOfSize(15)
                descript.numberOfLines = 0
                let descripStr = "企业简介: " + jobModel!.companyinfo
                let attrStr = NSMutableAttributedString(string: descripStr)
                attrStr.addAttributes([NSFontAttributeName:UIFont.boldSystemFontOfSize(15)], range: NSMakeRange(0, 5))
                attrStr.addAttributes([NSFontAttributeName:UIFont.systemFontOfSize(14)], range: NSMakeRange(5, attrStr.length-5))
                attrStr.addAttributes([NSForegroundColorAttributeName:UIColor.lightGrayColor()], range: NSMakeRange(5, attrStr.length-5))
                descript.attributedText = attrStr
                cell1.addSubview(descript)
            }else if indexPath.row == 4 {
                let criteria = UILabel(frame: CGRectMake(10,10,70,25))
                criteria.font = UIFont.boldSystemFontOfSize(15)
                criteria.text = "招聘条件:"
                let criteriaLabel = UILabel(frame: CGRectMake(80,10,75,25))
                criteriaLabel.font = UIFont.systemFontOfSize(14)
                criteriaLabel.text = jobModel!.education
                let address = UILabel(frame: CGRectMake(170,10,70,25))
                address.font = UIFont.boldSystemFontOfSize(15)
                address.text = "工作地点:"
                let addressLabel = UILabel(frame: CGRectMake(240,10,WIDTH-240,25))
                addressLabel.font = UIFont.systemFontOfSize(14)
                addressLabel.adjustsFontSizeToFitWidth = true
                addressLabel.text = jobModel!.address
                cell1.addSubview(criteria)
                cell1.addSubview(criteriaLabel)
                cell1.addSubview(address)
                cell1.addSubview(addressLabel)
            }else if indexPath.row == 5{
                let criteria = UILabel(frame: CGRectMake(10,10,70,25))
                criteria.font = UIFont.boldSystemFontOfSize(15)
                criteria.text = "招聘人数:"
                let criteriaLabel = UILabel(frame: CGRectMake(80,10,75,25))
                criteriaLabel.font = UIFont.systemFontOfSize(14)
                criteriaLabel.text = jobModel!.count
                let address = UILabel(frame: CGRectMake(170,10,70,25))
                address.font = UIFont.boldSystemFontOfSize(15)
                address.text = "福利待遇:"
                let addressLabel = UILabel(frame: CGRectMake(240,10,WIDTH-240,25))
                addressLabel.font = UIFont.systemFontOfSize(14)
                addressLabel.text = jobModel!.welfare
                cell1.addSubview(criteria)
                cell1.addSubview(criteriaLabel)
                cell1.addSubview(address)
                cell1.addSubview(addressLabel)
            }else if indexPath.row == 6 {
                let positionDescript = UILabel(frame: CGRectMake(10,10,100,25))
                positionDescript.font = UIFont.boldSystemFontOfSize(15)
                positionDescript.text = "职位描述:"
                let descripDetail = UILabel(frame: CGRectMake(10,40,WIDTH-20,200))
                descripDetail.font = UIFont.systemFontOfSize(14)
                descripDetail.textColor = UIColor.lightGrayColor()
                descripDetail.numberOfLines = 0
                descripDetail.text = jobModel!.description
                cell1.addSubview(positionDescript)
                cell1.addSubview(descripDetail)
            }else if indexPath.row == 7 {
                let nameLabel = UILabel(frame: CGRectMake(10,10,80,25))
                nameLabel.font = UIFont.boldSystemFontOfSize(15)
                nameLabel.text = "联系方式:"
                
                let name = UIButton(type: UIButtonType.Custom)
                name.frame = CGRectMake(100, 10, WIDTH-80-10-10, 25)
                name.setTitleColor(COLOR, forState: .Normal)
                name.titleLabel!.font = UIFont.systemFontOfSize(14)
                if num == 1 {
                    name.setTitle("查看联系方式", forState: .Normal)
                    name.sizeToFit()
                    name.addTarget(self, action: #selector(contactClick), forControlEvents: .TouchUpInside)
                }else if num == 2{
                    name.setTitle(jobModel!.phone, forState: .Normal)
                    name.sizeToFit()
                }
                cell1.addSubview(nameLabel)
                cell1.addSubview(name)
            }
            return cell1
        }else{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)as!MineRecruitTableViewCell
            cell.selectionStyle = .None
            
            
            if type == 1 {
                cell.showforUserModel(self.myInvitedList.data[indexPath.row])
            }else{
                let model = self.dataSource[indexPath.row]
                cell.showforCVModel(model)
            }
            return cell
        }
        //        cell.timeLab.text = "15分钟前"
        //        cell.job.text = model.birthday
        //        cell.nameTit.text = model.userid
        //        cell.one.text = "申请面试"
        //        cell.two.text = "的面试"
        
        
    }
    
    func contactClick() {
        num = 2
        self.employmentMessageTableView.reloadData()
        
    }
    
    func GetDate(){
        
        if type == 1 {
            
            
            
            let url = PARK_URL_Header+"UserGetInvite"
            let param = ["userid":QCLoginUserInfo.currentInfo.userid]
            NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in

//            Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
                if(error != nil){
                    
                }else{
                    let status = InvitedModel(JSONDecoder(json!))
                    // print("状态是")
                    // print(status.status)
                    if(status.status == "error"){
                        //                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        if status.errorData == nil {
                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                            hud.mode = .Text
                            hud.labelText = "抱歉，您还没有收到面试邀请"
                            hud.margin = 10.0
                            hud.removeFromSuperViewOnHide = true
                            hud.hide(true, afterDelay: 1)
                        }else{
                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                            hud.mode = .Text
                            hud.labelText = status.errorData
                            hud.margin = 10.0
                            hud.removeFromSuperViewOnHide = true
                            hud.hide(true)
                            //                        hud.margin = 10.0
                            //                        hud.removeFromSuperViewOnHide = true
                            hud.hide(true, afterDelay: 1)
                        }
                    }
                    if(status.status == "success"){
                        // print(status)
                        self.myInvitedList = InvitedList(status.data!)
                        self.myTableView.reloadData()
                        // print(status.data)
                    }
                }
                self.myTableView.mj_header.endRefreshing()
            }
        }else{
            
            let url = PARK_URL_Header+"getMyReciveResumeList"
            let param = ["userid":QCLoginUserInfo.currentInfo.userid]
            NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in

//            Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
                if(error != nil){
                    
                }else{
                    let status = HSCVListModel(JSONDecoder(json!))
                    // print("状态是")
                    // print(status.status)
                    if(status.status == "error"){
                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        //hud.labelText = status.errorData
                        if status.datas.count == 0 {
                            hud.labelText = "您还没有收到简历"
                            self.myTableView .reloadData()
                        }
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                    }
                    if(status.status == "success"){
                        // print(status)
                        self.dataSource = status.datas
                        self.myTableView .reloadData()
                        // print(status.datas)
                    }
                }
                self.myTableView.mj_header.endRefreshing()
            }
        }
    }
    
    func makeCVMessage(){
        resumeDetail.frame = CGRectMake(0, 0.5, WIDTH, HEIGHT-154.5)
        
        //        resumeDetail.showFor(birthday)
        //        resumeDetail.showSex(sex)
        //        resumeDetail.showName(name)
        //        resumeDetail.education(education)
        //        resumeDetail.address(address)
        //        resumeDetail.experience(experience)
        //        resumeDetail.jobName(tit)
        //        resumeDetail.comeTime(hiredate)
        //        resumeDetail.expectSalary(wantsalary)
        //        resumeDetail.targetLocation(wantcity)
        //        resumeDetail.targetPosition(wantposition)
        //        resumeDetail.selfEvaluation(descrip)
        //        resumeDetail.phoneNumber(phone)
        //        resumeDetail.email(ema)
        //        resumeDetail.currentSalary(currentsalary)
        //        resumeDetail.jobState(jobstate)
        self.view.addSubview(resumeDetail)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if type == 1 {
            currentJobModel = self.myInvitedList.data[indexPath.row]
            makeEmploymentMessage()
        }else {
            
            // print(indexPath.row)
            let model = self.dataSource[indexPath.row]
//            self.name = model.name
//            self.sex = model.sex
//            self.avatar = model.avatar
//            self.birthday = model.birthday
//            self.address = model.address
//            self.education = model.education
//            self.certificate = model.certificate
//            self.currentsalary = model.currentsalary
//            self.count = model.count
//            self.descrip = model.description
//            self.linkman = model.linkman
//            self.phone = model.phone
//            self.experience = model.experience
//            self.wantposition = model.wantposition
//            self.tit = model.title
//            self.jobstate = model.jobstate
//            self.ema = model.email
//            self.hiredate = model.hiredate
//            self.wantcity = model.wantcity
//            self.wantsalary = model.wantsalary
//            superViewController?.showRightBtn()
//            
//            //        self.makeCVMessage()
//            resumeDetail.frame = CGRectMake(0, 0.5, WIDTH, HEIGHT-107.5)
//            resumeDetail.delegate = self
//            resumeDetail.model = model
//            self.view.addSubview(resumeDetail)
            
            let cvVC = NSPersonalInfoDetailViewController()
            cvVC.cvModel = model
            self.navigationController?.pushViewController(cvVC, animated: true)
            
//            resumeDetail.frame = CGRectMake(0, 0.5, WIDTH, HEIGHT-107.5-44)
//            resumeDetail.model = model
//            resumeDetail.cvModel = model
//            resumeDetail.tag = 1001
//            self.view.addSubview(resumeDetail)
//            
//            let backBtn = UIButton(frame: CGRectMake(20, CGRectGetMaxY(resumeDetail.frame)+5, WIDTH-40, 34))
//            backBtn.tag = 1001
//            backBtn.layer.cornerRadius = 17
//            backBtn.layer.borderColor = COLOR.CGColor
//            backBtn.layer.borderWidth = 1
//            backBtn.setTitle("返回", forState: .Normal)
//            backBtn.setTitleColor(COLOR, forState: .Normal)
//            backBtn.addTarget(self, action: #selector(self.backBtnClick), forControlEvents: .TouchUpInside)
//            self.view.addSubview(backBtn)
            
        }
    }
    
    func makeEmploymentMessage_1() {
        
        
        employmentMessage.frame = CGRectMake(0, 0.5, WIDTH, HEIGHT-0.5)
        employmentMessage.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(employmentMessage)
        
        self.employmentMessageTableView.frame = CGRectMake(0, 0, employmentMessage.frame.size.width,employmentMessage.frame.size.height - WIDTH*65/375-64-49)
        //        self.employmentMessageTableView.backgroundColor = UIColor.redColor()
        
        let tackBtn = UIButton(frame: CGRectMake(WIDTH-WIDTH*130/375-WIDTH*15/375, self.employmentMessageTableView.frame.origin.y+self.employmentMessageTableView.frame.size.height+WIDTH*10/375, WIDTH*130/375, WIDTH*45/375))
        tackBtn.layer.cornerRadius = WIDTH*22.5/375
        tackBtn.layer.borderColor = COLOR.CGColor
        tackBtn.layer.borderWidth = 1
        tackBtn.setTitle("返回", forState: .Normal)
        tackBtn.setTitleColor(COLOR, forState: .Normal)
        tackBtn.addTarget(self, action: #selector(self.takeResume), forControlEvents: .TouchUpInside)
        employmentMessage.addSubview(tackBtn)
        
        let tack = UIButton(frame: CGRectMake(WIDTH*15/375, self.employmentMessageTableView.frame.origin.y+self.employmentMessageTableView.frame.size.height+WIDTH*10/375, WIDTH*130/375, WIDTH*45/375))
        tack.layer.cornerRadius = WIDTH*22.5/375
        tack.layer.borderColor = COLOR.CGColor
        tack.layer.borderWidth = 1
        tack.setTitle("投递简历", forState: .Normal)
        tack.setTitleColor(COLOR, forState: .Normal)
        tack.addTarget(self, action: #selector(self.resumeOnline(_:)), forControlEvents: .TouchUpInside)
        employmentMessage.addSubview(tack)
        
        employmentMessage.addSubview(employmentMessageTableView)
        
        
    }
    
    
    func makeEmploymentMessage() {
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let jobModel = currentJobModel
        
        //        strId = jobModel!.id
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        let rootScrollView = UIScrollView(frame: CGRectMake(0, 1, WIDTH, HEIGHT-64-1-44-WIDTH*59/375))
        rootScrollView.backgroundColor = UIColor.whiteColor()
        rootScrollView.tag = 1001
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
        
        let contactTelBtn = UIButton()
        contactTelBtn.frame = CGRectMake(CGRectGetMaxX(contactTagLab.frame)+8, CGRectGetMaxY(contactNameLab.frame)+8, 10, 25)
        contactTelBtn.setTitleColor(COLOR, forState: .Normal)
        contactTelBtn.titleLabel!.font = UIFont.systemFontOfSize(14)
        //        if !canLookTel {
        //            contactTelBtn.setTitle("查看联系方式", forState: .Normal)
        //            contactTelBtn.addTarget(self, action: #selector(contactClick), forControlEvents: .TouchUpInside)
        //        }else {
        contactTelBtn.setTitle(jobModel!.phone, forState: .Normal)
        //        }
        contactTelBtn.sizeToFit()
        //        contactTelBtn.center.y = contactNameLab.center.y
        rootScrollView.addSubview(contactTelBtn)
        
        rootScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(contactTelBtn.frame)+10)
        
        //        let tack = UIButton(frame: CGRectMake(
        //            WIDTH*35/375,
        //            CGRectGetMaxY(rootScrollView.frame)+WIDTH*2/375,
        //            WIDTH*305/375,
        //            WIDTH*45/375))
        //        tack.layer.cornerRadius = WIDTH*22.5/375
        //        tack.layer.borderColor = COLOR.CGColor
        //        tack.layer.borderWidth = 1
        //        tack.setTitle("投递简历", forState: .Normal)
        //        tack.setTitleColor(COLOR, forState: .Normal)
        //        tack.addTarget(self, action: #selector(self.resumeOnline(_:)), forControlEvents: .TouchUpInside)
        //        self.view.addSubview(tack)
        
        let tack = UIButton(frame: CGRectMake(
            WIDTH*35/375,
            CGRectGetMaxY(rootScrollView.frame)+WIDTH*2/375,
            WIDTH*180/375,
            WIDTH*45/375))
        tack.tag = 1001
        tack.layer.cornerRadius = WIDTH*22.5/375
        tack.layer.borderColor = COLOR.CGColor
        tack.layer.borderWidth = 1
        tack.setTitle("投递简历", forState: .Normal)
        tack.setTitleColor(COLOR, forState: .Normal)
        tack.addTarget(self, action: #selector(self.resumeOnline(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(tack)
        
        let tackBtn = UIButton(frame: CGRectMake(
            WIDTH*250/375,
            CGRectGetMaxY(rootScrollView.frame)+WIDTH*2/375,
            WIDTH*90/375,
            WIDTH*45/375))
        tackBtn.tag = 1001
        tackBtn.layer.cornerRadius = WIDTH*22.5/375
        tackBtn.layer.borderColor = COLOR.CGColor
        tackBtn.layer.borderWidth = 1
        tackBtn.setTitle("返回", forState: .Normal)
        tackBtn.setTitleColor(COLOR, forState: .Normal)
        tackBtn.addTarget(self, action: #selector(self.backBtnClick), forControlEvents: .TouchUpInside)
        self.view.addSubview(tackBtn)
        
        
    }
    
    func backBtnClick() {
        
        for subview in self.view.subviews {
            if subview.tag == 1001 {
                subview.removeFromSuperview()
            }
        }
//        self.view.viewWithTag(1001)?.removeFromSuperview()
    }
    
    func takeResume(){
        UIView.animateWithDuration(0.2) {
            self.employmentMessage.frame = CGRectMake(WIDTH, 0.5, WIDTH, HEIGHT-154.5)
        }
        //        self.employmentdataSource.removeAllObjects()
        self.employmentMessageTableView.reloadData()
        self.employmentMessage.removeFromSuperview()
    }
    
    // MARK:投递简历
    func resumeOnline(btn:UIButton) {
        
        let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("您已投递该简历，不需要重复投递", comment: "empty message"), preferredStyle: .Alert)
        self.presentViewController(alertController, animated: true, completion: nil)
        //                    let doneAction = UIAlertAction(title: "现在就去", style: .Default, handler: { (action) in
        //                        self.postedTheView()
        //                    })
        //                    alertController.addAction(doneAction)
        
        let cancelAction = UIAlertAction(title: "好的", style: .Cancel, handler: { (action) in
            
        })
        alertController.addAction(cancelAction)
        //                })
        //            }
        //        }
        
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
    
    func rightBarButtonClicked(){
        
        //        findPersonnel.rightBarButtonClicked()
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
