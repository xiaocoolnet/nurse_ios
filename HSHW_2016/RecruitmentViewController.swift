//
//  RecruitmentViewController.swift
//  HSHW_2016
//  Created by apple on 16/5/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class RecruitmentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate, LFLUISegmentedControlDelegate {//PostVacanciesDelegate,HSPostResumeViewDelegate
    
    let myTableView = UITableView()
    let scrollView = UIScrollView()
    let pageControl = SMPageControl()
    var imageArr = Array<NewsInfo>()
    var timer = Timer()
    var times = Int()
    let employment = UIView()
    let employmentMessage = UIView()
    let resumeDetail = Bundle.main.loadNibNamed("HSFindPersonDetailView", owner: nil, options: nil)?.first as! HSFindPersonDetailView
    let sendPostion = Bundle.main.loadNibNamed("PostVacancies", owner: nil, options: nil)?.first as! PostVacancies
    let sendResume = Bundle.main.loadNibNamed("HSPostResumeView", owner: nil, options: nil)?.first as! HSPostResumeView
    var jobDataSource:Array<JobModel>?
    var currentJobModel:JobModel?
    var CVDataSource:Array<CVModel>?
    
//    var requestHelper = NewsPageHelper()
    
    var strId = "1"
    
    var showType = 1
    var num = 1
    var selfNav:UINavigationController?
    var btnTag = 1
    
    var tit = NSString()
    var count = NSString()
    var linkman = NSString()
    
    var jobPager = 1
    var resumePager = 1

    
//    weak var superViewController:NurseStationViewController?
    
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
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        if showType == 1 {
            
//            self.setFiltrateItem_findJob()
            self.setSlideView()
            myTableView.frame = CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-65-45-49)
//            myTableView.frame = CGRect(x: 0, y: 38, width: WIDTH, height: HEIGHT-110-37)


        }else{
            
//            self.setFiltrateItem_findPerson()
            myTableView.frame = CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-65-45-49)
//            myTableView.frame = CGRect(x: 0, y: 38, width: WIDTH, height: HEIGHT-110-37)


        }
        self.configureUI()

//        makeDataSource()
//        sendPostion.delegate = self
//        sendResume.delegate = self
        
        self.makeEmployment()
        self.view.backgroundColor = COLOR
        
    }
    
    // 学历
    let eduDrop = DropDown()
    var eduDataSource = ["不限"]
    
    // 工作经验
    let expDrop = DropDown()
    var expDataSource = ["不限"]

    // 职称
    let certificateDrop = DropDown()
    var certificateDataSource = ["不限"]
    
    // MARK: 设置筛选按钮(找人才)
    func setFiltrateItem_findPerson() {
        
        // 学历
        let eduBtn = UIButton()
        eduBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        eduBtn.setTitle("学历", for: UIControlState())
        
        // 学历 下拉
        eduDrop.anchorView = eduBtn
        
        eduDrop.bottomOffset = CGPoint(x: 0, y: 37)
        eduDrop.width = WIDTH
        eduDrop.direction = .bottom
        
        eduDrop.dataSource = self.eduDataSource
        
        // 下拉列表选中后的回调方法
        eduDrop.selectionAction = { (index, item) in
            
            self.myTableView.mj_header.beginRefreshing()
            eduBtn.setTitle(item, for: UIControlState())
            
        }
        
        // 工作经验
        let expBtn = UIButton()
        expBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        expBtn.setTitle("工作经验", for: UIControlState())
        
        // 工作经验 下拉
        expDrop.anchorView = expBtn
        
        expDrop.bottomOffset = CGPoint(x: 0, y: 37)
        expDrop.width = WIDTH
        expDrop.direction = .bottom
        
        expDrop.dataSource = self.expDataSource
        
        // 下拉列表选中后的回调方法
        expDrop.selectionAction = { (index, item) in
            
            self.myTableView.mj_header.beginRefreshing()
            expBtn.setTitle(item, for: UIControlState())
            
        }
        
        // 职称
        let certificateBtn = UIButton()
        certificateBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        certificateBtn.setTitle("职称", for: UIControlState())
        
        // 职称 下拉
        certificateDrop.anchorView = certificateBtn
        
        certificateDrop.bottomOffset = CGPoint(x: 0, y: 37)
        certificateDrop.width = WIDTH
        certificateDrop.direction = .bottom
        
        certificateDrop.dataSource = self.certificateDataSource
        
        // 下拉列表选中后的回调方法
        certificateDrop.selectionAction = { (index, item) in
            
            self.myTableView.mj_header.beginRefreshing()
            certificateBtn.setTitle(item, for: UIControlState())
            
        }
        
        // 选择菜单
        let segChoose = LFLUISegmentedControl.segment(withFrame: CGRect(x: 0, y: 1, width: WIDTH, height: 37), titleArray: [eduBtn,expBtn,certificateBtn], defaultSelect: 0)
        segChoose?.tag = 101
        segChoose?.lineColor(COLOR)
        segChoose?.titleColor(UIColor.black, selectTitleColor: COLOR, backGroundColor: UIColor.white, titleFontSize: 14)
        segChoose?.delegate = self
        self.view.addSubview(segChoose!)
    }
    
    // 工作地点
    let addressBtn = ImageBtn()
