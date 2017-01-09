//
//  NSCircleAttentionViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2017/1/5.
//  Copyright © 2017年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class NSCircleAttentionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    let rootTableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    var forumModelArray = [ForumListDataModel]()
    var communityModelArray = [CommunityListDataModel]()
    var joinCommunityModelArray = [PublishCommunityDataModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //        self.view.backgroundColor = UIColor.cyanColor()
        self.setSubview()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "护士站 圈子 关注")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "护士站 圈子 关注")
    }
    
    // MARK: - 加载数据
    func loadData() {
        
        var flag = 0
        let total = 1
        
        CircleNetUtil.getFollowForumList(userid: QCLoginUserInfo.currentInfo.userid, pager: "1") { (success, response) in

            if success {
                self.pager = 2
                self.rootTableView.mj_footer.resetNoMoreData()
                
                self.forumModelArray = response as! [ForumListDataModel]
                
                self.rootTableView.reloadData()
            }
            
            flag += 1
            if flag == total {
                self.rootTableView.mj_header.endRefreshing()
            }
        }
        
    }
    
    // MARK: - 加载数据（上拉加载）
    var pager = 1
    func loadData_pullUp() {
        
        CircleNetUtil.getFollowForumList(userid: QCLoginUserInfo.currentInfo.userid, pager: "1") { (success, response) in
            if success {
                self.pager += 1
                
                let forumModelArray = response as! [ForumListDataModel]
                
                if forumModelArray.count == 0 {
                    self.rootTableView.mj_footer.endRefreshingWithNoMoreData()
                }else{
                    
                    self.rootTableView.mj_footer.endRefreshing()
                    for forumListData in forumModelArray {
                        self.forumModelArray.append(forumListData)
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
        
        rootTableView.register(NSCircleAttentionTableViewCell.self, forCellReuseIdentifier: "circleAttentionCell")
        
        rootTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData))
        rootTableView.mj_header.beginRefreshing()
        
        rootTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadData_pullUp))
        
        self.view.addSubview(rootTableView)
        
        let editBtn = UIButton(frame: CGRect(x: WIDTH-50-10, y: HEIGHT-50-64-65-49, width: 50, height: 50))
        editBtn.setImage(UIImage(named: "悬浮按钮"), for: UIControlState())
        editBtn.addTarget(self, action: #selector(editBtnClick), for: .touchUpInside)
//        self.view.addSubview(editBtn)
    }
    
    // MARK: - 悬浮按钮点击事件
    func editBtnClick() {
        print("悬浮按钮   点击")
        
        if requiredLogin(self.navigationController, previousViewController: self, hiddenNavigationBar: false) {
            
        }else{
            return
        }
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.removeFromSuperViewOnHide = true
        
        // 获取我关注的圈子
        CircleNetUtil.getPublishCommunity(userid: QCLoginUserInfo.currentInfo.userid, parentid: "281") { (success, response) in
            
            if success {
                
                self.joinCommunityModelArray = response as! [PublishCommunityDataModel]
                
                if self.joinCommunityModelArray.count == 0 {
                    hud.mode = .text
                    hud.label.text = "请先加入圈子"
                    hud.hide(animated: true, afterDelay: 1)
                }else{
                    hud.hide(animated: true)
                    
                    let circlePostForumController = NSCirclePostForumViewController()
                    circlePostForumController.hidesBottomBarWhenPushed = true
                    circlePostForumController.couldSelectedCircle = true
                    self.navigationController?.pushViewController(circlePostForumController, animated: true)
                }
            }else{
                hud.mode = .text
                hud.label.text = "请稍后再试"
                hud.hide(animated: true, afterDelay: 1)
            }
            
        }
        
    }
    
    // MARK: - UItableView datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return forumModelArray.count > 0 ? forumModelArray.count:1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forumModelArray.count > 0 ? 1:0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "circleAttentionCell", for: indexPath) as! NSCircleAttentionTableViewCell
        
        cell.selectionStyle = .none
        
        cell.setCell(with: forumModelArray[indexPath.section])
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    fileprivate let titleSize:CGFloat = 17
    fileprivate let contentSize:CGFloat = 14
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let forum = forumModelArray[indexPath.section]
        
        if forum.photo.count == 0 {
            
            let height = calculateHeight((forum.title), size: titleSize, width: WIDTH-16)
            
            
            var contentHeight = calculateHeight((forum.content), size: contentSize, width: WIDTH-16)
            if contentHeight >= UIFont.systemFont(ofSize: contentSize).lineHeight*3 {
                contentHeight = UIFont.systemFont(ofSize: contentSize).lineHeight*2
            }
            
            return 8+height+8+contentHeight+8+8+8+5// 上边距+标题高+间距+内容高+间距+点赞评论按钮高+下边距
        }else if forum.photo.count < 3 {
            let height = calculateHeight((forum.title), size: titleSize, width: WIDTH-16-110-8)
            
            
            var contentHeight = calculateHeight((forum.content), size: contentSize, width: WIDTH-16-110-8)
            if contentHeight >= UIFont.systemFont(ofSize: contentSize).lineHeight*3 {
                contentHeight = UIFont.systemFont(ofSize: contentSize).lineHeight*2
            }
            
            let cellHeight1:CGFloat = 8+80+8// 上边距+图片高+下边距
            let cellHeight2 = 8+height+8+contentHeight+8+8+8// 上边距+标题高+间距+内容高+间距+点赞评论按钮高+下边距
            
            
            return max(cellHeight1, cellHeight2)+5
        }else{
            let height = calculateHeight((forum.title), size: titleSize, width: WIDTH-16)
            
            
            var contentHeight = calculateHeight((forum.content), size: contentSize, width: WIDTH-16)
            if contentHeight >= UIFont.systemFont(ofSize: contentSize).lineHeight*3 {
                contentHeight = UIFont.systemFont(ofSize: contentSize).lineHeight*2
            }
            
            let imgHeight = (WIDTH-16-15*2)/3.0*2/3.0
            
            return 8+height+8+contentHeight+8+imgHeight+8+8+8+5// 上边距+标题高+间距+内容高+间距+图片高+间距+点赞评论按钮高+下边距
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return forumModelArray.count > 0 ? 20:100
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 40))
        
        if forumModelArray.count > 0 {
            
            footerView.tag = 100 + section
            footerView.addTarget(self, action: #selector(footerViewClick(footerBtn:)), for: .touchUpInside)
            
            let img = UIImageView(frame: CGRect(x: 8, y: 8, width: 25, height: 24))
            img.sd_setImage(with: URL(string: SHOW_IMAGE_HEADER+forumModelArray[section].community_photo), placeholderImage: nil)
            img.contentMode = .scaleAspectFit
            img.clipsToBounds = true
            footerView.addSubview(img)
            
            let nameBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
            nameBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            nameBtn.setTitleColor(COLOR, for: UIControlState())
            nameBtn.setTitle(forumModelArray[section].community_name, for: UIControlState())
            nameBtn.sizeToFit()
            nameBtn.frame.origin = CGPoint(x: img.frame.maxX+5, y: (40-nameBtn.frame.height)/2.0)
            footerView.addSubview(nameBtn)
            
            let comeinLab = UILabel(frame: CGRect(x: nameBtn.frame.maxX, y: 0, width: WIDTH-nameBtn.frame.maxX-8, height: 40))
            comeinLab.textAlignment = .right
            comeinLab.font = UIFont.systemFont(ofSize: 12)
            comeinLab.textColor = COLOR
            comeinLab.text = "进入圈子"
            footerView.addSubview(comeinLab)
        }
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        if forumModelArray.count > 0 {
            
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 20))
            headerView.backgroundColor = UIColor(white: 0.95, alpha: 1)
            
            return headerView
            
        }else{
            let headerView = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 100))
            headerView.backgroundColor = UIColor(white: 1, alpha: 1)
            headerView.textAlignment = .center
            headerView.text = "暂无贴子"
            
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("贴子详情")
        
        let forumDetailController = NSCircleForumDetailViewController()
        forumDetailController.hidesBottomBarWhenPushed = true
        forumDetailController.forumDataModel = forumModelArray[indexPath.section]
        self.navigationController?.pushViewController(forumDetailController, animated: true)
    }
    
    // footerView 点击事件
    func footerViewClick(footerBtn:UIButton)  {
        print("进入圈子")
        
        let circleDetailController = NSCircleDetailViewController()
        circleDetailController.hidesBottomBarWhenPushed = true
        circleDetailController.communityId = self.forumModelArray[footerBtn.tag-100].community_id
        self.navigationController?.pushViewController(circleDetailController, animated: true)
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
