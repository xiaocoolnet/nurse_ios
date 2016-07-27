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
    @IBOutlet weak var louzhuLab: UILabel!
    
    var collectBtn:UIButton = UIButton() // 收藏按钮
    var collectImgBtn:UIButton = UIButton() // 收藏图标
    
//    var likeBtn:UIButton = UIButton() // 点赞按钮
    var likeImgBtn:UIButton = UIButton() // 点赞图标
//    var likeLabel:UILabel = UILabel() // 点赞数字
    var like_bottom_Btn:UIButton = UIButton() // 下方点赞按钮

    let helper = HSNurseStationHelper()
    let replyTextField = UITextField()
    var contentTableView:UITableView!
    var postInfo:PostModel?
    var keyboardShowState = false
    
    var isCollect:Bool = false
    var isLike:Bool = false
    var likeNum = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if LOGIN_STATE {
            judgeCollection()
            judgeLike()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "帖子详情"
        
        likeNum = (postInfo?.like.count)!
        //内容视图
        contentTableView = UITableView.init(frame: CGRectMake(0, 90, WIDTH, HEIGHT-90-64-49), style: UITableViewStyle.Grouped)
        contentTableView.backgroundColor = UIColor.whiteColor()
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
        let height = calculateHeight(text, size: 14, width: WIDTH - 40)
        
        let bgView:UIView = UIView.init(frame: CGRectMake(0, 0, WIDTH, height+20))
        bgView.backgroundColor = UIColor.whiteColor()
        
        let label = UILabel(frame: CGRectMake(20,0,WIDTH-40,height+15))
        label.numberOfLines = 0
        label.text = text
        label.font = UIFont.systemFontOfSize(14)
        bgView.addSubview(label)
        contentTableView.tableHeaderView = bgView
        
        // 标题等头部内容
        postTitle.text = postInfo?.title
        avatar.layer.cornerRadius = avatar.frame.size.width/2.0
        avatar.layer.masksToBounds = true
        print(postInfo?.photo)
        
        louzhuLab.layer.cornerRadius = 2
        louzhuLab.layer.borderWidth = 1
        louzhuLab.layer.borderColor = COLOR.CGColor
        
        if postInfo?.photo == "default_header" || postInfo?.photo == "1234.png" {
            avatar.setImage(UIImage.init(named: "default_header"), forState: .Normal)
        }else{
            avatar.sd_setImageWithURL(NSURL.init(string: SHOW_IMAGE_HEADER+(postInfo?.photo)!), forState: .Normal)
        }
    
        print(postion.text,postInfo?.typename)
        avatarName.text = postInfo?.name
        sendTime.text = timeStampToString((postInfo?.write_time)!)
        // MARK: 阅读量
        seeCount.text = String(arc4random_uniform(10000))
        
        HSMineHelper().getUserInfo((postInfo?.userid)!) { (success, response) in
            
            dispatch_async(dispatch_get_main_queue(), { 
                self.level.text = String(format: "Lv.%02d",Int((response as! HSFansAndFollowModel).level)!)
            })
        }
        helper.showPostInfo((postInfo?.mid)!) { (success, response) in
            dispatch_async(dispatch_get_main_queue(), { 
                self.postion.text = (response as! PostModel).typename
            })
        }
        
    }
    
    // Linux时间戳转标准时间
    func timeStampToString(timeStamp:String)->String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:NSTimeInterval = string.doubleValue
        let dfmatter = NSDateFormatter()
        dfmatter.dateFormat="yyyy/MM/dd"
        
        let date = NSDate(timeIntervalSince1970: timeSta)
        
        print(dfmatter.stringFromDate(date))
        return dfmatter.stringFromDate(date)
    }
    
    // MARK:判断是否已收藏
    func judgeCollection() {
        HSMineHelper().getCollectionInfoWithType("4") { (success, response) in
            
            let list =  PostCollectListModel(response as! JSONDecoder).datas
            for model in list {
                if model.object_id == self.postInfo?.mid{
                    self.collectImgBtn.selected = true
                }
            }
        }
    }
    // MARK:判断是否已点赞
    func judgeLike() {
        
        for model in (self.postInfo?.like)! {
            if model.userid == QCLoginUserInfo.currentInfo.userid{
                self.likeImgBtn.selected = true
                self.like_bottom_Btn.selected = true
            }
        }
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
            print("picurl ===   ",SHOW_IMAGE_HEADER+picArray![indexPath.row].pictureurl)
            
            return detailCell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! HSStateCommentCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            if postInfo?.userid == postInfo?.comment[indexPath.row].userid {
                cell.louzhuLab.hidden = false
            }else{
                cell.louzhuLab.hidden = true
            }
            
            cell.floorLab.text = "\(indexPath.row+1)楼"
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
            commentView.backgroundColor = UIColor.whiteColor()
            
            setCollectEtcBtn(commentView)
            
            let line_bottomView:UIView = UIView.init(frame: CGRectMake(15, 49, WIDTH-30, 1))
            line_bottomView.backgroundColor = UIColor.lightGrayColor()
            commentView.addSubview(line_bottomView)
            return commentView
        }else{
            // 回复 视图
            let replyView:UIView = UIView.init(frame: CGRectMake(0, CGRectGetMaxY(contentTableView.frame), WIDTH, 50))
            replyView.backgroundColor = UIColor.whiteColor()
            
            let space:CGFloat = 15
            
            // 分享
            let shareBtn:UIButton = UIButton.init(frame: CGRectMake(space, 10, 30, 30))
            shareBtn.setImage(UIImage.init(named: "ic_two_share"), forState: UIControlState.Normal)
            shareBtn.addTarget(self, action: #selector(shareBtnClick(_:)), forControlEvents: .TouchUpInside)
            replyView.addSubview(shareBtn)
            
            // 赞
            like_bottom_Btn.frame = CGRectMake(space+30+space, 10, 30, 30)
            like_bottom_Btn.setImage(UIImage.init(named: "ic_two_like"), forState: UIControlState.Normal)
            like_bottom_Btn.setImage(UIImage.init(named: "ic_two_like_sel"), forState: UIControlState.Selected)
            like_bottom_Btn.addTarget(self, action: #selector(likeBtnClicked), forControlEvents: .TouchUpInside)
            replyView.addSubview(like_bottom_Btn)
            
            // 回复框
            replyTextField.frame = CGRectMake(space*3+60, 10, WIDTH-60-space*4, 30)
            replyTextField.borderStyle = UITextBorderStyle.RoundedRect
            replyTextField.placeholder = "回复楼主"
            replyTextField.returnKeyType = UIReturnKeyType.Send
            replyTextField.delegate = self
            replyView.addSubview(replyTextField)
            
            let line_topView:UIView = UIView.init(frame: CGRectMake(0, 0, WIDTH, 1))
            line_topView.backgroundColor = UIColor.lightGrayColor()
            replyView.addSubview(line_topView)
            
            let line_bottomView:UIView = UIView.init(frame: CGRectMake(0, 49, WIDTH, 1))
            line_bottomView.backgroundColor = UIColor.lightGrayColor()
            replyView.addSubview(line_bottomView)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HSPostDetailViewController.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardDidAppear), name: UIKeyboardDidShowNotification, object: nil)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HSPostDetailViewController.keyboardWillDisappear(_:)), name:UIKeyboardWillHideNotification, object: nil)
            
            return replyView
        }
    }
    
    // MARK:设置收藏等按钮
    func setCollectEtcBtn(commentView:UIView) {
        
        let space = (WIDTH-75*3)/4.0

        let margin = space+75
        
        let imagesNormalArray:Array<String> = ["ic_two_collect","ic_two_like","ic_two_comment"]
        let imagesSelectedArray:Array<String> = ["ic_two_collect_sel","ic_two_like_sel","ic_two_comment"]
        
        let textArray:Array<String> = ["收藏",String(likeNum),String((postInfo?.comment.count)!)]
        
        // 收藏按钮
        collectBtn.frame = CGRectMake(space, 10, 75, 30)
        collectBtn.addTarget(self, action: #selector(collectIconClick), forControlEvents: .TouchUpInside)
        
        collectImgBtn.frame = CGRectMake(0, 0, 30, 30)
        collectImgBtn.setImage(UIImage.init(named: imagesNormalArray[0]), forState: .Normal)
        collectImgBtn.setImage(UIImage.init(named: imagesSelectedArray[0]), forState: .Selected)
        collectImgBtn.addTarget(self, action: #selector(collectIconClick), forControlEvents: .TouchUpInside)
        collectImgBtn.tag = 1000
        collectBtn.addSubview(collectImgBtn)
        
        let collectLabel:UILabel = UILabel.init(frame: CGRectMake(33, 0, 42, 30))
        collectLabel.textColor = UIColor.init(red: 144/255.0, green: 25/255.0, blue: 106/255.0, alpha: 1)
        collectLabel.text = textArray[0]
        collectBtn.addSubview(collectLabel)
        
        commentView.addSubview(collectBtn)
        
        // 点赞按钮
        
        let likeBtn:UIButton = UIButton.init(frame: CGRectMake(margin+space, 10, 75, 30))
        likeBtn.addTarget(self, action: #selector(likeBtnClicked), forControlEvents: .TouchUpInside)
        
        likeImgBtn.frame =  CGRectMake(0, 0, 30, 30)
        likeImgBtn.setImage(UIImage.init(named: imagesNormalArray[1]), forState: .Normal)
        likeImgBtn.setImage(UIImage.init(named: imagesSelectedArray[1]), forState: .Selected)
        likeImgBtn.addTarget(self, action: #selector(likeBtnClicked), forControlEvents: .TouchUpInside)
        likeImgBtn.tag = 1000
        likeBtn.addSubview(likeImgBtn)
        
        let likeLabel:UILabel = UILabel.init(frame: CGRectMake(33, 0, 42, 30))
        likeLabel.textColor = UIColor.init(red: 144/255.0, green: 25/255.0, blue: 106/255.0, alpha: 1)
        likeLabel.text = textArray[1]
        likeBtn.addSubview(likeLabel)
        
        commentView.addSubview(likeBtn)
        
        // 评论按钮
        let commentBtn:UIButton = UIButton.init(frame: CGRectMake(margin*2+space, 10, 75, 30))
        commentBtn.addTarget(self, action: #selector(commentBtnClick(_:)), forControlEvents: .TouchUpInside)
        
        let commentImgBtn:UIButton = UIButton.init(frame: CGRectMake(0, 0, 30, 30))
        commentImgBtn.setImage(UIImage.init(named: imagesNormalArray[2]), forState: .Normal)
        commentImgBtn.setImage(UIImage.init(named: imagesSelectedArray[2]), forState: .Selected)
        commentImgBtn.addTarget(self, action: #selector(commentBtnClick(_:)), forControlEvents: .TouchUpInside)
        commentImgBtn.tag = 1000
        commentBtn.addSubview(commentImgBtn)
        
        let commentLabel:UILabel = UILabel.init(frame: CGRectMake(33, 0, 42, 30))
        commentLabel.textColor = UIColor.init(red: 144/255.0, green: 25/255.0, blue: 106/255.0, alpha: 1)
        commentLabel.text = textArray[2]
        commentBtn.addSubview(commentLabel)
        
        commentView.addSubview(commentBtn)
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 50
        }else{
            return 55
        }
    }
    
    // MARK:点击收藏按钮
    func collectIconClick() {
        // MARK:要求登录
        if !requiredLogin(self.navigationController!, hasBackItem: true) {
            return
        }
        
        if collectImgBtn.selected {
            let url = PARK_URL_Header+"cancelfavorite"
            let param = [
                "refid":QCLoginUserInfo.currentInfo.userid,
                "type":"4",
                "userid":self.postInfo!.mid
            ];
            Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
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
                        hud.hide(true, afterDelay: 0.5)
                        //                        user.setObject("false", forKey: (self.postInfo!.mid))
                    }
                    if(status.status == "success"){
                        
                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = "取消收藏成功"
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 0.5)
                        //self.myTableView .reloadData()
                        print(status.data)
                        self.collectImgBtn.selected = false
                    }
                }
                
            }
        }else{
            helper.collectionForum(postInfo!.mid, title: postInfo!.title, description: postInfo!.content) { (success, response) in
                if success {
                    dispatch_async(dispatch_get_main_queue(), {
                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = "收藏成功"
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 0.5)
                        self.collectImgBtn.selected = true
                    })
                }
            }
        }
    }
    
    // MARK:点击赞
    func likeBtnClicked() {
        
        // MARK:要求登录
        if !requiredLogin(self.navigationController!, hasBackItem: true) {
            return
        }
        
        if likeImgBtn.selected {
            
            let url = PARK_URL_Header+"ResetLike"
            let param = [
                "id":QCLoginUserInfo.currentInfo.userid,
                "type":"2",
                "userid":self.postInfo!.mid
            ];
            Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
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
                        hud.hide(true, afterDelay: 0.5)
                        
                    }
                    if(status.status == "success"){
                        
                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = "取消点赞成功"
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 0.5)
                        
                        print(status.data)
                        
                        dispatch_async(dispatch_get_main_queue(), { 
                            
                            self.likeImgBtn.selected = false
                            self.like_bottom_Btn.selected = false
                            self.likeNum -= 1
//                            self.likeLabel.text = String(Int(self.likeLabel.text!)!-1)
                            self.contentTableView.reloadData()
                        })
                    }
                }
            }
        }else{
            let url = PARK_URL_Header+"SetLike"
            let param = [
                "id":QCLoginUserInfo.currentInfo.userid,
                "type":"2",
                "userid":self.postInfo!.mid,
                ];
            Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
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
                        hud.hide(true, afterDelay: 0.5)
                    }
                    if(status.status == "success"){
                        
                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = "点赞成功"
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 0.5)
                        
                        print(status.data)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.likeImgBtn.selected = true
                            self.like_bottom_Btn.selected = true
                            self.likeNum += 1
