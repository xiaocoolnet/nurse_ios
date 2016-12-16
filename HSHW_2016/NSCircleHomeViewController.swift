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
    
    var cellNameArray = ["置顶贴","精华贴","申请圈主","取消关注"]
    
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
        
        rootTableView.registerClass(NSCircleHomeTableViewCell.self, forCellReuseIdentifier: "circleHomeCell")
        
        self.view.addSubview(rootTableView)
        
        self.setTableViewHeaderView()
    }
    
    // MARK: - 设置头视图
    func setTableViewHeaderView(unfoldIntroduce:Bool = false) {
        
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
        countLab.text = "13.5万人 16.5万贴子"
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
        
        let introduceBtn = UIButton(frame: CGRect(x: 8, y: introduceTagLab.frame.maxY+8, width: WIDTH-16, height: UIFont.systemFontOfSize(14).lineHeight))
        introduceBtn.titleLabel?.numberOfLines = 0
        introduceBtn.contentHorizontalAlignment = .Left
        introduceBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        introduceBtn.setTitleColor(UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1), forState: .Normal)

        let introduceStr:NSString = "儿科是全面研究小儿时期身心发育、保健以及疾病防治的综合医学科学。凡涉及儿童儿科是全面研究小儿时期身心发育、保健以及疾病防治的综合医学科学。凡涉及儿童。"
        let range = NSMakeRange(40, introduceStr.length-40)
        let cutIntroduceStr = introduceStr.length > 40 ? introduceStr.stringByReplacingCharactersInRange(range, withString: "..."):introduceStr
        let attrStr = NSMutableAttributedString(string: "    \(cutIntroduceStr) 展开")
        attrStr.addAttributes([NSForegroundColorAttributeName:UIColor(red: 28/255.0, green: 159/255.0, blue: 227/255.0, alpha: 1),NSUnderlineStyleAttributeName:NSUnderlineStyle.StyleSingle.rawValue], range: NSMakeRange(attrStr.length-2, 2))
        
        let attrStrUnfold = NSMutableAttributedString(string: "    \(introduceStr) 收起")
        
        attrStrUnfold.addAttributes([NSForegroundColorAttributeName:UIColor(red: 28/255.0, green: 159/255.0, blue: 227/255.0, alpha: 1),NSUnderlineStyleAttributeName:NSUnderlineStyle.StyleSingle.rawValue], range: NSMakeRange(attrStrUnfold.length-2, 2))
        
        introduceBtn.setAttributedTitle(attrStr, forState: .Normal)
        introduceBtn.setAttributedTitle(attrStrUnfold, forState: .Selected)
        
        introduceBtn.selected = unfoldIntroduce
        introduceBtn.frame.size.height = calculateHeight(introduceBtn.currentAttributedTitle!.string, size: 14, width: WIDTH-16)
        introduceBtn.addTarget(self, action: #selector(introduceBtnClick(_:)), forControlEvents: .TouchUpInside)
        tableHeaderView.addSubview(introduceBtn)
        
        
        // MARK: - 圈主
        let managerTagLab = UILabel(frame: CGRect(x: 8, y: introduceBtn.frame.maxY+10, width: WIDTH-16, height: UIFont.systemFontOfSize(14).lineHeight))
        managerTagLab.textAlignment = .Left
        managerTagLab.font = UIFont.systemFontOfSize(14)
        managerTagLab.textColor = UIColor.grayColor()
        managerTagLab.text = "圈主"
        tableHeaderView.addSubview(managerTagLab)
        
        let managerBgView = UIView(frame: CGRect(x: 8, y: managerTagLab.frame.maxY+10, width: WIDTH-16, height: 0))
        tableHeaderView.addSubview(managerBgView)
        
        let margin = (WIDTH-16)/12
        for i in 0 ..< 3 {
            let headerImg = UIImageView(frame: CGRect(x: margin+(margin*4*CGFloat(i)), y: 0, width: margin*2, height: margin*2))
            headerImg.backgroundColor = UIColor.lightGrayColor()
            headerImg.layer.cornerRadius = margin
            headerImg.clipsToBounds = true
            managerBgView.addSubview(headerImg)
            
            let nameLab = UILabel(frame: CGRect(x: margin*4*CGFloat(i), y: headerImg.frame.maxY+10, width: margin*4, height: UIFont.systemFontOfSize(12).lineHeight))
            nameLab.textAlignment = .Center
            nameLab.font = UIFont.systemFontOfSize(12)
            nameLab.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
            nameLab.text = "小丫头妈咪宝贝"
            managerBgView.addSubview(nameLab)
        }
        
        managerBgView.frame.size.height = margin*2+10+UIFont.systemFontOfSize(12).lineHeight
        
//        let introduceLab = UILabel(frame: CGRect(x: 8, y: introduceTagLab.frame.maxY+8, width: WIDTH-16, height: UIFont.systemFontOfSize(14).lineHeight))
//        introduceLab.numberOfLines = 0
//        introduceLab.textAlignment = .Left
//        introduceLab.font = UIFont.systemFontOfSize(14)
//        introduceLab.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
//        
//        introduceLab.attributedText = attrStr
//        introduceLab.sizeToFit()
//        tableHeaderView.addSubview(introduceLab)
        
        tableHeaderView.frame.size.height = managerBgView.frame.maxY+10
        
        rootTableView.tableHeaderView = tableHeaderView
    }
    
    // MARK: - 点击展开按钮
    func introduceBtnClick(introduceBtn:UIButton) {
        setTableViewHeaderView(!introduceBtn.selected)
    }
    
    // MARK: - UItableViewdatasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellNameArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("circleHomeCell", forIndexPath: indexPath) as! NSCircleHomeTableViewCell
        
        cell.selectionStyle = .None
        cell.accessoryType = .DisclosureIndicator
        
//        cell.setCellWithNewsInfo(forumModelArray[indexPath.row])
        cell.setCellWith(cellNameArray[indexPath.row], imageName: cellNameArray[indexPath.row], noteStr: nil)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 44
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
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 20))
        headerView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let forumListController = NSCircleForumListViewController()
        forumListController.title = "加精置顶贴子列表"
        self.navigationController?.pushViewController(forumListController, animated: true)
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
