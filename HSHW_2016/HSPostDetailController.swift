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
    @IBOutlet weak var collectionBtn: UIButton!
    @IBOutlet weak var goodBtn: UIButton!
    @IBOutlet weak var goodLabel: UILabel!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var veiwHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var fenxiangBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var contentTableView:UITableView!
    var forumInfo:ForumModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "帖子详情"
        commentView.registerNib(UINib(nibName:"HSStateCommentCell",bundle: nil ), forCellReuseIdentifier: "cell")
        commentView.estimatedRowHeight = 108
        commentView.rowHeight = UITableViewAutomaticDimension
        
        contentTableView.estimatedRowHeight = 100
        contentTableView.rowHeight = UITableViewAutomaticDimension
        contentTableView.registerNib(UINib(nibName: "HSForumDetailCell",bundle: nil), forCellReuseIdentifier: "detailcell")
        let text = "记录第一次发帖"
        let height = calculateHeight(text, size: 15, width: WIDTH - 40)
        let label = UILabel(frame: CGRectMake(20,0,WIDTH-40,height+20))
        label.numberOfLines = 0
        label.text = text
        contentTableView.tableHeaderView = label
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView.tag == 233  {
            let detailCell = tableView.dequeueReusableCellWithIdentifier("detailcell") as! HSForumDetailCell
            return detailCell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! HSStateCommentCell
        return cell
    }
    
    @IBAction func fenxiangBtnClick(sender: AnyObject) {
        
    }
    
    @IBAction func likeBtnClick(sender: AnyObject) {
        
    }
}