//                            self.likeLabel.text = String(Int(self.likeLabel.text!)!+1)
                            self.contentTableView.reloadData()
                        })
                    }
                }
            }
        }
    }

    // MARK:点击评论按钮
    func commentBtnClick(commentBtn: UIButton) {
        print("点击评论按钮")
        if self.contentTableView.contentSize.height > self.contentTableView.frame.size.height {
            
            self.contentTableView.contentOffset = CGPoint(x: 0, y: self.contentTableView.contentSize.height-self.contentTableView.frame.size.height)
        }
        replyTextField.becomeFirstResponder()
    }
    
    // MARK:点击分享
    func shareBtnClick(shareBtn:UIButton) {
        let alertController = UIAlertController(title: "分享到...", message: nil, preferredStyle: .ActionSheet)
        self.presentViewController(alertController, animated: true, completion: nil)
        
        let wechatAction = UIAlertAction(title: "微信好友", style: .Default) { (pengyouquanAction) in
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = MBProgressHUDMode.Text;
            hud.labelText = "这几个功能明天做"
            hud.margin = 10.0
            hud.removeFromSuperViewOnHide = true
            hud.hide(true, afterDelay: 2)
        }
        alertController.addAction(wechatAction)
        
        let weiboAction = UIAlertAction(title: "新浪微博", style: .Default) { (pengyouquanAction) in
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = MBProgressHUDMode.Text;
            hud.labelText = "这几个功能明天做"
            hud.margin = 10.0
            hud.removeFromSuperViewOnHide = true
            hud.hide(true, afterDelay: 2)
        }
        alertController.addAction(weiboAction)
        
        let pengyouquanAction = UIAlertAction(title: "朋友圈", style: .Default) { (pengyouquanAction) in
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = MBProgressHUDMode.Text;
            hud.labelText = "这几个功能明天做"
            hud.margin = 10.0
            hud.removeFromSuperViewOnHide = true
            hud.hide(true, afterDelay: 2)
        }
        alertController.addAction(pengyouquanAction)
        
        
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
    }
    
    // MARK:- 获取键盘信息并改变视图
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
    // MARK:-
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        // MARK:要求登录
        return requiredLogin(self.navigationController!, hasBackItem: true)
        
    }
    
    // MARK:点击回车  发表回复
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("textfield.text = ",textField.text)
        if textField.text != "" {
            helper.setComment((postInfo?.mid)!, content: (textField.text)!, type: "2", photo: "", handle: { (success, response) in
                print("添加评论",success,response)
                if success {
                    
                    let dic = ["userid":String(QCLoginUserInfo.currentInfo.userid),"name":String(QCLoginUserInfo.currentInfo.userName),"content":String(UTF8String: textField.text!)!]
                    let commentModel = CommentModel.init(JSONDecoder(dic))
                    self.postInfo?.comment.append(commentModel)
                    
                    self.contentTableView.reloadData()
                    if self.contentTableView.contentSize.height > self.contentTableView.frame.size.height {
                        
                        self.contentTableView.contentOffset = CGPoint(x: 0, y: self.contentTableView.contentSize.height-self.contentTableView.frame.size.height)
                    }
                    
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
    
    func upDateUI(status:String){
        if status == "1" {
            self.likeNum = self.likeNum + 1
        }else{
            self.likeNum = self.likeNum - 1
        }
        self.contentTableView.reloadData()
    }

    
    
}
    