//    let addressDrop = DropDown()
    var addressDataSource = ["不限"]
    
    // 薪资
    let salaryDrop = DropDown()
    var salaryDataSource = ["不限"]
    
    // 职位
    let jobTypeDrop = DropDown()
    var jobTypeDataSource = ["不限"]
    
    // MARK: 设置筛选按钮(找工作)
    func setFiltrateItem_findJob() {
        
        // 工作地点
        addressBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        addressBtn.setTitle("北京市-北京市", for: UIControlState())
        
        // 薪资
        let expBtn = UIButton()
        expBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        expBtn.setTitle("薪资", for: UIControlState())
        
        // 薪资 下拉
        salaryDrop.anchorView = expBtn
        
        salaryDrop.bottomOffset = CGPoint(x: 0, y: 37)
        salaryDrop.width = WIDTH
        salaryDrop.direction = .bottom
        
        salaryDrop.dataSource = self.salaryDataSource
        
        // 下拉列表选中后的回调方法
        salaryDrop.selectionAction = { (index, item) in
            
            self.myTableView.mj_header.beginRefreshing()
            expBtn.setTitle(item, for: UIControlState())
            
        }
        
        // 职位
        let jobTypeBtn = UIButton()
        jobTypeBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        jobTypeBtn.setTitle("职位", for: UIControlState())
        
        // 职位 下拉
        jobTypeDrop.anchorView = jobTypeBtn
        
        jobTypeDrop.bottomOffset = CGPoint(x: 0, y: 37)
        jobTypeDrop.width = WIDTH
        jobTypeDrop.direction = .bottom
        
        jobTypeDrop.dataSource = self.jobTypeDataSource
        
        // 下拉列表选中后的回调方法
        jobTypeDrop.selectionAction = { (index, item) in
            
            self.myTableView.mj_header.beginRefreshing()
            jobTypeBtn.setTitle(item, for: UIControlState())
            
        }
        
        // 选择菜单
        let segChoose = LFLUISegmentedControl.segment(withFrame: CGRect(x: 0, y: 1, width: WIDTH, height: 37), titleArray: [addressBtn,expBtn,jobTypeBtn], defaultSelect: 0)
        segChoose?.tag = 102
        segChoose?.lineColor(COLOR)
        segChoose?.titleColor(UIColor.black, selectTitleColor: COLOR, backGroundColor: UIColor.white, titleFontSize: 14)
        segChoose?.delegate = self
        self.view.addSubview(segChoose!)
    }
    
    var targetCityArray = ["北京市","北京市"]
    
    func targetCityBtnClick() {
        
        // print("点击目标城市")
        // 初始化
        let pick = AdressPickerView_2.shareInstance
        
        // 设置是否显示区县等，默认为false不显示
        pick.showTown = false
        pick.pickArray = targetCityArray as NSArray? // 设置第一次加载时需要跳转到相对应的地址
        pick.show((UIApplication.shared.keyWindow)!)
        
        // 选择完成之后回调
        pick.selectAdress { (dressArray) in
            
            self.targetCityArray = dressArray as! Array<String>
            
//            self.addressBtn.setTitle("\(self.targetCityArray[0])-\(self.targetCityArray[1])", for: UIControlState())
//            self.addressBtn.setTitle(self.targetCityArray[1], for: .normal)
            self.addressBtn.resetdataCenter(self.targetCityArray[1], self.addressBtn.image.image)
            
            self.myTableView.mj_header.beginRefreshing()
            
        }
    }
    
    // MARK: - LFLUISegmentedControlDelegate
    func uisegumentSelectionChange(_ selection: Int, segmentTag: Int) {
        
        addressBtn.lb_titleColor = UIColor.black
        addressBtn.resetdataCenter(addressBtn.lb_title.text, #imageLiteral(resourceName: "展开"))
        
        let salaryBtn = salaryDrop.anchorView as! ImageBtn
        salaryBtn.lb_titleColor = UIColor.black
        salaryBtn.resetdataCenter(salaryBtn.lb_title.text, #imageLiteral(resourceName: "展开"))
        
        let jobTypeBtn = jobTypeDrop.anchorView as! ImageBtn
        jobTypeBtn.lb_titleColor = UIColor.black
        jobTypeBtn.resetdataCenter(jobTypeBtn.lb_title.text, #imageLiteral(resourceName: "展开"))
        
        if segmentTag == 101 {
            
            if selection == 0 {
                _ = eduDrop.show()
            }else if selection == 1 {
                _ = expDrop.show()
            }else if selection == 2 {
                _ = certificateDrop.show()
            }
        }else{
            
            if selection == 0 {
                addressBtn.lb_titleColor = COLOR
                addressBtn.resetdataCenter(addressBtn.lb_title.text, #imageLiteral(resourceName: "展开-hover"))
                
                self.targetCityBtnClick()
            }else if selection == 1 {
                let salaryBtn = salaryDrop.anchorView as! ImageBtn
                salaryBtn.lb_titleColor = COLOR
                salaryBtn.resetdataCenter(salaryBtn.lb_title.text, #imageLiteral(resourceName: "展开-hover"))
                
                _ = salaryDrop.show()
            }else if selection == 2 {
                let jobTypeBtn = jobTypeDrop.anchorView as! ImageBtn
                jobTypeBtn.lb_titleColor = COLOR
                jobTypeBtn.resetdataCenter(jobTypeBtn.lb_title.text, #imageLiteral(resourceName: "展开-hover"))

                _ = jobTypeDrop.show()
            }
        }
    }
    
    
    func updateSlideImage(){
        
        for subView in self.scrollView.subviews {
            if subView.isKind(of: UIImageView.self) {
                subView.removeFromSuperview()
            }
        }
        
        let margin:CGFloat = 4
        pageControl.numberOfPages = self.imageArr.count
        pageControl.frame = CGRect(
            x: WIDTH-margin-pageControl.rect(forPageIndicator: 0).width*CGFloat(self.imageArr.count)-margin*CGFloat(self.imageArr.count-1),
            y: WIDTH*190/375-25,
            width: pageControl.rect(forPageIndicator: 0).width*CGFloat(self.imageArr.count)+margin*CGFloat(self.imageArr.count-1),
            height: 25)
        pageControl.indicatorMargin = margin
        pageControl.currentPage = 0
        
        for (i,slideImage) in self.imageArr.enumerated() {
            
            let  imageView = UIImageView()
            imageView.frame = CGRect(x: CGFloat(i)*WIDTH, y: 0, width: WIDTH, height: WIDTH*190/375)
            imageView.tag = i+1
            // TODO:JUDGE WIFI
            if  !NurseUtil.net.isWifi() && loadPictureOnlyWiFi {
//            if  (!(NetworkReachabilityManager()?.isReachableOnEthernetOrWiFi)! && loadPictureOnlyWiFi) || slideImage.thumbArr.count == 0 {
                imageView.image = UIImage.init(named: "defaultImage.png")
            }else{
                imageView.sd_setImage(with: URL(string: DomainName+"data/upload/"+(slideImage.thumbArr.first?.url)!), placeholderImage: UIImage.init(named: "defaultImage.png"))
            }
            
            let bottom = UIView(frame: CGRect(x: 0, y: WIDTH*190/375-25, width: WIDTH, height: 25))
            bottom.backgroundColor = UIColor.gray
            bottom.alpha = 0.5
            imageView.addSubview(bottom)
            
            let titLab = UILabel(frame: CGRect(x: 10, y: WIDTH*190/375-25, width: pageControl.frame.minX-10, height: 25))
            titLab.font = UIFont.systemFont(ofSize: 13)
            titLab.textColor = UIColor.white
            titLab.adjustsFontSizeToFitWidth = true
            titLab.text = slideImage.post_title
            titLab.tag = i+1
            imageView.addSubview(titLab)
            
            //为图片视图添加点击事件
            imageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
            //            手指头
            tap.numberOfTapsRequired = 1
            //            单击
            tap.numberOfTouchesRequired = 1
            imageView.addGestureRecognizer(tap)
            self.scrollView.addSubview(imageView)
        }
        
        scrollView.contentSize = CGSize(width: CGFloat(self.imageArr.count)*WIDTH, height: 0)
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        
    }
    
    func makeDataSource(){
        
        self.jobPager = 1
        self.resumePager = 1
        if showType == 1 {
            
            var flag = 0
            
            HSNurseStationHelper().getJobList((self.addressBtn.lb_title.text ?? "")!, salary: (self.salaryDrop.selectedItem ?? "")!, jobtype: (self.jobTypeDrop.selectedItem ?? "")!, pager: String(jobPager), handle: { (success, response) in

                if success {
                    self.jobPager += 1
                    DispatchQueue.main.async(execute: {
                        self.jobDataSource = response as? Array<JobModel> ?? []
                        self.myTableView.reloadData()
                        
                    })
                    
                    flag += 1
                    if flag == 2 {
                        self.myTableView.mj_header.endRefreshing()
                    }
                }else{
                    DispatchQueue.main.async(execute: {
                        self.myTableView.mj_header.endRefreshing()
                        
                        
                        if String(describing: (response ?? ("" as AnyObject))!) == "no data" {
                            self.jobDataSource = Array<JobModel>()
                            self.myTableView.reloadData()
                        }else{
                            
                            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                            hud.mode = MBProgressHUDMode.text;
                            hud.label.text = "无结果"
                            hud.detailsLabel.text = String(describing: (response ?? ("" as AnyObject))!)
                            hud.margin = 10.0
                            hud.removeFromSuperViewOnHide = true
                            hud.hide(animated: true, afterDelay: 1)
                        }
                        
                    })
                }
                })
            
            HSNurseStationHelper().getArticleListWithID("121") { (success, response) in
                
                if success {
                    // print(response)
                    let imageArr = response as! Array<NewsInfo>
                    self.imageArr = imageArr.count>=5 ? Array(imageArr[0...slideImageListMaxNum-1]):imageArr
                    
                    DispatchQueue.main.async(execute: {
                        self.updateSlideImage()
                        self.myTableView.reloadData()
                    })
                    
                    flag += 1
                    if flag == 2 {
                        self.myTableView.mj_header.endRefreshing()
                    }
                }else{
                    DispatchQueue.main.async(execute: {
                        self.myTableView.mj_header.endRefreshing()
                        
                        if (String(describing: (response ?? ("" as AnyObject))!) ) == "no data" {
                            self.imageArr = Array<NewsInfo>()
                            self.updateSlideImage()
                            self.myTableView.reloadData()
                        }else{
                            
                            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                            hud.mode = MBProgressHUDMode.text;
                            hud.label.text = "轮播图获取失败"
                            hud.detailsLabel.text = (String(describing: (response ?? ("" as AnyObject))!) )
                            hud.margin = 10.0
                            hud.removeFromSuperViewOnHide = true
                            hud.hide(animated: true, afterDelay: 1)
                        }
                        
                    })
                }
            }
        } else if showType == 2 {
            
            HSNurseStationHelper().getCVList((eduDrop.selectedItem ?? "")!, experience: (expDrop.selectedItem ?? "")!, certificate: (certificateDrop.selectedItem ?? "")!, pager: String(resumePager), handle: { (success, response) in

                DispatchQueue.main.async(execute: {
                    if !success {
                        return
                    }
                    self.resumePager += 1
                    self.CVDataSource = response as? Array<CVModel> ?? []
                    self.myTableView.reloadData()
                    //                    self.configureUI()
                })
                self.myTableView.mj_header.endRefreshing()
                })
        }
        
        if self.eduDataSource.count <= 1 {
            getDictionaryList("1", key: "education")
        }
        
        if self.expDataSource.count <= 1 {
            getDictionaryList("15", key: "experience")
        }
        
        if self.certificateDataSource.count <= 1 {
            getDictionaryList("6", key: "title")
        }
        
        if self.salaryDataSource.count <= 1 {
            getDictionaryList("11", key: "money")
        }
        
        if self.jobTypeDataSource.count <= 1 {
            getDictionaryList("7", key: "position")
        }
    }
    
    func loadData_pullUp(){
        if showType == 1 {
            
            HSNurseStationHelper().getJobList((self.addressBtn.currentTitle ?? "")!, salary: (self.salaryDrop.selectedItem ?? "")!, jobtype: (self.jobTypeDrop.selectedItem ?? "")!, pager: String(jobPager), handle: { (success, response) in
                
                if success {
                    self.jobPager += 1
                    DispatchQueue.main.async(execute: {
                        
                        for jobModel in (response as? Array<JobModel> ?? []) {
                            self.jobDataSource?.append(jobModel)
                        }
                        self.myTableView.reloadData()
                        self.myTableView.mj_footer.endRefreshing()

                    })
                    
                }else{
                    
                    DispatchQueue.main.async(execute: {
                        self.myTableView.mj_footer.endRefreshingWithNoMoreData()
                        
                    })
                }
            })
            
        } else if showType == 2 {
            
            HSNurseStationHelper().getCVList((eduDrop.selectedItem ?? "")!, experience: (expDrop.selectedItem ?? "")!, certificate: (certificateDrop.selectedItem ?? "")!, pager: String(resumePager), handle: { (success, response) in

                DispatchQueue.main.async(execute: {
                    if !success {
                        self.myTableView.mj_footer.endRefreshingWithNoMoreData()
                        return
                    }
                    
                    self.resumePager += 1
                    for cvModel in (response as? Array<CVModel> ?? []) {
                        self.CVDataSource?.append(cvModel)
                    }
                    self.myTableView.reloadData()
                    self.myTableView.mj_footer.endRefreshing()

                })
            })
        }
        
        if self.eduDataSource.count <= 1 {
            getDictionaryList("1", key: "education")
        }
        
        if self.expDataSource.count <= 1 {
            getDictionaryList("15", key: "experience")
        }
        
        if self.certificateDataSource.count <= 1 {
            getDictionaryList("6", key: "title")
        }
        
        if self.salaryDataSource.count <= 1 {
            getDictionaryList("11", key: "money")
        }
        
        if self.jobTypeDataSource.count <= 1 {
            getDictionaryList("7", key: "position")
        }
    }
    
    func getDictionaryList(_ type:String, key:String) {
        
        let url = PARK_URL_Header+"getDictionaryList"
        
        let param = ["type":type]

        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in

            if(error != nil){
                
            }else{
                let status = EduModel(JSONDecoder(json!))
                
                if(status.status == "error"){
                    
                }
                if(status.status == "success"){

                    switch key {
                    case "education":
                        if self.eduDataSource.count <= 1 {
                            
                            for obj in EduList(status.data!).objectlist {
                                self.eduDataSource.append(obj.name)
                            }
                            self.eduDrop.dataSource = self.eduDataSource
                        }

                    case "experience":
                        if self.expDataSource.count <= 1 {
                            
                            for obj in EduList(status.data!).objectlist {
                                self.expDataSource.append(obj.name)
                            }
                            self.expDrop.dataSource = self.expDataSource
                        }

                    case "title":
                        if self.certificateDataSource.count <= 1 {
                            
                            for obj in EduList(status.data!).objectlist {
                                self.certificateDataSource.append(obj.name)
                            }
                            self.certificateDrop.dataSource = self.certificateDataSource
                        }
                        
                    case "money":
                        if self.salaryDataSource.count <= 1 {
                            
                            for obj in EduList(status.data!).objectlist {
                                self.salaryDataSource.append(obj.name)
                            }
                            self.salaryDrop.dataSource = self.salaryDataSource
                        }
                        
                    case "position":
                        if self.jobTypeDataSource.count <= 1 {
                            
                            for obj in EduList(status.data!).objectlist {
                                self.jobTypeDataSource.append(obj.name)
                            }
                            self.jobTypeDrop.dataSource = self.jobTypeDataSource
                        }

                    default: break
                        
                    }
                }else{
                }
            }
            
        }
    }

    
    func configureUI(){
        let line = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.white
        //        myTableView.frame = CGRectMake(0, 0.5, WIDTH, HEIGHT-154.5)
        myTableView.backgroundColor = UIColor.white
        myTableView.tag = 0
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "identifier")
        myTableView.register(RecruitTableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(makeDataSource))
        myTableView.mj_header.beginRefreshing()
        
        myTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadData_pullUp))
        
        self.view.addSubview(myTableView)
        
        
        myTableView.rowHeight = 142
        
        let posted = UIButton()
        posted.frame = CGRect(x: WIDTH-70 , y: HEIGHT-230, width: 50, height: 50)
        posted.setImage(UIImage(named: "ic_edit.png"), for: UIControlState())
        posted.addTarget(self, action: #selector(RecruitmentViewController.postedTheView), for: .touchUpInside)
        self.view.addSubview(posted)
        posted.becomeFirstResponder()
    }
    
    func setSlideView() {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: WIDTH*190/375+37))
        
        let one = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: WIDTH*190/375))
        headerView.addSubview(one)
        
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(scroll), userInfo: nil, repeats: true)
        
        scrollView.frame = CGRect(x: 0, y: 0,width: WIDTH, height: WIDTH*190/375)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.tag = 1000
        
        scrollView.contentSize = CGSize(width: 4*WIDTH, height: 0)
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        one.addSubview(scrollView)
        
        pageControl.frame = CGRect(x: WIDTH-80, y: WIDTH*190/375-25, width: 80, height: 25)
        pageControl.pageIndicatorTintColor = UIColor.white
        pageControl.currentPageIndicatorTintColor = COLOR
        pageControl.numberOfPages = self.imageArr.count
        pageControl.currentPage = 0
        one.addSubview(pageControl)
        
        // 工作地点
