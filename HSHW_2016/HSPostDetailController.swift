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

//    @IBOutlet weak var postTitle: UILabel!
//    @IBOutlet weak var commentView: UITableView!
//    @IBOutlet weak var avatar: UIButton!
//    @IBOutlet weak var avatarName: UILabel!
//    @IBOutlet weak var postion: UILabel!
//    @IBOutlet weak var level: UILabel!
//    @IBOutlet weak var seeCount: UILabel!
//    @IBOutlet weak var sendTime: UILabel!
//    @IBOutlet weak var collectionBtn: UIButton!
//    @IBOutlet weak var goodBtn: UIButton!
//    @IBOutlet weak var goodLabel: UILabel!
//    @IBOutlet weak var commentBtn: UIButton!
//    @IBOutlet weak var commentLabel: UILabel!
//    @IBOutlet weak var veiwHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var fenxiangBtn: UIButton!
//    @IBOutlet weak var likeBtn: UIButton!
//    @IBOutlet weak var contentTableView:UITableView!
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
    weak var contentTableView:UITableView!
    var postInfo:PostModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "帖子详情"
        
        // 评论视图
        commentView.registerNib(UINib(nibName:"HSStateCommentCell",bundle: nil ), forCellReuseIdentifier: "cell")
        commentView.estimatedRowHeight = 108
        commentView.rowHeight = UITableViewAutomaticDimension
        
        //内容视图
        contentTableView = UITableView.init(frame: CGRectMake(0, 90, WIDTH, HEIGHT-90-50-64-49))
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
        
        contentTableView.frame = CGRectMake(contentTableView.frame.origin.x, contentTableView.frame.origin.y, WIDTH, WIDTH*0.9*11)
        
        postTitle.text = postInfo?.title
        avatarName.text = postInfo?.name
        postion.text = postInfo?.typename
        sendTime.text = postInfo?.write_time
        seeCount.text = "3346"
        level.text = "Lv.05"
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 233 {
            return (postInfo?.pic.count)!
        }else{
            print("comment count ",postInfo?.comment.count)
          
            return (postInfo?.comment.count)!
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
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView.tag != 233 {
            if postInfo?.comment.count == 0 {
                
                let noReply:UILabel = UILabel.init(frame: CGRectMake(0, 0, WIDTH, 200))
                noReply.backgroundColor = UIColor.redColor()
                noReply.textAlignment = NSTextAlignment.Center
                noReply.text = "暂无回复"
                return noReply
                
            }
        }
        return nil
    }
    
    @IBAction func fenxiangBtnClick(sender: AnyObject) {
        
    }
    
    @IBAction func likeBtnClick(sender: AnyObject) {
        
    }
}
