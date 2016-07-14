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
    var postInfo:ForumModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "帖子详情"
        commentView.registerNib(UINib(nibName:"HSStateCommentCell",bundle: nil ), forCellReuseIdentifier: "cell")
        commentView.estimatedRowHeight = 108
        commentView.rowHeight = UITableViewAutomaticDimension
        
        contentTableView.estimatedRowHeight = 100
        contentTableView.rowHeight = UITableViewAutomaticDimension
        contentTableView.registerNib(UINib(nibName: "HSForumDetailCell",bundle: nil), forCellReuseIdentifier: "detailcell")
        let text = postInfo!.content
        let height = calculateHeight(text, size: 15, width: WIDTH - 40)
        let label = UILabel(frame: CGRectMake(20,0,WIDTH-40,height+20))
        print("height=",height)
        label.numberOfLines = 0
        label.text = text
        contentTableView.tableHeaderView = label
        
        postTitle.text = postInfo?.title
        avatarName.text = postInfo?.name
        sendTime.text = postInfo?.write_time
        seeCount.text = "3346"
        level.text = "Lv.05"
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 233 {
            print("pic.count=",postInfo?.pic.count,"pic   ",postInfo)
            return (postInfo?.pic.count)!
        }else{
            print(postInfo?.comment.count)
            if postInfo?.comment.count == 0 {
                return 1
            }else{
                return (postInfo?.comment.count)!
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView.tag == 233  {
            let detailCell = tableView.dequeueReusableCellWithIdentifier("detailcell") as! HSForumDetailCell
            let picArray = postInfo?.pic
            let postImage:UIImage = UIImage.sd_imageWithData(NSData.init(contentsOfURL: NSURL.init(string: SHOW_IMAGE_HEADER+picArray![indexPath.row].pictureurl)!))
            detailCell.imageView?.image = postImage
            return detailCell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! HSStateCommentCell
        if postInfo?.comment.count == 0 {
            let defaultLabel:UILabel = UILabel.init(frame: CGRectMake(0, 0, WIDTH, 107))
            defaultLabel.backgroundColor = UIColor.cyanColor()
            defaultLabel.text = "暂无回复"
            cell.addSubview(defaultLabel)
            
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView.tag != 233 {
            if postInfo?.comment.count == 0 {
                return 107
            }
        }
        return WIDTH*0.9
    }
    
    @IBAction func fenxiangBtnClick(sender: AnyObject) {
        
    }
    
    @IBAction func likeBtnClick(sender: AnyObject) {
        
    }
}
