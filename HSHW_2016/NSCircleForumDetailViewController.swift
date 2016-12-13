//
//  NSCircleForumDetailViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/13.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class NSCircleForumDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let rootTableView = UITableView(frame: CGRect.zero, style: .Grouped)
    
    var forumModelArray = [ForumModel]()
//    var forumBestOrTopModelArray = [ForumModel]()
    
    var forumModel = ForumModel()
    
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
        
        let photo1 = photoModel()
        photo1.url = "20161202/5840e94624cb0.jpg"
        let photo2 = photoModel()
        photo2.url = "20161130/583eb4efc6dad.jpg"
        let photo3 = photoModel()
        photo3.url = "20161129/583ce3b933d98.jpg"
        
        
        forumModel.title = "请问各位同行，职场新手如何‘谈薪’才合适？"
        forumModel.content = "　　儿科学属临床医学的二级学科，研究对象是自胎儿至青春期的儿童。它是一门研究小儿生长发育规律、提高小儿身心健康水平和疾病防治质量的医学科学。\n    1、学科研究范围：儿科学研究从胎儿到青春期儿童有关促进生理及心理健康成长和疾病的防治。目前有儿童保健、新生儿学、呼吸、心血管、血液、肾脏、神经、内分泌与代谢、免疫感染与消化、急救以及小儿外科等专业。每个专业学科又和基础医学某些学科有密切联系，如生理、生化、病理、遗传以及分子生物学等。\n    2、课程设置：基础理论课：生理学，病理学，生物化学，分子生物学，免疫学，医学遗传学，医学统计学，临床流行病学，电子计算机应用以及与研究课题有关的基础医学课程。\n    专业课：儿科学与研究课题有关的内科各专业课程。\n儿科学主要相关学科：内科学、外科学，神经病学，妇产科学，传染病学等。"
        forumModel.like = "1136"
        forumModel.hits = "151"
        forumModel.istop = "1"
        forumModel.isbest = "1"
        forumModel.isreward = "1"
        
        forumModel.photo = [photo1,photo2,photo3]

        self.rootTableView.reloadData()
    }
    
    // MARK: - 设置子视图
    func setSubview() {
        
        self.title = "帖子详情"
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.whiteColor()
        rootTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-65)
        rootTableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
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
        
        let tableHeaderView = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 50))
        tableHeaderView.backgroundColor = UIColor.whiteColor()
        tableHeaderView.addTarget(self, action: #selector(tableViewHeaderViewClick), forControlEvents: .TouchUpInside)
        
        // 用户信息

        let img = UIImageView(frame: CGRect(x: 8, y: 8, width: 35, height: 35))
        img.backgroundColor = UIColor(red: 243/255.0, green: 229/255.0, blue: 240/255.0, alpha: 1)
        img.layer.cornerRadius = 17.5
        img.clipsToBounds = true
        tableHeaderView.addSubview(img)
        
        let nameLab = UILabel(frame: CGRect(x: img.frame.maxX+8, y: 8, width: calculateWidth("用户名", size: 12, height: 17), height: 17))
        nameLab.textAlignment = .Left
        nameLab.font = UIFont.systemFontOfSize(12)
        nameLab.textColor = UIColor.blackColor()
        nameLab.text = "用户名"
        tableHeaderView.addSubview(nameLab)
        
        let positionLab = UILabel(frame: CGRect(x: nameLab.frame.maxX+8, y: 0, width: calculateWidth("护士", size: 8, height: 12)+12, height: 12))
        positionLab.font = UIFont.systemFontOfSize(8)
        positionLab.textColor = UIColor.whiteColor()
        positionLab.layer.backgroundColor = COLOR.CGColor
        positionLab.textAlignment = .Center
        positionLab.center.y = nameLab.center.y
        positionLab.layer.cornerRadius = 6
        tableHeaderView.addSubview(positionLab)

        let levelLab = UILabel(frame: CGRect(x: img.frame.maxX+8, y: nameLab.frame.maxY+1, width: calculateWidth("Lv.35", size: 10, height: 17), height: 17))
        levelLab.font = UIFont.systemFontOfSize(10)
        levelLab.textColor = COLOR
        levelLab.textAlignment = .Center
        levelLab.text = "Lv.35"
        tableHeaderView.addSubview(levelLab)
        
        let timeLab = UILabel(frame: CGRect(
            x: WIDTH-10-calculateWidth("3分钟前", size: 10, height: 17),
            y: (50-UIFont.systemFontOfSize(10).lineHeight)/2.0,
            width: calculateWidth("3分钟前", size: 10, height: UIFont.systemFontOfSize(10).lineHeight),
            height: UIFont.systemFontOfSize(10).lineHeight))
        timeLab.font = UIFont.systemFontOfSize(10)
        timeLab.textColor = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1)
        timeLab.text = "3分钟前"
        tableHeaderView.addSubview(timeLab)
        
        rootTableView.tableHeaderView = tableHeaderView
    }
    
    // MARK:- tableView click
    func tableViewHeaderViewClick() {
        self.navigationController?.pushViewController(NSCircleHomeViewController(), animated: true)
    }
    
    // MARK: - moreBtnClick
    func moreBtnClick(moreBtn:UIButton) {
        print(moreBtn.tag)
        
        
        //        let alert =
        let labelTextArray = ["加精","置顶","删除","取消"]
        let labelTextColorArray = [COLOR,COLOR,UIColor.blackColor(),UIColor.lightGrayColor()]
        
        self.showAlert(with: labelTextArray, buttonTitleColorArray: labelTextColorArray)
        
        
    }
    
    func showAlert(with buttonTitleArray:[String], buttonTitleColorArray:[UIColor]) {
        
        let buttonFontSize:CGFloat = 15
        let buttonTitleDefaultColor = UIColor.blackColor()
        let animateWithDuration = 0.3
        
        let bgView = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT))
        bgView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        bgView.addTarget(self, action: #selector(alertCancel(_:)), forControlEvents: .TouchUpInside)
        UIApplication.sharedApplication().keyWindow?.addSubview(bgView)
        
        let alert = UIView(frame: CGRect(x: 0, y: HEIGHT, width: WIDTH, height: 0))
        alert.backgroundColor = UIColor.whiteColor()
        bgView.addSubview(alert)
        
        for (i,buttonTitle) in buttonTitleArray.enumerate() {
            let button = UIButton(frame: CGRect(x: 0, y: 44*CGFloat(i), width: WIDTH, height: 44))
            button.tag = 100+i
            button.titleLabel?.font = UIFont.systemFontOfSize(buttonFontSize)
            button.setTitle(buttonTitle, forState: .Normal)
            
            button.setTitleColor((i<buttonTitleColorArray.count ? buttonTitleColorArray[i]:buttonTitleDefaultColor), forState: .Normal)
            if i == buttonTitleArray.count-1 {
                button.addTarget(self, action: #selector(alertCancel(_:)), forControlEvents: .TouchUpInside)
            }else{
                button.addTarget(self, action: #selector(alertActionClick(_:)), forControlEvents: .TouchUpInside)
            }
            alert.addSubview(button)
            
            let line = UIView(frame: CGRect(x: 0, y: button.frame.height-1/UIScreen.mainScreen().scale, width: button.frame.width, height: 1/UIScreen.mainScreen().scale))
            line.backgroundColor = UIColor.lightGrayColor()
            button.addSubview(line)
        }
        
        UIView.animateWithDuration(animateWithDuration) {
            
            alert.frame = CGRect(x: 0, y: HEIGHT-44*CGFloat(buttonTitleArray.count), width: WIDTH, height: 44*CGFloat(buttonTitleArray.count))
        }
    }
    
    func alertActionClick(action:UIButton) {
        print(action.tag)
    }
    
    func alertCancel(action:UIView) {
        if action.superview == UIApplication.sharedApplication().keyWindow {
            action.removeFromSuperview()
        }else{
            alertCancel(action.superview!)
        }
    }
    
    
    // MARK: - UItableViewdatasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            var cell = tableView.dequeueReusableCellWithIdentifier("forumDetailCell")
            
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: "forumDetailCell")
                cell?.selectionStyle = .None
                cell?.textLabel?.numberOfLines = 0
            }
            
            switch indexPath.row {
            case 0:
                cell?.textLabel?.font = UIFont.systemFontOfSize(18)
                cell?.textLabel?.textColor = UIColor.blackColor()
                cell?.textLabel?.textAlignment = .Center
                cell?.textLabel?.text = forumModel.title
                
            case 1:
                cell?.textLabel?.font = UIFont.systemFontOfSize(14)
                cell?.textLabel?.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
                cell?.textLabel?.textAlignment = .Left
                cell?.textLabel?.text = forumModel.content
                
            default:
                break
            }
            
            
            return cell!
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
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                return calculateHeight(forumModel.title, size: 18, width: WIDTH-48)+20
            case 1:
                return calculateHeight(forumModel.content, size: 14, width: WIDTH-48)+20
            default:
                break
            }
            return 0
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 50:0.001
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            let contentView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 50))
            contentView.backgroundColor = UIColor.whiteColor()
            
            let collectBtn = UIButton(frame: CGRect(x: 20, y: 8, width: 30, height: 30))
            collectBtn.tag == 100
            collectBtn.layer.cornerRadius = 15
