//
//  RecruitmentViewController.swift
//  HSHW_2016
//  Created by apple on 16/5/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class RecruitmentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,HSFindPersonDetailViewDelegate,PostVacanciesDelegate,HSPostResumeViewDelegate {

    let myTableView = UITableView()
    let employmentMessageTableView = UITableView()
    let scrollView = UIScrollView()
    let pageControl = UIPageControl()
//    var picArr = Array<String>()
//    var titArr = Array<String>()
    var imageArr = Array<NewsInfo>()
    var timer = NSTimer()
    var times = Int()
    let employment = UIView()
    let employmentMessage = UIView()
    let resumeDetail = NSBundle.mainBundle().loadNibNamed("HSFindPersonDetailView", owner: nil, options: nil).first as! HSFindPersonDetailView
    let sendPostion = NSBundle.mainBundle().loadNibNamed("PostVacancies", owner: nil, options: nil).first as! PostVacancies
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
    var pho = NSString()
    var hiredate = NSString()
    var wantcity = NSString()
    
    
    weak var superViewController:NurseStationViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        if showType == 1 {
            self.setSlideView()

        }
        makeDataSource()
        sendPostion.delegate = self
        sendResume.delegate = self
        employmentMessageTableView.separatorStyle = .None
        resumeDetail.delegate = self
        

        self.makeEmployment()
        self.view.backgroundColor = COLOR

    }
    
    
    func updateSlideImage(){
        
        for subView in self.scrollView.subviews {
            if subView.isKindOfClass(UIImageView) {
                subView.removeFromSuperview()
            }
        }
        
        for (i,slideImage) in self.imageArr.enumerate() {
            
            let  imageView = UIImageView()
            imageView.frame = CGRectMake(CGFloat(i)*WIDTH, 0, WIDTH, WIDTH*190/375)
            imageView.tag = i+1
            if  (!(NetworkReachabilityManager()?.isReachableOnEthernetOrWiFi)! && loadPictureOnlyWiFi) || slideImage.thumbArr.count == 0 {
                imageView.image = UIImage.init(named: "defaultImage.png")
            }else{
                imageView.sd_setImageWithURL(NSURL(string: DomainName+"data/upload/"+(slideImage.thumbArr.first?.url)!), placeholderImage: UIImage.init(named: "defaultImage.png"))
            }
            
            let bottom = UIView(frame: CGRectMake(0, WIDTH*190/375-25, WIDTH, 25))
            bottom.backgroundColor = UIColor.grayColor()
            bottom.alpha = 0.5
            imageView.addSubview(bottom)
            
            let titLab = UILabel(frame: CGRectMake(10, WIDTH*190/375-25, WIDTH-100, 25))
            titLab.font = UIFont.systemFontOfSize(14)
            titLab.textColor = UIColor.whiteColor()
            titLab.text = slideImage.post_title
            titLab.tag = i+1
            imageView.addSubview(titLab)
            
            //为图片视图添加点击事件
            imageView.userInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
            //            手指头
            tap.numberOfTapsRequired = 1
            //            单击
            tap.numberOfTouchesRequired = 1
            imageView.addGestureRecognizer(tap)
            self.scrollView.addSubview(imageView)
        }
        
        scrollView.contentSize = CGSizeMake(CGFloat(self.imageArr.count)*WIDTH, 0)
        scrollView.contentOffset = CGPointMake(0, 0)
        
        pageControl.numberOfPages = self.imageArr.count
        pageControl.frame = CGRectMake(WIDTH-20*CGFloat(imageArr.count), WIDTH*190/375-25, 20*CGFloat(imageArr.count), 25)
        pageControl.currentPage = 0        
    }
    
    func makeDataSource(){
        if showType == 1 {
            
            var flag = 0
            
            jobHelper.getJobList({[unowned self] (success, response) in
                if success {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.jobDataSource = response as? Array<JobModel> ?? []
                        self.myTableView.reloadData()
                        
                    })
                    
                    flag += 1
                    if flag == 2 {
                        self.myTableView.mj_header.endRefreshing()
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue(), {
                        self.myTableView.mj_header.endRefreshing()
                        
                        if String(response!) == "no data" {
                            self.jobDataSource = Array<JobModel>()
                            self.myTableView.reloadData()
                        }else{
                            
                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                            hud.mode = MBProgressHUDMode.Text;
                            hud.labelText = "获取招聘信息失败"
                            hud.detailsLabelText = String(response!)
                            hud.margin = 10.0
                            hud.removeFromSuperViewOnHide = true
                            hud.hide(true, afterDelay: 1)
                        }
                        
                    })
                }
            })
            
            HSNurseStationHelper().getArticleListWithID("121") { (success, response) in
                
                if success {
                    print(response)
                    self.imageArr = response as! Array<NewsInfo>
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.updateSlideImage()
                        self.myTableView.reloadData()
                    })
                    
                    flag += 1
                    if flag == 2 {
                        self.myTableView.mj_header.endRefreshing()
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue(), {
                        self.myTableView.mj_header.endRefreshing()
                        
                        if String(response!) == "no data" {
                            self.imageArr = Array<NewsInfo>()
                            self.updateSlideImage()
                            self.myTableView.reloadData()
                        }else{
                            
                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                            hud.mode = MBProgressHUDMode.Text;
                            hud.labelText = "轮播图获取失败"
                            hud.detailsLabelText = String(response!)
                            hud.margin = 10.0
                            hud.removeFromSuperViewOnHide = true
                            hud.hide(true, afterDelay: 1)
                        }
                        
                    })
                }
            }
        } else if showType == 2 {
            jobHelper.getCVList({[unowned self] (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if !success {
                        return
                    }
                    self.CVDataSource = response as? Array<CVModel> ?? []
                    self.myTableView.reloadData()
//                    self.configureUI()
                })
                self.myTableView.mj_header.endRefreshing()
            })
        }
    }
    
    func configureUI(){
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.whiteColor()
//        myTableView.frame = CGRectMake(0, 0.5, WIDTH, HEIGHT-154.5)
        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-110)
        myTableView.backgroundColor = UIColor.whiteColor()
        myTableView.tag = 0
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "identifier")
        myTableView.registerClass(RecruitTableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(makeDataSource))
        myTableView.mj_header.beginRefreshing()
        
        employmentMessageTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "employmentMessage")
        employmentMessageTableView.delegate = self
        employmentMessageTableView.dataSource = self
        employmentMessageTableView.tag = 1
        self.view.addSubview(myTableView)
        

        myTableView.rowHeight = 142
        
        let posted = UIButton()
        posted.frame = CGRectMake(WIDTH-70 , HEIGHT-230, 50, 50)
        posted.setImage(UIImage(named: "ic_edit.png"), forState: .Normal)
        posted.addTarget(self, action: #selector(RecruitmentViewController.postedTheView), forControlEvents: .TouchUpInside)
        self.view.addSubview(posted)
        posted.becomeFirstResponder()
    }
    
    func setSlideView() {
        let one = UIView(frame: CGRectMake(0, 1, WIDTH, WIDTH*190/375))
        self.view.addSubview(one)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(scroll), userInfo: nil, repeats: true)
        
        scrollView.frame = CGRectMake(0, 0,WIDTH, WIDTH*190/375)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        scrollView.tag = 1000
        
        scrollView.contentSize = CGSizeMake(4*WIDTH, 0)
        scrollView.contentOffset = CGPointMake(0, 0)
        one.addSubview(scrollView)
        
        pageControl.frame = CGRectMake(WIDTH-80, WIDTH*190/375-25, 80, 25)
        pageControl.pageIndicatorTintColor = UIColor.whiteColor()
        pageControl.currentPageIndicatorTintColor = COLOR
        pageControl.numberOfPages = self.imageArr.count
        pageControl.currentPage = 0
        one.addSubview(pageControl)
        
        myTableView.tableHeaderView = one
    }
    
