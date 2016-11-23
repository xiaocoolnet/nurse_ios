//
//  NewsContantViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/14.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import SwiftyJSON

protocol changeModelDelegate {
    func changeModel(newInfo:NewsInfo, andIndex:Int)
}

class NewsContantViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate, UITextViewDelegate {

    let myTableView = UITableView()
    var collectBtn = UIButton()
    var collectHud = MBProgressHUD()
    let number = UILabel()
    let shareArr:[String] = ["ic_pengyouquan.png","ic_wechat.png","ic_weibo.png"]
    var newsInfo :NewsInfo? {
        didSet {
            self.title = newsInfo?.term_name
            self.likeNum = (newsInfo?.likes.count)!
            newsInfo?.post_hits = String(Int((newsInfo?.post_hits)!)!+1)
            self.getComment()
        }
    }
//    var navTitle:String = "新闻内容" {
//        didSet {
////            self.title = navTitle
//        }
//    }
    var index = 0
    var delegate:changeModelDelegate?
    
    var likeNum  = 0
    var webHeight:CGFloat = 100
//    var isLike:Bool = false
//    var isCollect:Bool = false
//    var dataSource = NewsList()
    var commentArray = [commentDataModel]()
    var helper = NewsPageHelper()
    let zan = UIButton(frame: CGRectMake(WIDTH*148/375, WIDTH*80/375, WIDTH*80/375, WIDTH*80/375))
    var finishLoad = false
    var tagNum = 0
    
    var mainFlag = 0
    var mainHud = MBProgressHUD()
    
    var webFlag = true// 防止多次加载网页
    
    let studyIdArray = ["10","95","11","130","131","132","12","134","135","136","13","137","138","139","140","141","142","143","14","15","16"]
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.defaultStat().pageviewStartWithName("新闻详情页")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.defaultStat().pageviewEndWithName("新闻详情页")
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
        self.navigationItem.leftBarButtonItem?.title = "返回"
        
        if LOGIN_STATE {
            mainHud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            //        MBProgressHUD().labelText = ""
            
            // MARK: 检查是否收藏
            checkHadFavorite((self.newsInfo?.object_id)!, type: "1", handle: { (success, response) in
                if success {
                    self.collectBtn.selected = true
                    self.collect_bottom_Btn.selected = true
                }else{
                    self.collectBtn.selected = false
                    self.collect_bottom_Btn.selected = false
                }
                checkHadLike((self.newsInfo?.object_id)!, type: "1", handle: { (success, response) in
                    if success {
                        self.zan.selected = true
                    }else{
                        self.zan.selected = false
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        self.collectBtn.enabled = true
//                        hud.hide(true)
                        self.mainFlag += 1
                        if self.mainFlag == 3 {
                            self.mainFlag = 0
                            self.mainHud.hide(true)
                        }
                    })
                })
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "新闻内容"
        
//        let collectBtn = UIBarButtonItem(image: UIImage(named: "ic_shoucang"), style: .Plain, target: self, action: #selector(collectionNews))
//
//        self.navigationItem.rightBarButtonItems = [shareBtn,collectBtn]
        
//        //收藏按钮
//        collectBtn = UIButton(frame:CGRectMake(0, 0, 18, 18))
//        collectBtn.setImage(UIImage(named: "btn_collect_sel"), forState: .Normal)
//        collectBtn.setImage(UIImage(named: "ic_shoucang"), forState: .Highlighted)
//        collectBtn.setImage(UIImage(named: "ic_shoucang"), forState: .Selected)
//        collectBtn.addTarget(self, action: #selector(collectionBtnClick), forControlEvents: .TouchUpInside)
//        collectBtn.enabled = false
//        let barButton1 = UIBarButtonItem(customView: collectBtn)
//        
       
        
        //分享按钮
        let shareBtn = UIButton(frame:CGRectMake(0, 0, 18, 18))
        shareBtn.setImage(UIImage(named: "yuandian.png"), forState: .Normal)
        shareBtn.addTarget(self, action: #selector(collectionNews), forControlEvents: .TouchUpInside)
        let barButton2 = UIBarButtonItem(customView: shareBtn)
        
//        //按钮间的空隙
//        let gap = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil,action: nil)
//        gap.width = 15;
//        //设置按钮（注意顺序）
        self.navigationItem.rightBarButtonItems = [barButton2]
        self.automaticallyAdjustsScrollViewInsets = false
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        self.view.backgroundColor = UIColor.whiteColor()
        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-64-1-46)
        myTableView.backgroundColor = UIColor.clearColor()
        myTableView.delegate = self
        myTableView.dataSource = self
        
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellIntenfer")
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "titleCell")
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "zanCell")
        myTableView.registerNib(UINib.init(nibName: "NewsSourceCell", bundle: nil), forCellReuseIdentifier: "sourceCell")
        myTableView.registerNib(UINib.init(nibName: "contentCell", bundle: nil), forCellReuseIdentifier: "webView")
        myTableView.registerNib(UINib.init(nibName: "HSNewsCommentCell", bundle: nil), forCellReuseIdentifier: "newsCommentCell")
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "textCell")
//        myTableView.registerClass(HSNewsCommentCell.self, forCellReuseIdentifier: "commentCell")
        
        myTableView.registerClass(GToutiaoTableViewCell.self, forCellReuseIdentifier: "RelatedNewsListCell")
        self.view.addSubview(myTableView)
