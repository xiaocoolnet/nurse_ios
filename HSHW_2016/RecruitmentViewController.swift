//
//  RecruitmentViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class RecruitmentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {

    let myTableView = UITableView()
    let employmentMessageTableView = UITableView()
    let scrollView = UIScrollView()
    let pageControl = UIPageControl()
    var picArr = NSArray()
    var timer = NSTimer()
    var times = Int()
    let employment = UIView()
    let employmentMessage = UIView()
    var employmentdataSource=NSMutableArray()
    let CVMessage = UIView()
    let jobHelper = HSNurseStationHelper()
    var jobDataSource:Array<JobModel>?
    var CVDataSource:Array<CVModel>?
    var showType = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeDataSource()
        
        picArr = ["1.png","2.png","3.png","4.png"]
        for i in 0...4 {
            let imageView = UIImageView()
            imageView.frame = CGRectMake(CGFloat(i)*WIDTH, 0, WIDTH, WIDTH*140/375)
            if i == 4 {
                imageView.image = UIImage(named: "1.png")
            }else{
                imageView.image = UIImage(named: "\(i+1).png")
            }
            imageView.tag = i+1
            //为图片视图添加点击事件
            imageView.userInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(AbroadViewController.tapAction(_:)))
            // 手指头
            tap.numberOfTapsRequired = 1
            // 单击
            tap.numberOfTouchesRequired = 1
            imageView.addGestureRecognizer(tap)
            scrollView.addSubview(imageView)
        }
        self.makeEmployment()
        
    }
    
    func makeDataSource(){
        if showType == 1 {
            jobHelper.getJobList({[unowned self] (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if !success {
                        return
                    }
                    self.jobDataSource = response as? Array<JobModel> ?? []
                    self.myTableView.reloadData()
                     self.configureUI()
                })
            })
        } else if showType == 2 {
            jobHelper.getCVList({[unowned self] (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if !success {
                        return
                    }
                    self.CVDataSource = response as? Array<CVModel> ?? []
                    self.myTableView.reloadData()
                     self.configureUI()
                })
            })
        }
    }
    
    func configureUI(){
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 0.5))
        line.backgroundColor = GREY
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.whiteColor()
        myTableView.frame = CGRectMake(0, 0.5, WIDTH, HEIGHT-154.5)
        myTableView.backgroundColor = UIColor.whiteColor()
        myTableView.tag = 0
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "identifier")
        myTableView.registerClass(RecruitTableViewCell.self, forCellReuseIdentifier: "cell")
        employmentMessageTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "employmentMessage")
        employmentMessageTableView.delegate = self
        employmentMessageTableView.dataSource = self
        employmentMessageTableView.tag = 1
        self.view.addSubview(myTableView)
        
        let one = UIView(frame: CGRectMake(0, 0.5, WIDTH, WIDTH*140/375))
        self.view.addSubview(one)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(RecruitmentViewController.scroll), userInfo: nil, repeats: true)
        timer.fire()
        
        scrollView.frame = CGRectMake(0, 0,WIDTH, WIDTH*140/375)
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        
        scrollView.contentSize = CGSizeMake(5*WIDTH, 0)
        scrollView.contentOffset = CGPointMake(0, 0)
        one.addSubview(scrollView)
        
        pageControl.frame = CGRectMake(WIDTH-80, WIDTH*140/375-30, 80, 30)
        pageControl.pageIndicatorTintColor = UIColor.whiteColor()
        pageControl.currentPageIndicatorTintColor = COLOR
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(RecruitmentViewController.pageNext), forControlEvents: .ValueChanged)
        one.addSubview(pageControl)
        
        
        myTableView.tableHeaderView = one
        myTableView.rowHeight = 142
        
        let posted = UIButton()
        posted.frame = CGRectMake(WIDTH-70 , HEIGHT-230, 50, 50)
        posted.setImage(UIImage(named: "ic_edit.png"), forState: .Normal)
        posted.addTarget(self, action: #selector(RecruitmentViewController.postedTheView), forControlEvents: .TouchUpInside)
        self.view.addSubview(posted)
        posted.becomeFirstResponder()
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
//    招聘信息详情
    func makeEmploymentMessage() {
        employmentMessage.frame = CGRectMake(0, 0.5, WIDTH, HEIGHT-154.5)
        employmentMessage.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(employmentMessage)
        self.employmentMessageTableView.frame = CGRectMake(0, 0, employmentMessage.frame.size.width,employmentMessage.frame.size.height - WIDTH*65/375)
//        employmentMessageTableView.tag = 1
//        employmentMessageTableView.backgroundColor = UIColor.redColor()
        let tackBtn = UIButton(frame: CGRectMake(WIDTH*15/375, self.employmentMessageTableView.frame.origin.y+self.employmentMessageTableView.frame.size.height+10, WIDTH*345/375, WIDTH*45/375))
        tackBtn.layer.cornerRadius = WIDTH*22.5/375
        tackBtn.layer.borderColor = COLOR.CGColor
        tackBtn.layer.borderWidth = 1
        tackBtn.setTitle("投递简历", forState: .Normal)
        tackBtn.setTitleColor(COLOR, forState: .Normal)
        tackBtn.addTarget(self, action: #selector(self.takeTheResume), forControlEvents: .TouchUpInside)
        employmentMessage.addSubview(tackBtn)
       
        employmentMessage.addSubview(employmentMessageTableView)
        
    }
    
    func makeCVMessage(){
    
        CVMessage.frame = CGRectMake(0, 0.5, WIDTH, HEIGHT-154.5)
//        CVMessage.backgroundColor = UIColor.redColor()
        self.view.addSubview(CVMessage)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        print("---")
        print(jobDataSource)
        print("---")
        if tableView.tag == 0 {

            return 200
            
        }else {
            
            if indexPath.row == 0 {
                let jobModel = jobDataSource![indexPath.row]
                let height = calculateHeight(jobModel.title, size: 18, width: WIDTH-20)
                return 20+height
            }else{
            
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
        
            return 6
        }
  
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let mycell = tableView.dequeueReusableCellWithIdentifier("identifier", forIndexPath: indexPath)
        
        if tableView.tag == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)as!RecruitTableViewCell
            cell.selectionStyle = .None
            if showType == 1 {
              
                cell.showforJobModel(jobDataSource![indexPath.row])
                
            }else{
                cell.showforCVModel(CVDataSource![indexPath.row])
            }
            cell.delivery.addTarget(self, action: #selector(self.resumeOnline), forControlEvents: .TouchUpInside)
            return cell
        }else{
            
            let cell1 = tableView.dequeueReusableCellWithIdentifier("employmentMessage", forIndexPath: indexPath)
            print(employmentdataSource)
            let jobModel = employmentdataSource[0]as! JobModel
            print(jobModel.title)
            cell1.selectionStyle = .None
            cell1.textLabel?.numberOfLines = 0
            
            if showType == 1 {
//               cell1.backgroundColor = UIColor.redColor()
                print(indexPath.row)
                if indexPath.row==0 {
                    let title = UILabel()
//                    title.backgroundColor = UIColor.brownColor()
                    let height = calculateHeight(jobModel.title, size: 18, width: WIDTH-20)
                    title.frame = CGRectMake(10, 10, WIDTH-20, height)
//                    title.textColor = 
                    title.text = jobModel.title
                    title.font = UIFont.systemFontOfSize(18)
                    title.numberOfLines = 0
                    cell1.addSubview(title)
//                    cell1.bringSubviewToFront(title)
                }
               
               
                return cell1
            }
            return cell1

        }
       
//       return mycell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        if showType == 1 {
            let model = self.jobDataSource![indexPath.row]
            self.employmentdataSource.addObject(model)
            print(jobDataSource)
            print(self.jobDataSource![indexPath.row])
            print(self.employmentdataSource)
            self.makeEmploymentMessage()
        }else {
            self.makeCVMessage()
        }
//        UIView.animateWithDuration(0.3) {
//            self.employmentMessage.frame = CGRectMake(0, 0.5, WIDTH, HEIGHT-154.5)
//        }
        
    }
    func resumeOnline() {
        print("投递简历")
        let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("你确定要投递该职位吗？", comment: "empty message"), preferredStyle: .Alert)
        let doneAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
        alertController.addAction(doneAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    
    }
    func postedTheView() {
        print("招聘")
        UIView.animateWithDuration(0.3) { 
            self.employment.frame = CGRectMake(0, 0.5, WIDTH, HEIGHT-154.5)
        }
        
    }
    func takeThePost() {
        print("提交招聘信息")
        UIView.animateWithDuration(0.3) {
            self.employment.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT-154.5)
        }
        
    }
    func takeTheResume() {
        print("提交简历")
        UIView.animateWithDuration(0.2) {
            self.employmentMessage.frame = CGRectMake(WIDTH, 0.5, WIDTH, HEIGHT-154.5)
        }
    }
    //    图片点击事件
    func tapAction(tap:UIGestureRecognizer) {
        var imageView = UIImageView()
        imageView = tap.view as! UIImageView
        print("这是第\(Int(imageView.tag))张图片")
    }
    func pageNext() {
        scrollView.contentOffset = CGPointMake(WIDTH*CGFloat(pageControl.currentPage), 0)
    }
    
    func scroll(){
        if times == 4 {
            pageControl.currentPage = 0
        }else{
            pageControl.currentPage = times
        }
        scrollView.setContentOffset(CGPointMake(WIDTH*CGFloat(times), 0), animated: true)
        times += 1
        print("招聘1")
    }
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        if times >= 5 {
            scrollView.setContentOffset(CGPointMake(0, 0), animated: false)
            times = 1
        }
        print("招聘2")
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var number = Int(scrollView.contentOffset.x/WIDTH)
        if number == 4 {
            number = 0
            pageControl.currentPage = number
        }else{
            pageControl.currentPage = number
        }
    }
}
