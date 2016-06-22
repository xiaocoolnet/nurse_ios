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
    let scrollView = UIScrollView()
    let pageControl = UIPageControl()
    var picArr = NSArray()
    var timer = NSTimer()
    var times = Int()
    let employment = UIView()
    let employmentMessage = UIView()
    var showType = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 0.5))
        line.backgroundColor = GREY
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.whiteColor()
        myTableView.frame = CGRectMake(0, 0.5, WIDTH, HEIGHT-154.5)
        myTableView.backgroundColor = UIColor.whiteColor()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "identifier")
        myTableView.registerClass(RecruitTableViewCell.self, forCellReuseIdentifier: "cell")
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
            //            手指头
            tap.numberOfTapsRequired = 1
            //            单击
            tap.numberOfTouchesRequired = 1
            imageView.addGestureRecognizer(tap)
            scrollView.addSubview(imageView)
        }
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
        
        self.makeEmployment()
        
        // Do any additional setup after loading the view.
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
        employmentMessage.frame = CGRectMake(WIDTH, 0.5, WIDTH, HEIGHT-154.5)
        employmentMessage.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(employmentMessage)
        
        let tackBtn = UIButton(frame: CGRectMake(WIDTH*15/375, employmentMessage.bounds.size.height-WIDTH*65/375, WIDTH*345/375, WIDTH*45/375))
        tackBtn.layer.cornerRadius = WIDTH*22.5/375
        tackBtn.layer.borderColor = COLOR.CGColor
        tackBtn.layer.borderWidth = 1
        tackBtn.setTitle("投递简历", forState: .Normal)
        tackBtn.setTitleColor(COLOR, forState: .Normal)
        tackBtn.addTarget(self, action: #selector(self.takeTheResume), forControlEvents: .TouchUpInside)
        employmentMessage.addSubview(tackBtn)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
       
        
        return 200
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)as!RecruitTableViewCell
        cell.selectionStyle = .None
        if showType == 1 {
            cell.titImg.image = UIImage(named: "3.png")
            cell.title.text = "儿科主管护士"
            cell.cont.text = "学历要求：中专\n工作年限\n相关证件：护士证"
            cell.name.text = "北京儿童医院"
        }else{
            cell.titImg.image = UIImage(named: "1.png")
            cell.title.text = "苏丽珍"
            cell.cont.text = "学历：中专\n工作年限：2年\n相关证件：护士证"
            cell.name.text = "苏丽珍"
        }
        cell.title.sizeToFit()
        cell.time.text = "2016/05/25"
        cell.location.text = "北京市"
        cell.content.text = "薪资待遇：5000～8000元\n福利待遇：社保、保持住\n招聘职位：护士／护理（20人）"
        cell.content.sizeToFit()
        cell.cont.sizeToFit()
        
        cell.delivery.addTarget(self, action: #selector(self.resumeOnline), forControlEvents: .TouchUpInside)
        
        return cell
   
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        UIView.animateWithDuration(0.3) {
            self.employmentMessage.frame = CGRectMake(0, 0.5, WIDTH, HEIGHT-154.5)
        }
        
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
