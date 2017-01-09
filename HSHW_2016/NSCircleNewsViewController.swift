//
//  NSCircleNewsViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2017/1/6.
//  Copyright © 2017年 校酷网络科技公司. All rights reserved.
//

import UIKit

class NSCircleNewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let rootTableView = UITableView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT-20-44), style: .plain)
    
    var newsListDataArray = [NewsListDataModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setNavigationBar()
        setSubviews()
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: 设置 NavigationBar
    func setNavigationBar() {
        
        self.title = "我的消息"
        
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_返回_white"), style: .done, target: self, action: #selector(popViewcontroller))
    }
    
    
    // MARK: - 加载数据
    func loadData() {
        
        CircleNetUtil.getMyMessageList(userid: QCLoginUserInfo.currentInfo.userid, pager: "1") { (success, response) in
            
            if success {
                self.pager = 2
                self.rootTableView.mj_footer.resetNoMoreData()
                
                self.newsListDataArray = response as! [NewsListDataModel]
                UserDefaults.standard.setValue((self.newsListDataArray.first?.create_time ?? newsUpdateTime)!, forKey: newsUpdateTime)
                self.rootTableView.reloadData()
            }else{
                
            }
            
            if self.rootTableView.mj_header.isRefreshing() {
                self.rootTableView.mj_header.endRefreshing()
            }
        }
    }
    
    // MARK: - 加载数据（上拉加载）
    var pager = 1
    func loadData_pullUp() {
        
        CircleNetUtil.getMyMessageList(userid: QCLoginUserInfo.currentInfo.userid, pager: String(pager)) { (success, response) in
            
            if success {
                self.pager += 1

                let newsListDataArray = response as! [NewsListDataModel]
                
                if newsListDataArray.count == 0 {
                    self.rootTableView.mj_footer.endRefreshingWithNoMoreData()
                }else{
                    
                    self.rootTableView.mj_footer.endRefreshing()
                    for forumListData in newsListDataArray {
                        self.newsListDataArray.append(forumListData)
                    }
                    self.rootTableView.reloadData()
                    
                }
                
            }else{
                
                self.rootTableView.mj_footer.endRefreshing()

            }
        }
        
    }
    
    // MARK: popViewcontroller
    func popViewcontroller() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: 设置子视图
    func setSubviews() {
        
//        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
        
        let line = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        // tableView
        rootTableView.frame = CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-20-44)
        rootTableView.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
        rootTableView.register(UINib.init(nibName: "NSCircleNewsTableViewCell", bundle: nil), forCellReuseIdentifier: "circleNewsCell")
        rootTableView.dataSource = self
        rootTableView.delegate = self
        self.view.addSubview(rootTableView)
        
        rootTableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadData))
        rootTableView.mj_header.beginRefreshing()
        
        rootTableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadData_pullUp))
    }
    
    // MARK: UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsListDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "circleNewsCell") as! NSCircleNewsTableViewCell
        
        
        cell.selectionStyle = .none
        
        cell.newsListDataModel = self.newsListDataArray[indexPath.row]
        cell.headerBtn.tag = 100 + indexPath.row
        cell.headerBtn.addTarget(self, action: #selector(userInfoBtnClick(userInfoBtn:)), for: .touchUpInside)
        
        return cell
    }
    
    // MARK: - 用户主页按钮点击事件
    func userInfoBtnClick(userInfoBtn:UIButton) {
        
        let circleUserInfoController = NSCircleUserInfoViewController()
        circleUserInfoController.userid = newsListDataArray[userInfoBtn.tag-100].from_userid
        self.navigationController?.pushViewController(circleUserInfoController, animated: true)
    }

    
    // MARK: UITableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //        let cell = FTMeSysMessageTableViewCell()
        
        return 89
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        self.navigationController?.pushViewController(CHSChPersonalInfoViewController(), animated: true)
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
