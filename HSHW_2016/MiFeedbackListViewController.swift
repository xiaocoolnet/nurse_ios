//
//  MiFeedbackListViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/11/16.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MiFeedbackListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let rootTableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    var feedbackListData = [FeedbackListData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default

        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        
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
//                self.navigationController?.pushViewController(MiFeedbackViewController(), animated: true)
                return
            }
        }
    }
    
    func setSubviews() {
        
        self.title = "我的反馈意见"
        
        let line = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        rootTableView.frame = CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-65)
        rootTableView.separatorStyle = .none
        rootTableView.dataSource = self
        rootTableView.delegate = self
        self.view.addSubview(rootTableView)
        
        rootTableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadData))
        rootTableView.mj_header.beginRefreshing()
        
        let feedbackBtn = UIButton()
        feedbackBtn.frame = CGRect(x: WIDTH-70 , y: HEIGHT-230, width: 50, height: 50)
        feedbackBtn.setImage(UIImage(named: "ic_edit.png"), for: UIControlState())
        feedbackBtn.addTarget(self, action: #selector(feedbackBtnClick), for: .touchUpInside)
        self.view.addSubview(feedbackBtn)
    }
    
    // MARK: 编辑按钮点击事件
    func feedbackBtnClick() {
        self.navigationController?.pushViewController(MiFeedbackViewController(), animated: true)

    }
    
    // MARK: uitableview datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.feedbackListData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.feedbackListData[section].reply.count
        if self.feedbackListData[section].reply.count > 0 {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25+calculateHeight(self.feedbackListData[indexPath.section].reply[indexPath.row].content!, size: 14, width: WIDTH-80)+10+5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        var cell = tableView.dequeueReusableCellWithIdentifier("feedbackListCell")
//        
//        if cell == nil {
//        }
        let replyHeight = calculateHeight(self.feedbackListData[indexPath.section].reply[indexPath.row].content!, size: 14, width: WIDTH-80)

        let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: WIDTH, height: replyHeight))
//        let cell = UITableViewCell(style: .Default, reuseIdentifier: "feedbackListCell")
        cell.selectionStyle = .none
        
        let replyBgView = UIView(frame: CGRect(x: 50, y: 0, width: WIDTH-70, height: 25+replyHeight+10))
        replyBgView.backgroundColor = UIColor(red: 249/255.0, green: 242/255.0, blue: 247/255.0, alpha: 1)
        cell.contentView.addSubview(replyBgView)
        
        let replyTitleLab = UILabel(frame: CGRect(x: 55, y: 5, width: WIDTH-80, height: 25))
        replyTitleLab.textColor = COLOR
        replyTitleLab.font = UIFont.systemFont(ofSize: 14)
        replyTitleLab.text = self.feedbackListData[indexPath.section].reply[indexPath.row].title
        cell.contentView.addSubview(replyTitleLab)
        
        let replyLab = UILabel(frame: CGRect(x: 55, y: replyTitleLab.frame.maxY, width: WIDTH-80, height: 0))
        replyLab.numberOfLines = 0
        replyLab.textColor = UIColor.gray
        replyLab.font = UIFont.systemFont(ofSize: 14)
        cell.contentView.addSubview(replyLab)
        
        replyLab.frame.size.height = replyHeight
//        replyLab.center = replyBgView.center
        replyLab.text = self.feedbackListData[indexPath.section].reply[indexPath.row].content
        
        
        return cell
    }
    
    // MARK: uitableview delegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let contentHeight = calculateHeight(self.feedbackListData[section].content!, size: 16, width: WIDTH-8-25-8-8)
        
        let feedbackView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 8+contentHeight+8))
        feedbackView.backgroundColor = UIColor.white
        
        let indexLab = UILabel(frame: CGRect(x: 8, y: 8, width: 30, height: 30))
        indexLab.layer.cornerRadius = 15
//        indexLab.layer.backgroundColor = COLOR.CGColor
        indexLab.layer.borderWidth = 1
        indexLab.layer.borderColor = COLOR.cgColor
        indexLab.textAlignment = .center
        indexLab.textColor = COLOR
        indexLab.text = String(section+1)
        feedbackView.addSubview(indexLab)
        
        let feedbackContentLab = UILabel(frame: CGRect(x: indexLab.frame.maxX+8, y: 8, width: WIDTH-8-30-8-8, height: contentHeight))
        feedbackContentLab.numberOfLines = 0
        feedbackContentLab.font = UIFont.systemFont(ofSize: 16)
        feedbackContentLab.textColor = UIColor.black
        feedbackContentLab.text = self.feedbackListData[section].content
        feedbackView.addSubview(feedbackContentLab)
        
        let feedbackTimeLab = UILabel(frame: CGRect(x: indexLab.frame.maxX+8, y: feedbackContentLab.frame.maxY+8, width: WIDTH-8-30-8-8, height: 25))
        feedbackTimeLab.font = UIFont.systemFont(ofSize: 14)
        feedbackTimeLab.textAlignment = .right
        feedbackTimeLab.textColor = UIColor.gray
        feedbackTimeLab.text = self.timeStampToString(self.feedbackListData[section].create_time!)
        feedbackView.addSubview(feedbackTimeLab)
        
        return feedbackView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8+calculateHeight(self.feedbackListData[section].content!, size: 16, width: WIDTH-8-30-8-8)+8+25+8
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    // Linux时间戳转标准时间
    func timeStampToString(_ timeStamp:String)->String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy-MM-dd hh:mm:ss"
        
        let date = Date(timeIntervalSince1970: timeSta)
        
        //        print(dfmatter.stringFromDate(date))
        return dfmatter.string(from: date)
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
