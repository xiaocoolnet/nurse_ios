//
//  NSCircleListViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/6.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class NSCircleListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let rootTableView = UITableView()
    
    var forumModelArray = [CommunityModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //        self.view.backgroundColor = UIColor.cyanColor()
        self.setSubview()
        
        loadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.defaultStat().pageviewStartWithName("护士站 圈子 列表")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.defaultStat().pageviewEndWithName("护士站 圈子 列表")
    }
    
    func loadData() {
        let forum1 = CommunityModel()
        forum1.community_name = "儿科"
        forum1.description = "儿科是全面研究小儿时期身心发育保健以及疾病防治的综合医学科学..."
        
        let forum2 = CommunityModel()
        forum2.community_name = "内科"
        forum2.description = "内科是全面研究小儿时期身心发育保健以及疾病防治的综合医学科学..."
        
        let forum3 = CommunityModel()
        forum3.community_name = "外科"
        forum3.description = "外科是全面研究小儿时期身心发育保健以及疾病防治的综合医学科学..."
        
        let forum4 = CommunityModel()
        forum4.community_name = "妇产科"
        forum4.description = "妇产科是全面研究小儿时期身心发育保健以及疾病防治的综合医学科学..."
        
        let forum5 = CommunityModel()
        forum5.community_name = "急诊科"
        forum5.description = "急诊科是全面研究小儿时期身心发育保健以及疾病防治的综合医学科学..."
        
        let forum6 = CommunityModel()
        forum6.community_name = "灌水吐槽"
        forum6.description = "儿科是全面研究小儿时期身心发育保健以及疾病防治的综合医学科学..."
        
        forumModelArray = [forum1,forum2,forum3,forum4,forum5,forum6]
        
        self.rootTableView.reloadData()
    }
    
    // MARK: - 设置子视图
    func setSubview() {
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.title = "圈子列表"
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        line.layer.cornerRadius = 6
        line.layer.borderColor = UIColor(red: 145/255.0, green: 26/255.0, blue: 107/255.0, alpha: 1.0).CGColor
        line.layer.borderWidth = 1
        
        
        rootTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-65-49)
        rootTableView.backgroundColor = UIColor.whiteColor()
        
        rootTableView.rowHeight = 76
        
        rootTableView.delegate = self
        rootTableView.dataSource = self
        
        rootTableView.registerNib(UINib(nibName: "NSCircleListTableViewCell", bundle: nil), forCellReuseIdentifier: "circleListCell")
        
        //        myTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(makeDataSource))
        //        rootTableView.mj_header.beginRefreshing()
        
        //        myTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadData_pullUp))
        
        self.view.addSubview(rootTableView)
        
    }
    
    // MARK: - UItableViewdatasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forumModelArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("circleListCell", forIndexPath: indexPath) as! NSCircleListTableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier("circleListCell") as! NSCircleListTableViewCell
        
        cell.selectionStyle = .None
        
        cell.communityModel = forumModelArray[indexPath.row]
//        cell.setCellWithNewsInfo(forumModelArray[indexPath.section])
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("点击圈子")
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