//        addressBtn.titleLabel?.adjustsFontSizeToFitWidth = true
//        addressBtn.setTitle("北京市", for: UIControlState())
        addressBtn.frame = CGRect(x: 0, y: 0, width: WIDTH/3.0, height: 37)
        addressBtn.lb_title_fontSize = 14
        addressBtn.resetdataCenter("北京市", #imageLiteral(resourceName: "展开"))
        
        addressBtn.lb_titleColor = COLOR
        addressBtn.resetdataCenter(addressBtn.lb_title.text, #imageLiteral(resourceName: "展开-hover"))
        
        // 薪资
        let expBtn = ImageBtn(frame: CGRect(x: 0, y: 0, width: WIDTH/3.0, height: 37))
//        expBtn.titleLabel?.adjustsFontSizeToFitWidth = true
//        expBtn.setTitle("薪资", for: UIControlState())
        expBtn?.lb_title_fontSize = 14
        expBtn?.resetdataCenter("薪资", #imageLiteral(resourceName: "展开"))
        
        // 薪资 下拉
        salaryDrop.anchorView = expBtn
        
        salaryDrop.bottomOffset = CGPoint(x: 0, y: 37)
        salaryDrop.width = WIDTH/3.0
        salaryDrop.direction = .bottom
        
        salaryDrop.dataSource = self.salaryDataSource
        
        // 下拉列表选中后的回调方法
        salaryDrop.selectionAction = { (index, item) in
            
            self.myTableView.mj_header.beginRefreshing()
//            expBtn?.setTitle(item, for: UIControlState())
            expBtn?.resetdataCenter(item, expBtn?.image.image)
        }
        
        // 职位
        let jobTypeBtn = ImageBtn(frame: CGRect(x: 0, y: 0, width: WIDTH/3.0, height: 37))
        jobTypeBtn?.lb_title_fontSize = 14
//        certificateBtn?.titleLabel?.adjustsFontSizeToFitWidth = true
//        certificateBtn.setTitle("职位", for: UIControlState())
        jobTypeBtn?.resetdataCenter("职位", jobTypeBtn?.image.image)
        
        // 职位 下拉
        jobTypeDrop.anchorView = jobTypeBtn
        
        jobTypeDrop.bottomOffset = CGPoint(x: 0, y: 37)
        jobTypeDrop.width = WIDTH/3.0
        jobTypeDrop.direction = .bottom
        
        jobTypeDrop.dataSource = self.jobTypeDataSource
        
        // 下拉列表选中后的回调方法
        jobTypeDrop.selectionAction = { (index, item) in
            
            self.myTableView.mj_header.beginRefreshing()

//            jobTypeBtn?.lb_titleColor = UIColor.black
            jobTypeBtn?.resetdataCenter(item, jobTypeBtn?.image.image)

        }
        
        // 选择菜单
        let segChoose = LFLUISegmentedControl.segment(withFrame: CGRect(x: 0, y: WIDTH*190/375, width: WIDTH, height: 37), titleArray: [addressBtn,expBtn!,jobTypeBtn!], defaultSelect: 0)
        segChoose?.tag = 102
        segChoose?.lineColor(COLOR)
        segChoose?.titleColor(UIColor.black, selectTitleColor: COLOR, backGroundColor: UIColor.white, titleFontSize: 14)
        segChoose?.delegate = self
        headerView.addSubview(segChoose!)
        
        let line = UIView(frame: CGRect(x: 0, y: 37, width: WIDTH, height: 1/UIScreen.main.scale))
        line.backgroundColor = UIColor.lightGray
        headerView.addSubview(line)
        
        myTableView.tableHeaderView = headerView
    }
    
    // MARK: - 发布招聘信息
    func makeEmployment() {
        employment.frame = CGRect(x: 0, y: HEIGHT, width: WIDTH, height: HEIGHT-154.5)
        employment.backgroundColor = UIColor.white
        self.view.addSubview(employment)
        
        let tackBtn = UIButton(frame: CGRect(x: WIDTH*15/375, y: employment.bounds.size.height-WIDTH*65/375, width: WIDTH*345/375, height: WIDTH*45/375))
        tackBtn.layer.cornerRadius = WIDTH*22.5/375
        tackBtn.layer.borderColor = COLOR.cgColor
        tackBtn.layer.borderWidth = 1
        tackBtn.setTitle("提交", for: UIControlState())
        tackBtn.setTitleColor(COLOR, for: UIControlState())
        tackBtn.addTarget(self, action: #selector(self.takeThePost), for: .touchUpInside)
        employment.addSubview(tackBtn)
    }
    // MARK: - 简历详情
    func lookResumeDetail(){
        resumeDetail.frame = CGRect(x: 0, y: 0.5, width: WIDTH, height: HEIGHT-154.5)
        self.view.addSubview(resumeDetail)
    }
    
    // MARK: - tableview Datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if showType == 1 {
            return jobDataSource?.count ?? 0
        }else{
            return CVDataSource?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as!RecruitTableViewCell
        cell.selectionStyle = .none
        if showType == 1 {
            cell.showforJobModel(jobDataSource![indexPath.row])
            cell.delivery.tag = indexPath.row
            btnTag = cell.delivery.tag
            cell.delivery.addTarget(self, action: #selector(self.resumeOnline(_:)), for: .touchUpInside)
        }else{
            cell.showforCVModel(CVDataSource![indexPath.row])
            cell.delivery.tag = indexPath.row
            btnTag = cell.delivery.tag
            cell.delivery.addTarget(self, action: #selector(self.invited(_:)), for: .touchUpInside)
        }
        
        return cell
    }
    
    // MARK: - tableveiw Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(indexPath.row)
        if tableView.tag == 0 {
            if showType == 1 {
                self.currentJobModel = self.jobDataSource![indexPath.row]
                
                HSNurseStationHelper().setHits(self.jobDataSource![indexPath.row].id, type: "2", handle: { (success, response) in
                    
                })
                
                let RecruitmentDetailVC = NSRecruitmentDetailViewController()
                self.jobDataSource![indexPath.row].hits = String(NSString(string: self.jobDataSource![indexPath.row].hits).integerValue+1)
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
    
    // MARK: - 邀请面试
    func invited(_ btn:UIButton) {
        inviteJob(self.CVDataSource![btn.tag])
    }
    
    func inviteJob(_ model:CVModel) {
        // print("邀请面试")
        
        // MARK:要求登录
        if !requiredLogin(self.navigationController!, previousViewController: self, hiddenNavigationBar: false) {
            return
        }
        
        if QCLoginUserInfo.currentInfo.usertype == "1" {
            
            let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("您是个人用户，不能发布面试邀请", comment: "empty message"), preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            
            let cancelAction = UIAlertAction(title: "好的", style: .cancel, handler: { (action) in
                return
            })
            alertController.addAction(cancelAction)
        }else{
            let url = PARK_URL_Header+"getMyPublishJobList"
            let param = ["userid":QCLoginUserInfo.currentInfo.userid]
            NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
                if(error != nil){
                    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hud.mode = MBProgressHUDMode.text;

                    hud.label.text = "网络错误，请稍后再试"
                    //hud.label.text = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(animated: true, afterDelay: 1)
                }else{
                    let status = MineJobModel(JSONDecoder(json!))
                    if(status.status == "success"){
                        // print(status)
                        self.inviteJob_1(model, status: status)
                        
                    }else if(status.status == "error"){
                        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                        hud.mode = MBProgressHUDMode.text;
                        if status.data == nil {
                            hud.label.text = "您还没有发布职位，请先发布职位"
                        }
                        //hud.label.text = status.errorData
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(animated: true, afterDelay: 1)
                    }
                }
                
            }
        }
    }
    
    func inviteJob_1(_ model:CVModel, status:MineJobModel) {
        let arr = MineJobList(status.data!)
        
        let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("请选择您要邀请的职位", comment: "empty message"), preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        
        for job in arr.objectlist {
            let doneAction = UIAlertAction(title: job.title, style: .default, handler: { (cancelAction) in
                
                let inviteHud = MBProgressHUD.showAdded(to: self.view, animated: true)
                inviteHud.label.text = "正在获取邀请状态"
                inviteHud.removeFromSuperViewOnHide = true
                inviteHud.margin = 10.0
                
                HSNurseStationHelper().InviteJob_judge(model.userid, companyid: QCLoginUserInfo.currentInfo.userid, jobid: job.id) { (success, response) in
                    
                    if success {
                        inviteHud.hide(animated: true)
                        if String(describing: (response ?? ("" as AnyObject))!) == "1" {
                            
                            let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("您已邀请过 \(model.name) 面试该职位，无需再次邀请", comment: "empty message"), preferredStyle: .alert)
                            self.present(alertController, animated: true, completion: nil)
                            let doneAction = UIAlertAction(title: "好的", style: .default, handler: nil)
                            alertController.addAction(doneAction)
                        }else{
                            
                            let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("你确定要向 \(model.name) 发送邀请吗？", comment: "empty message"), preferredStyle: .alert)
                            self.present(alertController, animated: true, completion: nil)
                            
                            let doneAction = UIAlertAction(title: "确定", style: .cancel, handler: { (cancelAction) in
                                
                                let sendInviteHud = MBProgressHUD.showAdded(to: self.view, animated: true)
                                sendInviteHud.label.text = "正在发送邀请"
                                sendInviteHud.removeFromSuperViewOnHide = true
                                sendInviteHud.margin = 10.0
                                
                                let url = PARK_URL_Header+"InviteJob"
                                let param = [
                                    "userid":model.userid,
                                    "jobid":job.id,
                                    "companyid":QCLoginUserInfo.currentInfo.userid
                                ]
                                NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
                                    // print(request)
                                    if(error != nil){
                                        sendInviteHud.mode = MBProgressHUDMode.text;
                                        sendInviteHud.label.text = "发送邀请失败 \(error?.localizedDescription)"
                                        sendInviteHud.hide(animated: true, afterDelay: 1)
                                    }else{
                                        let result = Http(JSONDecoder(json!))
                                        if(result.status == "success"){
                                            //  菊花加载
                                            //                                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                                            sendInviteHud.mode = MBProgressHUDMode.text;
                                            sendInviteHud.label.text = "发送邀请成功"
                                            //                                    hud.margin = 10.0
                                            //                                    hud.removeFromSuperViewOnHide = true
                                            sendInviteHud.hide(animated: true, afterDelay: 1)
                                            // print(111111)
                                        }else{
                                            //  菊花加载
                                            //                                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                                            sendInviteHud.mode = MBProgressHUDMode.text;
                                            sendInviteHud.label.text = "发送邀请失败"
                                            //                                    hud.margin = 10.0
                                            //                                    hud.removeFromSuperViewOnHide = true
                                            sendInviteHud.hide(animated: true, afterDelay: 1)
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
                        inviteHud.mode = MBProgressHUDMode.text
                        inviteHud.label.text = "获取邀请状态失败"
                        inviteHud.hide(animated: true, afterDelay: 1)
                    }
                }
            })
            
            alertController.addAction(doneAction)
        }
        
        
        let cancelAction = UIAlertAction(title: "取消", style: .destructive, handler: { (cancelAction) in
            return
        })
        alertController.addAction(cancelAction)
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
            resumeHud.label.text = "正在获取简历信息"
            resumeHud.removeFromSuperViewOnHide = true
            resumeHud.margin = 10.0
            
            HSNurseStationHelper().getResumeInfo(QCLoginUserInfo.currentInfo.userid) { (success, response) in
                if success {
                    
                    // 判断是否已投递简历
                    resumeHud.label.text = "正在获取简历投递状态"
                    
                    HSNurseStationHelper().ApplyJob_judge(QCLoginUserInfo.currentInfo.userid, companyid: self.jobDataSource![btn.tag].companyid, jobid: self.jobDataSource![btn.tag].id, handle: { (success, response) in
                        if success {
                            resumeHud.hide(animated: true)
                            if String(describing: (response ?? ("" as AnyObject))!) == "1" {
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
                                    applyJobHud.label.text = "正在投递简历"
                                    applyJobHud.removeFromSuperViewOnHide = true
                                    applyJobHud.margin = 10.0
                                    
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
                                                applyJobHud.mode = MBProgressHUDMode.text;
                                                applyJobHud.label.text = "投递简历成功"
                                                //                                            hud.margin = 10.0
                                                //                                            hud.removeFromSuperViewOnHide = true
                                                applyJobHud.hide(animated: true, afterDelay: 1)
                                                // print(111111)
                                            }else{
                                                //  菊花加载
                                                //                                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                                                applyJobHud.mode = MBProgressHUDMode.text;
                                                applyJobHud.label.text = "投递简历失败"
                                                //                                            hud.margin = 10.0
                                                //                                            hud.removeFromSuperViewOnHide = true
                                                applyJobHud.hide(animated: true, afterDelay: 1)
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
                            resumeHud.mode = MBProgressHUDMode.text
                            resumeHud.label.text = "获取简历投递状态失败"
                            resumeHud.hide(animated: true, afterDelay: 1)
                        }
                    })
                    
                    
                }else{
                    if String(describing: (response ?? ("" as AnyObject))!) == "no data" {
                        
                        DispatchQueue.main.async(execute: {
                            resumeHud.hide(animated: true)
                            let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("您还没有简历，请上传简历后投递？", comment: "empty message"), preferredStyle: .alert)
                            self.present(alertController, animated: true, completion: nil)
                            let doneAction = UIAlertAction(title: "现在就去", style: .default, handler: { (action) in
                                self.postedTheView()
                            })
                            alertController.addAction(doneAction)
                            
                            let cancelAction = UIAlertAction(title: "先不投了", style: .cancel, handler: { (action) in
                                
                            })
                            alertController.addAction(cancelAction)
                        })
                    }else{
                        resumeHud.mode = MBProgressHUDMode.text
                        resumeHud.label.text = "获取简历信息失败"
                        resumeHud.hide(animated: true, afterDelay: 1)
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
                
                let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("您是个人用户，不能发布招聘信息", comment: "empty message"), preferredStyle: .alert)
                self.present(alertController, animated: true, completion: nil)
                
                let cancelAction = UIAlertAction(title: "好的", style: .cancel, handler: { (action) in
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
                
                let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("您是企业用户，不能编辑简历", comment: "empty message"), preferredStyle: .alert)
                self.present(alertController, animated: true, completion: nil)
                
                let cancelAction = UIAlertAction(title: "好的", style: .cancel, handler: { (action) in
                    return
                })
                alertController.addAction(cancelAction)
            }else{
                self.navigationController?.pushViewController(editResumeViewController(), animated: true)
            }
        }
    }
    
//    func rightBarButtonClicked() {
//        if showType == 2 {
//            UIView.animateWithDuration(0.2) {
//                self.sendPostion.frame = CGRectMake(WIDTH, 0.5, WIDTH, HEIGHT-154.5)
//            }
//            self.sendPostion.removeFromSuperview()
//            self.employmentMessage.removeFromSuperview()
//            superViewController?.hiddenBtn()
//        } else if showType == 1 {
//            UIView.animateWithDuration(0.2) {
//                self.sendResume.frame = CGRectMake(WIDTH, 0.5, WIDTH, HEIGHT-154.5)
//            }
//            self.sendResume.removeFromSuperview()
//            self.resumeDetail.removeFromSuperview()
//            superViewController?.hiddenBtn()
//        }
//    }
    //MARK:-----SendPositionDelegate-----
//    func clickedSendBtn(){
//        rightBarButtonClicked()
//    }
    
    func takeThePost() {
        UIView.animate(withDuration: 0.3, animations: {
            self.employment.frame = CGRect(x: 0, y: HEIGHT, width: WIDTH, height: HEIGHT-154.5)
        }) 
    }
    
    func takeTheResume() {
        
        let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("你确定要投递该职位吗？", comment: "empty message"), preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        
        let doneAction = UIAlertAction(title: "确定", style: .cancel, handler: { (doneAction) in
            
            let model = self.currentJobModel
            let url = PARK_URL_Header+"ApplyJob"
            let param = [
                "userid":QCLoginUserInfo.currentInfo.userid,
                "jobid":model!.id,
                "companyid" :model!.companyid
            ]
            NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
                // print(request)
                if(error != nil){
                    //  菊花加载
                    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hud.mode = MBProgressHUDMode.text;
                    hud.label.text = "投递简历失败（error）"
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(animated: true, afterDelay: 1)
                }else{
                    let result = Http(JSONDecoder(json!))
                    if(result.status == "success"){
                        //  菊花加载
                        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                        hud.mode = MBProgressHUDMode.text;
                        hud.label.text = "投递简历成功"
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(animated: true, afterDelay: 1)
                        // print(111111)
                    }else{
                        //  菊花加载
                        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                        hud.mode = MBProgressHUDMode.text;
                        hud.label.text = "投递简历失败"
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(animated: true, afterDelay: 1)
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
    
    //MARK:delegate-find
    func sendInvite(_ model:CVModel){
        inviteJob(model)
    }
    func hiddenResumeDetail() {
        UIView.animate(withDuration: 0.2, animations: {
            self.resumeDetail.frame = CGRect(x: WIDTH, y: 0.5, width: WIDTH, height: HEIGHT-154.5)
        }) 
        self.resumeDetail.removeFromSuperview()
    }
    //MARK:delegate-find
    func uploadAvatar() -> UIImage{
        return UIImage()
    }
//    func saveResumeBtnClicked(){
//        rightBarButtonClicked()
//    }
    
    // MARK:图片点击事件
    func tapAction(_ tap:UIGestureRecognizer) {
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.tag == 1000 {
            pageControl.currentPage = Int(scrollView.contentOffset.x)/Int(WIDTH)
            //        timer.fireDate = NSDate.distantPast()
            timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(TouTiaoViewController.scroll), userInfo: nil, repeats: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 1000 {
            var offsetX:CGFloat = self.scrollView.contentOffset.x
            offsetX = offsetX + (self.scrollView.frame.size.width * 0.5)
            let page:Int = Int(offsetX)/Int(self.scrollView.frame.size.width)
            pageControl.currentPage = page
        }
    }
    //开始拖拽时
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //            timer.fireDate = NSDate.distantFuture()
        if scrollView.tag == 1000 {
            timer.invalidate()
        }
    }
}
