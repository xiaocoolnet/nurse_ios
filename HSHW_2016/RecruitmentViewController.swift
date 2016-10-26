//
//  RecruitmentViewController.swift
//  HSHW_2016
//  Created by apple on 16/5/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class RecruitmentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,PostVacanciesDelegate,HSPostResumeViewDelegate {
    
    let myTableView = UITableView()
    let scrollView = UIScrollView()
    let pageControl = SMPageControl()
    var imageArr = Array<NewsInfo>()
    var timer = NSTimer()
    var times = Int()
    let employment = UIView()
    let employmentMessage = UIView()
    let resumeDetail = NSBundle.mainBundle().loadNibNamed("HSFindPersonDetailView", owner: nil, options: nil).first as! HSFindPersonDetailView
    let sendPostion = NSBundle.mainBundle().loadNibNamed("PostVacancies", owner: nil, options: nil).first as! PostVacancies
    let sendResume = NSBundle.mainBundle().loadNibNamed("HSPostResumeView", owner: nil, options: nil).first as! HSPostResumeView
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
    
    var tit = NSString()
    var count = NSString()
    var linkman = NSString()
    
    
    weak var superViewController:NurseStationViewController?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        if showType == 1 {
            self.setSlideView()
            
        }
        makeDataSource()
        sendPostion.delegate = self
        sendResume.delegate = self
        
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
        pageControl.frame = CGRectMake(WIDTH-8-pageControl.rectForPageIndicator(0).width*CGFloat(self.imageArr.count)-6*CGFloat(self.imageArr.count-1), WIDTH*190/375-25, pageControl.rectForPageIndicator(0).width*CGFloat(self.imageArr.count)+6*CGFloat(self.imageArr.count-1), 25)
        pageControl.indicatorMargin = 6
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
                    // print(response)
                    let imageArr = response as! Array<NewsInfo>
                    self.imageArr = imageArr.count>=5 ? Array(imageArr[0...slideImageListMaxNum-1]):imageArr
                    
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 160
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if showType == 1 {
            return jobDataSource?.count ?? 0
        }else{
            return CVDataSource?.count ?? 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
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
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // print(indexPath.row)
        if tableView.tag == 0 {
            if showType == 1 {
                self.currentJobModel = self.jobDataSource![indexPath.row]
                
                let RecruitmentDetailVC = NSRecruitmentDetailViewController()
                RecruitmentDetailVC.currentJobModel = self.jobDataSource![indexPath.row]
                RecruitmentDetailVC.jobDataSource = self.jobDataSource
                self.navigationController?.pushViewController(RecruitmentDetailVC, animated: true)
            }else {
                
                let cvVC = NSPersonalInfoDetailViewController()
                cvVC.cvModel = self.CVDataSource![indexPath.row]
                self.navigationController?.pushViewController(cvVC, animated: true)
            }
        }
    }
    
    // MARK:邀请面试
    func invited(btn:UIButton) {
        inviteJob(self.CVDataSource![btn.tag])
    }
    
    func inviteJob(model:CVModel) {
        // print("邀请面试")
        
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
                    // print("状态是")
                    // print(status.status)
                    if(status.status == "error"){
                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
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
                                    "jobid":job.id,
                                    "companyid":QCLoginUserInfo.currentInfo.userid
                                ]
                                Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
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
        // print("招聘")
        
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
        UIView.animateWithDuration(0.3) {
            self.employment.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT-154.5)
        }
    }
    
    func takeTheResume() {
        
        let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("你确定要投递该职位吗？", comment: "empty message"), preferredStyle: .Alert)
        self.presentViewController(alertController, animated: true, completion: nil)
        
        let doneAction = UIAlertAction(title: "确定", style: .Cancel, handler: { (doneAction) in
            
            let model = self.currentJobModel
            let url = PARK_URL_Header+"ApplyJob"
            let param = [
                "userid":QCLoginUserInfo.currentInfo.userid,
                "jobid":model!.id,
                "companyid" :model!.companyid
            ]
            Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
                // print(request)
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
                        // print(111111)
                    }else{
                        //  菊花加载
                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = "投递简历失败"
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
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
        // print("这是第\(Int(imageView.tag))张图片")
        
        let next = NewsContantViewController()
        next.newsInfo = imageArr[imageView.tag-1]
        //        next.navTitle = imageArr[imageView.tag-1].term_name
        
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
}
