//
//  NSCircleHomeViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/8.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class NSCircleHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let rootTableView = UITableView(frame: CGRect.zero, style: .Grouped)
    
    var forumModelArray = [ForumModel]()
    var forumBestOrTopModelArray = [ForumModel]()
    
    var communityModel = CommunityModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //        self.view.backgroundColor = UIColor.cyanColor()
        self.setSubview()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.defaultStat().pageviewStartWithName("护士站 圈子 详情")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.defaultStat().pageviewEndWithName("护士站 圈子 详情")
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
        
        self.view.addSubview(rootTableView)
        
        self.setTableViewHeaderView()
    }
    
    // MARK: - 设置头视图
    func setTableViewHeaderView() {
        
        let tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: WIDTH/375*60+20))
        
        let btn2Width = WIDTH/375*80
        
        // 圈子
        let img = UIImageView(frame: CGRect(x: 8, y: 10, width: btn2Width, height: WIDTH/375*60))
        img.backgroundColor = UIColor(red: 243/255.0, green: 229/255.0, blue: 240/255.0, alpha: 1)
        tableHeaderView.addSubview(img)
        
        let nameLab = UILabel(frame: CGRect(x: img.frame.maxX+8, y: img.frame.minY, width: WIDTH-88-btn2Width-16, height: WIDTH/375*30))
        nameLab.textAlignment = .Left
        nameLab.font = UIFont.systemFontOfSize(18)
        nameLab.textColor = COLOR
        nameLab.text = "急诊科"
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
        
        let line = UIView(frame: CGRect(x: 0, y: img.frame.maxY+img.frame.minY, width: WIDTH, height: 2/UIScreen.mainScreen().scale))
        line.backgroundColor = UIColor.lightGrayColor()
        tableHeaderView.addSubview(line)
        
        // 圈子介绍
        let introduceTagLab = UILabel(frame: CGRect(x: 8, y: line.frame.maxY+8, width: WIDTH-16, height: UIFont.systemFontOfSize(14).lineHeight))
        introduceTagLab.textAlignment = .Left
        introduceTagLab.font = UIFont.systemFontOfSize(14)
        introduceTagLab.textColor = UIColor.grayColor()
        introduceTagLab.text = "圈子介绍"
        tableHeaderView.addSubview(introduceTagLab)
        
        let introduceLab = UILabel(frame: CGRect(x: 8, y: introduceTagLab.frame.maxY+8, width: WIDTH-16, height: UIFont.systemFontOfSize(14).lineHeight))
        introduceLab.numberOfLines = 0
        introduceLab.textAlignment = .Left
        introduceLab.font = UIFont.systemFontOfSize(14)
        introduceLab.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
        var introduceStr:NSString = "儿科是全面研究小儿时期身心发育、保健以及疾病防治的综合医学科学。凡涉及儿童儿科是全面研究小儿时期身心发育、保健以及疾病防治的综合医学科学。凡涉及儿童"
        let range = NSMakeRange(40, introduceStr.length-40)
        introduceStr = introduceStr.length > 40 ? introduceStr.stringByReplacingCharactersInRange(range, withString: "..."):introduceStr
        let attrStr = NSMutableAttributedString(string: "    \(introduceStr)展开")
        attrStr.addAttributes([NSForegroundColorAttributeName:UIColor(),NSUnderlineStyleAttributeName:NSUnderlineStyle.StyleSingle.rawValue], range: NSMakeRange(attrStr.length-2, 2))
        
        
        introduceLab.attributedText = attrStr
        introduceLab.sizeToFit()
        tableHeaderView.addSubview(introduceLab)
        
        tableHeaderView.frame.size.height = introduceLab.frame.maxY+10
        
        rootTableView.tableHeaderView = tableHeaderView
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
