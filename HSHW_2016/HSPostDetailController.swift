//
//  HSPostDetailController.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/7/3.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class HSPostDetailController: UIViewController,UITableViewDataSource, UITableViewDelegate,UIWebViewDelegate {

    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var commentView: UITableView!
    @IBOutlet weak var avatar: UIButton!
    @IBOutlet weak var avatarName: UILabel!
    @IBOutlet weak var postion: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var seeCount: UILabel!
    @IBOutlet weak var sendTime: UILabel!
    @IBOutlet weak var contentWeb: UIWebView!
    @IBOutlet weak var collectionBtn: UIButton!
    @IBOutlet weak var goodBtn: UIButton!
    @IBOutlet weak var goodLabel: UILabel!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var veiwHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var fenxiangBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    var newsInfo :NewsInfo?
    var dataSource = NewsList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "帖子详情"
        commentView.registerNib(UINib(nibName:"HSStateCommentCell",bundle: nil ), forCellReuseIdentifier: "cell")
        commentView.estimatedRowHeight = 108
        commentView.rowHeight = UITableViewAutomaticDimension
        
        for subView in contentWeb!.subviews
        {
            let v = subView
            if v.isKindOfClass(UIScrollView.self) == true
            {
                (v as! UIScrollView).scrollEnabled = false
                (v as! UIScrollView).alwaysBounceVertical = false
                
                (v as! UIScrollView).showsHorizontalScrollIndicator = false
                (v as! UIScrollView).showsVerticalScrollIndicator = false
            }
        }
        // Do any additional setup after loading the view.
        
    }
    func loadRequestUrl(requestUrl:NSURL){
        contentWeb.loadRequest(NSURLRequest(URL: requestUrl))
    }
    
   
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! HSStateCommentCell
        return cell
    }
    
    @IBAction func fenxiangBtnClick(sender: AnyObject) {
    }
    
    @IBAction func likeBtnClick(sender: AnyObject) {
    }
    
}



