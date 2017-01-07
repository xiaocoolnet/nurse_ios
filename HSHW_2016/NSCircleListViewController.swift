//
//  NSCircleListViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/6.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class NSCircleListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var titleString = ""
    var term_id = ""// 父类的分类id,全部则传0
    var best = ""// best(选精1,不0)
    var hot = ""// hot(热门1,不0)
    var sort = ""
    
    var showDropDown = false
    
    let circleBtn = ImageBtn()
    let sortBtn = ImageBtn()
    
    let rootTableView = UITableView()
    var communityCateDataArray = [CommunityCateDataModel]()

    var communityModelArray = [CommunityListDataModel]()
    
    var circleArray = [["全部圈子"],["智能排序","关注人数","发帖总量"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //        self.view.backgroundColor = UIColor.cyanColor()
        self.setSubview()
        
//        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "护士站 圈子 列表 \(self.titleString)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "护士站 圈子 列表")
    }
    
    // MARK: - 加载数据
    func loadData() {
        
        var flag = 0
        let total = 2
        
        CircleNetUtil.getChannellist(parentid: "281") { (success, response) in
            if success {
                self.communityCateDataArray = response as! [CommunityCateDataModel]
                
                self.circleArray[0] = ["全部圈子"]
                
                for communityCateData in self.communityCateDataArray {
                    self.circleArray[0].append(communityCateData.name)
                }                
            }else{
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.removeFromSuperViewOnHide = true
                hud.mode = .text
                hud.label.text = "获取圈子分类失败"
                hud.hide(animated: true, afterDelay: 1)
            }
            
            flag += 1
            if flag == total {
                self.rootTableView.mj_header.endRefreshing()
            }
        }
        
        CircleNetUtil.getCommunityList(userid: QCLoginUserInfo.currentInfo.userid, term_id: term_id, best: best, hot: hot, pager: "1", sort: sort) { (success, response) in
            if success {
                self.pager = 2
                self.rootTableView.mj_footer.resetNoMoreData()
                
                self.communityModelArray = response as! [CommunityListDataModel]
                self.rootTableView.reloadData()
            }else{
                
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.removeFromSuperViewOnHide = true
                hud.mode = .text
                hud.label.text = "获取圈子列表失败"
                hud.hide(animated: true, afterDelay: 1)
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
        
        
        CircleNetUtil.getCommunityList(userid: QCLoginUserInfo.currentInfo.userid, term_id: term_id, best: best, hot: hot, pager: "1", sort: sort) { (success, response) in
            if success {
                self.pager += 1

                let communityModelArray = response as! [CommunityListDataModel]
                
                if communityModelArray.count == 0 {
                    self.rootTableView.mj_footer.endRefreshingWithNoMoreData()
                }else{
                    
                    self.rootTableView.mj_footer.endRefreshing()
                    for forumListData in communityModelArray {
                        self.communityModelArray.append(forumListData)
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
        
        self.title = titleString
        let line1 = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line1.backgroundColor = COLOR
        self.view.addSubview(line1)
        
        rootTableView.frame = CGRect(x: 0, y: showDropDown ? 45:1, width: WIDTH, height: showDropDown ? HEIGHT-65-49-44:HEIGHT-65-49)
        rootTableView.backgroundColor = UIColor.white
        
        rootTableView.rowHeight = 76
        
        rootTableView.delegate = self
        rootTableView.dataSource = self
        
        rootTableView.register(UINib(nibName: "NSCircleListTableViewCell", bundle: nil), forCellReuseIdentifier: "circleListCell")
        
        rootTableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadData))
        rootTableView.mj_header.beginRefreshing()

        rootTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadData_pullUp))
        
        self.view.addSubview(rootTableView)
        
        if showDropDown {
            self.setDropDown()
        }
    }
    
    // MARK: - 设置下拉列表
    func setDropDown() {
        // MARK: 下拉列表
        circleBtn.frame = CGRect(x: 0, y: 1, width: WIDTH/2, height: 44)
        circleBtn.tag = 101
        circleBtn.lb_titleColor = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0)
        circleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        circleBtn.resetdataCenter(circleArray.first?.first, UIImage(named: "下拉"))
        circleBtn.addTarget(self, action: #selector(dropDownClick(_:)), for: .touchUpInside)
        self.view.addSubview(circleBtn)
        
        sortBtn.frame = CGRect(x: WIDTH/2, y: 1, width: WIDTH/2, height: 44)
        sortBtn.tag = 102
        sortBtn.lb_titleColor = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0)
        sortBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        sortBtn.resetdataCenter(circleArray.last?.first, UIImage(named: "下拉"))
        sortBtn.addTarget(self, action: #selector(dropDownClick(_:)), for: .touchUpInside)
        self.view.addSubview(sortBtn)
        
        let line2V = UILabel(frame: CGRect(x: WIDTH/2.0, y: 1, width: 1/UIScreen.main.scale, height: 44))
        line2V.backgroundColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
        self.view.addSubview(line2V)
        
        let line2H = UILabel(frame: CGRect(x: 0, y: 44, width: WIDTH, height: 1/UIScreen.main.scale))
        line2H.backgroundColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
        self.view.addSubview(line2H)
    }
    
    // MARK: - 下拉列表点击事件
    func dropDownClick(_ dropDownBtn:ImageBtn) {
        
        if (self.view.viewWithTag(1234) != nil) {
            circleBtn.resetdataCenter(circleBtn.lb_title.text, UIImage(named: "下拉"))
            circleBtn.lb_titleColor = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0)
            sortBtn.resetdataCenter(sortBtn.lb_title.text, UIImage(named: "下拉"))
            sortBtn.lb_titleColor = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0)
            self.view.viewWithTag(1234)?.removeFromSuperview()
            return
        }
        
//        if dropDownBtn == sortBtn {
//            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//            hud.removeFromSuperViewOnHide = true
//            hud.mode = .text
//            hud.label.text = "功能尚未实现"
//            hud.hide(animated: true, afterDelay: 1.5)
//            return
//        }
        
        dropDownBtn.lb_titleColor = COLOR
        dropDownBtn.resetdataCenter(dropDownBtn.lb_title.text, UIImage(named: "下拉（点击）"))
        
        let bgView = UIButton(frame: CGRect(x: 0, y: dropDownBtn.frame.maxY, width: WIDTH, height: HEIGHT-64-45))
        bgView.tag = 1234
        bgView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        bgView.addTarget(self, action: #selector(hideDropDown), for: .touchUpInside)
        self.view.addSubview(bgView)

        
        let dropDownScroolView = UIScrollView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 0))
        dropDownScroolView.backgroundColor = UIColor.white
        bgView.addSubview(dropDownScroolView)
        
        for i in 0 ..< (dropDownBtn == circleBtn ? circleArray[0].count:circleArray[1].count) {
            
            let img = UIImageView(frame: CGRect(x: 8, y: 44*CGFloat(i), width: 10, height: 44))
            img.contentMode = .scaleAspectFit
            img.clipsToBounds = true
            img.image = UIImage(named: "选择圈子")
            dropDownScroolView.addSubview(img)
            
            let button = UIButton(frame: CGRect(x: 26, y: 44*CGFloat(i), width: WIDTH-26-8, height: 44))
            button.contentHorizontalAlignment = .left
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            button.setTitleColor(UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1), for: UIControlState())
            button.setTitleColor(COLOR, for: .selected)
            if dropDownBtn == circleBtn {
                button.tag = 100+i

                button.setTitle(circleArray[0][i], for: UIControlState())
                button.isSelected = circleArray[0][i] == circleBtn.lb_title.text ? true:false
            }else{
                button.tag = 200+i

                button.setTitle(circleArray[1][i], for: UIControlState())
                button.isSelected = circleArray[1][i] == dropDownBtn.lb_title.text ? true:false
            }
            button.addTarget(self, action: #selector(dropBtnClick(_:)), for: .touchUpInside)
            dropDownScroolView.addSubview(button)
            
            let line = UILabel(frame: CGRect(x: 0, y: 44*CGFloat(i)+44, width: WIDTH, height: 1/UIScreen.main.scale))
            line.backgroundColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
            dropDownScroolView.addSubview(line)
            
            img.isHidden = !button.isSelected
            
            dropDownScroolView.contentSize.height = line.frame.maxY
        }
        
        dropDownScroolView.frame.size.height = min(dropDownScroolView.contentSize.height, bgView.frame.height)
        
    }
    
    // MARK: - 隐藏下拉
    func hideDropDown(_ button:UIButton) {
        button.removeFromSuperview()
        circleBtn.resetdataCenter(circleBtn.lb_title.text, UIImage(named: "下拉"))
        circleBtn.lb_titleColor = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0)
        sortBtn.resetdataCenter(sortBtn.lb_title.text, UIImage(named: "下拉"))
        sortBtn.lb_titleColor = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0)
    }
    
    // MARK: - 点击下拉选项
    func dropBtnClick(_ dropBtn:UIButton) {
        print(dropBtn.tag)
        
        if dropBtn.tag < 200 {
            
            circleBtn.resetdataCenter(dropBtn.currentTitle, UIImage(named: "下拉"))
            circleBtn.lb_titleColor = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0)
            
            if dropBtn.tag == 100 {
                self.term_id = ""
            }else{
                self.term_id = self.communityCateDataArray[dropBtn.tag-100-1].term_id
            }
            
            self.rootTableView.mj_header.beginRefreshing()
        }else{
            
            sortBtn.resetdataCenter(dropBtn.currentTitle, UIImage(named: "下拉"))
            sortBtn.lb_titleColor = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0)
            self.sort = String(dropBtn.tag-200)
            
            self.rootTableView.mj_header.beginRefreshing()

        }
        dropBtn.superview?.superview?.removeFromSuperview()

    }
    
    // MARK: - 加入按钮点击事件
    func joinBtnClick(joinBtn:UIButton) {
        
        if requiredLogin(self.navigationController, previousViewController: self, hiddenNavigationBar: false) {
            
        }else{
            return
        }
        
        if joinBtn.isSelected {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.removeFromSuperViewOnHide = true
            hud.mode = .text
            hud.label.text = "您已加入该圈子"
            hud.hide(animated: true, afterDelay: 1.5)
            return
        }else{
            
            CircleNetUtil.addCommunity(userid: QCLoginUserInfo.currentInfo.userid, cid: communityModelArray[joinBtn.tag-100].id, handle: { (success, response) in
                if success {
                    joinBtn.isSelected = true
                    joinBtn.backgroundColor = COLOR
                    self.communityModelArray[joinBtn.tag-100].join = "1"
                }
            })
        }
    }
    
    // MARK: - UItableViewdatasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return communityModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("circleListCell", forIndexPath: indexPath) as! NSCircleListTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "circleListCell") as! NSCircleListTableViewCell
        
        cell.selectionStyle = .none
        
        cell.communityModel = communityModelArray[indexPath.row]
        
        cell.joinBtn.tag = 100+indexPath.row
        cell.joinBtn.addTarget(self, action: #selector(joinBtnClick(joinBtn:)), for: .touchUpInside)
//        cell.setCellWithNewsInfo(forumModelArray[indexPath.section])
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("点击圈子")
        
        let circleDetailController = NSCircleDetailViewController()
        circleDetailController.hidesBottomBarWhenPushed = true
        circleDetailController.communityModel = communityModelArray[indexPath.row]
        circleDetailController.isJoin = communityModelArray[indexPath.row].join == "1" ? true:false
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
