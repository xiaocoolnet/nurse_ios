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
    }
    
    func setSubviews() {
        
        self.title = "意见反馈"
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        rootTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-65)
        rootTableView.separatorStyle = .None
        rootTableView.dataSource = self
        rootTableView.delegate = self
        self.view.addSubview(rootTableView)
        
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
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return calculateHeight(replyText, size: 16, width: WIDTH-58)+10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        var cell = tableView.dequeueReusableCellWithIdentifier("feedbackListCell")
//        
//        if cell == nil {
//        }
        let replyHeight = calculateHeight(replyText, size: 16, width: WIDTH-58)+10

        let cell = UITableViewCell(frame: CGRectMake(0, 0, WIDTH, replyHeight))
//        let cell = UITableViewCell(style: .Default, reuseIdentifier: "feedbackListCell")
        cell.selectionStyle = .None
        
        let replyLab = UILabel(frame: CGRectMake(50, 0, WIDTH-58, 0))
        replyLab.backgroundColor = UIColor(red: 249/255.0, green: 242/255.0, blue: 247/255.0, alpha: 1)
        replyLab.numberOfLines = 0
        replyLab.textColor = COLOR
        replyLab.font = UIFont.systemFontOfSize(16)
        cell.contentView.addSubview(replyLab)
        
        replyLab.frame.size.height = replyHeight
        replyLab.text = replyText
        
        
        return cell
    }
    
    let feedbackContent = "找工作：填写简历按钮无反应、投递简历 无反应 找人才：发布企业招聘按钮无反应"
    let replyText = "您好，您反馈的问题我们已经收到了，会及时作出处理"
    // MARK: uitableview delegate
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let contentHeight = calculateHeight(feedbackContent, size: 16, width: WIDTH-8-25-8-8)
        
        let feedbackView = UIView(frame: CGRectMake(0, 0, WIDTH, 8+contentHeight+8))
        feedbackView.backgroundColor = UIColor.whiteColor()
        
        let iconImg = UIImageView(frame: CGRectMake(8, 8, 25, 30))
        iconImg.image = UIImage(named: "ic_note")
        feedbackView.addSubview(iconImg)
        
        let feedbackContentLab = UILabel(frame: CGRectMake(CGRectGetMaxX(iconImg.frame)+8, 8, WIDTH-8-25-8-8, contentHeight))
        feedbackContentLab.numberOfLines = 0
        feedbackContentLab.font = UIFont.systemFontOfSize(16)
        feedbackContentLab.textColor = UIColor.blackColor()
        feedbackContentLab.text = feedbackContent
        feedbackView.addSubview(feedbackContentLab)
        
        return feedbackView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8+calculateHeight(feedbackContent, size: 16, width: WIDTH-8-25-8-8)+8
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
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
