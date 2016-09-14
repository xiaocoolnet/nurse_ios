//
//  ChildsViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class ChildsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, HSFindPersonDetailViewDelegate {
    
    var type = 1 // 1 个人 2 企业
    
    let myTableView = UITableView()
    let resumeDetail = NSBundle.mainBundle().loadNibNamed("HSFindPersonDetailView", owner: nil, options: nil).first as! HSFindPersonDetailView
    let employmentMessageTableView = UITableView()
    let employmentMessage = UIView()
    var num = 1
    var currentJobModel:InvitedInfo?
    var CVDataSource:Array<CVModel>?
    let jobHelper = HSNurseStationHelper()
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
        
        resumeDetail.delegate = self
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        resumeDetail.delegate = self
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
    
    func sendInvite(model:CVModel){
        inviteJob(model)
    }
    
    func inviteJob(model:CVModel) {
        print("邀请面试")
        
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
            Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
                if(error != nil){
                    
                }else{
                    let status = MineJobModel(JSONDecoder(json!))
                    print("状态是")
                    print(status.status)
                    if(status.status == "error"){
                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        //hud.labelText = status.errorData
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                    }else if(status.status == "success"){
                        print(status)
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
                        if String(response!) == "1" {
                            
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
                                Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
                                    print(request)
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
                                            print(111111)
                                        }else{
                                            //  菊花加载
                                            //                                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                                            sendInviteHud.mode = MBProgressHUDMode.Text;
                                            sendInviteHud.labelText = "发送邀请失败"
                                            //                                    hud.margin = 10.0
                                            //                                    hud.removeFromSuperViewOnHide = true
                                            sendInviteHud.hide(true, afterDelay: 1)
                                            print(2222222)
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
                print(self.myInvitedList.data.count)
                return self.myInvitedList.data.count
            }else{
                return self.dataSource.count
            }
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView.tag == 1 {
            let cell1 = UITableViewCell()
            //            print(employmentdataSource)
            //            let jobModel = employmentdataSource[0]as! JobModel
            let jobModel = currentJobModel
            
            print(jobModel!.title)
            cell1.selectionStyle = .None
            cell1.textLabel?.numberOfLines = 0
//            strId = jobModel!.id
//            print(jobModel.id)
            print(indexPath.row)
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
                timeImage.frame = CGRectMake(55, 10, 8, 8)
                let timeLabel = UILabel(frame: CGRectMake(65,10,100,10))
                timeLabel.font = UIFont.systemFontOfSize(10)
                timeLabel.text = "2016/03/16"
                
//                cell1.addSubview(eyeImage)
//                cell1.addSubview(lookCount)
//                cell1.addSubview(timeImage)
//                cell1.addSubview(timeLabel)
                
            }else if indexPath.row == 2 {
                let nameLabel = UILabel(frame: CGRectMake(10,10,100,25))
                nameLabel.font = UIFont.boldSystemFontOfSize(15)
                nameLabel.text = "企业名称:"
                let name = UILabel(frame: CGRectMake(120,10,200,25))
                name.font = UIFont.systemFontOfSize(14)
                name.text = jobModel!.companyname
                cell1.addSubview(nameLabel)
                cell1.addSubview(name)
            }else if indexPath.row == 3 {
                let descript = UILabel(frame: CGRectMake(10,10,WIDTH-20,50))
                descript.font = UIFont.boldSystemFontOfSize(15)
                descript.numberOfLines = 0
                let descripStr = "企业简介:" + jobModel!.title
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
                name.frame = CGRectMake(100, 10, 100, 25)
                name.setTitleColor(COLOR, forState: .Normal)
                name.titleLabel!.font = UIFont.systemFontOfSize(14)
                if num == 1 {
                    name.setTitle("查看联系方式", forState: .Normal)
                    name.addTarget(self, action: #selector(contactClick), forControlEvents: .TouchUpInside)
                }else if num == 2{
                    name.setTitle(jobModel!.phone, forState: .Normal)
                    
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
            
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.labelText = "正在获取面试邀请"
            hud.margin = 10.0
            hud.removeFromSuperViewOnHide = true
            
            let url = PARK_URL_Header+"UserGetInvite"
            // TODO: userid 待更新
            let param = ["userid":QCLoginUserInfo.currentInfo.userid]
            Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
                if(error != nil){
                    
                }else{
                    let status = InvitedModel(JSONDecoder(json!))
                    print("状态是")
                    print(status.status)
                    if(status.status == "error"){
//                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = status.errorData
//                        hud.margin = 10.0
//                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                    }
                    if(status.status == "success"){
                        print(status)
                        self.myInvitedList = InvitedList(status.data!)
                        self.myTableView.reloadData()
                        print(status.data)
                        hud.hide(true, afterDelay: 1)
                    }
                }
                self.myTableView.mj_header.endRefreshing()
            }
        }else{
            
            let url = PARK_URL_Header+"getMyReciveResumeList"
            // TODO: userid 待更新
            let param = ["userid":QCLoginUserInfo.currentInfo.userid]
            Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
                if(error != nil){
                    
                }else{
                    let status = HSCVListModel(JSONDecoder(json!))
                    print("状态是")
                    print(status.status)
                    if(status.status == "error"){
                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        //hud.labelText = status.errorData
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                    }
                    if(status.status == "success"){
                        print(status)
                        self.dataSource = status.datas
                        self.myTableView .reloadData()
                        print(status.datas)
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
            
            print(indexPath.row)
            let model = self.dataSource[indexPath.row]
            self.name = model.name
            self.sex = model.sex
            self.avatar = model.avatar
            self.birthday = model.birthday
            self.address = model.address
            self.education = model.education
            self.certificate = model.certificate
            self.currentsalary = model.currentsalary
            self.count = model.count
            self.descrip = model.description
            self.linkman = model.linkman
            self.phone = model.phone
            self.experience = model.experience
            self.wantposition = model.wantposition
            self.tit = model.title
            self.jobstate = model.jobstate
            self.ema = model.email
            self.hiredate = model.hiredate
            self.wantcity = model.wantcity
            self.wantsalary = model.wantsalary
            superViewController?.showRightBtn()
            
            //        self.makeCVMessage()
            resumeDetail.frame = CGRectMake(0, 0.5, WIDTH, HEIGHT-107.5)
            resumeDetail.delegate = self
            resumeDetail.model = model
            self.view.addSubview(resumeDetail)
        }
    }
    
    func makeEmploymentMessage() {
        
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
        
//        // MARK:要求登录
//        if !requiredLogin(self.navigationController!, hasBackItem: true) {
//            return
//        }
        
//        jobHelper.getResumeInfo(QCLoginUserInfo.currentInfo.userid) { (success, response) in
//            if success {
//                print("投递简历")
//                let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("你确定要投递该职位吗？", comment: "empty message"), preferredStyle: .Alert)
//                self.presentViewController(alertController, animated: true, completion: nil)
//                
//                let doneAction = UIAlertAction(title: "确定", style: .Cancel, handler: { (doneAction) in
//                    let url = PARK_URL_Header+"ApplyJob"
//                    let param = [
//                        "userid":QCLoginUserInfo.currentInfo.userid,
//                        "jobid":self.jobDataSource![btn.tag].id,
//                        "companyid":self.jobDataSource![btn.tag].companyid
//                    ]
//                    Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
//                        print(request)
//                        if(error != nil){
//                            
//                        }else{
//                            let result = Http(JSONDecoder(json!))
//                            if(result.status == "success"){
//                                //  菊花加载
//                                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                                hud.mode = MBProgressHUDMode.Text;
//                                hud.labelText = "投递简历成功"
//                                hud.margin = 10.0
//                                hud.removeFromSuperViewOnHide = true
//                                hud.hide(true, afterDelay: 1)
//                                print(111111)
//                            }else{
//                                //  菊花加载
//                                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                                hud.mode = MBProgressHUDMode.Text;
//                                hud.labelText = "投递简历失败"
//                                hud.margin = 10.0
//                                hud.removeFromSuperViewOnHide = true
//                                hud.hide(true, afterDelay: 1)
//                                print(2222222)
//                            }
//                        }
//                    }
//                    
//                    
//                })
//                alertController.addAction(doneAction)
//                
//                let cancelAction = UIAlertAction(title: "取消", style: .Default, handler: { (cancelAction) in
//                    return
//                })
//                alertController.addAction(cancelAction)
//                
//                
//            }else{
        
//                dispatch_async(dispatch_get_main_queue(), {
        
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
