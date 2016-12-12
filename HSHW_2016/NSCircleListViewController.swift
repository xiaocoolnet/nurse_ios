//
//  NSCircleListViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/6.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class NSCircleListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let rootTableView = UITableView()
    
    var communityModelArray = [CommunityModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //        self.view.backgroundColor = UIColor.cyanColor()
        self.setSubview()
        
        loadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.defaultStat().pageviewStartWithName("护士站 圈子 列表")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.defaultStat().pageviewEndWithName("护士站 圈子 列表")
    }
    
    func loadData() {
        let forum1 = CommunityModel()
        forum1.community_name = "儿科"
        forum1.description = "儿科是全面研究小儿时期身心发育保健以及疾病防治的综合医学科学..."
        
        let forum2 = CommunityModel()
        forum2.community_name = "内科"
        forum2.description = "内科是全面研究小儿时期身心发育保健以及疾病防治的综合医学科学..."
        
        let forum3 = CommunityModel()
        forum3.community_name = "外科"
        forum3.description = "外科是全面研究小儿时期身心发育保健以及疾病防治的综合医学科学..."
        
        let forum4 = CommunityModel()
        forum4.community_name = "妇产科"
        forum4.description = "妇产科是全面研究小儿时期身心发育保健以及疾病防治的综合医学科学..."
        
        let forum5 = CommunityModel()
        forum5.community_name = "急诊科"
        forum5.description = "急诊科是全面研究小儿时期身心发育保健以及疾病防治的综合医学科学..."
        
        let forum6 = CommunityModel()
        forum6.community_name = "灌水吐槽"
        forum6.description = "儿科是全面研究小儿时期身心发育保健以及疾病防治的综合医学科学..."
        
        communityModelArray = [forum1,forum2,forum3,forum4,forum5,forum6]
        
        self.rootTableView.reloadData()
    }
    let circleBtn = ImageBtn()
    let sortBtn = ImageBtn()
    // MARK: - 设置子视图
    func setSubview() {
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.title = "圈子列表"
        let line1 = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line1.backgroundColor = COLOR
        self.view.addSubview(line1)
//        line1.layer.cornerRadius = 6
//        line1.layer.borderColor = UIColor(red: 145/255.0, green: 26/255.0, blue: 107/255.0, alpha: 1.0).CGColor
//        line1.layer.borderWidth = 1
        
        // MARK: 下拉列表
//        let cir =
        circleBtn.frame = CGRect(x: 0, y: 1, width: WIDTH/2, height: 44)
        circleBtn.lb_titleColor = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0)
//        circleBtn.setTitleColor(UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0), forState: .Normal)
        circleBtn.titleLabel?.font = UIFont.systemFontOfSize(16)
        circleBtn.resetdataCenter("全部圈子", UIImage(named: "下拉"))
//        circleBtn.setTitle("全部圈子", forState: .Normal)
        circleBtn.addTarget(self, action: #selector(dropDownClick(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(circleBtn)
        
        sortBtn.frame = CGRect(x: WIDTH/2, y: 1, width: WIDTH/2, height: 44)
        sortBtn.lb_titleColor = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0)
//        sortBtn.setTitleColor(UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0), forState: .Normal)
        sortBtn.titleLabel?.font = UIFont.systemFontOfSize(16)
        sortBtn.resetdataCenter("智能排序", UIImage(named: "下拉"))
