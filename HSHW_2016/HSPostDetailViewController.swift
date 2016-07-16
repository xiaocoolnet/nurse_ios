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

class HSPostDetailViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIWebViewDelegate,UIScrollViewDelegate {
    
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var avatar: UIButton!
    @IBOutlet weak var avatarName: UILabel!
    @IBOutlet weak var postion: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var seeCount: UILabel!
    @IBOutlet weak var sendTime: UILabel!

    let helper = HSNurseStationHelper()
    let replyTextField = UITextField()
    var contentTableView:UITableView!
    var postInfo:PostModel?
    var keyboardShowState = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "帖子详情"
        
        //内容视图
        contentTableView = UITableView.init(frame: CGRectMake(0, 90, WIDTH, HEIGHT-90-64-49), style: UITableViewStyle.Grouped)
        
        contentTableView.tag = 311
        contentTableView.rowHeight = 100
        contentTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        contentTableView.delegate = self
        contentTableView.dataSource = self
        
        self.view.addSubview(contentTableView)
        
        //注册cell
        contentTableView.registerNib(UINib.init(nibName: "HSForumDetailCell", bundle: nil), forCellReuseIdentifier: "detailCell")
        contentTableView.registerNib(UINib.init(nibName: "HSStateCommentCell", bundle: nil), forCellReuseIdentifier: "cell")

        //文字内容
        let text = postInfo!.content
        let height = calculateHeight(text, size: 15, width: WIDTH - 40)
        
        let bgView:UIView = UIView.init(frame: CGRectMake(0, 0, WIDTH, height+20))
        bgView.backgroundColor = UIColor.whiteColor()
        
        let label = UILabel(frame: CGRectMake(20,0,WIDTH-40,height+20))
        label.numberOfLines = 0
        label.text = text
        bgView.addSubview(label)
        contentTableView.tableHeaderView = bgView
        
