//
//  NSCircleDetailViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/8.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class NSCircleDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let rootTableView = UITableView(frame: CGRect.zero, style: .Grouped)
    
    var forumModelArray = [ForumModel]()
    var forumBestOrTopModelArray = [ForumModel]()

    var communityModel = CommunityModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //        self.view.backgroundColor = UIColor.cyanColor()
        self.setSubview()
        
        loadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.defaultStat().pageviewStartWithName("护士站 圈子 详情")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.defaultStat().pageviewEndWithName("护士站 圈子 详情")
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
        
        loadData2()
        
        self.rootTableView.reloadData()
    }
    
    func loadData2() {
        let forum1 = ForumModel()
        forum1.title = "1请问各位同行，职场新手如何‘谈薪’才合适？"
        forum1.content = "从期望薪资可以看出求职者对自己的定位，符合自己能力及潜力的薪资报价，体现的是对自身能力的认可..."
        forum1.like = "2254"
        forum1.hits = "2255"
        forum1.istop = "1"
        
        let forum2 = ForumModel()
        forum2.title = "2请问各位同行，职场新手如何‘谈薪’才合适？"
        forum2.content = "从期望薪资可以看出求职者对自己的定位，符合自己能力及潜力的薪资报价，体现的是对自身能力的认可..."
        forum2.like = "2254"
        forum2.hits = "2255"
        let photo1 = photoModel()
        photo1.url = "20161202/5840e94624cb0.jpg"
        forum2.photo = [photo1]
        forum2.isbest = "1"
        
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
        forum3.istop = "1"
        forum3.isbest = "1"
        
        let forum4 = ForumModel()
        forum4.title = "4请问各位同行，职场新手如何‘谈薪’才合适？"
        forum4.content = "从期望薪资可以看出求职者对自己的定位，符合自己能力及潜力的薪资报价，体现的是对自身能力的认可..."
        forum4.like = "2254"
        forum4.hits = "2255"
        forum4.istop = "1"
        forum4.isbest = "1"
        forum4.isreward = "1"

        forum4.photo = [photo1,photo2,photo3]
        
        forumBestOrTopModelArray = [forum1,forum2,forum3,forum4]
    }
    
    // MARK: - 设置子视图
    func setSubview() {
        
        self.title = "圈子详情"
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.whiteColor()
        rootTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-65)
        rootTableView.backgroundColor = UIColor.whiteColor()
        
        rootTableView.delegate = self
        rootTableView.dataSource = self
        
        rootTableView.registerClass(NSCircleDetailTableViewCell.self, forCellReuseIdentifier: "circleDetailCell")
        rootTableView.registerClass(NSCircleDetailTopTableViewCell.self, forCellReuseIdentifier: "circleDetailTopCell")

        //        myTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(makeDataSource))
        //        rootTableView.mj_header.beginRefreshing()
        
        //        myTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadData_pullUp))
        
        self.view.addSubview(rootTableView)
        
        self.setTableViewHeaderView()
    }
    
    // MARK: - 设置头视图
    func setTableViewHeaderView() {
        
        let tableHeaderView = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: WIDTH/375*60+20))
        tableHeaderView.addTarget(self, action: #selector(tableViewHeaderViewClick), forControlEvents: .TouchUpInside)
        
        let btn2Width = WIDTH/375*80

        // 圈子
        let img = UIImageView(frame: CGRect(x: 8, y: 10, width: btn2Width, height: WIDTH/375*60))
        img.backgroundColor = UIColor(red: 243/255.0, green: 229/255.0, blue: 240/255.0, alpha: 1)
        tableHeaderView.addSubview(img)
        
        let nameLab = UILabel(frame: CGRect(x: img.frame.maxX+8, y: img.frame.minY, width: WIDTH-88-btn2Width-16, height: WIDTH/375*30))
        nameLab.textAlignment = .Left
        nameLab.font = UIFont.systemFontOfSize(18)
        nameLab.textColor = COLOR
        nameLab.text = "儿科"
        tableHeaderView.addSubview(nameLab)
        
        let countLab = UILabel(frame: CGRect(x: img.frame.maxX+8, y: nameLab.frame.maxY, width: WIDTH-88-btn2Width-16, height: WIDTH/375*30))
        countLab.textAlignment = .Left
        countLab.font = UIFont.systemFontOfSize(12)
        countLab.textColor = UIColor.lightGrayColor()
        countLab.adjustsFontSizeToFitWidth = true
        countLab.text = "13.5万人 16.5万帖子"
        tableHeaderView.addSubview(countLab)
        
        let joinBtn = UIButton(frame: CGRect(x: WIDTH-88, y: tableHeaderView.frame.height/2.0-15, width: 80, height: 30))
        joinBtn.layer.cornerRadius = 6
        joinBtn.layer.borderColor = COLOR.CGColor
        joinBtn.layer.borderWidth = 1
        joinBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        joinBtn.setTitleColor(COLOR, forState: .Normal)
        joinBtn.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        joinBtn.setTitle("加入", forState: .Normal)
        joinBtn.setTitle("已加入", forState: .Selected)
        joinBtn.setImage(UIImage(named: "加入"), forState: .Normal)
        joinBtn.setImage(UIImage(named: "已加入"), forState: .Selected)
        tableHeaderView.addSubview(joinBtn)
//        joinBtn.backgroundColor = COLOR
//        joinBtn.selected = true
        joinBtn.backgroundColor = UIColor.clearColor()
        joinBtn.selected = false

        rootTableView.tableHeaderView = tableHeaderView
    }
    
    // MARK:- tableView click
    func tableViewHeaderViewClick() {
        self.navigationController?.pushViewController(NSCircleHomeViewController(), animated: true)
    }
    
    // MARK: - moreBtnClick
    func moreBtnClick(moreBtn:UIButton) {
        print(moreBtn.tag)
        
        let labelTextArray = ["加精","置顶","删除","取消"]
        let labelTextColorArray = [COLOR,COLOR,UIColor.blackColor(),UIColor.lightGrayColor()]
        
        NSCirclePublicAction.showSheet(with: labelTextArray, buttonTitleColorArray: labelTextColorArray)
        
    }
    
    // MARK: - UItableViewdatasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return forumBestOrTopModelArray.count <= 0 ? 1:2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && forumBestOrTopModelArray.count > 0 {
            return forumBestOrTopModelArray.count
        }
        return forumModelArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 && forumBestOrTopModelArray.count > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("circleDetailTopCell", forIndexPath: indexPath) as! NSCircleDetailTopTableViewCell
            
            cell.selectionStyle = .None
            
            cell.setCellWithNewsInfo(forumBestOrTopModelArray[indexPath.row])
            
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("circleDetailCell", forIndexPath: indexPath) as! NSCircleDetailTableViewCell
        
        cell.selectionStyle = .None
        
        cell.setCellWithNewsInfo(forumModelArray[indexPath.row])
        
        cell.moreBtn.tag = 100+indexPath.row
        cell.moreBtn.addTarget(self, action: #selector(moreBtnClick(_:)), forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    private let titleSize:CGFloat = 14
    private let contentSize:CGFloat = 12
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 && forumBestOrTopModelArray.count > 0 {
            return 30
        }
        
        let forum = forumModelArray[indexPath.row]
        
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
        return 20
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 20))
        headerView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("帖子详情")
    }
    
    // footerView 点击事件
    func footerViewClick()  {
        print("进入圈子")
    }
    
    // 调整 button 图片和文字
    func initButton(btn:UIButton) {
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center//使图片和文字水平居中显示
        btn.titleEdgeInsets = UIEdgeInsetsMake((btn.imageView!.frame.size.height+btn.titleLabel!.bounds.size.height)/2+8, -btn.imageView!.frame.size.width, 0.0,0.0)//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
        btn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0,(btn.imageView!.frame.size.height+btn.titleLabel!.bounds.size.height)/2+5, -btn.titleLabel!.bounds.size.width)//图片距离右边框距离减少图片的宽度，其它不边
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