//        sortBtn.setTitle("智能排序", forState: .Normal)
        sortBtn.addTarget(self, action: #selector(dropDownClick(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(sortBtn)
        
        let line2V = UILabel(frame: CGRectMake(WIDTH/2.0, 1, 1/UIScreen.mainScreen().scale, 44))
        line2V.backgroundColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
        self.view.addSubview(line2V)
        
        let line2H = UILabel(frame: CGRectMake(0, 44, WIDTH, 1/UIScreen.mainScreen().scale))
        line2H.backgroundColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
        self.view.addSubview(line2H)
        
        rootTableView.frame = CGRectMake(0, 45, WIDTH, HEIGHT-65-49-45)
        rootTableView.backgroundColor = UIColor.whiteColor()
        
        rootTableView.rowHeight = 76
        
        rootTableView.delegate = self
        rootTableView.dataSource = self
        
        rootTableView.registerNib(UINib(nibName: "NSCircleListTableViewCell", bundle: nil), forCellReuseIdentifier: "circleListCell")
        
        //        myTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(makeDataSource))
        //        rootTableView.mj_header.beginRefreshing()
        
        //        myTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadData_pullUp))
        
        self.view.addSubview(rootTableView)
        
    }
    
    // MARK: - 下拉列表点击事件
    func dropDownClick(dropDownBtn:ImageBtn) {
        
        self.view.viewWithTag(1234)?.removeFromSuperview()
        
        dropDownBtn.lb_titleColor = COLOR
        dropDownBtn.resetdataCenter(dropDownBtn.lb_title.text, UIImage(named: "下拉（点击）"))
        
        let bgView = UIButton(frame: CGRect(x: 0, y: dropDownBtn.frame.maxY, width: WIDTH, height: HEIGHT-64-45))
        bgView.tag = 1234
        bgView.backgroundColor = UIColor.lightGrayColor()
        bgView.addTarget(self, action: #selector(hideDropDown), forControlEvents: .TouchUpInside)
        self.view.addSubview(bgView)

        
        let bgBtn = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 44*3))
        bgBtn.backgroundColor = UIColor.whiteColor()
        bgView.addSubview(bgBtn)
        
        for i in 0 ..< 3 {
            
            let img = UIImageView(frame: CGRect(x: 8, y: 44*CGFloat(i), width: 10, height: 44))
            img.contentMode = .ScaleAspectFit
            img.clipsToBounds = true
            img.image = UIImage(named: "选择圈子")
            bgBtn.addSubview(img)
            
            let button = UIButton(frame: CGRect(x: 26, y: 44*CGFloat(i), width: WIDTH-26-8, height: 44))
            button.tag = 100+i
            button.contentHorizontalAlignment = .Left
            button.titleLabel?.font = UIFont.systemFontOfSize(18)
            button.setTitleColor(UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1), forState: .Normal)
            button.setTitleColor(COLOR, forState: .Selected)
            button.setTitle("交流", forState: .Normal)
            button.addTarget(self, action: #selector(dropBtnClick(_:)), forControlEvents: .TouchUpInside)
            bgBtn.addSubview(button)
            
            let line = UILabel(frame: CGRectMake(0, 44*CGFloat(i)+44, WIDTH, 1/UIScreen.mainScreen().scale))
            line.backgroundColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
            bgBtn.addSubview(line)
            
            if i == 1 {
                button.selected = true
            }
            
            img.hidden = !button.selected
        }
    }
    
    func hideDropDown(button:UIButton) {
        button.removeFromSuperview()
        circleBtn.resetdataCenter(circleBtn.lb_title.text, UIImage(named: "下拉"))
        circleBtn.lb_titleColor = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0)
        sortBtn.resetdataCenter(sortBtn.lb_title.text, UIImage(named: "下拉"))
        sortBtn.lb_titleColor = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0)
    }
    
    func dropBtnClick(dropBtn:UIButton) {
        print(dropBtn.tag)
        dropBtn.superview?.superview?.removeFromSuperview()
        circleBtn.resetdataCenter(circleBtn.lb_title.text, UIImage(named: "下拉"))
        circleBtn.lb_titleColor = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0)
        sortBtn.resetdataCenter(sortBtn.lb_title.text, UIImage(named: "下拉"))
        sortBtn.lb_titleColor = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0)

    }
    
    // MARK: - UItableViewdatasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return communityModelArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("circleListCell", forIndexPath: indexPath) as! NSCircleListTableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier("circleListCell") as! NSCircleListTableViewCell
        
        cell.selectionStyle = .None
        
        cell.communityModel = communityModelArray[indexPath.row]
//        cell.setCellWithNewsInfo(forumModelArray[indexPath.section])
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("点击圈子")
        
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
