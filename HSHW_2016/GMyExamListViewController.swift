//
//  GMyExamListViewController.swift
//  HSHW_2016
//
//  Created by DreamCool on 16/7/17.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class GMyExamListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    
    var helper = HSMineHelper()
    
    var examType = 0// 0 每日一练  1 在线考试
    
    var dailyBtn = UIButton()
    var examBtn = UIButton()
    
    let myScrollView = UIScrollView()
    let fansTableView = UITableView()
    let focusTableView = UITableView()
    
    var navigationBarLineView = UIView()
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.navigationBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        setTitleView()
        
        // 线
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        // 总滚动视图
        myScrollView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-115)
        myScrollView.contentSize = CGSizeMake(WIDTH*2.0, HEIGHT-115)
        myScrollView.pagingEnabled = true
        myScrollView.showsHorizontalScrollIndicator = false
        myScrollView.delegate = self
        self.view.addSubview(myScrollView)
        
        // 每日一练列表
        fansTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-115)
        fansTableView.backgroundColor = UIColor.clearColor()
        fansTableView.registerClass(GMyExamListTableViewCell.self, forCellReuseIdentifier: "cell")
        fansTableView.rowHeight = 70
        fansTableView.tag = 410
        fansTableView.delegate = self
        fansTableView.dataSource = self
        myScrollView.addSubview(fansTableView)
        
        // 在线考试列表
        focusTableView.frame = CGRectMake(WIDTH, 0, WIDTH, HEIGHT-115)
        focusTableView.backgroundColor = UIColor.clearColor()
        focusTableView.registerClass(GMyExamListTableViewCell.self, forCellReuseIdentifier: "cell")
        focusTableView.rowHeight = 70
        focusTableView.tag = 411
        focusTableView.delegate = self
        focusTableView.dataSource = self
        myScrollView.addSubview(focusTableView)
        
        myScrollView.contentOffset = CGPointMake(CGRectGetMinX(self.fansTableView.frame), CGRectGetMinY(self.fansTableView.frame))
        
        // Do any additional setup after loading the view.
    }
    
    // 设置 TitleView
    func setTitleView() {
        let titleBgView = UIView.init(frame: CGRectMake(0, 0, WIDTH/2.0, 44))
        
        // 每日一练按钮
        dailyBtn = UIButton.init(frame: CGRectMake(0, 0, CGRectGetWidth(titleBgView.frame)/2.0, CGRectGetHeight(titleBgView.frame)))
        dailyBtn.setTitle("每日一练", forState: .Normal)
        dailyBtn.setTitleColor(UIColor.init(red: 157/255.0, green: 158/255.0, blue: 159/255.0, alpha: 1), forState: .Normal)
        dailyBtn.setTitleColor(UIColor.init(red: 145/255.0, green: 0, blue: 105/255.0, alpha: 1), forState: .Selected)
        dailyBtn.addTarget(self, action: #selector(self.fansBtnClick(_:)), forControlEvents: .TouchUpInside)
        dailyBtn.selected = true
        titleBgView.addSubview(dailyBtn)
        
        // 在线考试按钮
        examBtn = UIButton.init(frame: CGRectMake(CGRectGetMaxX(dailyBtn.frame), 0, CGRectGetWidth(titleBgView.frame)-CGRectGetMaxX(dailyBtn.frame), CGRectGetHeight(titleBgView.frame)))
        examBtn.setTitle("在线考试", forState: .Normal)
        examBtn.setTitleColor(UIColor.init(red: 157/255.0, green: 158/255.0, blue: 159/255.0, alpha: 1), forState: .Normal)
        examBtn.setTitleColor(UIColor.init(red: 145/255.0, green: 0, blue: 105/255.0, alpha: 1), forState: .Selected)
        examBtn.addTarget(self, action: #selector(self.focusBtnClick(_:)), forControlEvents: .TouchUpInside)
        titleBgView.addSubview(examBtn)
        
        // 线
        navigationBarLineView = UIView.init(frame: CGRectMake(CGRectGetMinX(dailyBtn.frame), CGRectGetMaxY(dailyBtn.frame)-5, CGRectGetWidth(dailyBtn.frame), 5))
        navigationBarLineView.backgroundColor = UIColor.init(red: 145/255.0, green: 0, blue: 105/255.0, alpha: 1)
        titleBgView.addSubview(navigationBarLineView)
        
        self.navigationItem.titleView = titleBgView
    }
    
    // 每日一练按钮 点击事件
    func fansBtnClick(fineBtn: UIButton) {
        fineBtn.selected = true
        for subView in (fineBtn.superview?.subviews)! {
            if subView .isKindOfClass(UIButton.classForCoder()) {
                if subView != fineBtn {
                    (subView as! UIButton).selected = false
                }
            }
            
        }
        
        UIView.animateWithDuration(0.3) {
            self.navigationBarLineView.frame = CGRectMake(CGRectGetMinX(fineBtn.frame), CGRectGetMaxY(fineBtn.frame)-5, CGRectGetWidth(fineBtn.frame), 5)
            self.myScrollView.contentOffset = CGPointMake(CGRectGetMinX(self.fansTableView.frame), CGRectGetMinY(self.fansTableView.frame))
        }
    }
    
    // 在线考试按钮 点击事件
    func focusBtnClick(focusBtn: UIButton) {
        focusBtn.selected = true
        for subView in (focusBtn.superview?.subviews)! {
            if subView .isKindOfClass(UIButton.classForCoder()) {
                if subView != focusBtn {
                    (subView as! UIButton).selected = false
                }
            }
            
        }
        UIView.animateWithDuration(0.3) {
            self.navigationBarLineView.frame = CGRectMake(CGRectGetMinX(focusBtn.frame), CGRectGetMaxY(focusBtn.frame)-5, CGRectGetWidth(focusBtn.frame), 5)
            self.myScrollView.contentOffset = CGPointMake(CGRectGetMinX(self.focusTableView.frame), CGRectGetMinY(self.focusTableView.frame))
        }
    }
    
    private var fansListArray:Array<GTestExamList> = []
    private var focusListArray:Array<GTestExamList> = []
    
    // 加载数据
    func loadData() {
        
        helper.GetExampaper(QCLoginUserInfo.currentInfo.userid, type: "1") { (success, response) in
            self.fansListArray = response as! Array<GTestExamList>
            self.fansTableView.reloadData()
        }
        
        helper.GetExampaper(QCLoginUserInfo.currentInfo.userid, type: "2") { (success, response) in
            self.focusListArray = response as! Array<GTestExamList>
            self.focusTableView.reloadData()
        }
    }
    
    // MARK: tableView 代理方法
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 410 {
            return fansListArray.count
        }else{
            return focusListArray.count
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! GMyExamListTableViewCell
        cell.selectionStyle = .None
        cell.inde = indexPath.row
        
        if tableView.tag == 410 {
            cell.fansModel = fansListArray[indexPath.row] 
        }else if tableView.tag == 411{
            cell.fansModel = focusListArray[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        let userPageVC = GMyExaminationViewController()

        userPageVC.type = 1
        if tableView.tag == 410 {
            userPageVC.subType = 1
            userPageVC.dataSource = fansListArray[indexPath.row].question
        }else{
            userPageVC.subType = 2
            userPageVC.dataSource = focusListArray[indexPath.row].question
        }
        
        
        self.navigationController?.pushViewController(userPageVC, animated: true)
    }
    
    // MARK: UIScrollView 代理方法
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 {
            fansBtnClick(dailyBtn)
        }else if scrollView.contentOffset.x == WIDTH {
            focusBtnClick(examBtn)
        }
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
