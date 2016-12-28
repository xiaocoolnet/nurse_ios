//
//  NSCircleDetailViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/8.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class NSCircleDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var communityModel = CommunityListDataModel() {
        didSet {
            self.setTableViewHeaderView()
            self.loadData()
        }
    }
    
    var communityId = "" {
        didSet {
            
        }
    }
    
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
        
//        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.communityId != "" {
            self.getCommunityInfo()
        }else{
            self.setTableViewHeaderView()
            self.loadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "护士站 圈子 详情")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "护士站 圈子 详情")
    }
    
    
    func getCommunityInfo() {
        CircleNetUtil.getCommunityInfo(userid: QCLoginUserInfo.currentInfo.userid, cid: communityId) { (success, response) in
            if success {
                self.communityModel = response as! CommunityListDataModel
            }
        }
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
                self.isJoin = true
            }else{
                self.isJoin = false
            }
            self.setTableViewHeaderView()
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
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.removeFromSuperViewOnHide = true
            hud.mode = .text
            hud.label.text = "您已加入该圈子"
            hud.hide(animated: true, afterDelay: 1.5)
            return
        }else{
            CircleNetUtil.addCommunity(userid: QCLoginUserInfo.currentInfo.userid, cid: communityModel.id, handle: { (success, response) in
                if success {
                    joinBtn.isSelected = !joinBtn.isSelected
                    joinBtn.backgroundColor = joinBtn.isSelected ? COLOR:UIColor.white
                    self.isJoin = !self.isJoin
                }
            })
        }

    }
    
    // MARK:- tableView click
    func tableViewHeaderViewClick() {
        let circleHomeController = NSCircleHomeViewController()
        circleHomeController.communityModel = self.communityModel
        circleHomeController.isJoin = self.isJoin
        self.navigationController?.pushViewController(circleHomeController, animated: true)
    }
    
    // MARK: - moreBtnClick
    fileprivate var currentForumModel = ForumListDataModel()
    func moreBtnClick(_ moreBtn:UIButton) {
        print(moreBtn.tag)
        
        currentForumModel = self.forumModelArray[moreBtn.tag-100]
        
        var labelTextArray = [String]()
        var labelTextColorArray = [UIColor]()
        
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
        
        self.showSheet(with: labelTextArray, buttonTitleColorArray: labelTextColorArray, forumId: self.forumModelArray[moreBtn.tag-100].id)
        
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
        
        cell.imgBtn.tag = 200+indexPath.row
        cell.imgBtn.addTarget(self, action: #selector(userInfoBtnClick(userInfoBtn:)), for: .touchUpInside)
        
        cell.moreBtn.tag = 100+indexPath.row
        cell.moreBtn.addTarget(self, action: #selector(moreBtnClick(_:)), for: .touchUpInside)
        
        return cell
    }
    
    // MARK: - 用户主页按钮点击事件
    func userInfoBtnClick(userInfoBtn:UIButton) {
        
        let circleUserInfoController = NSCircleUserInfoViewController()
        circleUserInfoController.userid = forumModelArray[userInfoBtn.tag-200].userid
        self.navigationController?.pushViewController(circleUserInfoController, animated: true)
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
        if indexPath.section == 0 && forumBestOrTopModelArray.count > 0 {
            forumDetailController.forumDataModel = self.forumBestOrTopModelArray[indexPath.row]
        }else{
            forumDetailController.forumDataModel = self.forumModelArray[indexPath.row]
        }
        self.navigationController?.pushViewController(forumDetailController, animated: true)

    }
    
    // MARK: - 数据
    func getReportArray() -> [String] {
        let reportArray = ["诽谤辱骂","淫秽色情","垃圾广告","血腥暴力","欺诈（酒托、话费托等行为）","违法行为（涉毒、暴恐、违禁品等行为）"]
        return reportArray
    }
    func getRewardArray() -> [String] {
        let rewardArray = ["1","2","5","10"]
        return rewardArray
    }
    
    // MARK: - 显示举报弹窗
    func showReportAlert(with forumId:String) {
        
        let buttonFontSize:CGFloat = 14
        let animateWithDuration = 0.3
        
        let bgView = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT))
        bgView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        bgView.addTarget(self, action: #selector(alertCancel(_:)), for: .touchUpInside)
        UIApplication.shared.keyWindow?.addSubview(bgView)
        
        let alert = UIView(frame: CGRect(x: WIDTH*0.06, y: HEIGHT, width: WIDTH*0.88, height: 0))
        alert.backgroundColor = UIColor.white
        alert.layer.cornerRadius = 8
        bgView.addSubview(alert)
        
        let titleLab = UILabel(frame: CGRect(x: 0, y: 20, width: alert.frame.width, height: UIFont.systemFont(ofSize: 18).lineHeight))
        titleLab.font = UIFont.systemFont(ofSize: 18)
        titleLab.textAlignment = .center
        titleLab.textColor = UIColor.black
        titleLab.text = "请告诉我们您举报的理由"
        alert.addSubview(titleLab)
        
        let buttonHeight:CGFloat = 30
        let buttonMargin:CGFloat = 10
        var buttonWidth:CGFloat = (alert.frame.width-116-buttonMargin)/2.0
        var buttonX:CGFloat = 58
        var buttonY = titleLab.frame.maxY+25
        
        for (i,buttonTitle) in getReportArray().enumerated() {
            switch i {
            case 0:
                buttonX = 58
                buttonWidth = 125
                
            case 1:
                buttonX = 58+(buttonWidth+buttonMargin)
                buttonWidth = 125
                
            case 2:
                buttonY = buttonY+buttonHeight+buttonMargin
                buttonX = 58
                buttonWidth = 125
                
            case 3:
                buttonX = 58+(buttonWidth+buttonMargin)
                buttonWidth = 125
                
            case 4:
                buttonY = buttonY+buttonHeight+buttonMargin
                buttonX = 58
                buttonWidth = alert.frame.width-116
                
            case 5:
                buttonY = buttonY+buttonHeight+buttonMargin
                buttonX = 58
                buttonWidth = alert.frame.width-116
                
            default:
                break
            }
            
            let button = UIButton(frame: CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight))
            button.tag = 1000+i
            button.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.layer.cornerRadius = 3
            button.layer.borderColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1).cgColor
            button.layer.borderWidth = 1/UIScreen.main.scale
            
            button.setTitleColor(UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1), for: UIControlState())
            button.setTitleColor(UIColor.white, for: .selected)
            
            button.setTitle(buttonTitle, for: UIControlState())
            
            button.backgroundColor = i == 0 ? COLOR:UIColor.clear
            button.isSelected = i == 0 ? true:false
            
            button.addTarget(self, action: #selector(chooseReportType(_:)), for: .touchUpInside)
            
            alert.addSubview(button)
            
        }
        
        let reportBtn = UIButton(frame: CGRect(x: 35, y: buttonY+buttonHeight+35, width: alert.frame.width-70, height: 40))
        reportBtn.tag = NSString(string: forumId).integerValue
        reportBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        reportBtn.layer.cornerRadius = 6
        reportBtn.setTitle("确认举报", for: UIControlState())
        
        reportBtn.setTitleColor(UIColor.white, for: UIControlState())
        reportBtn.backgroundColor = COLOR
        
        reportBtn.addTarget(self, action: #selector(sureReportBtnClick(_:)), for: .touchUpInside)
        
        alert.addSubview(reportBtn)
        
        alert.frame.size.height = reportBtn.frame.maxY+25
        
        UIView.animate(withDuration: animateWithDuration, animations: {
            
            alert.frame.origin.y = (HEIGHT-alert.frame.size.height)/2.0
        })
    }
    
    // MARK: - 选择举报理由
    func chooseReportType(_ typeBtn:UIButton) {
        
        for subView in (typeBtn.superview?.subviews ?? [UIView]())! {
            if subView.tag >= 1000 && subView.tag <= 2000 {
                if subView is UIButton {
                    let button = subView as! UIButton
                    button.isSelected = false
                    button.backgroundColor = UIColor.clear
                    
                }
            }
        }
        
        typeBtn.isSelected = true
        typeBtn.backgroundColor = COLOR
        
        //        reportType = reportArray[typeBtn.tag-1000]
        //        print(reportType)
        print(getReportArray()[typeBtn.tag-1000])
        
    }
    
    // MARK: - 确认举报
    func sureReportBtnClick(_ rewardBtn:UIButton) {
        
        for subView in (rewardBtn.superview?.subviews ?? [UIView]())! {
            if (subView.tag >= 1000 && subView.tag <= 2000) && subView is UIButton {
                let button = subView as! UIButton
                if button.isSelected {
                    
                    print(button.tag,getReportArray()[button.tag-1000])
                    CircleNetUtil.addReport(userid: QCLoginUserInfo.currentInfo.userid, t_id: String(rewardBtn.tag), score: getReportArray()[button.tag-1000], handle: { (success, response) in
                        
                        self.alertCancel(rewardBtn)
                    })
                }
            }
        }
    }
    
    // MARK: - 显示打赏弹窗
    func showAlert() {
        
        let buttonFontSize:CGFloat = 24
        let animateWithDuration = 0.3
        
        let bgView = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT))
        bgView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        bgView.addTarget(self, action: #selector(alertCancel(_:)), for: .touchUpInside)
        UIApplication.shared.keyWindow?.addSubview(bgView)
        
        let alert = UIView(frame: CGRect(x: WIDTH*0.06, y: HEIGHT, width: WIDTH*0.88, height: 0))
        alert.backgroundColor = UIColor.white
        alert.layer.cornerRadius = 8
        bgView.addSubview(alert)
        
        let titleLab = UILabel(frame: CGRect(x: 0, y: 20, width: alert.frame.width, height: UIFont.systemFont(ofSize: 18).lineHeight))
        titleLab.font = UIFont.systemFont(ofSize: 18)
        titleLab.textAlignment = .center
        titleLab.textColor = UIColor.black
        titleLab.text = "好的文章，就是要打赏"
        alert.addSubview(titleLab)
        
        let noteLab = UILabel(frame: CGRect(x: 0, y: titleLab.frame.maxY+8, width: alert.frame.width, height: UIFont.systemFont(ofSize: 12).lineHeight))
        noteLab.font = UIFont.systemFont(ofSize: 12)
        noteLab.textAlignment = .center
        noteLab.textColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1)
        noteLab.text = "可用护士币：1324"
        alert.addSubview(noteLab)
        
        let buttonWidth:CGFloat = 50
        let buttonMargin = (alert.frame.width-70-buttonWidth*4)/3.0
        
        for (i,buttonTitle) in getRewardArray().enumerated() {
            
            let button = UIButton(frame: CGRect(x: 35+(buttonWidth+buttonMargin)*CGFloat(i), y: noteLab.frame.maxY+25, width: buttonWidth, height: buttonWidth))
            button.tag = 1000+i
            button.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize)
            button.layer.cornerRadius = buttonWidth/2.0
            button.setTitle(buttonTitle, for: UIControlState())
            
            button.setTitleColor(UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1), for: UIControlState())
            button.setTitleColor(UIColor.white, for: .selected)
            
            button.backgroundColor = i == 0 ? COLOR:UIColor(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1)
            button.isSelected = i == 0 ? true:false
            
            button.addTarget(self, action: #selector(chooseRewardCount(_:)), for: .touchUpInside)
            
            alert.addSubview(button)
            
        }
        
        let rewardBtn = UIButton(frame: CGRect(x: 35, y: noteLab.frame.maxY+25+buttonWidth+25, width: alert.frame.width-70, height: 40))
        rewardBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        rewardBtn.layer.cornerRadius = 6
        rewardBtn.setTitle("打赏", for: UIControlState())
        
        rewardBtn.setTitleColor(UIColor.white, for: UIControlState())
        rewardBtn.backgroundColor = COLOR
        
        rewardBtn.addTarget(self, action: #selector(sureRewardBtnClick(_:)), for: .touchUpInside)
        
        alert.addSubview(rewardBtn)
        
        alert.frame.size.height = rewardBtn.frame.maxY+25
        
        UIView.animate(withDuration: animateWithDuration, animations: {
            
            alert.frame.origin.y = (HEIGHT-alert.frame.size.height)/2.0
        })
    }
    
    // MARK: - 选择打赏护士币数量
    func chooseRewardCount(_ countBtn:UIButton) {
        
        for subView in (countBtn.superview?.subviews ?? [UIView]())! {
            if subView.tag >= 1000 && subView.tag <= 2000 {
                if subView is UIButton {
                    let button = subView as! UIButton
                    button.isSelected = false
                    button.backgroundColor = UIColor(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1)
                    
                }
            }
        }
        
        countBtn.isSelected = true
        countBtn.backgroundColor = COLOR
        
        //        rewardCount = rewardArray[countBtn.tag-1000]
        //        print(rewardCount)
        print(countBtn.tag-1000)
        print(getRewardArray()[countBtn.tag-1000])
    }
    
    // MARK: - 确认打赏
    func sureRewardBtnClick(_ rewardBtn:UIButton) {
        
        for subView in (rewardBtn.superview?.subviews ?? [UIView]())! {
            if (subView.tag >= 1000 && subView.tag <= 2000) && subView is UIButton {
                let button = subView as! UIButton
                if button.isSelected {
                    
                    print(button.tag,getRewardArray()[button.tag-1000])
                    alertCancel(rewardBtn)
                    
                }
            }
        }
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
        
        if action.currentTitle == "置顶" {
            alertCancel(action)
            
            if currentForumModel.istop == "1" {
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.removeFromSuperViewOnHide = true
                hud.mode = .text
                hud.label.text = "贴子已置顶"
                hud.hide(animated: true, afterDelay: 1.5)
                return
            }
            CircleNetUtil.forumSetTop(tid: String(action.tag/100), handle: { (success, response) in
                if success {
                    print("置顶贴子成功")
                    if self.communityId != "" {
                        self.getCommunityInfo()
                    }else{
                        self.setTableViewHeaderView()
                        self.loadData()
                    }
                }else{
                    print("置顶贴子失败")
                }
            })
        }else if action.currentTitle == "加精" {
            alertCancel(action)
            if currentForumModel.isbest == "1" {
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.removeFromSuperViewOnHide = true
                hud.mode = .text
                hud.label.text = "贴子已加精"
                hud.hide(animated: true, afterDelay: 1.5)
                return
            }
            CircleNetUtil.forumSetTop(tid: String(action.tag/100), handle: { (success, response) in
                if success {
                    print("加精贴子成功")
                    if self.communityId != "" {
                        self.getCommunityInfo()
                    }else{
                        self.setTableViewHeaderView()
                        self.loadData()
                    }
                }else{
                    print("加精贴子失败")
                }
            })
        }else if action.currentTitle == "举报" {
            alertCancel(action)
            self.showReportAlert(with: String(action.tag/100))
        }else if action.currentTitle == "删除" {
            alertCancel(action)
            self.showSheet(with: ["删除贴子","取消"], buttonTitleColorArray: [UIColor.black,UIColor.lightGray], forumId: String(action.tag/100))
        }else if action.currentTitle == "删除贴子" {
            alertCancel(action)
            print("删除贴子")
            CircleNetUtil.DeleteForum(tid: String(action.tag/100), handle: { (success, response) in
                if success {
                    print("删除贴子成功")
                    if self.communityId != "" {
                        self.getCommunityInfo()
                    }else{
                        self.setTableViewHeaderView()
                        self.loadData()
                    }
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