        // 标题等头部内容
        postTitle.text = postInfo?.title
        avatarName.text = postInfo?.name
        postion.text = postInfo?.typename
        sendTime.text = postInfo?.write_time
        seeCount.text = "3346"
        level.text = "Lv.05"
    }
    //MARK:- TableView 代理方法
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return (postInfo?.pic.count)!
        }else{
            return 3
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let detailCell = tableView.dequeueReusableCellWithIdentifier("detailCell") as! HSForumDetailCell
            detailCell.selectionStyle = UITableViewCellSelectionStyle.None
            
            let picArray = postInfo?.pic
            detailCell.postImageView.sd_setImageWithURL(NSURL.init(string: SHOW_IMAGE_HEADER+picArray![indexPath.row].pictureurl))
            
            return detailCell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! HSStateCommentCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return (WIDTH-16)*2/3.0+20
        }else{
            if postInfo?.comment.count > 0 {
                let text = postInfo!.comment[indexPath.row].content
                let height = calculateHeight(text, size: 15, width: WIDTH - 40)
                return height
            }else{
                // TODO:仅作测试用，后期改为0
                return 107
            }
        }
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView.tag == 311 {
            if section == 1 {
        // TODO:有评论内容后postInfo?.comment.count > 0 统统改为postInfo?.comment.count == 0
                if postInfo?.comment.count > 0 {
                    
                    let noReply:UILabel = UILabel.init(frame: CGRectMake(0, 0, WIDTH, 200))
                    noReply.textAlignment = NSTextAlignment.Center
                    noReply.text = "暂无回复"
                    return noReply
                    
                }else{
                    return nil
                }
            }
        }

        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 && postInfo?.comment.count > 0 {
            return 200
        }else{
            return 0.0000000000001
        }
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            // 收藏 点赞 评论 视图
            let commentView:UIView = UIView.init(frame: CGRectMake(0, CGRectGetMaxY(contentTableView.frame), WIDTH, 50))
            
            let space = (WIDTH-75*3)/4.0
            let margin = space+75
            
            let imagesArray:Array<String> = ["ic_two_collect","ic_two_like","ic_two_comment"]
            let textArray:Array<String> = ["收藏","1136","16"]
            
            for i in 0...2 {
                let btn:UIButton = UIButton.init(frame: CGRectMake(margin*CGFloat(i)+space, 10, 75, 30))
                btn.tag = 3110+i
                btn.addTarget(self, action: #selector(collectionBtnClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
                let imageView:UIImageView = UIImageView.init(frame: CGRectMake(0, 0, 30, 30))
                imageView.image = UIImage.init(named: imagesArray[i])
                btn.addSubview(imageView)
                
                let label:UILabel = UILabel.init(frame: CGRectMake(33, 0, 42, 30))
                label.textColor = UIColor.init(red: 144/255.0, green: 25/255.0, blue: 106/255.0, alpha: 1)
                label.text = textArray[i]
                btn.addSubview(label)
                
                commentView.addSubview(btn)
            }
            
            let lineView:UIView = UIView.init(frame: CGRectMake(0, 49, WIDTH, 1))
            lineView.backgroundColor = UIColor.lightGrayColor()
            commentView.addSubview(lineView)
            // contentTableView.tableFooterView = commentView
            return commentView
        }else{
            // 回复 视图
            let replyView:UIView = UIView.init(frame: CGRectMake(0, CGRectGetMaxY(contentTableView.frame), WIDTH, 55))
            
            let space:CGFloat = 15
            
            let shareBtn:UIButton = UIButton.init(frame: CGRectMake(space, 10, 30, 30))
            shareBtn.setImage(UIImage.init(named: "ic_fenxiang"), forState: UIControlState.Normal)
            replyView.addSubview(shareBtn)
            
            let likeBtn:UIButton = UIButton.init(frame: CGRectMake(space+30+space, 10, 30, 30))
            
            likeBtn.setImage(UIImage.init(named: "ic_two_like"), forState: UIControlState.Normal)
            replyView.addSubview(likeBtn)
            
            replyTextField.frame = CGRectMake(space*3+60, 10, WIDTH-60-space*4, 30)
            replyTextField.borderStyle = UITextBorderStyle.RoundedRect
            replyTextField.placeholder = "回复楼主"
            replyTextField.returnKeyType = UIReturnKeyType.Send
            replyTextField.delegate = self
            replyView.addSubview(replyTextField)
            
            let lineView:UIView = UIView.init(frame: CGRectMake(0, 0, WIDTH, 1))
            lineView.backgroundColor = UIColor.lightGrayColor()
            replyView.addSubview(lineView)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HSPostDetailViewController.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardDidAppear), name: UIKeyboardDidShowNotification, object: nil)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HSPostDetailViewController.keyboardWillDisappear(_:)), name:UIKeyboardWillHideNotification, object: nil)
            
            return replyView
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 50
        }else{
            return 55
        }
    }
    
    func collectionBtnClicked(btn:UIButton) {
        print("click the ",btn.tag," button")
    }
    
    func shareBtnClick(shareBtn: UIButton) {
        
    }
    
    func likeBtnClick(likeBtn: UIButton) {
        
    }
    
    func keyboardWillAppear(notification: NSNotification) {
        
        // 获取键盘信息
        let keyboardinfo = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]
        
        let keyboardheight:CGFloat = (keyboardinfo?.CGRectValue.size.height)!
        
        UIView.animateWithDuration(0.3) {
            self.contentTableView.contentOffset = CGPoint.init(x: 0, y: self.contentTableView.contentSize.height-keyboardheight-49)
        }
        
        print("键盘弹起")
        print(keyboardheight)
        
    }
    
    func keyboardDidAppear(notification:NSNotification) {
        keyboardShowState = true
    }
    
    func keyboardWillDisappear(notification:NSNotification){
        UIView.animateWithDuration(0.3) {
            self.contentTableView.contentOffset = CGPoint.init(x: 0, y: self.contentTableView.contentSize.height-self.contentTableView.frame.size.height)
        }
        print("键盘落下")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("textfield.text = ",textField.text)
        if textField.text != "" {
            helper.setComment((postInfo?.mid)!, content: (postInfo?.content)!, type: "2", photo: (postInfo?.photo)!, handle: { (success, response) in
                print("添加评论",success)
            })
        }
        textField.resignFirstResponder()
        return true
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if keyboardShowState == true {
            self.view.endEditing(true)
            keyboardShowState = false
        }
    }
}
