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
    let resumeDetail = Bundle.main.loadNibNamed("HSFindPersonDetailView", owner: nil, options: nil)?.first as! HSFindPersonDetailView
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
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        resumeDetail.delegate = self
        
        let line = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)

        self.view.backgroundColor = UIColor.white
        
        myTableView.frame = CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-115)
        myTableView.backgroundColor = UIColor.clear
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .none
        myTableView.register(MineRecruitTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(myTableView)
        myTableView.rowHeight = 72
        
        myTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(GetDate))
        myTableView.mj_header.beginRefreshing()
        
        employmentMessageTableView.register(UITableViewCell.self, forCellReuseIdentifier: "employmentMessage")
        employmentMessageTableView.delegate = self
        employmentMessageTableView.dataSource = self
        employmentMessageTableView.tag = 1
        employmentMessageTableView.separatorStyle = .none
        
        //        self.GetDate()
        
        // Do any additional setup after loading the view.
    }
    
    func lookContectBtnClick(_ lookContectBtn: UIButton, phoneNumber: UILabel, email: UILabel) {
        HSMineHelper().getCompanyCertify({ (success, response) in
            if success {
                
                let companyInfo = response as! CompanyInfo
                
                if companyInfo.status == "1" {
                    lookContectBtn.isHidden = true
                    phoneNumber.isHidden = false
                    email.isHidden = false
                }else{
                    
                    let alertController = UIAlertController(title: NSLocalizedString("您尚未通过企业认证，不能查看个人联系方式", comment: "Warn"), message: NSLocalizedString("请先到 我的招聘-企业认证 中 认证", comment: "empty message"), preferredStyle: .alert)
                    self.present(alertController, animated: true, completion: nil)
                    
                    let cancelAction = UIAlertAction(title: "好的", style: .cancel, handler: { (action) in
                        return
                    })
                    alertController.addAction(cancelAction)
                }
                return
            }else{
                let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("获取企业认证状态失败，请稍后再试", comment: "empty message"), preferredStyle: .alert)
                self.present(alertController, animated: true, completion: nil)
                
                let cancelAction = UIAlertAction(title: "好的", style: .cancel, handler: { (action) in
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 1 {
            let cell1 = UITableViewCell()
            //            // print(employmentdataSource)
            //            let jobModel = employmentdataSource[0]as! JobModel
            let jobModel = currentJobModel
            
            // print(jobModel!.title)
            cell1.selectionStyle = .none
            cell1.textLabel?.numberOfLines = 0
            //            strId = jobModel!.id
            //            // print(jobModel.id)
            // print(indexPath.row)
            if indexPath.row==0 {
                let title = UILabel()
                let height = calculateHeight(jobModel!.title, size: 18, width: WIDTH-20)
                title.frame = CGRect(x: 10, y: 10, width: WIDTH-20, height: height)
                title.text = jobModel!.title
                title.font = UIFont.systemFont(ofSize: 20)
                title.textColor = COLOR
                title.numberOfLines = 0
                cell1.addSubview(title)
            }else if indexPath.row == 1 {
                let eyeImage = UIImageView(image: UIImage(named: "ic_eye_purple.png"))
                eyeImage.frame = CGRect(x: 10,y: 10,width: 13,height: 9)
                let lookCount = UILabel(frame: CGRect(x: 20,y: 10,width: 30,height: 10))
                lookCount.font = UIFont.systemFont(ofSize: 10)
                lookCount.text = "3346"
                let timeImage = UIImageView(image: UIImage(named: "ic_time_purple.png"))
                timeImage.frame = CGRect(x: 10, y: 10, width: 8, height: 8)
                let timeLabel = UILabel(frame: CGRect(x: timeImage.frame.maxX+5,y: 10,width: 100,height: 10))
                timeLabel.font = UIFont.systemFont(ofSize: 10)
                timeLabel.text = self.timeStampToString(jobModel!.create_time)
                
                //                cell1.addSubview(eyeImage)
                //                cell1.addSubview(lookCount)
                cell1.addSubview(timeImage)
                cell1.addSubview(timeLabel)
                
            }else if indexPath.row == 2 {
                let nameLabel = UILabel(frame: CGRect(x: 10,y: 10,width: 100,height: 25))
                nameLabel.font = UIFont.boldSystemFont(ofSize: 15)
                nameLabel.text = "企业名称:"
                nameLabel.sizeToFit()
                let name = UILabel(frame: CGRect(x: nameLabel.frame.maxX+8,y: 10,width: 200,height: 25))
                name.font = UIFont.systemFont(ofSize: 14)
                name.text = jobModel!.companyname
                name.sizeToFit()
                name.center.y = nameLabel.center.y
                
                cell1.addSubview(nameLabel)
                cell1.addSubview(name)
            }else if indexPath.row == 3 {
                let descript = UILabel(frame: CGRect(x: 10,y: 10,width: WIDTH-20,height: 50))
                descript.font = UIFont.boldSystemFont(ofSize: 15)
                descript.numberOfLines = 0
                let descripStr = "企业简介: " + jobModel!.companyinfo
                let attrStr = NSMutableAttributedString(string: descripStr)
                attrStr.addAttributes([NSFontAttributeName:UIFont.boldSystemFont(ofSize: 15)], range: NSMakeRange(0, 5))
                attrStr.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 14)], range: NSMakeRange(5, attrStr.length-5))
                attrStr.addAttributes([NSForegroundColorAttributeName:UIColor.lightGray], range: NSMakeRange(5, attrStr.length-5))
                descript.attributedText = attrStr
                cell1.addSubview(descript)
            }else if indexPath.row == 4 {
                let criteria = UILabel(frame: CGRect(x: 10,y: 10,width: 70,height: 25))
                criteria.font = UIFont.boldSystemFont(ofSize: 15)
                criteria.text = "招聘条件:"
                let criteriaLabel = UILabel(frame: CGRect(x: 80,y: 10,width: 75,height: 25))
                criteriaLabel.font = UIFont.systemFont(ofSize: 14)
                criteriaLabel.text = jobModel!.education
                let address = UILabel(frame: CGRect(x: 170,y: 10,width: 70,height: 25))
                address.font = UIFont.boldSystemFont(ofSize: 15)
                address.text = "工作地点:"
                let addressLabel = UILabel(frame: CGRect(x: 240,y: 10,width: WIDTH-240,height: 25))
                addressLabel.font = UIFont.systemFont(ofSize: 14)
                addressLabel.adjustsFontSizeToFitWidth = true
                addressLabel.text = jobModel!.address
                cell1.addSubview(criteria)
                cell1.addSubview(criteriaLabel)
                cell1.addSubview(address)
                cell1.addSubview(addressLabel)
            }else if indexPath.row == 5{
                let criteria = UILabel(frame: CGRect(x: 10,y: 10,width: 70,height: 25))
                criteria.font = UIFont.boldSystemFont(ofSize: 15)
                criteria.text = "招聘人数:"
                let criteriaLabel = UILabel(frame: CGRect(x: 80,y: 10,width: 75,height: 25))
                criteriaLabel.font = UIFont.systemFont(ofSize: 14)
                criteriaLabel.text = jobModel!.count
                let address = UILabel(frame: CGRect(x: 170,y: 10,width: 70,height: 25))
                address.font = UIFont.boldSystemFont(ofSize: 15)
                address.text = "福利待遇:"
                let addressLabel = UILabel(frame: CGRect(x: 240,y: 10,width: WIDTH-240,height: 25))
                addressLabel.font = UIFont.systemFont(ofSize: 14)
                addressLabel.text = jobModel!.welfare
                cell1.addSubview(criteria)
                cell1.addSubview(criteriaLabel)
                cell1.addSubview(address)
                cell1.addSubview(addressLabel)
            }else if indexPath.row == 6 {
                let positionDescript = UILabel(frame: CGRect(x: 10,y: 10,width: 100,height: 25))
                positionDescript.font = UIFont.boldSystemFont(ofSize: 15)
                positionDescript.text = "职位描述:"
                let descripDetail = UILabel(frame: CGRect(x: 10,y: 40,width: WIDTH-20,height: 200))
                descripDetail.font = UIFont.systemFont(ofSize: 14)
                descripDetail.textColor = UIColor.lightGray
                descripDetail.numberOfLines = 0
                descripDetail.text = jobModel!.description
                cell1.addSubview(positionDescript)
                cell1.addSubview(descripDetail)
            }else if indexPath.row == 7 {
                let nameLabel = UILabel(frame: CGRect(x: 10,y: 10,width: 80,height: 25))
                nameLabel.font = UIFont.boldSystemFont(ofSize: 15)
                nameLabel.text = "联系方式:"
                
                let name = UIButton(type: UIButtonType.custom)
                name.frame = CGRect(x: 100, y: 10, width: WIDTH-80-10-10, height: 25)
                name.setTitleColor(COLOR, for: UIControlState())
                name.titleLabel!.font = UIFont.systemFont(ofSize: 14)
                if num == 1 {
                    name.setTitle("查看联系方式", for: UIControlState())
                    name.sizeToFit()
                    name.addTarget(self, action: #selector(contactClick), for: .touchUpInside)
                }else if num == 2{
                    name.setTitle(jobModel!.phone, for: UIControlState())
                    name.sizeToFit()
                }
                cell1.addSubview(nameLabel)
                cell1.addSubview(name)
            }
            return cell1
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as!MineRecruitTableViewCell
            cell.selectionStyle = .none
            
            
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
            NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in

//            Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
                if(error != nil){
                    
                }else{
                    let status = InvitedModel(JSONDecoder(json!))
                    // print("状态是")
                    // print(status.status)
                    if(status.status == "error"){
                        //                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        if status.errorData == nil {
                            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                            hud.mode = .text
                            hud.label.text = "抱歉，您还没有收到面试邀请"
                            hud.margin = 10.0
                            hud.removeFromSuperViewOnHide = true
                            hud.hide(animated: true, afterDelay: 1)
                        }else{
                            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                            hud.mode = .text
                            hud.label.text = status.errorData
                            hud.margin = 10.0
                            hud.removeFromSuperViewOnHide = true
                            hud.hide(animated: true)
                            //                        hud.margin = 10.0
                            //                        hud.removeFromSuperViewOnHide = true
                            hud.hide(animated: true, afterDelay: 1)
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
            NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in

//            Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
                if(error != nil){
                    
                }else{
                    let status = HSCVListModel(JSONDecoder(json!))
                    // print("状态是")
                    // print(status.status)
                    if(status.status == "error"){
                        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                        hud.mode = MBProgressHUDMode.text;
                        //hud.label.text = status.errorData
                        if status.datas.count == 0 {
                            hud.label.text = "您还没有收到简历"
                            self.myTableView .reloadData()
                        }
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(animated: true, afterDelay: 1)
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
        resumeDetail.frame = CGRect(x: 0, y: 0.5, width: WIDTH, height: HEIGHT-154.5)
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
        
        
        employmentMessage.frame = CGRect(x: 0, y: 0.5, width: WIDTH, height: HEIGHT-0.5)
        employmentMessage.backgroundColor = UIColor.white
        self.view.addSubview(employmentMessage)
        
        self.employmentMessageTableView.frame = CGRect(x: 0, y: 0, width: employmentMessage.frame.size.width,height: employmentMessage.frame.size.height - WIDTH*65/375-64-49)
        //        self.employmentMessageTableView.backgroundColor = UIColor.redColor()
        
        let tackBtn = UIButton(frame: CGRect(x: WIDTH-WIDTH*130/375-WIDTH*15/375, y: self.employmentMessageTableView.frame.origin.y+self.employmentMessageTableView.frame.size.height+WIDTH*10/375, width: WIDTH*130/375, height: WIDTH*45/375))
        tackBtn.layer.cornerRadius = WIDTH*22.5/375
        tackBtn.layer.borderColor = COLOR.cgColor
        tackBtn.layer.borderWidth = 1
        tackBtn.setTitle("返回", for: UIControlState())
        tackBtn.setTitleColor(COLOR, for: UIControlState())
        tackBtn.addTarget(self, action: #selector(self.takeResume), for: .touchUpInside)
        employmentMessage.addSubview(tackBtn)
        
        let tack = UIButton(frame: CGRect(x: WIDTH*15/375, y: self.employmentMessageTableView.frame.origin.y+self.employmentMessageTableView.frame.size.height+WIDTH*10/375, width: WIDTH*130/375, height: WIDTH*45/375))
        tack.layer.cornerRadius = WIDTH*22.5/375
        tack.layer.borderColor = COLOR.cgColor
        tack.layer.borderWidth = 1
        tack.setTitle("投递简历", for: UIControlState())
        tack.setTitleColor(COLOR, for: UIControlState())
        tack.addTarget(self, action: #selector(self.resumeOnline(_:)), for: .touchUpInside)
        employmentMessage.addSubview(tack)
        
        employmentMessage.addSubview(employmentMessageTableView)
        
        
    }
    
    
    func makeEmploymentMessage() {
        let line = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.white
        
        let jobModel = currentJobModel
        
        //        strId = jobModel!.id
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        let rootScrollView = UIScrollView(frame: CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-64-1-44-WIDTH*59/375))
        rootScrollView.backgroundColor = UIColor.white
        rootScrollView.tag = 1001
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
        timeImage.frame = CGRect(x: 10, y: title.frame.maxY+10, width: 8, height: 8)
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
        
        let salaryTagLab = UILabel(frame: CGRect(x: 170,y: descript.frame.maxY+10,width: 70,height: 25))
        salaryTagLab.font = UIFont.boldSystemFont(ofSize: 15)
        salaryTagLab.text = "薪资待遇:"
        salaryTagLab.sizeToFit()
        rootScrollView.addSubview(salaryTagLab)
        
        let salaryLab = UILabel(frame: CGRect(x: salaryTagLab.frame.maxX+8,y: descript.frame.maxY+10,width: WIDTH-240,height: 25))
        salaryLab.font = UIFont.systemFont(ofSize: 14)
        salaryLab.textColor = UIColor.lightGray
        salaryLab.text = currentJobModel!.salary
        salaryLab.sizeToFit()
        rootScrollView.addSubview(salaryLab)
        
        
        
        let personalNumTagLab = UILabel(frame: CGRect(x: 10,y: salaryLab.frame.maxY+10,width: 70,height: 25))
        personalNumTagLab.font = UIFont.boldSystemFont(ofSize: 15)
        personalNumTagLab.text = "招聘人数:"
        personalNumTagLab.sizeToFit()
        rootScrollView.addSubview(personalNumTagLab)
        
        let personalNumLab = UILabel(frame: CGRect(x: personalNumTagLab.frame.maxX+8,y: salaryLab.frame.maxY+10,width: 75,height: 25))
        personalNumLab.font = UIFont.systemFont(ofSize: 14)
        personalNumLab.textColor = UIColor.lightGray
        personalNumLab.text = jobModel!.count
        personalNumLab.sizeToFit()
        rootScrollView.addSubview(personalNumLab)
        
        let welfareTagLab = UILabel(frame: CGRect(x: 170,y: salaryLab.frame.maxY+10,width: 70,height: 25))
        welfareTagLab.font = UIFont.boldSystemFont(ofSize: 15)
        welfareTagLab.text = "福利待遇:"
        welfareTagLab.sizeToFit()
        rootScrollView.addSubview(welfareTagLab)
        
        let welfareLab = UILabel(frame: CGRect(x: welfareTagLab.frame.maxX+8,y: salaryLab.frame.maxY+10,width: WIDTH-240,height: 25))
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
        
        let contactTelBtn = UIButton()
        contactTelBtn.frame = CGRect(x: contactTagLab.frame.maxX+8, y: contactNameLab.frame.maxY+8, width: 10, height: 25)
        contactTelBtn.setTitleColor(COLOR, for: UIControlState())
        contactTelBtn.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        //        if !canLookTel {
        //            contactTelBtn.setTitle("查看联系方式", forState: .Normal)
        //            contactTelBtn.addTarget(self, action: #selector(contactClick), forControlEvents: .TouchUpInside)
        //        }else {
        contactTelBtn.setTitle(jobModel!.phone, for: UIControlState())
        //        }
        contactTelBtn.sizeToFit()
        //        contactTelBtn.center.y = contactNameLab.center.y
        rootScrollView.addSubview(contactTelBtn)
        
        rootScrollView.contentSize = CGSize(width: 0, height: contactTelBtn.frame.maxY+10)
        
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
        
        let tack = UIButton(frame: CGRect(
            x: WIDTH*35/375,
            y: rootScrollView.frame.maxY+WIDTH*2/375,
            width: WIDTH*180/375,
            height: WIDTH*45/375))
        tack.tag = 1001
        tack.layer.cornerRadius = WIDTH*22.5/375
        tack.layer.borderColor = COLOR.cgColor
        tack.layer.borderWidth = 1
        tack.setTitle("投递简历", for: UIControlState())
        tack.setTitleColor(COLOR, for: UIControlState())
        tack.addTarget(self, action: #selector(self.resumeOnline(_:)), for: .touchUpInside)
        self.view.addSubview(tack)
        
        let tackBtn = UIButton(frame: CGRect(
            x: WIDTH*250/375,
            y: rootScrollView.frame.maxY+WIDTH*2/375,
            width: WIDTH*90/375,
            height: WIDTH*45/375))
        tackBtn.tag = 1001
        tackBtn.layer.cornerRadius = WIDTH*22.5/375
        tackBtn.layer.borderColor = COLOR.cgColor
        tackBtn.layer.borderWidth = 1
        tackBtn.setTitle("返回", for: UIControlState())
        tackBtn.setTitleColor(COLOR, for: UIControlState())
        tackBtn.addTarget(self, action: #selector(self.backBtnClick), for: .touchUpInside)
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
        UIView.animate(withDuration: 0.2, animations: {
            self.employmentMessage.frame = CGRect(x: WIDTH, y: 0.5, width: WIDTH, height: HEIGHT-154.5)
        }) 
        //        self.employmentdataSource.removeAllObjects()
        self.employmentMessageTableView.reloadData()
        self.employmentMessage.removeFromSuperview()
    }
    
    // MARK:投递简历
    func resumeOnline(_ btn:UIButton) {
        
        let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("您已投递该简历，不需要重复投递", comment: "empty message"), preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        //                    let doneAction = UIAlertAction(title: "现在就去", style: .Default, handler: { (action) in
        //                        self.postedTheView()
        //                    })
        //                    alertController.addAction(doneAction)
        
        let cancelAction = UIAlertAction(title: "好的", style: .cancel, handler: { (action) in
            
        })
        alertController.addAction(cancelAction)
        //                })
        //            }
        //        }
        
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
