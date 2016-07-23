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
    
    var isCollect:Bool = false
    var isLike:Bool = false
    
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
        avatar.layer.cornerRadius = avatar.frame.size.width/2.0
        avatar.layer.masksToBounds = true
        avatar.sd_setImageWithURL(NSURL.init(string: SHOW_IMAGE_HEADER+(postInfo?.photo)!), forState: .Normal)
        avatarName.text = postInfo?.name
        postion.text = postInfo?.typename
        sendTime.text = timeStampToString((postInfo?.write_time)!)
        seeCount.text = "3346"
        level.text = "Lv.05"
    }
    
    // Linux时间戳转标准时间
    func timeStampToString(timeStamp:String)->String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:NSTimeInterval = string.doubleValue
        let dfmatter = NSDateFormatter()
        dfmatter.dateFormat="yyyy/MM/dd hh:mm"
        
        let date = NSDate(timeIntervalSince1970: timeSta)
        
        print(dfmatter.stringFromDate(date))
        return dfmatter.stringFromDate(date)
    }
    
    func getData() {
        
    }
    
    //MARK:- TableView 代理方法
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return (postInfo?.pic.count)!
        }else{
            return (postInfo?.comment.count)!
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
            
            if postInfo?.userid != postInfo?.comment[indexPath.row].userid {
                cell.louzhuLab.hidden = true
            }else{
                cell.louzhuLab.hidden = false
            }
            
            cell.commentModel = postInfo?.comment[indexPath.row]
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
                return height+107
            }else{
                // TODO:仅作测试用，后期改为0
                return 0
            }
        }
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView.tag == 311 {
            if section == 1 {
        // TODO:有评论内容后postInfo?.comment.count > 0 统统改为postInfo?.comment.count == 0
                if postInfo?.comment.count == 0 {
                    
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
        if section == 1 && postInfo?.comment.count == 0 {
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
            
            
            let textArray:Array<String> = ["收藏","1136",String((postInfo?.comment.count)!)]
            
            for i in 0...2 {
                let btn:UIButton = UIButton.init(frame: CGRectMake(margin*CGFloat(i)+space, 10, 75, 30))
                btn.tag = 3110+i
                if btn.tag == 3110 {
                    btn.addTarget(self, action: #selector(collectionBtnClicked(_:)), forControlEvents: .TouchUpInside)
                }else if btn.tag == 3111 {
                    btn.addTarget(self, action: #selector(shareBtnClick(_:)), forControlEvents: .TouchUpInside)
                }else{
                    btn.addTarget(self, action: #selector(likeBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                }
                
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
    
    func collectionBtnClicked(btn:UIButton){
        let user = NSUserDefaults.standardUserDefaults()
        let uid = user.stringForKey("userid")
        let userID = user.stringForKey(postInfo!.mid)
        if userID == "false"||userID==nil{
            helper.collectionForum(postInfo!.mid, title: postInfo!.title, description: postInfo!.content) { (success, response) in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                   let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                   hud.mode = MBProgressHUDMode.Text;
                   hud.labelText = "收藏成功"
                   hud.margin = 10.0
                   hud.removeFromSuperViewOnHide = true
                   hud.hide(true, afterDelay: 1)
                   user.setObject("true", forKey: "isCollect")
                   user.setObject("true", forKey: (self.postInfo!.mid))
                   self.isCollect=true
                    })
                }
            }

        }else{
            
            let url = PARK_URL_Header+"cancelfavorite"
            let param = [
                "refid":uid,
                "type":"4",
                "userid":self.postInfo!.mid
            ];
            Alamofire.request(.GET, url, parameters: param as? [String:String]).response { request, response, json, error in
                print(request)
                if(error != nil){
                    
                }else{
                    let status = Http(JSONDecoder(json!))
                    print("状态是")
                    print(status.status)
                    if(status.status == "error"){
                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = status.errorData
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
//                        user.setObject("false", forKey: (self.postInfo!.mid))
                    }
                    if(status.status == "success"){
                        
                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = "取消收藏成功"
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                        //self.myTableView .reloadData()
                        print(status.data)
                        self.isCollect=false
                        user.setObject("false", forKey: "isCollect")
                        user.removeObjectForKey((self.postInfo!.mid))
                    }
                }
                
            }
            
        }

    }
    
    func shareBtnClick(shareBtn: UIButton) {
        print("点赞")
        self.zanAddNum()
        
    }
    
    func likeBtnClick(likeBtn: UIButton) {
        print("评论")
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
            helper.setComment((postInfo?.mid)!, content: (textField.text)!, type: "2", photo: "", handle: { (success, response) in
                print("添加评论",success)
                if success {
                    
                    let dic = ["userid":String(QCLoginUserInfo.currentInfo.userid),"name":String(QCLoginUserInfo.currentInfo.userName),"content":String(UTF8String: textField.text!)!]
                    let commentModel = CommentModel.init(JSONDecoder(dic))
                    self.postInfo?.comment.append(commentModel)
                    
                    self.contentTableView.reloadData()
                    self.contentTableView.contentOffset = CGPoint(x: 0, y: self.contentTableView.contentSize.height-self.contentTableView.frame.size.height)
                    
                    textField.text = nil
                    
                }
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
    func zanAddNum() {
        let user = NSUserDefaults.standardUserDefaults()
        let uid = user.stringForKey("userid")
        let userID = user.stringForKey(self.postInfo!.mid)
            print(userID)
            if userID == "false"||userID==nil{
                let url = PARK_URL_Header+"SetLike"
                let param = [
                    "id":uid,
                    "type":"2",
                    "userid":self.postInfo!.mid,
                    ];
                Alamofire.request(.GET, url, parameters: param as? [String:String] ).response { request, response, json, error in
                    print(request)
                    if(error != nil){
                        
                    }else{
                        let status = Http(JSONDecoder(json!))
                        print("状态是")
                        print(status.status)
                        if(status.status == "error"){
                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                            hud.mode = MBProgressHUDMode.Text
                            hud.labelText = status.errorData
                            hud.margin = 10.0
                            hud.removeFromSuperViewOnHide = true
                            hud.hide(true, afterDelay: 1)
                        }
                        if(status.status == "success"){
                            
                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                            hud.mode = MBProgressHUDMode.Text;
                            hud.labelText = "点赞成功"
                            hud.margin = 10.0
                            hud.removeFromSuperViewOnHide = true
                            hud.hide(true, afterDelay: 1)
                            user.setObject("true", forKey: "isLike")
                            user.setObject("true", forKey: self.postInfo!.mid)
                            print(status.data)
                            self.isLike=true
                        }
                    }
                }
            }else{
                
                let url = PARK_URL_Header+"ResetLike"
                let param = [
                    "id":uid,
                    "type":"2",
                    "userid":self.postInfo!.mid
                ];
                Alamofire.request(.GET, url, parameters: param as? [String:String]).response { request, response, json, error in
                    print(request)
                    if(error != nil){
                        
                    }else{
                        let status = Http(JSONDecoder(json!))
                        print("状态是")
                        print(status.status)
                        if(status.status == "error"){
                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                            hud.mode = MBProgressHUDMode.Text;
                            hud.labelText = status.errorData
                            hud.margin = 10.0
                            hud.removeFromSuperViewOnHide = true
                            hud.hide(true, afterDelay: 1)
//                            user.setObject("false", forKey: self.postInfo!.mid)
                        }
                        if(status.status == "success"){
                            
                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                            hud.mode = MBProgressHUDMode.Text;
                            hud.labelText = "取消点赞成功"
                            hud.margin = 10.0
                            hud.removeFromSuperViewOnHide = true
                            hud.hide(true, afterDelay: 1)
                            //self.myTableView .reloadData()
                            print(status.data)
                            self.isLike=false
                            user.setObject("false", forKey: "isLike")
//                            self.performSelectorOnMainThread(#selector(self.upDateUI(_:)), withObject: [btn.tag,"0"], waitUntilDone:true)
                            user.removeObjectForKey(self.postInfo!.mid)
                        }
                    }
                    
                }
                
            }
        
        }
    }
    

