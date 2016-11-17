//
//  MiFeedbackListViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/11/16.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MiFeedbackListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let rootTableView = UITableView(frame: CGRectZero, style: .Grouped)
    
    var feedbackListData = [FeedbackListData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setSubviews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default

        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
        
        self.loadData()

    }
    
    // MARK: 加载数据
    func loadData() {
        HSMineHelper().getfeedbackList { (success, response) in
            
            if self.rootTableView.mj_header.isRefreshing() {
                self.rootTableView.mj_header.endRefreshing()
            }
            if success {
                self.feedbackListData = response as! [FeedbackListData]
                
                self.rootTableView.reloadData()
            }else{
                self.navigationController?.pushViewController(MiFeedbackViewController(), animated: true)
                return
            }
        }
    }
    
    func setSubviews() {
        
        self.title = "我的反馈意见"
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        rootTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-65)
        rootTableView.separatorStyle = .None
        rootTableView.dataSource = self
        rootTableView.delegate = self
        self.view.addSubview(rootTableView)
        
        rootTableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadData))
        rootTableView.mj_header.beginRefreshing()
        
        let feedbackBtn = UIButton()
        feedbackBtn.frame = CGRectMake(WIDTH-70 , HEIGHT-230, 50, 50)
        feedbackBtn.setImage(UIImage(named: "ic_edit.png"), forState: .Normal)
        feedbackBtn.addTarget(self, action: #selector(feedbackBtnClick), forControlEvents: .TouchUpInside)
        self.view.addSubview(feedbackBtn)
    }
    
    // MARK: 编辑按钮点击事件
    func feedbackBtnClick() {
        self.navigationController?.pushViewController(MiFeedbackViewController(), animated: true)

    }
    
    // MARK: uitableview datasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.feedbackListData.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.feedbackListData[section].reply.count
        if self.feedbackListData[section].reply.count > 0 {
            return 1
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 25+calculateHeight(self.feedbackListData[indexPath.section].reply[indexPath.row].content!, size: 14, width: WIDTH-80)+10+5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        var cell = tableView.dequeueReusableCellWithIdentifier("feedbackListCell")
//        
//        if cell == nil {
//        }
        let replyHeight = calculateHeight(self.feedbackListData[indexPath.section].reply[indexPath.row].content!, size: 14, width: WIDTH-80)

        let cell = UITableViewCell(frame: CGRectMake(0, 0, WIDTH, replyHeight))
//        let cell = UITableViewCell(style: .Default, reuseIdentifier: "feedbackListCell")
        cell.selectionStyle = .None
        
        let replyBgView = UIView(frame: CGRectMake(50, 0, WIDTH-70, 25+replyHeight+10))
        replyBgView.backgroundColor = UIColor(red: 249/255.0, green: 242/255.0, blue: 247/255.0, alpha: 1)
        cell.contentView.addSubview(replyBgView)
        
        let replyTitleLab = UILabel(frame: CGRectMake(55, 5, WIDTH-80, 25))
        replyTitleLab.textColor = COLOR
        replyTitleLab.font = UIFont.systemFontOfSize(14)
        replyTitleLab.text = self.feedbackListData[indexPath.section].reply[indexPath.row].title
        cell.contentView.addSubview(replyTitleLab)
        
        let replyLab = UILabel(frame: CGRectMake(55, CGRectGetMaxY(replyTitleLab.frame), WIDTH-80, 0))
        replyLab.numberOfLines = 0
        replyLab.textColor = UIColor.grayColor()
        replyLab.font = UIFont.systemFontOfSize(14)
        cell.contentView.addSubview(replyLab)
        
        replyLab.frame.size.height = replyHeight
//        replyLab.center = replyBgView.center
        replyLab.text = self.feedbackListData[indexPath.section].reply[indexPath.row].content
        
        
        return cell
    }
    
    // MARK: uitableview delegate
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let contentHeight = calculateHeight(self.feedbackListData[section].content!, size: 16, width: WIDTH-8-25-8-8)
        
        let feedbackView = UIView(frame: CGRectMake(0, 0, WIDTH, 8+contentHeight+8))
        feedbackView.backgroundColor = UIColor.whiteColor()
        
        let indexLab = UILabel(frame: CGRectMake(8, 8, 30, 30))
        indexLab.layer.cornerRadius = 15
//        indexLab.layer.backgroundColor = COLOR.CGColor
        indexLab.layer.borderWidth = 1
        indexLab.layer.borderColor = COLOR.CGColor
        indexLab.textAlignment = .Center
        indexLab.textColor = COLOR
        indexLab.text = String(section+1)
        feedbackView.addSubview(indexLab)
        
        let feedbackContentLab = UILabel(frame: CGRectMake(CGRectGetMaxX(indexLab.frame)+8, 8, WIDTH-8-30-8-8, contentHeight))
        feedbackContentLab.numberOfLines = 0
        feedbackContentLab.font = UIFont.systemFontOfSize(16)
        feedbackContentLab.textColor = UIColor.blackColor()
        feedbackContentLab.text = self.feedbackListData[section].content
        feedbackView.addSubview(feedbackContentLab)
        
        let feedbackTimeLab = UILabel(frame: CGRectMake(CGRectGetMaxX(indexLab.frame)+8, CGRectGetMaxY(feedbackContentLab.frame)+8, WIDTH-8-30-8-8, 25))
        feedbackTimeLab.font = UIFont.systemFontOfSize(14)
        feedbackTimeLab.textAlignment = .Right
        feedbackTimeLab.textColor = UIColor.grayColor()
        feedbackTimeLab.text = self.timeStampToString(self.feedbackListData[section].create_time!)
        feedbackView.addSubview(feedbackTimeLab)
        
        return feedbackView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8+calculateHeight(self.feedbackListData[section].content!, size: 16, width: WIDTH-8-30-8-8)+8+25+8
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    // Linux时间戳转标准时间
    func timeStampToString(timeStamp:String)->String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:NSTimeInterval = string.doubleValue
        let dfmatter = NSDateFormatter()
        dfmatter.dateFormat="yyyy-MM-dd hh:mm:ss"
        
        let date = NSDate(timeIntervalSince1970: timeSta)
        
        //        print(dfmatter.stringFromDate(date))
        return dfmatter.stringFromDate(date)
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