//            collectBtn.layer.backgroundColor = UIColor(red: 244/255.0, green: 229/255.0, blue: 240/255.0, alpha: 1).CGColor
            collectBtn.setImage(UIImage(named: "收藏（默认）"), forState: .Normal)
            collectBtn.setImage(UIImage(named: "收藏"), forState: .Selected)
            collectBtn.addTarget(self, action: #selector(collectBtnClick(_:)), forControlEvents: .TouchUpInside)
            contentView.addSubview(collectBtn)
            
            let collectNumLab = UILabel(frame: CGRect(x: collectBtn.frame.maxX+8, y: 0, width: 0, height: 0))
            collectNumLab.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
            collectNumLab.font = UIFont.systemFontOfSize(14)
            collectNumLab.text = forumModel.hits
            collectNumLab.sizeToFit()
            collectNumLab.center.y = collectBtn.center.y
            contentView.addSubview(collectNumLab)
            
            let likeBtn = UIButton(frame: CGRect(x: collectNumLab.frame.maxX+20, y: 8, width: 30, height: 30))
            likeBtn.tag == 101
            likeBtn.layer.cornerRadius = 15
//            likeBtn.layer.backgroundColor = UIColor(red: 244/255.0, green: 229/255.0, blue: 240/255.0, alpha: 1).CGColor
            //                likeBtn.setImage(UIImage(named: "点赞（默认）"), forState: .Normal)
            likeBtn.setImage(UIImage(named: "点赞"), forState: .Normal)
            likeBtn.addTarget(self, action: #selector(likeBtnClick(_:)), forControlEvents: .TouchUpInside)
            contentView.addSubview(likeBtn)
            
            let likeNumLab = UILabel(frame: CGRect(x: likeBtn.frame.maxX+8, y: 0, width: 0, height: 0))
            likeNumLab.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
            likeNumLab.font = UIFont.systemFontOfSize(14)
            likeNumLab.text = forumModel.like
            likeNumLab.sizeToFit()
            likeNumLab.center.y = likeBtn.center.y
            contentView.addSubview(likeNumLab)
            
            let rewardBtn = UIButton(frame: CGRect(x: likeNumLab.frame.maxX+20, y: 8, width: 30, height: 30))
            rewardBtn.tag == 102
            rewardBtn.layer.cornerRadius = 15
//            rewardBtn.layer.backgroundColor = UIColor(red: 244/255.0, green: 229/255.0, blue: 240/255.0, alpha: 1).CGColor
            rewardBtn.setImage(UIImage(named: "打赏（默认）"), forState: .Normal)
            rewardBtn.setImage(UIImage(named: "打赏"), forState: .Selected)
            rewardBtn.addTarget(self, action: #selector(rewardBtnClick(_:)), forControlEvents: .TouchUpInside)
            contentView.addSubview(rewardBtn)
            
            let rewardNumLab = UILabel(frame: CGRect(x: rewardBtn.frame.maxX+8, y: 0, width: 0, height: 0))
            rewardNumLab.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
            rewardNumLab.font = UIFont.systemFontOfSize(14)
            rewardNumLab.text = "打赏"
            rewardNumLab.sizeToFit()
            rewardNumLab.center.y = rewardBtn.center.y
            contentView.addSubview(rewardNumLab)
            
            let moreBtn = UIButton(frame: CGRect(x: likeNumLab.frame.maxX+10, y: 8, width: 30, height: 30))
            
            moreBtn.setTitle("···", forState: .Normal)
            moreBtn.titleLabel?.font = UIFont.systemFontOfSize(18)
            moreBtn.layer.cornerRadius = 2
            moreBtn.setTitleColor(UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1), forState: .Normal)
            moreBtn.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
            
            let moreBtnWidth = calculateWidth("···", size: 18, height: 10)+10
            moreBtn.frame = CGRect(x: contentView.frame.width-20-moreBtnWidth, y: 0, width: moreBtnWidth, height: 10)
            moreBtn.center.y = rewardNumLab.center.y
            
            moreBtn.addTarget(self, action: #selector(moreBtnClick(_:)), forControlEvents: .TouchUpInside)
            
            contentView.addSubview(moreBtn)
            
            return contentView
        }else{
            return nil
        }

    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 15))
        headerView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("点击cell")
    }
    
    // MARK: - 收藏、点赞、打赏 按钮点击事件
    func collectBtnClick(collectBtn:UIButton) {
        print("1")
    }
    func likeBtnClick(likeBtn:UIButton) {
        print("2")
    }
    func rewardBtnClick(rewardBtn:UIButton) {
        print("3")
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
