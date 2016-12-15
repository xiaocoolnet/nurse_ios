//
//  NSCircleMineViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/6.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class NSCircleMineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    let rootTableView = UITableView(frame: CGRect.zero, style: .Grouped)
    
    var cellNameArray1 = ["我的贴子","认证","管理圈子"]
    var cellImageNameArray1 = ["我的贴子","认证","管理圈子"]

    var cellNameArray2 = ["儿科","内科","护士交友"]
    var cellImageNameArray2 = ["avatar20161210111815639.png","avatar2016112316325312354.png","defaultavatar.png"]
    var cellNoteArray2 = ["1352人参与，5214个帖子","1352人参与，5214个帖子","1352人参与，5214个帖子"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //        self.view.backgroundColor = UIColor.cyanColor()
        self.setSubview()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.defaultStat().pageviewStartWithName("护士站 圈子 我的")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.defaultStat().pageviewEndWithName("护士站 圈子 我的")
    }
    
    // MARK: - 设置子视图
    func setSubview() {
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.whiteColor()
        rootTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-65-45-49)
        rootTableView.backgroundColor = UIColor.whiteColor()
        
        rootTableView.delegate = self
        rootTableView.dataSource = self
        
        rootTableView.registerClass(NSCircleHomeTableViewCell.self, forCellReuseIdentifier: "circleHomeCell")
        
        //        myTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(makeDataSource))
        //        rootTableView.mj_header.beginRefreshing()
        
        //        myTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadData_pullUp))
        
        self.view.addSubview(rootTableView)
        
        self.setTableViewHeaderView()
    }
    
    // MARK: - 设置头视图
    func setTableViewHeaderView() {
        
        let tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 50))
        
//        let messageCount = "2"
//        let searchBtn = UIButton(frame: CGRect(x: 8, y: 10, width: WIDTH-16, height: 35))
//        searchBtn.layer.cornerRadius = 6
//        searchBtn.layer.borderColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1).CGColor
//        searchBtn.layer.borderWidth = 1/UIScreen.mainScreen().scale
//        tableHeaderView.addSubview(searchBtn)
//        
//        let searchLab = UILabel(frame: CGRect(x: 8, y: 10, width: WIDTH-16, height: 35))
        
        let search = UISearchBar(frame: CGRect(x: 8, y: 10, width: WIDTH-16, height: 35))
        search.barTintColor = UIColor.whiteColor()
        search.searchBarStyle = .Minimal
//        search.layer.cornerRadius = 6
//        search.layer.borderWidth = 1/UIScreen.mainScreen().scale
//        search.layer.borderColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1).CGColor
        search.placeholder = "大家都在搜：护士那些事"
        search.delegate = self
        tableHeaderView.addSubview(search)
        
        tableHeaderView.frame.size.height = search.frame.maxY+8
        
        rootTableView.tableHeaderView = tableHeaderView
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
        
    // MARK: - UItableViewdatasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("circleHomeCell", forIndexPath: indexPath) as! NSCircleHomeTableViewCell
        
        cell.selectionStyle = .None
        cell.accessoryType = .DisclosureIndicator
        
        if indexPath.section == 0 {
            cell.setCellWith(cellNameArray1[indexPath.row], imageName: cellImageNameArray1[indexPath.row], noteStr: nil)
        }else {
            cell.setCellWith(cellNameArray2[indexPath.row], imageName: cellImageNameArray2[indexPath.row], noteStr: cellNoteArray2[indexPath.row], isNetImage: true)
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 44
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 14
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    //    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //        let footerView = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 35))
    //        footerView.addTarget(self, action: #selector(footerViewClick), forControlEvents: .TouchUpInside)
    //
    //        let nameBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
    //        nameBtn.setImage(UIImage(named: "精华帖"), forState: .Normal)
    //        nameBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
    //        nameBtn.setTitleColor(COLOR, forState: .Normal)
    //        nameBtn.setTitle("内科", forState: .Normal)
    //        nameBtn.sizeToFit()
    //        nameBtn.frame.origin = CGPoint(x: 8, y: (35-nameBtn.frame.height)/2.0)
    //        footerView.addSubview(nameBtn)
    //
    //        let comeinLab = UILabel(frame: CGRect(x: nameBtn.frame.maxX, y: 0, width: WIDTH-nameBtn.frame.maxX-8, height: 35))
    //        comeinLab.textAlignment = .Right
    //        comeinLab.font = UIFont.systemFontOfSize(12)
    //        comeinLab.textColor = COLOR
    //        comeinLab.text = "进入圈子"
    //        footerView.addSubview(comeinLab)
    //
    //        return footerView
    //    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 14))
        headerView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("帖子详情")
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