//    发布招聘信息
    func makeEmployment() {
        employment.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT-154.5)
        employment.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(employment)
        
        let tackBtn = UIButton(frame: CGRectMake(WIDTH*15/375, employment.bounds.size.height-WIDTH*65/375, WIDTH*345/375, WIDTH*45/375))
        tackBtn.layer.cornerRadius = WIDTH*22.5/375
        tackBtn.layer.borderColor = COLOR.CGColor
        tackBtn.layer.borderWidth = 1
        tackBtn.setTitle("提交", forState: .Normal)
        tackBtn.setTitleColor(COLOR, forState: .Normal)
        tackBtn.addTarget(self, action: #selector(self.takeThePost), forControlEvents: .TouchUpInside)
        employment.addSubview(tackBtn)
    }
//  简历详情
    func lookResumeDetail(){
        resumeDetail.frame = CGRectMake(0, 0.5, WIDTH, HEIGHT-154.5)
        self.view.addSubview(resumeDetail)
    }
//  招聘信息详情
    func makeEmploymentMessage() {
        employmentMessage.frame = CGRectMake(0, 0.5, WIDTH, HEIGHT-64-49-0.5)
        employmentMessage.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(employmentMessage)
        self.employmentMessageTableView.frame = CGRectMake(0, 0, employmentMessage.frame.size.width,employmentMessage.frame.size.height - WIDTH*65/375)
//        employmentMessageTableView.tag = 1
//        employmentMessageTableView.backgroundColor = UIColor.redColor()
        let tackBtn = UIButton(frame: CGRectMake(WIDTH-WIDTH*130/375-WIDTH*15/375, self.employmentMessageTableView.frame.origin.y+self.employmentMessageTableView.frame.size.height+10, WIDTH*130/375, WIDTH*45/375))
        tackBtn.layer.cornerRadius = WIDTH*22.5/375
        tackBtn.layer.borderColor = COLOR.CGColor
        tackBtn.layer.borderWidth = 1
        tackBtn.setTitle("返回", forState: .Normal)
        tackBtn.setTitleColor(COLOR, forState: .Normal)
        tackBtn.addTarget(self, action: #selector(self.takeResume), forControlEvents: .TouchUpInside)
        employmentMessage.addSubview(tackBtn)
        
        let tack = UIButton(frame: CGRectMake(WIDTH*15/375, self.employmentMessageTableView.frame.origin.y+self.employmentMessageTableView.frame.size.height+10, WIDTH*130/375, WIDTH*45/375))
        tack.layer.cornerRadius = WIDTH*22.5/375
        tack.layer.borderColor = COLOR.CGColor
        tack.layer.borderWidth = 1
        tack.setTitle("投递简历", forState: .Normal)
        tack.setTitleColor(COLOR, forState: .Normal)
        tack.addTarget(self, action: #selector(self.resumeOnline(_:)), forControlEvents: .TouchUpInside)
        employmentMessage.addSubview(tack)
       
        employmentMessage.addSubview(employmentMessageTableView)
        
        
    }
    
    func makeCVMessage(model:CVModel){
        resumeDetail.frame = CGRectMake(0, 0.5, WIDTH, HEIGHT-64-49-0.5)
        resumeDetail.model = model
        resumeDetail.headerImg.sd_setImageWithURL(NSURL(string: SHOW_IMAGE_HEADER+model.avatar), placeholderImage: UIImage(named: "img_head_nor"))
        resumeDetail.showFor(birthday)
        resumeDetail.showSex(sex)
        resumeDetail.showName(name)
        resumeDetail.education(education)
        resumeDetail.address(address)
        resumeDetail.experience(experience)
        resumeDetail.jobName(certificate)
        resumeDetail.comeTime(hiredate)
        resumeDetail.expectSalary(wantsalary)
        resumeDetail.targetLocation(wantcity)
        resumeDetail.targetPosition(wantposition)
        resumeDetail.selfEvaluation(descrip)
        resumeDetail.phoneNumber(phone)
        resumeDetail.email(ema)
        resumeDetail.currentSalary(currentsalary)
        resumeDetail.jobState(jobstate)
        self.view.addSubview(resumeDetail)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        print("---")
        print(jobDataSource)
        print("---")
        if tableView.tag == 0 {
            return 170
        }else {
            if indexPath.row == 0 {
                let jobModel = jobDataSource![indexPath.row]
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
                let jobModel = jobDataSource![0]
                let height = calculateHeight(jobModel.description, size: 14, width: WIDTH-20)
                return 40+height
            }else if indexPath.row == 7 {
                return 35
            }
            else{
                return 100
            }
        }
     
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0{
            if showType == 1 {
                return jobDataSource?.count ?? 0
            }else{
                return CVDataSource?.count ?? 0
            }
        }else {
            return 8
        }
  
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let mycell = tableView.dequeueReusableCellWithIdentifier("identifier", forIndexPath: indexPath)
        
        if tableView.tag == 0 {
        
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)as!RecruitTableViewCell
            cell.selectionStyle = .None
            if showType == 1 {
                cell.showforJobModel(jobDataSource![indexPath.row])
                cell.delivery.tag = indexPath.row
                btnTag = cell.delivery.tag
                cell.delivery.addTarget(self, action: #selector(self.resumeOnline(_:)), forControlEvents: .TouchUpInside)
            }else{
                cell.showforCVModel(CVDataSource![indexPath.row])
                cell.delivery.tag = indexPath.row
                btnTag = cell.delivery.tag
                cell.delivery.addTarget(self, action: #selector(self.invited(_:)), forControlEvents: .TouchUpInside)
            }
            
            return cell
        }else{
            let cell1 = UITableViewCell()
//            print(employmentdataSource)
//            let jobModel = employmentdataSource[0]as! JobModel
            let jobModel = currentJobModel
            
            print(jobModel!.title)
            cell1.selectionStyle = .None
            cell1.textLabel?.numberOfLines = 0
            strId = jobModel!.id
            print(jobModel!.id)
            if showType == 1 {
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
                    eyeImage.frame = CGRectMake(10,10,8,8)
                    let lookCount = UILabel(frame: CGRectMake(20,10,30,10))
                    lookCount.font = UIFont.systemFontOfSize(10)
                    lookCount.text = "3346"
                    let timeImage = UIImageView(image: UIImage(named: "ic_time_purple.png"))
                    timeImage.frame = CGRectMake(55, 10, 8, 8)
                    let timeLabel = UILabel(frame: CGRectMake(65,10,100,10))
                    timeLabel.font = UIFont.systemFontOfSize(10)
                    timeLabel.text = "2016/03/16"
                    
                    cell1.addSubview(eyeImage)
                    cell1.addSubview(lookCount)
                    cell1.addSubview(timeImage)
                    cell1.addSubview(timeLabel)
                    
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
                    descripDetail.frame.size.height = calculateHeight((jobModel?.description)!, size: 14, width: WIDTH-20)
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
            }
            return cell1
        }
    }
    
    func contactClick() {
        num = 2
        self.employmentMessageTableView.reloadData()
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        if tableView.tag == 0 {
            if showType == 1 {
//                let model = self.jobDataSource![indexPath.row]
//                self.employmentdataSource.addObject(model)
                self.currentJobModel = self.jobDataSource![indexPath.row]
                print(jobDataSource)
                print(self.jobDataSource![indexPath.row].title)
//                print(self.employmentdataSource)
//                superViewController?.showRightBtn()
                self.makeEmploymentMessage()
            }else {
                let model = self.CVDataSource![indexPath.row]
                self.name = model.name
                self.sex = model.sex == "0" ? "女":"男"
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
//                superViewController?.showRightBtn()
                self.makeCVMessage(model)
            }
        }
    }
    
    // MARK:邀请面试
    func invited(btn:UIButton) {
        inviteJob(self.CVDataSource![btn.tag])
    }
    
    func inviteJob(model:CVModel) {
        print("邀请面试")
        
        // MARK:要求登录
        if !requiredLogin(self.navigationController!, previousViewController: self, hasBackItem: true) {
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
            
            let inviteHud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            inviteHud.labelText = "正在获取邀请状态"
            inviteHud.removeFromSuperViewOnHide = true
            inviteHud.margin = 10.0
            
            jobHelper.InviteJob_judge(model.userid, companyid: QCLoginUserInfo.currentInfo.userid, jobid: model.id) { (success, response) in
                
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
        }
        
    }
    
    // MARK: 投递简历
    func resumeOnline(btn:UIButton) {
        
        // MARK:要求登录
        if !requiredLogin(self.navigationController!, previousViewController: self, hasBackItem: true) {
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
                                
                                print("投递简历")
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
                                        print(request)
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
                                                print(111111)
                                            }else{
                                                //  菊花加载
                                                //                                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                                                applyJobHud.mode = MBProgressHUDMode.Text;
                                                applyJobHud.labelText = "投递简历失败"
                                                //                                            hud.margin = 10.0
                                                //                                            hud.removeFromSuperViewOnHide = true
                                                applyJobHud.hide(true, afterDelay: 1)
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
                                self.postedTheView()
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
    
    func postedTheView() {
        print("招聘")
        
        // MARK:要求登录
        if !requiredLogin(self.navigationController!, previousViewController: self, hasBackItem: true) {
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
    
    func rightBarButtonClicked() {
        if showType == 2 {
            UIView.animateWithDuration(0.2) {
                self.sendPostion.frame = CGRectMake(WIDTH, 0.5, WIDTH, HEIGHT-154.5)
            }
            self.sendPostion.removeFromSuperview()
            self.employmentMessage.removeFromSuperview()
            superViewController?.hiddenBtn()
        } else if showType == 1 {
            UIView.animateWithDuration(0.2) {
                self.sendResume.frame = CGRectMake(WIDTH, 0.5, WIDTH, HEIGHT-154.5)
            }
            self.sendResume.removeFromSuperview()
            self.resumeDetail.removeFromSuperview()
            superViewController?.hiddenBtn()
        }
    }
    //MARK:-----SendPositionDelegate-----
    func clickedSendBtn(){
        rightBarButtonClicked()
    }
    
    func takeThePost() {
        print("提交招聘信息")
        UIView.animateWithDuration(0.3) {
            self.employment.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT-154.5)
        }
    }
    
    func takeTheResume() {
        print("提交简历")
//        UIView.animateWithDuration(5) {
//            self.employmentMessage.frame = CGRectMake(WIDTH, 0.5, WIDTH, HEIGHT-154.5)
//        }
        
        let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("你确定要投递该职位吗？", comment: "empty message"), preferredStyle: .Alert)
        self.presentViewController(alertController, animated: true, completion: nil)
        
        let doneAction = UIAlertAction(title: "确定", style: .Cancel, handler: { (doneAction) in

//        print(self.employmentdataSource.count)
//            let model = self.employmentdataSource[0] as! JobModel
        let model = self.currentJobModel
            let url = PARK_URL_Header+"ApplyJob"
            let param = [
                "userid":QCLoginUserInfo.currentInfo.userid,
                "jobid":model!.id,
                "companyid" :model!.companyid
            ]
            Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
                print(request)
                if(error != nil){
                    //  菊花加载
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = "投递简历失败（error）"
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }else{
                    let result = Http(JSONDecoder(json!))
                    if(result.status == "success"){
                        //  菊花加载
                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = "投递简历成功"
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                        print(111111)
                    }else{
                        //  菊花加载
                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = "投递简历失败"
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                        print(2222222)
                    }
                }
            }
            
//            self.employmentdataSource.removeAllObjects()
            self.employmentMessageTableView.reloadData()
//            self.employmentMessage.removeFromSuperview()
//            self.superViewController?.hiddenBtn()
        })
        alertController.addAction(doneAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .Default, handler: { (cancelAction) in
            return
        })
        alertController.addAction(cancelAction)
    }
    
    func takeResume(){
        UIView.animateWithDuration(0.2) {
            self.employmentMessage.frame = CGRectMake(WIDTH, 0.5, WIDTH, HEIGHT-154.5)
        }
//        self.employmentdataSource.removeAllObjects()
        self.employmentMessageTableView.reloadData()
        self.employmentMessage.removeFromSuperview()
        superViewController?.hiddenBtn()
    }
    
    
    
    //MARK:delegate-find
    func sendInvite(model:CVModel){
        inviteJob(model)
    }
    func hiddenResumeDetail() {
        UIView.animateWithDuration(0.2) {
            self.resumeDetail.frame = CGRectMake(WIDTH, 0.5, WIDTH, HEIGHT-154.5)
        }
        self.resumeDetail.removeFromSuperview()
    }
    //MARK:delegate-find
    func uploadAvatar() -> UIImage{
        return UIImage()
    }
    func saveResumeBtnClicked(){
        rightBarButtonClicked()
    }

    // MARK:图片点击事件
    func tapAction(tap:UIGestureRecognizer) {
        var imageView = UIImageView()
        imageView = tap.view as! UIImageView
        print("这是第\(Int(imageView.tag))张图片")
        
        let next = NewsContantViewController()
        next.newsInfo = imageArr[imageView.tag-1]
        next.navTitle = imageArr[imageView.tag-1].term_name
        
        self.navigationController?.pushViewController(next, animated: true)
    }
    
//    func pageNext() {
//        scrollView.contentOffset = CGPointMake(WIDTH*CGFloat(pageControl.currentPage), 0)
//    }
    
    func scroll(){
        
        if self.pageControl.currentPage == self.pageControl.numberOfPages-1 {
            self.pageControl.currentPage = 0
        }else{
            self.pageControl.currentPage += 1
        }
        let offSetX:CGFloat = CGFloat(self.pageControl.currentPage) * CGFloat(self.scrollView.frame.size.width)
        scrollView.setContentOffset(CGPoint(x: offSetX,y: 0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView.tag == 1000 {
            pageControl.currentPage = Int(scrollView.contentOffset.x)/Int(WIDTH)
            //        timer.fireDate = NSDate.distantPast()
            timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(TouTiaoViewController.scroll), userInfo: nil, repeats: true)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.tag == 1000 {
            var offsetX:CGFloat = self.scrollView.contentOffset.x
            offsetX = offsetX + (self.scrollView.frame.size.width * 0.5)
            let page:Int = Int(offsetX)/Int(self.scrollView.frame.size.width)
            pageControl.currentPage = page
        }
    }
    //开始拖拽时
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        //            timer.fireDate = NSDate.distantFuture()
        if scrollView.tag == 1000 {
            timer.invalidate()
        }
    }
    
//    func scroll(){
//        if times == 4 {
//            pageControl.currentPage = 0
//        }else{
//            pageControl.currentPage = times
//        }
//        scrollView.setContentOffset(CGPointMake(WIDTH*CGFloat(times), 0), animated: true)
//        times += 1
//        //MARK:注释掉两条输出信息
////        print("招聘1")
//    }
//    
//    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
//        if times >= 5 {
//            scrollView.setContentOffset(CGPointMake(0, 0), animated: false)
//            times = 1
//        }
////        print("招聘2")
//    }
//    
//    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        var number = Int(scrollView.contentOffset.x/WIDTH)
//        if number == 4 {
//            number = 0
//            pageControl.currentPage = number
//        }else{
//            pageControl.currentPage = number
//        }
//        timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(scroll), userInfo: nil, repeats: true)
//
//    }
//    
//    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
//        //            timer.fireDate = NSDate.distantFuture()
//        timer.invalidate()
//    }
}
