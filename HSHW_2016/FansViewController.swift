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
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitleView()

        // 线
        let line = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.white
        
        // 总滚动视图
        myScrollView.frame = CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-115)
        myScrollView.contentSize = CGSize(width: WIDTH*2.0, height: HEIGHT-115)
        myScrollView.isPagingEnabled = true
        myScrollView.showsHorizontalScrollIndicator = false
        myScrollView.delegate = self
        self.view.addSubview(myScrollView)
        
        // 我的粉丝列表
        fansTableView.frame = CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT-115)
        fansTableView.backgroundColor = UIColor.clear
        fansTableView.register(FansTableViewCell.self, forCellReuseIdentifier: "cell")
        fansTableView.rowHeight = 70
        fansTableView.tag = 410
        fansTableView.delegate = self
        fansTableView.dataSource = self
        myScrollView.addSubview(fansTableView)
        
        fansTableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadData_fans))
        fansTableView.mj_header.beginRefreshing()
        
        // 我的关注列表
        focusTableView.frame = CGRect(x: WIDTH, y: 0, width: WIDTH, height: HEIGHT-115)
        focusTableView.backgroundColor = UIColor.clear
        focusTableView.register(FansTableViewCell.self, forCellReuseIdentifier: "cell")
        focusTableView.rowHeight = 70
        focusTableView.tag = 411
        focusTableView.delegate = self
        focusTableView.dataSource = self
        myScrollView.addSubview(focusTableView)
        focusTableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadData_follow))
        focusTableView.mj_header.beginRefreshing()
        
        myScrollView.contentOffset = userType == 0 ? CGPoint(x: self.fansTableView.frame.minX, y: self.fansTableView.frame.minY):CGPoint(x: self.focusTableView.frame.minX, y: self.focusTableView.frame.minY)
        
        // Do any additional setup after loading the view.
    }
    
    // 设置 TitleView
    func setTitleView() {
        let titleBgView = UIView.init(frame: CGRect(x: 0, y: 0, width: WIDTH/2.0, height: 44))
        
        // 我的粉丝按钮
        fansBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: titleBgView.frame.width/2.0, height: titleBgView.frame.height))
        fansBtn.setTitle("我的粉丝", for: UIControlState())
        fansBtn.setTitleColor(UIColor.init(red: 157/255.0, green: 158/255.0, blue: 159/255.0, alpha: 1), for: UIControlState())
        fansBtn.setTitleColor(UIColor.init(red: 145/255.0, green: 0, blue: 105/255.0, alpha: 1), for: .selected)
        fansBtn.addTarget(self, action: #selector(self.fansBtnClick(_:)), for: .touchUpInside)
        fansBtn.isSelected = userType==0 ? true:false
        titleBgView.addSubview(fansBtn)
        
        // 我的关注按钮
        focusBtn = UIButton.init(frame: CGRect(x: fansBtn.frame.maxX, y: 0, width: titleBgView.frame.width-fansBtn.frame.maxX, height: titleBgView.frame.height))
        focusBtn.setTitle("我的关注", for: UIControlState())
        focusBtn.setTitleColor(UIColor.init(red: 157/255.0, green: 158/255.0, blue: 159/255.0, alpha: 1), for: UIControlState())
        focusBtn.setTitleColor(UIColor.init(red: 145/255.0, green: 0, blue: 105/255.0, alpha: 1), for: .selected)
        focusBtn.addTarget(self, action: #selector(self.focusBtnClick(_:)), for: .touchUpInside)
        focusBtn.isSelected = userType==1 ? true:false
        titleBgView.addSubview(focusBtn)
        
        // 线
        navigationBarLineView = UIView.init(frame: CGRect(x: userType == 0 ? fansBtn.frame.minX:focusBtn.frame.minX, y: fansBtn.frame.maxY-5, width: fansBtn.frame.width, height: 5))
        navigationBarLineView.backgroundColor = UIColor.init(red: 145/255.0, green: 0, blue: 105/255.0, alpha: 1)
        titleBgView.addSubview(navigationBarLineView)
        
        self.navigationItem.titleView = titleBgView
    }
    
    // 我的粉丝按钮 点击事件
    func fansBtnClick(_ fineBtn: UIButton) {
        fineBtn.isSelected = true
        for subView in (fineBtn.superview?.subviews)! {
            if subView .isKind(of: UIButton.classForCoder()) {
                if subView != fineBtn {
                    (subView as! UIButton).isSelected = false
                }
            }
            
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.navigationBarLineView.frame = CGRect(x: fineBtn.frame.minX, y: fineBtn.frame.maxY-5, width: fineBtn.frame.width, height: 5)
            self.myScrollView.contentOffset = CGPoint(x: self.fansTableView.frame.minX, y: self.fansTableView.frame.minY)
        }) 
    }
    
    // 我的关注按钮 点击事件
    func focusBtnClick(_ focusBtn: UIButton) {
        focusBtn.isSelected = true
        for subView in (focusBtn.superview?.subviews)! {
            if subView .isKind(of: UIButton.classForCoder()) {
                if subView != focusBtn {
                    (subView as! UIButton).isSelected = false
                }
            }
            
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.navigationBarLineView.frame = CGRect(x: focusBtn.frame.minX, y: focusBtn.frame.maxY-5, width: focusBtn.frame.width, height: 5)
            self.myScrollView.contentOffset = CGPoint(x: self.focusTableView.frame.minX, y: self.focusTableView.frame.minY)
        }) 
    }
    
    fileprivate var fansListArray:Array<FansFollowListDataModel> = []
    fileprivate var focusListArray:Array<FansFollowListDataModel> = []

    // 加载数据
    func loadData_follow() {
        
        CircleNetUtil.getFansFollowList(userid: QCLoginUserInfo.currentInfo.userid, type: "1") { (success, response) in
            self.focusListArray = response as! Array<FansFollowListDataModel>
            self.focusTableView.reloadData()
            
            self.focusTableView.mj_header.endRefreshing()
        }
    }
    
    // 加载数据
    func loadData_fans() {
        
        CircleNetUtil.getFansFollowList(userid: QCLoginUserInfo.currentInfo.userid, type: "2") { (success, response) in
            self.fansListArray = response as! Array<FansFollowListDataModel>
            self.fansTableView.reloadData()
            
            self.fansTableView.mj_header.endRefreshing()
        }
        
    }
    
    // MARK: tableView 代理方法
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 410 {
            return fansListArray.count
        }else{
            return focusListArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as!FansTableViewCell
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator

        if tableView.tag == 410 {
            cell.fansModel = fansListArray[indexPath.row]
        }else if tableView.tag == 411{
            cell.followModel = focusListArray[indexPath.row]
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
        
        let userPageVC = NSCircleUserInfoViewController()
        if tableView.tag == 410 {
            userPageVC.userid = fansListArray[indexPath.row].fid
        }else if tableView.tag == 411{
            userPageVC.userid = focusListArray[indexPath.row].fid
        }
//        userPageVC.focusArray = focusListArray
        
        self.navigationController?.pushViewController(userPageVC, animated: true)
    }
    
    // MARK: UIScrollView 代理方法
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
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