//        myTableView.separatorColor = UIColor.clearColor()
        myTableView.separatorStyle = .None

        setReplyView()

    }
    
    let replyView = UIView()
    var comment_bottom_Btn:UIButton = UIButton() // 下方评论按钮
    var commentIcon_bottom_Lab:UILabel = UILabel() // 下方评论角标
    var collect_bottom_Btn:UIButton = UIButton() // 下方收藏按钮
    var share_bottom_Btn:UIButton = UIButton() // 下方分享按钮
    var send_bottom_Btn:UIButton = UIButton() // 下方发送按钮
    let replyTextField = UIPlaceHolderTextView()
    var keyboardShowState = false
    
    // MARK: 设置回复视图
    func setReplyView() {
        // 回复 视图
        replyView.frame = CGRectMake(0, HEIGHT-46-64, WIDTH, 46)
        replyView.backgroundColor = UIColor(red: 244/255.0, green: 245/255.0, blue: 246/255.0, alpha: 1)
        
        let space:CGFloat = 15
        
        // 回复框
        replyTextField.frame = CGRectMake(space, 8, WIDTH-90-space*5, 30)
        replyTextField.layer.cornerRadius = 6
//        replyTextField.borderStyle = UITextBorderStyle.RoundedRect
        replyTextField.placeholder = "写评论..."
        replyTextField.font = UIFont.systemFontOfSize(16)
//        replyTextField.returnKeyType = UIReturnKeyType.Send
        replyTextField.delegate = self
        replyView.addSubview(replyTextField)
        
        // 评论
        comment_bottom_Btn.frame = CGRectMake(CGRectGetMaxX(replyTextField.frame)+space, 8, 30, 30)
        comment_bottom_Btn.setImage(UIImage(named: "ic_liuyan"), forState: .Normal)
//        comment_bottom_Btn.setImage(UIImage(named: "ic_shoucang"), forState: .Highlighted)
//        comment_bottom_Btn.setImage(UIImage(named: "ic_shoucang"), forState: .Selected)
        comment_bottom_Btn.addTarget(self, action: #selector(commentBtnClick), forControlEvents: .TouchUpInside)
        replyView.addSubview(comment_bottom_Btn)
        
        // 评论角标
        let commentIcon_bottom_Lab_Width = calculateWidth(String((self.commentArray.count)), size: 12, height: 15)+10
        commentIcon_bottom_Lab.frame = CGRectMake(CGRectGetWidth(comment_bottom_Btn.frame)-commentIcon_bottom_Lab_Width/2.0, -7.5, commentIcon_bottom_Lab_Width, 15)
        commentIcon_bottom_Lab.backgroundColor = UIColor.redColor()
        commentIcon_bottom_Lab.layer.cornerRadius = 7.5
        commentIcon_bottom_Lab.clipsToBounds = true
        commentIcon_bottom_Lab.textAlignment = .Center
        commentIcon_bottom_Lab.textColor = UIColor.whiteColor()
        commentIcon_bottom_Lab.font = UIFont.systemFontOfSize(12)
        commentIcon_bottom_Lab.text = String((self.commentArray.count))
        comment_bottom_Btn.addSubview(commentIcon_bottom_Lab)
        
        // 收藏
        collect_bottom_Btn.frame = CGRectMake(CGRectGetMaxX(comment_bottom_Btn.frame)+space, 8, 30, 30)
        collect_bottom_Btn.setImage(UIImage(named: "btn_collect_sel"), forState: .Normal)
        collect_bottom_Btn.setImage(UIImage(named: "ic_shoucang"), forState: .Highlighted)
        collect_bottom_Btn.setImage(UIImage(named: "ic_shoucang"), forState: .Selected)
        collect_bottom_Btn.addTarget(self, action: #selector(collectionBtnClick), forControlEvents: .TouchUpInside)
        replyView.addSubview(collect_bottom_Btn)
        
        // 分享
        share_bottom_Btn.frame = CGRectMake(CGRectGetMaxX(collect_bottom_Btn.frame)+space, 8, 30, 30)
        share_bottom_Btn.setImage(UIImage.init(named: "ic_fenxiang"), forState: UIControlState.Normal)
        share_bottom_Btn.addTarget(self, action: #selector(collectionNews), forControlEvents: .TouchUpInside)
        replyView.addSubview(share_bottom_Btn)
        
        // 发送
        send_bottom_Btn.frame = CGRectMake(CGRectGetMaxX(replyTextField.frame)-50, CGRectGetMaxY(replyTextField.frame)+8, 50, 25)
        send_bottom_Btn.layer.cornerRadius = 6
        send_bottom_Btn.backgroundColor = UIColor.grayColor()
        send_bottom_Btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        send_bottom_Btn.titleLabel!.font = UIFont.systemFontOfSize(14)
        send_bottom_Btn.setTitle("发送", forState: .Normal)
        send_bottom_Btn.tag = NSString(string: (newsInfo?.object_id)!).integerValue
        send_bottom_Btn.selected = false
        send_bottom_Btn.addTarget(self, action: #selector(sendComment), forControlEvents: .TouchUpInside)
        replyView.addSubview(send_bottom_Btn)
        
        let line_topView:UIView = UIView.init(frame: CGRectMake(0, 0, WIDTH, 1))
        line_topView.backgroundColor = UIColor.lightGrayColor()
        replyView.addSubview(line_topView)
        
        self.view.addSubview(replyView)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardDidAppear), name: UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name:UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK: 评论按钮点击事件
    func commentBtnClick() {
        if self.myTableView.rectForSection(1).size.height > self.myTableView.frame.size.height {
            self.myTableView.contentOffset.y = self.myTableView.rectForSection(1).origin.y
        }else{
            self.myTableView.contentOffset.y = self.myTableView.contentSize.height-self.myTableView.frame.size.height
        }
    }
    
    // MARK:- 获取键盘信息并改变视图
    func keyboardWillAppear(notification: NSNotification) {
        
        // 获取键盘信息
        let keyboardinfo = notification.userInfo![UIKeyboardFrameEndUserInfoKey]
        
        let keyboardheight:CGFloat = (keyboardinfo?.CGRectValue.size.height)!
        
        replyView.frame = CGRectMake(0, HEIGHT-86-33-64, WIDTH, 86+33)
        replyTextField.frame.size = CGSizeMake(WIDTH-30, 70)
        send_bottom_Btn.frame = CGRectMake(CGRectGetMaxX(replyTextField.frame)-50, CGRectGetMaxY(replyTextField.frame)+8, 50, 25)
        comment_bottom_Btn.hidden = true
        collect_bottom_Btn.hidden = true
        share_bottom_Btn.hidden = true
        
        UIView.animateWithDuration(0.3) {
            self.replyView.frame.origin.y = HEIGHT-86-33-64-keyboardheight
        }
        
    }
    
    func keyboardDidAppear(notification:NSNotification) {
        keyboardShowState = true
    }
    
    func keyboardWillDisappear(notification:NSNotification){
        UIView.animateWithDuration(0.3) {
            self.replyView.frame = CGRectMake(0, HEIGHT-46-64, WIDTH, 46)
            self.replyTextField.frame.size = CGSizeMake(WIDTH-90-75, 30)
            self.comment_bottom_Btn.hidden = false
            self.collect_bottom_Btn.hidden = false
            self.share_bottom_Btn.hidden = false
//            self.myTableView.frame.size.height = HEIGHT-64-1-46
        }
        // print("键盘落下")
    }
    // MARK:-
    
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        // MARK:要求登录
        if requiredLogin(self.navigationController!, previousViewController: self, hiddenNavigationBar: false) {
            
            HSMineHelper().getPersonalInfo { (success, response) in
                if success {
                    
                    
                }else{
                    
                }
            }
            return true
        }else{
            return false
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        self.send_bottom_Btn.selected = false
        self.send_bottom_Btn.tag = NSString(string: (self.newsInfo?.object_id)!).integerValue
        self.replyTextField.placeholder = "写评论..."
    }
    
    func textViewDidChange(textView: UITextView) {
        if textView.text.characters.count > 0 {
            send_bottom_Btn.backgroundColor = COLOR
        }else{
            send_bottom_Btn.backgroundColor = UIColor.whiteColor()
        }
    }
    
    //去除空格和回车
    func trimLineString(str:String)->String{
        let nowStr = str.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        return nowStr
    }
    // 发表评论
    func sendComment() {
        
        
        if replyTextField.text != "" && trimLineString(replyTextField.text) != ""{
            
            
            
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.labelText = "正在发表评论"
            hud.margin = 10.0
            hud.removeFromSuperViewOnHide = true
            
            HSNurseStationHelper().setComment(
                String(self.send_bottom_Btn.tag),
                content: (replyTextField.text)!,
                type: self.send_bottom_Btn.selected ? "3":"1",
                photo: "",
                handle: { (success, response) in
                // print("添加评论",success,response)
                let result = response as! addScore_ReadingInformationDataModel
                if success {
                    
                    let url = PARK_URL_Header+"getRefComments"
                    let param = [
                        "refid": self.newsInfo!.object_id
                    ];
                    Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
                        
                        if(error != nil){
                            
                            hud.mode = MBProgressHUDMode.Text;
                            hud.labelText = "评论失败"
                          
                            hud.hide(true, afterDelay: 1)
                        }else{
                            let status = commentModel(JSONDecoder(json!))
                            
                            if(status.status == "error"){
                                
                                hud.mode = MBProgressHUDMode.Text;
                                hud.labelText = "评论失败"
                                
                                hud.hide(true, afterDelay: 1)
                            }
                            if(status.status == "success"){
                                
                                hud.mode = MBProgressHUDMode.Text;
                                hud.labelText = "评论成功"
                                hud.hide(true, afterDelay: 1)
                                
                                self.replyTextField.placeholder = "写评论..."
                                self.send_bottom_Btn.tag = NSString(string: (self.newsInfo?.object_id)!).integerValue
                                self.send_bottom_Btn.selected = false
                                
                                self.commentArray = status.data
                                self.commentIcon_bottom_Lab.text = String((self.commentArray.count))
                                self.myTableView.reloadData()
                                
                                if ((result.event) != "") {
                                    self.showScoreTips((result.event), score: (result.score))
                                }
                                
                                self.myTableView.contentOffset.y = self.myTableView.contentSize.height-self.myTableView.frame.size.height
                                
                            }
                        }
                    }
                    
                    self.replyTextField.text = nil
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), {
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = "评论失败"
                        hud.hide(true, afterDelay: 1)
                    })
                }
            })
            replyTextField.resignFirstResponder()
        }else{
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.margin = 10.0
            hud.removeFromSuperViewOnHide = true
            hud.mode = MBProgressHUDMode.Text;
            hud.labelText = "请输入内容"
            hud.hide(true, afterDelay: 1)
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if keyboardShowState == true {

            replyTextField.resignFirstResponder()
            keyboardShowState = false
        }
    }
    
    // MARK:点击收藏按钮
    func collectionBtnClick(){
        
        // MARK:要求登录
        if !requiredLogin(self.navigationController!, previousViewController: self, hiddenNavigationBar: false) {
            return
        }
        
        var type = "1"
        for studyId in studyIdArray {
            if studyId == (newsInfo?.term_id)! {
                type = "3"
                break
            }
        }
        
        collectHud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
        collectHud.margin = 10.0
        collectHud.removeFromSuperViewOnHide = true
        self.collectBtn.enabled = false
        self.collect_bottom_Btn.enabled = false
        
        if self.collectBtn.selected {
            let url = PARK_URL_Header+"cancelfavorite"
            let param = [
                "refid":newsInfo?.object_id,
                "type":type,
                "userid":QCLoginUserInfo.currentInfo.userid
            ];
            Alamofire.request(.GET, url, parameters: param as? [String:String]).response { request, response, json, error in
                
                dispatch_async(dispatch_get_main_queue(), {
                
                    if(error != nil){
                        self.collectHud.mode = MBProgressHUDMode.Text;
                        self.collectHud.labelText = "取消收藏失败"
                    }else{
                        let status = Http(JSONDecoder(json!))
             
                        if(status.status == "error"){

                            self.collectHud.mode = MBProgressHUDMode.Text;
                            self.collectHud.labelText = status.errorData

                        }
                        if(status.status == "success"){
                            
                            self.collectBtn.selected = false
                            self.collect_bottom_Btn.selected = false
                            
                            self.collectHud.mode = MBProgressHUDMode.Text;
                            self.collectHud.labelText = "取消收藏成功"

                        }
                    }
                    self.collectHud.hide(true, afterDelay: 1)
                    self.collectBtn.enabled = true
                    self.collect_bottom_Btn.enabled = true
                })
            }
        }else{
            
            helper.collectionNews(newsInfo!.object_id,type: type as String, title: (newsInfo?.post_title)!, description: newsInfo!.post_excerpt) { (success, response) in
                if success {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.collectBtn.selected = true
                        self.collect_bottom_Btn.selected = true
                        self.collectHud.mode = MBProgressHUDMode.Text;
                        self.collectHud.labelText = "收藏成功"
                        self.collectHud.hide(true, afterDelay: 1)
                        self.collectBtn.enabled = true
                        self.collect_bottom_Btn.enabled = true
                    })
                }
            }
        }

    }
    
    func collectionNews_1(){
        
        let alertController = UIAlertController(title: "分享到...", message: nil, preferredStyle: .ActionSheet)
        self.presentViewController(alertController, animated: true, completion: nil)
        
        let wechatAction = UIAlertAction(title: "微信好友", style: .Default) { (pengyouquanAction) in
            
            let btn = UIButton()
            btn.tag = 1
            self.shareTheNews(btn)
        }
        alertController.addAction(wechatAction)
        
        let weiboAction = UIAlertAction(title: "新浪微博", style: .Default) { (pengyouquanAction) in

            let btn = UIButton()
            btn.tag = 2
            self.shareTheNews(btn)

        }
        alertController.addAction(weiboAction)
        
        let pengyouquanAction = UIAlertAction(title: "朋友圈", style: .Default) { (pengyouquanAction) in
            
            let btn = UIButton()
            btn.tag = 0
            self.shareTheNews(btn)
            
        }
        alertController.addAction(pengyouquanAction)
        
        
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
    }
    
    // MARK:- 分享视图
    func collectionNews() {
        let imageArray = ["ic_share_friendzone","ic_share_wechat","ic_share_qq","ic_share_qzone","ic_share_weibo"]
        let imageNameArray = ["微信朋友圈","微信好友","QQ好友","QQ空间","新浪微博"]
        
        let bgView = UIButton(frame: CGRectMake(0, 0, WIDTH, HEIGHT))
        bgView.backgroundColor = UIColor(white: 0.5, alpha: 0.3)
        bgView.tag = 101
        bgView.addTarget(self, action: #selector(shareViewHide(_:)), forControlEvents: .TouchUpInside)
        UIApplication.sharedApplication().keyWindow!.addSubview(bgView)
        
        let bottomView = UIView(frame: CGRectMake(0, CGRectGetMaxY(bgView.frame), WIDTH, HEIGHT*0.4))
        bottomView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
        bgView.addSubview(bottomView)
        
        let shareBtnWidth:CGFloat = WIDTH/7.0
//        let maxMargin:CGFloat = shareBtnWidth/3.0
        let shareBtnCount:Int = 5 // 每行的按钮数
        let margin = shareBtnWidth/3.0
        
        let labelHeight = margin/2.0
        
        var labelMaxY:CGFloat = 0
        
        for i in 0...4 {
            
            let shareBtn_1 = UIButton(frame: CGRectMake(margin*(CGFloat(i%shareBtnCount)+1)+shareBtnWidth*CGFloat(i%shareBtnCount), margin*(CGFloat(i/shareBtnCount)+1)+(shareBtnWidth+margin+labelHeight)*CGFloat(i/shareBtnCount), shareBtnWidth, shareBtnWidth))
            shareBtn_1.layer.cornerRadius = shareBtnWidth/2.0
            shareBtn_1.backgroundColor = UIColor.whiteColor()
            shareBtn_1.setImage(UIImage(named: imageArray[i]), forState: .Normal)
            shareBtn_1.tag = 1000+i
            shareBtn_1.addTarget(self, action: #selector(shareBtnClick(_:)), forControlEvents: .TouchUpInside)
            bottomView.addSubview(shareBtn_1)
            // print(shareBtn_1.frame)
            
            let shareLab_1 = UILabel(frame: CGRectMake(CGRectGetMinX(shareBtn_1.frame)-margin/2.0, CGRectGetMaxY(shareBtn_1.frame)+margin/2.0, shareBtnWidth+margin, labelHeight))
            shareLab_1.textColor = UIColor.grayColor()
            shareLab_1.font = UIFont.systemFontOfSize(12)
            shareLab_1.textAlignment = .Center
            shareLab_1.text = imageNameArray[i]
            bottomView.addSubview(shareLab_1)
            
            labelMaxY = CGRectGetMaxY(shareLab_1.frame)
        }
        
        let line = UIView(frame: CGRectMake(0, labelMaxY+margin, WIDTH, 1))
        line.backgroundColor = UIColor.lightGrayColor()
        bottomView.addSubview(line)
        
        let cancelBtnHeight = shareBtnWidth*0.8
        
        let cancelBtn = UIButton(frame: CGRectMake(0, CGRectGetMaxY(line.frame), WIDTH, cancelBtnHeight))
        cancelBtn.backgroundColor = UIColor(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1)
        cancelBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        cancelBtn.setTitle("取消", forState: .Normal)
        cancelBtn.tag = 102
        cancelBtn.addTarget(self, action: #selector(shareViewHide(_:)), forControlEvents: .TouchUpInside)
        bottomView.addSubview(cancelBtn)
        
        bottomView.frame.size.height = CGRectGetMaxY(cancelBtn.frame)
        
        UIView.animateWithDuration(0.5) {
            bottomView.frame.origin.y = HEIGHT - CGRectGetMaxY(cancelBtn.frame)
        }
    }
    
    // 分享视图取消事件
    func shareViewHide(shareView:UIButton) {
        if shareView.tag == 102 {
            shareView.superview!.superview!.removeFromSuperview()
        }else{
            shareView.removeFromSuperview()
        }
    }
    
    // 分享视图分享按钮点击事件
    func shareBtnClick(shareBtn:UIButton) {
        shareBtn.superview!.superview!.removeFromSuperview()
        
        let btn = UIButton()
        
        switch shareBtn.tag {
        case 1000://朋友圈
            btn.tag = 0
        case 1001://微信好友
            btn.tag = 1
        case 1002://QQ好友
            btn.tag = 3
        case 1003://QQ空间
            btn.tag = 4
        case 1004://新浪微博
            btn.tag = 2
            
        default:
            return
        }
        self.shareTheNews(btn)
    }
    
    // MARK:-
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            let one = UIView(frame: CGRectMake(0, 0, WIDTH, 30))
            one.backgroundColor = UIColor.whiteColor()
            let lineone = UILabel(frame: CGRectMake(10, 29, WIDTH-20, 1))
            lineone.backgroundColor = COLOR
            one.addSubview(lineone)
            let tit = UILabel(frame: CGRectMake(10, 0, 100, 30))
            tit.textColor = COLOR
            tit.font = UIFont.systemFontOfSize(14)
            tit.text = "热点评论"
            one.addSubview(tit)
            
            return one
        }else{
            return nil
        }
    }
    
    // MARK:获取评论列表
    func getComment() {
        // print(newsInfo?.object_id,newsInfo?.title)
        let url = PARK_URL_Header+"getRefComments"
        let param = [
            "refid": newsInfo!.object_id
        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in

            if(error != nil){
            }else{
                let status = commentModel(JSONDecoder(json!))
                
                if(status.status == "error") && status.errorData != ""{
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = "获取评论列表失败"
                    hud.detailsLabelText = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                    //self.createTableView()
                    // print(status)
                    
                    self.commentArray = status.data
                    self.commentIcon_bottom_Lab.text = String((self.commentArray.count))
                    
                    self.myTableView .reloadData()
                    // print(status.data)
                }
            }
        
            self.mainFlag += 1
            if self.mainFlag == 3 {
                self.mainFlag = 0
                self.mainHud.hide(true)
            }
        
        }
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return  0
        }else if section == 1 {
            return 30
        }else{
            return 0
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }else if section == 1 {
            if self.commentArray.count == 0 {
                return 1
            }else{
                
                return (self.commentArray.count)
            }
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row==0 {
                
                let height = calculateHeight(newsInfo?.post_title ?? "", size: 21, width: WIDTH-30)
                // print(newsInfo?.post_title)
                // print(height)
                return height+30
            }else if indexPath.row==1{
                return 20
            }else if indexPath.row==2{
               return webHeight
            }else{
            
                return 220
            }
         
        }else{
            if self.commentArray.count == 0 {
                return 100
            }else{
                
                let height = calculateHeight((self.commentArray[indexPath.row].content), size: 14, width: WIDTH-62-16)
                
                var child_commentBtnY = height+8+40+8+8+14+8
                for child_comment in (self.commentArray[indexPath.row].child_comments) {
                    
                    let child_commentBtnHeight = child_comment.content.boundingRectWithSize(
                        CGSizeMake(WIDTH-60-10-30-16, 0),
                        options: .UsesLineFragmentOrigin,
                        attributes: [NSFontAttributeName:UIFont.systemFontOfSize(14)],
                        context: nil).size.height+10
                    
                    child_commentBtnY += child_commentBtnHeight+25+5
                    
                }

                return child_commentBtnY+8+1
            }
        }
    }
    
    var addScore_ReadingInformation = false
    var addScore_ReadingInformationName = ""
    var addScore_ReadingInformationScore = ""

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            var cell1:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cellIntenfer")!
            cell1.selectionStyle = .None
            
            cell1.textLabel?.numberOfLines = 0
           
            if indexPath.row == 0 {
               
                cell1 = UITableViewCell.init(style: .Default, reuseIdentifier: "cellIntenfer")
                cell1.selectionStyle = .None

                let title = UILabel()
                let height = calculateHeight((newsInfo?.post_title)!, size: 21, width: WIDTH-20)
                title.frame = CGRectMake(15, 0, WIDTH-30, height+30)
                title.text = newsInfo?.post_title
                title.numberOfLines = 0
                title.font = UIFont.systemFontOfSize(21)
                cell1.addSubview(title)
                tableView.rowHeight=height+30
                
                return cell1

            }else if indexPath.row == 1 {

                let cell = tableView.dequeueReusableCellWithIdentifier("sourceCell", forIndexPath: indexPath)as! NewsSourceCell
                cell.source.text = "来源：\((newsInfo?.post_source)!)"
                
                cell.post_like.text = newsInfo?.post_hits
                let time:Array = (newsInfo?.post_modified!.componentsSeparatedByString(" "))!
                cell.createTime.text = time[0]
                
                return cell
                
            }else if indexPath.row == 2 {
                
                let webCell = tableView.dequeueReusableCellWithIdentifier("webView") as! contentCell
                if webFlag {
                    
                    helper.addScore_ReadingInformation((newsInfo?.object_id)!, handle: { (success, response) in
                        if success || String((response ?? "")!) == "阅读资讯加积分到上限值"{
                            
                            let url = NSURL(string:NewsInfo_Header+(self.newsInfo?.object_id)!)
                            webCell.loadRequestUrl(url!)
                            webCell.contentWebView.delegate = self
                            self.webFlag = false
                            
                            if success {
                                self.addScore_ReadingInformation = true
                                self.addScore_ReadingInformationName = (response as! addScore_ReadingInformationDataModel).event
                                self.addScore_ReadingInformationScore = (response as! addScore_ReadingInformationDataModel).score
                            }
                           
                        }else{
                            let alert = UIAlertController(title: nil, message: "获取新闻内容失败", preferredStyle: .Alert)
                            self.presentViewController(alert, animated: true, completion: {
                                
                            })
                            
                            let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: { (action) in
                                
                            })
                            alert.addAction(cancelAction)
                            
                            let replyAction = UIAlertAction(title: "重试", style: .Default, handler: { (action) in
                                
                                self.myTableView.reloadData()
                            })
                            alert.addAction(replyAction)
                        }
                    })
                    
                }
                return webCell
               
            }else{
                
                let cell3 = tableView.dequeueReusableCellWithIdentifier("zanCell", forIndexPath: indexPath)
                for view in cell3.subviews {
                    view.removeFromSuperview()
                }
                cell3.selectionStyle = .None
                let line = UILabel(frame: CGRectMake(WIDTH*63/375, 14.5, WIDTH*250/375, 1))
                line.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
                let share = UILabel(frame: CGRectMake(WIDTH/2-30, 5, 60, 20))
                share.font = UIFont.systemFontOfSize(12)
                share.textAlignment = .Center
                share.textColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
                share.text = "分享到"
                share.backgroundColor = UIColor.whiteColor()
                for i in 0...2 {
                    let shareBtn = UIButton(frame: CGRectMake(WIDTH*(15+119*CGFloat(i))/375, WIDTH*30/375, WIDTH*108/375, WIDTH*30/375))
                    shareBtn.tag = i
                    shareBtn.layer.cornerRadius = 4
                    shareBtn.layer.borderColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0).CGColor
                    
                    shareBtn.layer.borderWidth = 0.5
                    shareBtn.setImage(UIImage(named: shareArr[i]), forState: .Normal)
                    shareBtn.addTarget(self, action: #selector(self.shareTheNews(_:)), forControlEvents: .TouchUpInside)
                    cell3.addSubview(shareBtn)
                }
                
                zan.setImage(UIImage(named: "img_like.png"), forState: .Normal)
                zan.setImage(UIImage(named: "img_like_sel.png"), forState: .Selected)
                zan.tag = indexPath.row
                zan.addTarget(self, action: #selector(NewsContantViewController.zanAddNum(_:)), forControlEvents: .TouchUpInside)
                number.frame = CGRectMake(WIDTH/2-25, WIDTH*170/375, 50, 18)
                number.text =  "\(self.likeNum)"
//        self.likeNum = hashValue!
                number.sizeToFit()
                number.font = UIFont.systemFontOfSize(12)
                number.frame = CGRectMake(WIDTH/2-number.bounds.size.width/2-8, WIDTH*170/375, number.bounds.size.width, 18)
                number.textAlignment = .Center
                number.textColor = COLOR
                let one = UILabel(frame: CGRectMake(WIDTH/2-number.bounds.size.width/2-48, WIDTH*170/375, 40, 18))
                one.font = UIFont.systemFontOfSize(12)
                one.textColor = UIColor.grayColor()
                one.textAlignment = .Right
                one.text = "已有"
               
                let two = UILabel(frame: CGRectMake(WIDTH/2+number.bounds.size.width/2-8, WIDTH*170/375, 50, 18))
                two.font = UIFont.systemFontOfSize(12)
                two.textColor = UIColor.grayColor()
                two.text = "人点赞"
                
                cell3.addSubview(one)
                cell3.addSubview(two)
                cell3.addSubview(number)
                cell3.addSubview(zan)
                cell3.addSubview(line)
                cell3.addSubview(share)
                
                return cell3
            }

            
        }else{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("newsCommentCell") as! HSNewsCommentCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            if self.commentArray.count == 0 {
                cell.textLabel?.text = "暂无评论"
                cell.textLabel?.textColor = UIColor.grayColor()
                cell.textLabel?.textAlignment = .Center
                
                cell.nameLab.text = nil
                cell.contentLab.text = nil
                cell.timeLab.text = nil
                cell.headerBtn.setImage(nil, forState: .Normal)
            }else{
                cell.textLabel?.text = nil
                cell.floorLab.text = "\(self.commentArray.count-indexPath.row)楼"
                cell.commentModel = self.commentArray[indexPath.row]
            }
            return cell
        }
        
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        BaiduMobStat.defaultStat().webviewStartLoadWithRequest(request)
        return true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        //获取页面高度（像素）
        let clientheight_str:String = webView.stringByEvaluatingJavaScriptFromString("document.body.offsetHeight")!
        let clienthetght_temp:NSString = NSString(string: clientheight_str)
        let clientheight = CGFloat(clienthetght_temp.floatValue)

        //设置到WebView上
        webView.frame = CGRectMake(0, 0, self.view.frame.size.width, CGFloat(clientheight))
        //获取WebView最佳尺寸（点）
        let frame:CGSize = webView.sizeThatFits(webView.frame.size)
        //再次设置WebView高度（点）
        webView.frame = CGRectMake(0, 0, self.view.frame.size.width, frame.height);
        webHeight = webView.frame.size.height
        self.myTableView.reloadData()
        
        self.mainFlag += 1
        if self.mainFlag == 3 {
            self.mainFlag = 0
            self.mainHud.hide(true)
            if addScore_ReadingInformation {
                
                showScoreTips(addScore_ReadingInformationName, score: addScore_ReadingInformationScore)
            }
        }

    }
    
    // MARK: 显示积分提示
    func showScoreTips(name:String, score:String) {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.opacity = 0.3
        hud.margin = 10
        hud.color = UIColor(red: 145/255.0, green: 26/255.0, blue: 107/255.0, alpha: 0.3)
        hud.mode = .CustomView
        let customView = UIImageView(frame: CGRectMake(0, 0, WIDTH*0.8, WIDTH*0.8*238/537))
        customView.image = UIImage(named: "scorePopImg.png")
        let titLab = UILabel(frame: CGRectMake(
            CGRectGetWidth(customView.frame)*351/537,
            CGRectGetHeight(customView.frame)*30/238,
            CGRectGetWidth(customView.frame)*174/537,
            CGRectGetHeight(customView.frame)*50/238))
        titLab.textColor = UIColor(red: 140/255.0, green: 39/255.0, blue: 90/255.0, alpha: 1)
        titLab.textAlignment = .Left
        titLab.font = UIFont.systemFontOfSize(16)
        titLab.text = name
        titLab.adjustsFontSizeToFitWidth = true
        customView.addSubview(titLab)
        
        let scoreLab = UILabel(frame: CGRectMake(
            CGRectGetWidth(customView.frame)*351/537,
            CGRectGetHeight(customView.frame)*100/238,
            CGRectGetWidth(customView.frame)*174/537,
            CGRectGetHeight(customView.frame)*50/238))
        scoreLab.textColor = UIColor(red: 252/255.0, green: 13/255.0, blue: 27/255.0, alpha: 1)

        scoreLab.textAlignment = .Left
        scoreLab.font = UIFont.systemFontOfSize(24)
        scoreLab.text = "+\(score)"
        scoreLab.adjustsFontSizeToFitWidth = true
        scoreLab.sizeToFit()
        customView.addSubview(scoreLab)
        
        let jifenLab = UILabel(frame: CGRectMake(
            CGRectGetMaxX(scoreLab.frame)+5,
            CGRectGetHeight(customView.frame)*100/238,
            CGRectGetWidth(customView.frame)-CGRectGetMaxX(scoreLab.frame)-5-CGRectGetWidth(customView.frame)*13/537,
            CGRectGetHeight(customView.frame)*50/238))
        jifenLab.textColor = UIColor(red: 107/255.0, green: 106/255.0, blue: 106/255.0, alpha: 1)
        jifenLab.textAlignment = .Center
        jifenLab.font = UIFont.systemFontOfSize(16)
        jifenLab.text = "护士币"
        jifenLab.adjustsFontSizeToFitWidth = true
        jifenLab.center.y = scoreLab.center.y
        customView.addSubview(jifenLab)
        
        hud.customView = customView
        hud.hide(true, afterDelay: 3)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       if indexPath.section == 1 {
            self.replyTextField.placeholder = "回复 \(self.commentArray[indexPath.row].username)"
            self.send_bottom_Btn.tag = NSString(string: self.commentArray[indexPath.row].cid).integerValue
            self.send_bottom_Btn.selected = true
            self.replyTextField.becomeFirstResponder()
        }
    }

    var shareNewsUrl = ""
    
    func shareTheNews(btn:UIButton) {
        
        self.shareNewsUrl = NewsInfo_Header+(self.newsInfo?.object_id)!
        self.shareNews(btn)

        
//        let url = "http://apis.baidu.com/3023/shorturl/shorten"
//        
//        Alamofire.request(.GET, url, parameters: ["url_long":NewsInfo_Header+(newsInfo?.object_id)!+"&type=1"], encoding: .URLEncodedInURL, headers: ["apikey":"615ac7276ff0b752fc5f0b8cfa845544"]).response { (request, response, json, error) in
//
//            if error != nil {
//                self.shareNewsUrl = NewsInfo_Header+(self.newsInfo?.object_id)!
//            }else{
//                
//                let js = try?NSJSONSerialization.JSONObjectWithData(json!, options: .MutableLeaves)
//
//                if JSON(js!)["urls"][0]["result"].boolValue {
//
//                    self.shareNewsUrl = JSON(js!)["urls"][0]["url_short"].string!
//                }else{
//                    self.shareNewsUrl = NewsInfo_Header+(self.newsInfo?.object_id)!
//                }
//            }
//            
//            self.shareNews(btn)
//        }
        
    }
    
    func shareNews(btn:UIButton) {
        
        if btn.tag == 0 || btn.tag == 1 {
            
            let message = WXMediaMessage()
            message.title = newsInfo?.post_title
            message.description = newsInfo?.post_excerpt

            if newsInfo?.thumbArr.count == 0 {
                let thumbImage = UIImage(named: "appLogo")
                message.setThumbImage(thumbImage)
                
            }else{
                
                let str = DomainName+"data/upload/"+(newsInfo?.thumbArr.first?.url)!
                let url = NSURL(string: str)
                let data = NSData(contentsOfURL: url!)
                let thumbImage = UIImage(data: data!)
                
                if (thumbImage != nil) {
                    
                    let data2 = thumbImage!.compressImage(thumbImage!, maxLength: 32700)
                    message.setThumbImage(UIImage(data: data2!))
                }else{
                    let thumbImage = UIImage(named: "appLogo")
                    message.setThumbImage(thumbImage)
                }
            }
            
            let webPageObject = WXWebpageObject()
            webPageObject.webpageUrl = NewsInfo_Header+(newsInfo?.object_id)!+"&type=1"
            message.mediaObject = webPageObject
            
            let req = SendMessageToWXReq()
            req.bText = false
            req.message = message
            
            switch btn.tag {
            case 0:
                req.scene = Int32(WXSceneTimeline.rawValue)
            case 1:
                req.scene = Int32(WXSceneSession.rawValue)
            default:
                break
            }
            
            
            WXApi.sendReq(req)
        }else if btn.tag == 2 {
            let authRequest:WBAuthorizeRequest = WBAuthorizeRequest.request() as! WBAuthorizeRequest
            authRequest.redirectURI = kRedirectURI
            authRequest.scope = "all"
            
            let message = WBMessageObject.message() as! WBMessageObject
            if WeiboSDK.isCanShareInWeiboAPP() {
                message.text = (newsInfo?.post_title)!
            }else{
                message.text = "\((newsInfo?.post_title)!) \(shareNewsUrl) 想看更多内容，马上下载【中国护士网】http://t.cn/RczKRS3 (分享自@中国护士网)"
            }
            let webpage:WBWebpageObject = WBWebpageObject.object() as! WBWebpageObject
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            let dateStr = dateFormatter.stringFromDate(NSDate())
            webpage.objectID = "chinanurse\(kAppKey)\(dateStr)"
            webpage.title = newsInfo?.post_title
            webpage.description = newsInfo?.post_excerpt
            if newsInfo?.thumbArr.count == 0 {
                let thumbImage = UIImage(named: "appLogo")
                let data = UIImageJPEGRepresentation(thumbImage!, 0.5)!
                webpage.thumbnailData = data
            }else{
                
                let str = DomainName+"data/upload/"+(newsInfo?.thumbArr.first?.url)!
                let url = NSURL(string: str)
                let data = NSData(contentsOfURL: url!)
                if data == nil {
                    let thumbImage = UIImage(named: "appLogo")
                    let data = UIImageJPEGRepresentation(thumbImage!, 0.5)!
                    webpage.thumbnailData = data
                    
                }else{
                    
                    let thumbImage = UIImage(data: data!)
                    
                    let data2 = thumbImage!.compressImage(thumbImage!, maxLength: 32700)
                    
                    webpage.thumbnailData = data2
                }
            }

            webpage.webpageUrl = shareNewsUrl
            message.mediaObject = webpage
            
            let request = WBSendMessageToWeiboRequest.requestWithMessage(message, authInfo: authRequest, access_token: AppDelegate().wbtoken) as! WBSendMessageToWeiboRequest
            request.userInfo = ["ShareMessageFrom":"NewsContantViewController"]
            
            WeiboSDK.sendRequest(request)
        }else{
            
            let newsUrl = NSURL(string: shareNewsUrl)
            let title = newsInfo?.post_title
            let description = newsInfo?.post_excerpt
            
            var previewImageData = NSData()
            if newsInfo?.thumbArr.count == 0 {
                let thumbImage = UIImage(named: "appLogo")
                previewImageData = UIImageJPEGRepresentation(thumbImage!, 0.5)!
            }else{
                
                let str = DomainName+"data/upload/"+(newsInfo?.thumbArr.first?.url)!
                let url = NSURL(string: str)
                let data = NSData(contentsOfURL: url!)
                let thumbImage = UIImage(data: data!)
                
                previewImageData = thumbImage!.compressImage(thumbImage!, maxLength: 32700)!
            }
            
            let newsObj = QQApiNewsObject(URL: newsUrl, title: title, description: description, previewImageData: previewImageData, targetContentType: QQApiURLTargetTypeNews)
            let req = SendMessageToQQReq(content: newsObj)
            
            if btn.tag == 3 {
                QQApiInterface.sendReq(req)
            }else if btn.tag == 4 {
                QQApiInterface.SendReqToQZone(req)
            }
        }
        
//        // print(btn.tag)

    }
    
    func zanAddNum(btn:UIButton) {
        

        if !requiredLogin(self.navigationController!, previousViewController: self, hiddenNavigationBar: false) {
            return
        }
        
        self.zan.enabled = false

        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.margin = 10.0
        hud.removeFromSuperViewOnHide = true
        
        if zan.selected {
            let url = PARK_URL_Header+"ResetLike"
            let param = [
                "id":newsInfo?.object_id,
                "type":"1",
                "userid":QCLoginUserInfo.currentInfo.userid
            ];
            Alamofire.request(.GET, url, parameters: param as? [String:String]).response { request, response, json, error in
                
                self.zan.enabled = true

                if(error != nil){
                    hud.mode = MBProgressHUDMode.Text
                    hud.labelText = "取消点赞失败"
                    hud.hide(true, afterDelay: 1)
                }else{
                    let status = Http(JSONDecoder(json!))

                    if(status.status == "error"){

                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = status.errorData
                        hud.hide(true, afterDelay: 1)
                        //                            user.setObject("false", forKey: (self.newsInfo?.object_id)!)
                    }
                    if(status.status == "success"){
                        
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = "取消点赞成功"
                        hud.hide(true, afterDelay: 1)

                        self.performSelectorOnMainThread(#selector(self.upDateUI(_:)), withObject: [btn.tag,"0"], waitUntilDone:true)
                        
                        for (i,obj) in (self.newsInfo?.likes)!.enumerate() {
                            if obj.userid == QCLoginUserInfo.currentInfo.userid {
                                self.newsInfo?.likes.removeAtIndex(i)
                            }
                        }
                        
                    }
                }
                
            }
        }else{
            let url = PARK_URL_Header+"SetLike"
            let param = [
                "id":newsInfo?.object_id,
                "type":"1",
                "userid":QCLoginUserInfo.currentInfo.userid,
                ];
            Alamofire.request(.GET, url, parameters: param as? [String:String] ).response { request, response, json, error in

                self.zan.enabled = true

                if(error != nil){
                    hud.mode = MBProgressHUDMode.Text
                    hud.labelText = "点赞失败"
                    hud.hide(true, afterDelay: 1)
                }else{
                    let status = addScore_ReadingInformationModel(JSONDecoder(json!))

                    if(status.status == "error"){

                        hud.mode = MBProgressHUDMode.Text
                        hud.labelText = status.errorData
                        hud.hide(true, afterDelay: 1)
                    }
                    if(status.status == "success"){
                        
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = "点赞成功"
                        hud.hide(true, afterDelay: 1)
                        self.performSelectorOnMainThread(#selector(self.upDateUI(_:)), withObject: [btn.tag,"1"], waitUntilDone:true)
                        if ((status.data?.event) != "") {
                            self.showScoreTips((status.data?.event)!, score: (status.data?.score)!)
                        }
                        
                        let dic = ["userid":QCLoginUserInfo.currentInfo.userid]
                        let model:LikeInfo = LikeInfo.init(JSONDecoder(dic))
                        self.newsInfo?.likes.append(model)
                        
                    }
                }
            }
        }
        
    }
    
    
    func upDateUI(status:NSArray){

        if status[1] as! String=="1" {
             self.likeNum = self.likeNum + 1
            self.zan.selected = true
        }else{
             self.likeNum = self.likeNum - 1
            self.zan.selected = false
        }
        
        self.zan.enabled = true
        
        let indexPath = NSIndexPath.init(forRow: status[0] as! Int, inSection: 0)

        self.myTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.delegate?.changeModel(newsInfo!, andIndex: index)
    }
}
