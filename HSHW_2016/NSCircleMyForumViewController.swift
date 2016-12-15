//
//  NSCircleMyForumViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class NSCircleMyForumViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    let rootTableView = UITableView(frame: CGRect.zero, style: .Grouped)
    
    var forumModelArray = [ForumModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //        self.view.backgroundColor = UIColor.cyanColor()
        self.setSubview()
        
        loadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.defaultStat().pageviewStartWithName("护士站 圈子 我的")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.defaultStat().pageviewEndWithName("护士站 圈子 我的")
    }
    
    func loadData() {
        let forum1 = ForumModel()
        forum1.title = "1请问各位同行，职场新手如何‘谈薪’才合适？"
        forum1.content = "从期望薪资可以看出求职者对自己的定位，符合自己能力及潜力的薪资报价，体现的是对自身能力的认可..."
        forum1.like = "2254"
        forum1.hits = "2255"
        
        let forum2 = ForumModel()
        forum2.title = "2请问各位同行，职场新手如何‘谈薪’才合适？"
        forum2.content = "从期望薪资可以看出求职者对自己的定位，符合自己能力及潜力的薪资报价，体现的是对自身能力的认可..."
        forum2.like = "2254"
        forum2.hits = "2255"
        let photo1 = photoModel()
        photo1.url = "20161202/5840e94624cb0.jpg"
        forum2.photo = [photo1]
        
        let forum3 = ForumModel()
        forum3.title = "3请问各位同行，职场新手如何‘谈薪’才合适？"
        forum3.content = "从期望薪资可以从期望薪资可以看出求职者对自己的定位，符合自己能力及潜力的薪资报价，体现的是对自身能力的认可...从期望薪资可以看出求职者对自己的定位，符合自己能力及潜力的薪资报价，体现的是对自身能力的认可..."
        forum3.like = "2254"
        forum3.hits = "2255"
        let photo2 = photoModel()
        photo2.url = "20161130/583eb4efc6dad.jpg"
        let photo3 = photoModel()
        photo3.url = "20161129/583ce3b933d98.jpg"
        forum3.photo = [photo2,photo3]
        
        let forum4 = ForumModel()
        forum4.title = "4请问各位同行，职场新手如何‘谈薪’才合适？"
        forum4.content = "从期望薪资可以看出求职者对自己的定位，符合自己能力及潜力的薪资报价，体现的是对自身能力的认可..."
        forum4.like = "2254"
        forum4.hits = "2255"
        
        forum4.photo = [photo1,photo2,photo3]
        
        forumModelArray = [forum1,forum2,forum3,forum4]
        
        self.rootTableView.reloadData()
    }
    
    // MARK: - 设置子视图
    func setSubview() {
        self.view.backgroundColor = UIColor.whiteColor()
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.whiteColor()
        rootTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-65-45)
        rootTableView.backgroundColor = UIColor.whiteColor()
        
        rootTableView.delegate = self
        rootTableView.dataSource = self
        
        rootTableView.registerClass(NSCircleDetailTableViewCell.self, forCellReuseIdentifier: "circleDetailCell")
        
        //        myTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(makeDataSource))
        //        rootTableView.mj_header.beginRefreshing()
        
        //        myTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadData_pullUp))
        
        self.view.addSubview(rootTableView)
        
    }
    
    // MARK: - moreBtnClick
    func moreBtnClick(moreBtn:UIButton) {
        print(moreBtn.tag)
        
        let labelTextArray = ["删除","取消"]
        let labelTextColorArray = [UIColor.blackColor(),UIColor.lightGrayColor()]
        
        NSCirclePublicAction.showSheet(with: labelTextArray, buttonTitleColorArray: labelTextColorArray)
        
    }
    
    // MARK: - UItableViewdatasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return forumModelArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("circleDetailCell", forIndexPath: indexPath) as! NSCircleDetailTableViewCell
        
        cell.selectionStyle = .None
        
        cell.setCellWithNewsInfo(forumModelArray[indexPath.section])
        
        cell.moreBtn.tag = 100+indexPath.row
        cell.moreBtn.addTarget(self, action: #selector(moreBtnClick(_:)), forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    private let titleSize:CGFloat = 14
    private let contentSize:CGFloat = 12
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let forum = forumModelArray[indexPath.section]
        
        if forum.photo.count == 0 {
            
            let height = calculateHeight((forum.title), size: titleSize, width: WIDTH-16)
            
            
            var contentHeight = calculateHeight((forum.content), size: contentSize, width: WIDTH-16)
            if contentHeight >= UIFont.systemFontOfSize(contentSize).lineHeight*3 {
                contentHeight = UIFont.systemFontOfSize(contentSize).lineHeight*2
            }
            
            return 55+8+height+8+contentHeight+8+8+8// 个人信息高+上边距+标题高+间距+内容高+间距+点赞评论按钮高+下边距
        }else if forum.photo.count < 3 {
            let height = calculateHeight((forum.title), size: titleSize, width: WIDTH-16-110-8)
            
            
            var contentHeight = calculateHeight((forum.content), size: contentSize, width: WIDTH-16-110-8)
            if contentHeight >= UIFont.systemFontOfSize(contentSize).lineHeight*3 {
                contentHeight = UIFont.systemFontOfSize(contentSize).lineHeight*2
            }
            
            let cellHeight1:CGFloat = 80+8+8+8// 上边距+图片高+下边距
            let cellHeight2 = 8+height+8+contentHeight+8+8+8// 上边距+标题高+间距+内容高+间距+点赞评论按钮高+下边距
            
            
            return max(cellHeight1, cellHeight2)+55
        }else{
            let height = calculateHeight((forum.title), size: titleSize, width: WIDTH-16)
            
            
            var contentHeight = calculateHeight((forum.content), size: contentSize, width: WIDTH-16)
            if contentHeight >= UIFont.systemFontOfSize(contentSize).lineHeight*3 {
                contentHeight = UIFont.systemFontOfSize(contentSize).lineHeight*2
            }
            
            let imgHeight = (WIDTH-16-15*2)/3.0*2/3.0
            
            return 55+8+height+8+contentHeight+8+imgHeight+8+8+8// 个人信息高+上边距+标题高+间距+内容高+间距+图片高+间距+点赞评论按钮高+下边距
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 14
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 35))
        footerView.addTarget(self, action: #selector(footerViewClick), forControlEvents: .TouchUpInside)
        
        let nameBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
        nameBtn.setImage(UIImage(named: "精华帖"), forState: .Normal)
        nameBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        nameBtn.setTitleColor(COLOR, forState: .Normal)
        nameBtn.setTitle("内科", forState: .Normal)
        nameBtn.sizeToFit()
        nameBtn.frame.origin = CGPoint(x: 8, y: (35-nameBtn.frame.height)/2.0)
        footerView.addSubview(nameBtn)
        
        let comeinLab = UILabel(frame: CGRect(x: nameBtn.frame.maxX, y: 0, width: WIDTH-nameBtn.frame.maxX-8, height: 35))
        comeinLab.textAlignment = .Right
        comeinLab.font = UIFont.systemFontOfSize(12)
        comeinLab.textColor = COLOR
        comeinLab.text = "进入圈子"
        footerView.addSubview(comeinLab)
        
        return footerView
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 14))
        headerView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("帖子详情")
        
        switch (indexPath.section,indexPath.row) {
        case (0,0):
            self.navigationController?.pushViewController(NSCircleMyForumHomeViewController(), animated: true)
        default:
            break
        }
    }
    
    // footerView 点击事件
    func footerViewClick()  {
        print("进入圈子")
        
        let circleDetailController = NSCircleDetailViewController()
        circleDetailController.hidesBottomBarWhenPushed = true
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
