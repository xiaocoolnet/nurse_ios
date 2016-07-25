//
//  FansViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class FansViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    
    var helper = HSMineHelper()
    
    var userType = 0// 0 粉丝  1 关注
    
    
    var fansBtn = UIButton()
    var focusBtn = UIButton()
    
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
        
        // 我的粉丝列表
        fansTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-115)
        fansTableView.backgroundColor = UIColor.clearColor()
        fansTableView.registerClass(FansTableViewCell.self, forCellReuseIdentifier: "cell")
        fansTableView.rowHeight = 70
        fansTableView.tag = 410
        fansTableView.delegate = self
        fansTableView.dataSource = self
        myScrollView.addSubview(fansTableView)
        
        // 我的关注列表
        focusTableView.frame = CGRectMake(WIDTH, 0, WIDTH, HEIGHT-115)
        focusTableView.backgroundColor = UIColor.clearColor()
        focusTableView.registerClass(FansTableViewCell.self, forCellReuseIdentifier: "cell")
        focusTableView.rowHeight = 70
        focusTableView.tag = 411
        focusTableView.delegate = self
        focusTableView.dataSource = self
        myScrollView.addSubview(focusTableView)
        
        myScrollView.contentOffset = userType == 0 ? CGPointMake(CGRectGetMinX(self.fansTableView.frame), CGRectGetMinY(self.fansTableView.frame)):CGPointMake(CGRectGetMinX(self.focusTableView.frame), CGRectGetMinY(self.focusTableView.frame))
        
        // Do any additional setup after loading the view.
    }
    
    // 设置 TitleView
    func setTitleView() {
        let titleBgView = UIView.init(frame: CGRectMake(0, 0, WIDTH/2.0, 44))
        
        // 我的粉丝按钮
        fansBtn = UIButton.init(frame: CGRectMake(0, 0, CGRectGetWidth(titleBgView.frame)/2.0, CGRectGetHeight(titleBgView.frame)))
        fansBtn.setTitle("我的粉丝", forState: .Normal)
        fansBtn.setTitleColor(UIColor.init(red: 157/255.0, green: 158/255.0, blue: 159/255.0, alpha: 1), forState: .Normal)
        fansBtn.setTitleColor(UIColor.init(red: 145/255.0, green: 0, blue: 105/255.0, alpha: 1), forState: .Selected)
        fansBtn.addTarget(self, action: #selector(self.fansBtnClick(_:)), forControlEvents: .TouchUpInside)
        fansBtn.selected = userType==0 ? true:false
        titleBgView.addSubview(fansBtn)
        
        // 我的关注按钮
        focusBtn = UIButton.init(frame: CGRectMake(CGRectGetMaxX(fansBtn.frame), 0, CGRectGetWidth(titleBgView.frame)-CGRectGetMaxX(fansBtn.frame), CGRectGetHeight(titleBgView.frame)))
        focusBtn.setTitle("我的关注", forState: .Normal)
        focusBtn.setTitleColor(UIColor.init(red: 157/255.0, green: 158/255.0, blue: 159/255.0, alpha: 1), forState: .Normal)
        focusBtn.setTitleColor(UIColor.init(red: 145/255.0, green: 0, blue: 105/255.0, alpha: 1), forState: .Selected)
        focusBtn.addTarget(self, action: #selector(self.focusBtnClick(_:)), forControlEvents: .TouchUpInside)
        focusBtn.selected = userType==1 ? true:false
        titleBgView.addSubview(focusBtn)
        
        // 线
        navigationBarLineView = UIView.init(frame: CGRectMake(userType == 0 ? CGRectGetMinX(fansBtn.frame):CGRectGetMinX(focusBtn.frame), CGRectGetMaxY(fansBtn.frame)-5, CGRectGetWidth(fansBtn.frame), 5))
        navigationBarLineView.backgroundColor = UIColor.init(red: 145/255.0, green: 0, blue: 105/255.0, alpha: 1)
        titleBgView.addSubview(navigationBarLineView)
        
        self.navigationItem.titleView = titleBgView
    }
    
    // 我的粉丝按钮 点击事件
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
    
    // 我的关注按钮 点击事件
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
    
    private var fansListArray:Array<HSFansAndFollowModel> = []
    private var focusListArray:Array<HSFansAndFollowModel> = []
    
    // 加载数据
    func loadData() {
        
        helper.getFansOrFollowList(1) { (success, response) in
            self.fansListArray = response as! Array<HSFansAndFollowModel>
            self.fansTableView.reloadData()
        }
        
        helper.getFansOrFollowList(2) { (success, response) in
            self.focusListArray = response as! Array<HSFansAndFollowModel>
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
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)as!FansTableViewCell
        cell.selectionStyle = .None
        cell.accessoryType = .DisclosureIndicator

        if tableView.tag == 410 {
            cell.fansModel = fansListArray[indexPath.row]
        }else if tableView.tag == 411{
            cell.followModel = focusListArray[indexPath.row]
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        let userPageVC = HSUserPageViewController()
        userPageVC.userid = fansListArray[indexPath.row].userid
        
        self.navigationController?.pushViewController(userPageVC, animated: true)
    }
    
    // MARK: UIScrollView 代理方法
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 {
            fansBtnClick(fansBtn)
        }else if scrollView.contentOffset.x == WIDTH {
            focusBtnClick(focusBtn)
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
