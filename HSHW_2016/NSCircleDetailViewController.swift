//
//  NSCircleDetailViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/8.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class NSCircleDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var communityModel = CommunityListDataModel()
    
    let rootTableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    var forumModelArray = [ForumListDataModel]()
    var forumBestOrTopModelArray = [ForumListDataModel]()

    var isMaster = false
    var isJoin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //        self.view.backgroundColor = UIColor.cyanColor()
        self.setSubview()
        
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "护士站 圈子 详情")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "护士站 圈子 详情")
    }
    
    func loadData() {
        
        CircleNetUtil.getForumList(userid: QCLoginUserInfo.currentInfo.userid, cid: communityModel.id, isbest: "", istop: "", pager: "1") { (success, response) in
            if success {
                self.forumModelArray = response as! [ForumListDataModel]
                self.rootTableView.reloadData()
            }
        }
        
        CircleNetUtil.getForumList(userid: QCLoginUserInfo.currentInfo.userid, cid: communityModel.id, isbest: "", istop: "1", pager: "1") { (success, response) in
            if success {
                self.forumBestOrTopModelArray = response as! [ForumListDataModel]
                self.rootTableView.reloadData()
            }
        }
        
        CircleNetUtil.judge_apply_community(userid: QCLoginUserInfo.currentInfo.userid, cid: communityModel.id) { (success, response) in
            if success {
                if (response as! String) == "yes" {
                    self.isMaster = true
                }else{
                    self.isMaster = false
                }
            }
        }
      
        CircleNetUtil.judge_Community(userid: QCLoginUserInfo.currentInfo.userid, cid: communityModel.id) { (success, response) in
            if success {
                if (response as? String) == "no" {
                    self.isJoin = false
                }else{
                    self.isJoin = true
                }
                self.setTableViewHeaderView()
            }
        }
    }
    
    // MARK: - 设置子视图
    func setSubview() {
        
        self.title = "圈子详情"
        
        let line = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.white
        rootTableView.frame = CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-65)
        rootTableView.backgroundColor = UIColor.white
        
        rootTableView.delegate = self
        rootTableView.dataSource = self
        
        rootTableView.register(NSCircleDetailTableViewCell.self, forCellReuseIdentifier: "circleDetailCell")
        rootTableView.register(NSCircleDetailTopTableViewCell.self, forCellReuseIdentifier: "circleDetailTopCell")

        //        myTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(makeDataSource))
        //        rootTableView.mj_header.beginRefreshing()
        
        //        myTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadData_pullUp))
        
        self.view.addSubview(rootTableView)
        
        self.setTableViewHeaderView()
        
        let editBtn = UIButton(frame: CGRect(x: WIDTH-50-10, y: HEIGHT-50-64-65, width: 50, height: 50))
        editBtn.setImage(UIImage(named: "悬浮按钮"), for: UIControlState())
        editBtn.addTarget(self, action: #selector(editBtnClick), for: .touchUpInside)
        self.view.addSubview(editBtn)
    }
    
    // MARK: - 悬浮按钮点击事件
    func editBtnClick() {
        print("悬浮按钮   点击")
        
        self.navigationController?.pushViewController(NSCirclePostForumViewController(), animated: true)
    }
    
    // MARK: - 设置头视图
    func setTableViewHeaderView() {
        
        let tableHeaderView = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: WIDTH/375*60+20))
        tableHeaderView.addTarget(self, action: #selector(tableViewHeaderViewClick), for: .touchUpInside)
        
        let btn2Width = WIDTH/375*80

        // 圈子
        let img = UIImageView(frame: CGRect(x: 8, y: 10, width: btn2Width, height: WIDTH/375*60))
        img.backgroundColor = UIColor(red: 243/255.0, green: 229/255.0, blue: 240/255.0, alpha: 1)
        img.contentMode = .center
        img.sd_setImage(with: URL(string: SHOW_IMAGE_HEADER+communityModel.photo), placeholderImage: nil)
        tableHeaderView.addSubview(img)
        
        let nameLab = UILabel(frame: CGRect(x: img.frame.maxX+8, y: img.frame.minY, width: WIDTH-88-btn2Width-16, height: WIDTH/375*30))
        nameLab.textAlignment = .left
        nameLab.font = UIFont.systemFont(ofSize: 18)
        nameLab.textColor = COLOR
        nameLab.text = communityModel.community_name
        tableHeaderView.addSubview(nameLab)
        
        let countLab = UILabel(frame: CGRect(x: img.frame.maxX+8, y: nameLab.frame.maxY, width: WIDTH-88-btn2Width-16, height: WIDTH/375*30))
        countLab.textAlignment = .left
        countLab.font = UIFont.systemFont(ofSize: 12)
        countLab.textColor = UIColor.lightGray
        countLab.adjustsFontSizeToFitWidth = true
        var personNum = "\(communityModel.person_num)人"
        
        if NSString(string: communityModel.person_num).doubleValue >= 10000 {
            personNum = NSString(format: "%.2f万人", NSString(string: communityModel.person_num).doubleValue/10000.0) as String
        }
        
        var forumNum = "\(communityModel.f_count)贴子"
        
        if NSString(string: communityModel.f_count).doubleValue >= 10000 {
            forumNum = NSString(format: "%.2f万贴子", NSString(string: communityModel.f_count).doubleValue/10000.0) as String
        }
        
        countLab.text = "\(personNum) \(forumNum)"
        tableHeaderView.addSubview(countLab)
        
        let joinBtn = UIButton(frame: CGRect(x: WIDTH-88, y: tableHeaderView.frame.height/2.0-15, width: 80, height: 30))
        joinBtn.layer.cornerRadius = 6
        joinBtn.layer.borderColor = COLOR.cgColor
        joinBtn.layer.borderWidth = 1
        joinBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        joinBtn.setTitleColor(COLOR, for: UIControlState())
        joinBtn.setTitleColor(UIColor.white, for: .selected)
        joinBtn.setTitle("加入", for: UIControlState())
        joinBtn.setTitle("已加入", for: .selected)
        joinBtn.setImage(UIImage(named: "加入"), for: UIControlState())
        joinBtn.setImage(UIImage(named: "已加入"), for: .selected)
        joinBtn.addTarget(self, action: #selector(joinBtnClick(_:)), for: .touchUpInside)
        tableHeaderView.addSubview(joinBtn)
//        joinBtn.backgroundColor = COLOR
//        joinBtn.selected = true
        joinBtn.backgroundColor = UIColor.white
//        joinBtn.selected = false
        
        if isJoin {
            joinBtn.backgroundColor = COLOR
            joinBtn.isSelected = true
        }else{
            joinBtn.backgroundColor = UIColor.white
            joinBtn.isSelected = false
        }

        rootTableView.tableHeaderView = tableHeaderView
    }
    
    // MARK: - 加入按钮点击事件
    func joinBtnClick(_ joinBtn:UIButton) {
        
        
        if isJoin {
            
        }else{
            CircleNetUtil.addCommunity(userid: QCLoginUserInfo.currentInfo.userid, cid: communityModel.id, handle: { (success, response) in
                if success {
                    joinBtn.isSelected = !joinBtn.isSelected
                    joinBtn.backgroundColor = joinBtn.isSelected ? COLOR:UIColor.white
                }
            })
        }

    }
    
    // MARK:- tableView click
    func tableViewHeaderViewClick() {
        self.navigationController?.pushViewController(NSCircleHomeViewController(), animated: true)
    }
    
    // MARK: - moreBtnClick
    func moreBtnClick(_ moreBtn:UIButton) {
        print(moreBtn.tag)
        
        
        var labelTextArray = ["加精","置顶","删除","取消"]
        var labelTextColorArray = [COLOR,COLOR,UIColor.black,UIColor.lightGray]
        
        if isMaster {
            labelTextArray = ["加精","置顶","删除","取消"]
            labelTextColorArray = [COLOR,COLOR,UIColor.black,UIColor.lightGray]
        }else if QCLoginUserInfo.currentInfo.userid == self.forumModelArray[moreBtn.tag-100].userid {
            labelTextArray = ["删除","取消"]
            labelTextColorArray = [UIColor.black,UIColor.lightGray]
        }else{
            labelTextArray = ["举报","取消"]
            labelTextColorArray = [UIColor.black,UIColor.lightGray]
        }
        
        NSCirclePublicAction.showSheet(with: labelTextArray, buttonTitleColorArray: labelTextColorArray)
        
    }
    
    // MARK: - UItableViewdatasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return forumBestOrTopModelArray.count <= 0 ? 1:2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && forumBestOrTopModelArray.count > 0 {
            return forumBestOrTopModelArray.count
        }
        return forumModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 && forumBestOrTopModelArray.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "circleDetailTopCell", for: indexPath) as! NSCircleDetailTopTableViewCell
            
            cell.selectionStyle = .none
            
            cell.setCellWith(forumBestOrTopModelArray[indexPath.row])
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "circleDetailCell", for: indexPath) as! NSCircleDetailTableViewCell
        
        cell.selectionStyle = .none
        
        cell.setCellWith(forumModelArray[indexPath.row])
        
        cell.moreBtn.tag = 100+indexPath.row
        cell.moreBtn.addTarget(self, action: #selector(moreBtnClick(_:)), for: .touchUpInside)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    fileprivate let titleSize:CGFloat = 14
    fileprivate let contentSize:CGFloat = 12
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 && forumBestOrTopModelArray.count > 0 {
            return 30
        }
        
        let forum = forumModelArray[indexPath.row]
        
        if forum.photo.count == 0 {
            
            let height = calculateHeight((forum.title), size: titleSize, width: WIDTH-16)
            
            
            var contentHeight = calculateHeight((forum.content), size: contentSize, width: WIDTH-16)
            if contentHeight >= UIFont.systemFont(ofSize: contentSize).lineHeight*3 {
                contentHeight = UIFont.systemFont(ofSize: contentSize).lineHeight*2
            }
            
            return 55+8+height+8+contentHeight+8+8+8// 个人信息高+上边距+标题高+间距+内容高+间距+点赞评论按钮高+下边距
        }else if forum.photo.count < 3 {
            let height = calculateHeight((forum.title), size: titleSize, width: WIDTH-16-110-8)
            
            
            var contentHeight = calculateHeight((forum.content), size: contentSize, width: WIDTH-16-110-8)
            if contentHeight >= UIFont.systemFont(ofSize: contentSize).lineHeight*3 {
                contentHeight = UIFont.systemFont(ofSize: contentSize).lineHeight*2
            }
            
            let cellHeight1:CGFloat = 80+8+8+8// 上边距+图片高+下边距
            let cellHeight2 = 8+height+8+contentHeight+8+8+8// 上边距+标题高+间距+内容高+间距+点赞评论按钮高+下边距
            
            
            return max(cellHeight1, cellHeight2)+55
        }else{
            let height = calculateHeight((forum.title), size: titleSize, width: WIDTH-16)
            
            
            var contentHeight = calculateHeight((forum.content), size: contentSize, width: WIDTH-16)
            if contentHeight >= UIFont.systemFont(ofSize: contentSize).lineHeight*3 {
                contentHeight = UIFont.systemFont(ofSize: contentSize).lineHeight*2
            }
            
            let imgHeight = (WIDTH-16-15*2)/3.0*2/3.0
            
            return 55+8+height+8+contentHeight+8+imgHeight+8+8+8// 个人信息高+上边距+标题高+间距+内容高+间距+图片高+间距+点赞评论按钮高+下边距
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 20))
        headerView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("贴子详情")
        
        let forumDetailController = NSCircleForumDetailViewController()
        forumDetailController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(forumDetailController, animated: true)

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
