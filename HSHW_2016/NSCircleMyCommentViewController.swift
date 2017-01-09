//
//  NSCircleMyCommentViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class NSCircleMyCommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    let rootTableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    var forumModelArray = [ForumListDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //        self.view.backgroundColor = UIColor.cyanColor()
        self.setSubview()
        
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "护士站 圈子 我的贴子 评论")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "护士站 圈子 我的贴子 评论")
    }
    
    // MARK: - 加载数据
    func loadData() {
        
        CircleNetUtil.getMyJudgeCommunity(userid: QCLoginUserInfo.currentInfo.userid, pager: "1") { (success, response) in
            if success {
                self.pager = 2
                self.rootTableView.mj_footer.resetNoMoreData()
                
                self.forumModelArray = response as! [ForumListDataModel]
                self.rootTableView.reloadData()
            }
            
            if self.rootTableView.mj_header.isRefreshing() {
                self.rootTableView.mj_header.endRefreshing()
            }
        }
    }
    
    // MARK: - 加载数据（上拉加载）
    var pager = 1
    func loadData_pullUp() {
        
        CircleNetUtil.getMyJudgeCommunity(userid: QCLoginUserInfo.currentInfo.userid, pager: "1") { (success, response) in
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
        self.view.backgroundColor = UIColor.white
        
        let line = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line.backgroundColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.white
        rootTableView.frame = CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-65-45)
        rootTableView.backgroundColor = UIColor.white
        
        rootTableView.delegate = self
        rootTableView.dataSource = self
        
        rootTableView.register(NSCircleDetailTableViewCell.self, forCellReuseIdentifier: "circleDetailCell")
        
        rootTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData))
        rootTableView.mj_header.beginRefreshing()
        
        rootTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadData_pullUp))
        
        self.view.addSubview(rootTableView)
        
    }
    
    // MARK: - moreBtnClick
    func moreBtnClick(_ moreBtn:UIButton) {
        print(moreBtn.tag)
        
        let labelTextArray = ["删除","取消"]
        let labelTextColorArray = [UIColor.black,UIColor.lightGray]
        
        self.showSheet(with: labelTextArray, buttonTitleColorArray: labelTextColorArray, forumId: self.forumModelArray[moreBtn.tag-100].id)
        
        
    }
    
    // MARK: - UItableViewdatasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return forumModelArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "circleDetailCell", for: indexPath) as! NSCircleDetailTableViewCell
        
        cell.selectionStyle = .none
        
        cell.setCellWith(forumModelArray[indexPath.section])
        
        cell.moreBtn.tag = 100+indexPath.row
        cell.moreBtn.addTarget(self, action: #selector(moreBtnClick(_:)), for: .touchUpInside)
        
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
            
            return 55+8+height+8+contentHeight+8+8+8+5// 个人信息高+上边距+标题高+间距+内容高+间距+点赞评论按钮高+下边距
        }else if forum.photo.count < 3 {
            let height = calculateHeight((forum.title), size: titleSize, width: WIDTH-16-110-8)
            
            
            var contentHeight = calculateHeight((forum.content), size: contentSize, width: WIDTH-16-110-8)
            if contentHeight >= UIFont.systemFont(ofSize: contentSize).lineHeight*3 {
                contentHeight = UIFont.systemFont(ofSize: contentSize).lineHeight*2
            }
            
            let cellHeight1:CGFloat = 80+8+8+8// 上边距+图片高+下边距
            let cellHeight2 = 8+height+8+contentHeight+8+8+8// 上边距+标题高+间距+内容高+间距+点赞评论按钮高+下边距
            
            
            return max(cellHeight1, cellHeight2)+55+5
        }else{
            let height = calculateHeight((forum.title), size: titleSize, width: WIDTH-16)
            
            
            var contentHeight = calculateHeight((forum.content), size: contentSize, width: WIDTH-16)
            if contentHeight >= UIFont.systemFont(ofSize: contentSize).lineHeight*3 {
                contentHeight = UIFont.systemFont(ofSize: contentSize).lineHeight*2
            }
            
            let imgHeight = (WIDTH-16-15*2)/3.0*2/3.0
            
            return 55+8+height+8+contentHeight+8+imgHeight+8+8+8+5// 个人信息高+上边距+标题高+间距+内容高+间距+图片高+间距+点赞评论按钮高+下边距
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 35))
        footerView.tag = 100 + section
        footerView.addTarget(self, action: #selector(footerViewClick(footerBtn:)), for: .touchUpInside)
        
        let img = UIImageView(frame: CGRect(x: 8, y: 8, width: 25, height: 19))
        img.sd_setImage(with: URL(string: SHOW_IMAGE_HEADER+forumModelArray[section].community_photo), placeholderImage: nil)
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        footerView.addSubview(img)
        
        let nameBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
        nameBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        nameBtn.setTitleColor(COLOR, for: UIControlState())
        nameBtn.setTitle(forumModelArray[section].community_name, for: UIControlState())
        nameBtn.sizeToFit()
        nameBtn.frame.origin = CGPoint(x: img.frame.maxX+5, y: (35-nameBtn.frame.height)/2.0)
        footerView.addSubview(nameBtn)
        
        let comeinLab = UILabel(frame: CGRect(x: nameBtn.frame.maxX, y: 0, width: WIDTH-nameBtn.frame.maxX-8, height: 35))
        comeinLab.textAlignment = .right
        comeinLab.font = UIFont.systemFont(ofSize: 12)
        comeinLab.textColor = COLOR
        comeinLab.text = "进入圈子"
        footerView.addSubview(comeinLab)
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 14))
        headerView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("贴子详情")
        
        let circleForumDetailController = NSCircleForumDetailViewController()
        circleForumDetailController.forumDataModel = forumModelArray[indexPath.section]
        self.navigationController?.pushViewController(circleForumDetailController, animated: true)
        //        switch (indexPath.section,indexPath.row) {
        //        case (0,0):
        //        default:
        //            break
        //        }
    }
    
    // footerView 点击事件
    func footerViewClick(footerBtn:UIButton)  {
        print("进入圈子")
        
        let circleDetailController = NSCircleDetailViewController()
        circleDetailController.hidesBottomBarWhenPushed = true
        circleDetailController.communityId = forumModelArray[footerBtn.tag-100].community_id
        self.navigationController?.pushViewController(circleDetailController, animated: true)
    }
    
    // MARK: - 显示加精置顶等弹出 sheet
    func showSheet(with buttonTitleArray:[String], buttonTitleColorArray:[UIColor], forumId:String) {
        
        let buttonFontSize:CGFloat = 15
        let buttonTitleDefaultColor = UIColor.black
        let animateWithDuration = 0.3
        
        let bgView = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT))
        bgView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        bgView.addTarget(self, action: #selector(alertCancel(_:)), for: .touchUpInside)
        UIApplication.shared.keyWindow?.addSubview(bgView)
        
        let alert = UIView(frame: CGRect(x: 0, y: HEIGHT, width: WIDTH, height: 0))
        alert.backgroundColor = UIColor.white
        bgView.addSubview(alert)
        
        for (i,buttonTitle) in buttonTitleArray.enumerated() {
            let button = UIButton(frame: CGRect(x: 0, y: 44*CGFloat(i), width: WIDTH, height: 44))
            
            button.tag = NSString(string: forumId).integerValue*100+i
            button.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize)
            button.setTitle(buttonTitle, for: UIControlState())
            
            button.setTitleColor((i<buttonTitleColorArray.count ? buttonTitleColorArray[i]:buttonTitleDefaultColor), for: UIControlState())
            if i == buttonTitleArray.count-1 {
                button.addTarget(self, action: #selector(alertCancel(_:)), for: .touchUpInside)
            }else{
                button.addTarget(self, action: #selector(alertActionClick(_:)), for: .touchUpInside)
            }
            alert.addSubview(button)
            
            let line = UIView(frame: CGRect(x: 0, y: button.frame.height-1/UIScreen.main.scale, width: button.frame.width, height: 1/UIScreen.main.scale))
            line.backgroundColor = UIColor.lightGray
            button.addSubview(line)
        }
        
        UIView.animate(withDuration: animateWithDuration, animations: {
            
            alert.frame = CGRect(x: 0, y: HEIGHT-44*CGFloat(buttonTitleArray.count), width: WIDTH, height: 44*CGFloat(buttonTitleArray.count))
        })
    }
    
    // MARK: - 弹出 sheet 点击选项
    func alertActionClick(_ action:UIButton) {
        print(action.tag)
        
        if action.currentTitle == "删除" {
            alertCancel(action)
            self.showSheet(with: ["删除贴子","取消"], buttonTitleColorArray: [UIColor.black,UIColor.lightGray], forumId: String(action.tag/100))
        }else if action.currentTitle == "删除贴子" {
            alertCancel(action)
            print("删除贴子")
            CircleNetUtil.DeleteForum(tid: String(action.tag/100), handle: { (success, response) in
                if success {
                    print("删除贴子成功")
                    //                    if self.communityId != "" {
                    //                        self.getCommunityInfo()
                    //                    }else{
                    //                        self.setTableViewHeaderView()
                    //                        self.loadData()
                    //                    }
                }else{
                    print("删除贴子失败")
                }
            })
        }
    }
    
    func alertCancel(_ action:UIView) {
        if action.superview == UIApplication.shared.keyWindow {
            action.removeFromSuperview()
        }else{
            alertCancel(action.superview!)
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
