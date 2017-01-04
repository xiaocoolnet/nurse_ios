//
//  NSCircleMineViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/6.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class NSCircleMineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    let rootTableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    var cellNameArray1 = ["我的贴子","认证"]
    var cellImageNameArray1 = ["我的贴子","认证","管理圈子"]

    var cellNameArray2 = ["儿科","内科","护士交友"]
    var cellImageNameArray2 = ["avatar20161210111815639.png","avatar2016112316325312354.png","defaultavatar.png"]
    var cellNoteArray2 = ["1352人参与，5214个贴子","1352人参与，5214个贴子","1352人参与，5214个贴子"]
    
    var personAuthData = PersonAuthDataModel()
    
    var communityList = [CommunityListDataModel]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //        self.view.backgroundColor = UIColor.cyanColor()
        self.setSubview()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "护士站 圈子 我的")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "护士站 圈子 我的")
    }
    
    // MARK: - 加载数据
    func loadData() {
        
        var flag = 0
        let total = 3
        
        CircleNetUtil.getMyCommunityList(userid: QCLoginUserInfo.currentInfo.userid, pager: "1") { (success, response) in
            if success {
                self.pager = 2
                self.rootTableView.mj_footer.resetNoMoreData()
                
                self.communityList = response as! [CommunityListDataModel]
                self.rootTableView.reloadData()
            }
            
            flag += 1
            if flag == total {
                
                if self.rootTableView.mj_header.isRefreshing() {
                    self.rootTableView.mj_header.endRefreshing()
                }
            }
        }
        
        CircleNetUtil.getPersonAuth(userid: QCLoginUserInfo.currentInfo.userid, handle: { (success, response) in
            if success {
                self.personAuthData = response as! PersonAuthDataModel
            }
            flag += 1
            if flag == total {
                
                if self.rootTableView.mj_header.isRefreshing() {
                    self.rootTableView.mj_header.endRefreshing()
                }
            }
        })
        
        if QCLoginUserInfo.currentInfo.isCircleManager == "1" {
            self.cellNameArray1 = ["我的贴子","认证","管理圈子"]
            self.rootTableView.reloadData()
            flag += 1
            if flag == total {
                
                if self.rootTableView.mj_header.isRefreshing() {
                    self.rootTableView.mj_header.endRefreshing()
                }
            }
        }else{
            
            CircleNetUtil.judge_apply_community(userid: QCLoginUserInfo.currentInfo.userid, cid: "") { (success, response) in
                if success {
                    if (response as! String) == "yes" {
                        self.cellNameArray1 = ["我的贴子","认证","管理圈子"]
                    }else{
                        self.cellNameArray1 = ["我的贴子","认证"]
                    }
                    self.rootTableView.reloadData()
                }
                flag += 1
                if flag == total {
                    
                    if self.rootTableView.mj_header.isRefreshing() {
                        self.rootTableView.mj_header.endRefreshing()
                    }
                }
            }
            
        }
    }
    
    // MARK: - 加载数据（上拉加载）
    var pager = 1
    func loadData_pullUp() {
        
        CircleNetUtil.getMyCommunityList(userid: QCLoginUserInfo.currentInfo.userid, pager: String(pager)) { (success, response) in
            if success {
                self.pager += 1
                
                let forumModelArray = response as! [CommunityListDataModel]

                
                if forumModelArray.count == 0 {
                    self.rootTableView.mj_footer.endRefreshingWithNoMoreData()
                }else{
                    
                    self.rootTableView.mj_footer.endRefreshing()
                    for forumListData in forumModelArray {
                        self.communityList.append(forumListData)
                    }
                    self.rootTableView.reloadData()
                    
                }
            }else{
                
                self.rootTableView.mj_footer.endRefreshing()
            }
        }
        
    }
    
    // MARK: - 设置子视图
    func setSubview() {
        
        let line = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line.backgroundColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.white
        rootTableView.frame = CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-65-45-49)
        rootTableView.backgroundColor = UIColor.white
        
        rootTableView.delegate = self
        rootTableView.dataSource = self
        
        rootTableView.register(NSCircleHomeTableViewCell.self, forCellReuseIdentifier: "circleHomeCell")
        
        rootTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData))
        rootTableView.mj_header.beginRefreshing()
        
        rootTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadData_pullUp))
        
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
        search.barTintColor = UIColor.white
        search.searchBarStyle = .minimal
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
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.removeFromSuperViewOnHide = true
        
        CircleNetUtil.getForumList(userid: QCLoginUserInfo.currentInfo.userid, cid: "", isbest: "", istop: "", pager: "", title: searchBar.text!) { (success, response) in
            if success {
                
                hud.hide(animated: true)
                
                searchBar.text = ""
                searchBar.resignFirstResponder()
                searchBar.showsCancelButton = false
                
                let forumList = response as! [ForumListDataModel]
                
                let circleSearchResultController = NSCircleSearchResultViewController()
                circleSearchResultController.hidesBottomBarWhenPushed = true
                circleSearchResultController.forumModelArray = forumList
                circleSearchResultController.title = "搜索结果"
                self.navigationController?.pushViewController(circleSearchResultController, animated: true)
            }else{
                hud.mode = .text
                hud.label.text = "搜索失败"
                hud.hide(animated: true, afterDelay: 1)
            }
            
        }
        
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
        
    // MARK: - UItableViewdatasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return cellNameArray1.count
        }else{
            return self.communityList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "circleHomeCell", for: indexPath) as! NSCircleHomeTableViewCell
        
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        
        if indexPath.section == 0 {
            
            if indexPath.row == 1 {
                switch self.personAuthData.status {
                case "-1":// 拒绝
                    cell.setCellWith(cellNameArray1[indexPath.row], imageName: cellImageNameArray1[indexPath.row], noteStr: "已拒绝")
                case "0":// 未认证
                    cell.setCellWith(cellNameArray1[indexPath.row], imageName: cellImageNameArray1[indexPath.row], noteStr: nil)
                case "1":// 通过
                    cell.setCellWith(cellNameArray1[indexPath.row], imageName: cellImageNameArray1[indexPath.row], noteStr: self.personAuthData.auth_type)
                case "2":// 认证中
                    cell.setCellWith(cellNameArray1[indexPath.row], imageName: cellImageNameArray1[indexPath.row], noteStr: "审核中")
                default:
                    cell.setCellWith(cellNameArray1[indexPath.row], imageName: cellImageNameArray1[indexPath.row], noteStr: nil)
                }
            }else{
                cell.setCellWith(cellNameArray1[indexPath.row], imageName: cellImageNameArray1[indexPath.row], noteStr: nil)
            }
            
        }else {
            let communityModel = communityList[indexPath.row]
            var personNum = "\(communityModel.person_num)人"
            
            if NSString(string: communityModel.person_num).doubleValue >= 10000 {
                personNum = NSString(format: "%.2f万人", NSString(string: communityModel.person_num).doubleValue/10000.0) as String
            }
            
            var forumNum = "\(communityModel.f_count)个贴子"
            
            if NSString(string: communityModel.f_count).doubleValue >= 10000 {
                forumNum = NSString(format: "%.2f万个贴子", NSString(string: communityModel.f_count).doubleValue/10000.0) as String
            }

            cell.setCellWith(communityList[indexPath.row].community_name, imageName: communityList[indexPath.row].photo, noteStr: "\(personNum)参与,\(forumNum)", isNetImage: true)
//            cell.setCellWith(cellNameArray2[indexPath.row], imageName: cellImageNameArray2[indexPath.row], noteStr: cellNoteArray2[indexPath.row], isNetImage: true)
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 14
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    //    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //        let footerView = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 35))
    //        footerView.addTarget(self, action: #selector(footerViewClick), forControlEvents: .TouchUpInside)
    //
    //        let nameBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
    //        nameBtn.setImage(UIImage(named: "精华贴"), forState: .Normal)
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 14))
        headerView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("贴子详情")
        
        switch (indexPath.section,indexPath.row) {
        case (0,0):
            self.navigationController?.pushViewController(NSCircleMyForumHomeViewController(), animated: true)
        case (0,1):
            
            switch self.personAuthData.status {
            case "1":// 通过
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.removeFromSuperViewOnHide = true
                hud.mode = .text
                hud.label.text = "您已认证成功"
                hud.hide(animated: true, afterDelay: 1.5)
            case "2":// 认证中
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.removeFromSuperViewOnHide = true
                hud.mode = .text
                hud.label.text = "正在审核中"
                hud.hide(animated: true, afterDelay: 1.5)
            default:
                let circleAuthController = NSCircleAuthViewController()
                circleAuthController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(circleAuthController, animated: true)
            }
            

//            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//            hud.removeFromSuperViewOnHide = true
//            hud.mode = .text
//            hud.label.text = "敬请期待"
//            hud.hide(animated: true, afterDelay: 1.5)
        case (0,2):
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.removeFromSuperViewOnHide = true
            hud.mode = .text
            hud.label.text = "敬请期待"
            hud.hide(animated: true, afterDelay: 1.5)
        default:
            
            let circleDetailController = NSCircleDetailViewController()
            circleDetailController.communityModel = communityList[indexPath.row]
            self.navigationController?.pushViewController(circleDetailController, animated: true)
            break
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
