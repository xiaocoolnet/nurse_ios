//
//  NewsContantViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/14.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON

protocol changeModelDelegate {
    func changeModel(_ newInfo:NewsInfo, andIndex:Int)
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
//    var NewsPageHelper() = NewsPageHelper()
    let zan = UIButton(frame: CGRect(x: WIDTH*148/375, y: WIDTH*80/375, width: WIDTH*80/375, height: WIDTH*80/375))
    var finishLoad = false
    var tagNum = 0
    
    var mainFlag = 0
    var mainHud = MBProgressHUD()
    
    var webFlag = true// 防止多次加载网页
    
    let studyIdArray = ["10","95","11","130","131","132","12","134","135","136","13","137","138","139","140","141","142","143","14","15","16"]
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "新闻详情页")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "新闻详情页")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.leftBarButtonItem?.title = "返回"
        
        if LOGIN_STATE {
            mainHud = MBProgressHUD.showAdded(to: self.view, animated: true)
            //        MBProgressHUD().labelText = ""
            
            // MARK: 检查是否收藏
            checkHadFavorite((self.newsInfo?.object_id)!, type: "1", handle: { (success, response) in
                if success {
                    self.collectBtn.isSelected = true
                    self.collect_bottom_Btn.isSelected = true
                }else{
                    self.collectBtn.isSelected = false
                    self.collect_bottom_Btn.isSelected = false
                }
                checkHadLike((self.newsInfo?.object_id)!, type: "1", handle: { (success, response) in
                    if success {
                        self.zan.isSelected = true
                    }else{
                        self.zan.isSelected = false
                    }
                    DispatchQueue.main.async(execute: {
                        self.collectBtn.isEnabled = true
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
        let shareBtn = UIButton(frame:CGRect(x: 0, y: 0, width: 18, height: 18))
        shareBtn.setImage(UIImage(named: "yuandian.png"), for: UIControlState())
        shareBtn.addTarget(self, action: #selector(collectionNews), for: .touchUpInside)
        let barButton2 = UIBarButtonItem(customView: shareBtn)
        
//        //按钮间的空隙
//        let gap = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil,action: nil)
//        gap.width = 15;
//        //设置按钮（注意顺序）
        self.navigationItem.rightBarButtonItems = [barButton2]
        self.automaticallyAdjustsScrollViewInsets = false
        
        let line = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        self.view.backgroundColor = UIColor.white
        myTableView.frame = CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-64-1-46)
        myTableView.backgroundColor = UIColor.clear
        myTableView.delegate = self
        myTableView.dataSource = self
        
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIntenfer")
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "titleCell")
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "zanCell")
        myTableView.register(UINib.init(nibName: "NewsSourceCell", bundle: nil), forCellReuseIdentifier: "sourceCell")
        myTableView.register(UINib.init(nibName: "contentCell", bundle: nil), forCellReuseIdentifier: "webView")
        myTableView.register(UINib.init(nibName: "HSNewsCommentCell", bundle: nil), forCellReuseIdentifier: "newsCommentCell")
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "textCell")
//        myTableView.registerClass(HSNewsCommentCell.self, forCellReuseIdentifier: "commentCell")
        
        myTableView.register(GToutiaoTableViewCell.self, forCellReuseIdentifier: "RelatedNewsListCell")
        self.view.addSubview(myTableView)
//        myTableView.separatorColor = UIColor.clearColor()
        myTableView.separatorStyle = .none

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
        replyView.frame = CGRect(x: 0, y: HEIGHT-46-64, width: WIDTH, height: 46)
        replyView.backgroundColor = UIColor(red: 244/255.0, green: 245/255.0, blue: 246/255.0, alpha: 1)
        
        let space:CGFloat = 15
        
        // 回复框
        replyTextField.frame = CGRect(x: space, y: 8, width: WIDTH-90-space*5, height: 30)
        replyTextField.layer.cornerRadius = 6
//        replyTextField.borderStyle = UITextBorderStyle.RoundedRect
        replyTextField.placeholder = "写评论..."
        replyTextField.font = UIFont.systemFont(ofSize: 16)
//        replyTextField.returnKeyType = UIReturnKeyType.Send
        replyTextField.delegate = self
        replyView.addSubview(replyTextField)
        
        // 评论
        comment_bottom_Btn.frame = CGRect(x: replyTextField.frame.maxX+space, y: 8, width: 30, height: 30)
        comment_bottom_Btn.setImage(UIImage(named: "ic_liuyan"), for: UIControlState())
//        comment_bottom_Btn.setImage(UIImage(named: "ic_shoucang"), forState: .Highlighted)
//        comment_bottom_Btn.setImage(UIImage(named: "ic_shoucang"), forState: .Selected)
        comment_bottom_Btn.addTarget(self, action: #selector(commentBtnClick), for: .touchUpInside)
        replyView.addSubview(comment_bottom_Btn)
        
        // 评论角标
        let commentIcon_bottom_Lab_Width = calculateWidth(String((self.commentArray.count)), size: 12, height: 15)+15
        commentIcon_bottom_Lab.frame = CGRect(x: comment_bottom_Btn.frame.width-commentIcon_bottom_Lab_Width/2.0, y: -7.5, width: commentIcon_bottom_Lab_Width, height: 15)
        commentIcon_bottom_Lab.backgroundColor = UIColor.red
        commentIcon_bottom_Lab.layer.cornerRadius = 7.5
        commentIcon_bottom_Lab.clipsToBounds = true
        commentIcon_bottom_Lab.textAlignment = .center
        commentIcon_bottom_Lab.textColor = UIColor.white
        commentIcon_bottom_Lab.font = UIFont.systemFont(ofSize: 12)
        commentIcon_bottom_Lab.text = String((self.commentArray.count))
        comment_bottom_Btn.addSubview(commentIcon_bottom_Lab)
        
        // 收藏
        collect_bottom_Btn.frame = CGRect(x: comment_bottom_Btn.frame.maxX+space, y: 8, width: 30, height: 30)
        collect_bottom_Btn.setImage(UIImage(named: "btn_collect_sel"), for: UIControlState())
        collect_bottom_Btn.setImage(UIImage(named: "ic_shoucang"), for: .highlighted)
        collect_bottom_Btn.setImage(UIImage(named: "ic_shoucang"), for: .selected)
        collect_bottom_Btn.addTarget(self, action: #selector(collectionBtnClick), for: .touchUpInside)
        replyView.addSubview(collect_bottom_Btn)
        
        // 分享
        share_bottom_Btn.frame = CGRect(x: collect_bottom_Btn.frame.maxX+space, y: 8, width: 30, height: 30)
        share_bottom_Btn.setImage(UIImage.init(named: "ic_fenxiang"), for: UIControlState())
        share_bottom_Btn.addTarget(self, action: #selector(collectionNews), for: .touchUpInside)
        replyView.addSubview(share_bottom_Btn)
        
        // 发送
        send_bottom_Btn.frame = CGRect(x: replyTextField.frame.maxX-50, y: replyTextField.frame.maxY+8, width: 50, height: 25)
        send_bottom_Btn.layer.cornerRadius = 6
        send_bottom_Btn.backgroundColor = UIColor.gray
        send_bottom_Btn.setTitleColor(UIColor.white, for: UIControlState())
        send_bottom_Btn.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        send_bottom_Btn.setTitle("发送", for: UIControlState())
        send_bottom_Btn.tag = NSString(string: (newsInfo?.object_id)!).integerValue
        send_bottom_Btn.isSelected = false
        send_bottom_Btn.addTarget(self, action: #selector(sendComment), for: .touchUpInside)
        replyView.addSubview(send_bottom_Btn)
        
        let line_topView:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line_topView.backgroundColor = UIColor.lightGray
        replyView.addSubview(line_topView)
        
        self.view.addSubview(replyView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidAppear), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: 评论按钮点击事件
    func commentBtnClick() {
        if self.myTableView.rect(forSection: 1).size.height > self.myTableView.frame.size.height {
            self.myTableView.contentOffset.y = self.myTableView.rect(forSection: 1).origin.y
        }else{
            self.myTableView.contentOffset.y = self.myTableView.contentSize.height-self.myTableView.frame.size.height
        }
    }
    
    // MARK:- 获取键盘信息并改变视图
    func keyboardWillAppear(_ notification: Notification) {
        
        // 获取键盘信息
        let keyboardinfo = notification.userInfo![UIKeyboardFrameEndUserInfoKey]
        
        let keyboardheight:CGFloat = ((keyboardinfo as AnyObject).cgRectValue.size.height)
        
        replyView.frame = CGRect(x: 0, y: HEIGHT-86-33-64, width: WIDTH, height: 86+33)
        replyTextField.frame.size = CGSize(width: WIDTH-30, height: 70)
        send_bottom_Btn.frame = CGRect(x: replyTextField.frame.maxX-50, y: replyTextField.frame.maxY+8, width: 50, height: 25)
        comment_bottom_Btn.isHidden = true
        collect_bottom_Btn.isHidden = true
        share_bottom_Btn.isHidden = true
        
        UIView.animate(withDuration: 0.3, animations: {
            self.replyView.frame.origin.y = HEIGHT-86-33-64-keyboardheight
        }) 
        
    }
    
    func keyboardDidAppear(_ notification:Notification) {
        keyboardShowState = true
    }
    
    func keyboardWillDisappear(_ notification:Notification){
        UIView.animate(withDuration: 0.3, animations: {
            self.replyView.frame = CGRect(x: 0, y: HEIGHT-46-64, width: WIDTH, height: 46)
            self.replyTextField.frame.size = CGSize(width: WIDTH-90-75, height: 30)
            self.comment_bottom_Btn.isHidden = false
            self.collect_bottom_Btn.isHidden = false
            self.share_bottom_Btn.isHidden = false
//            self.myTableView.frame.size.height = HEIGHT-64-1-46
        }) 
        // print("键盘落下")
    }
    // MARK:-
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
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
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.send_bottom_Btn.isSelected = false
        self.send_bottom_Btn.tag = NSString(string: (self.newsInfo?.object_id)!).integerValue
        self.replyTextField.placeholder = "写评论..."
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count > 0 {
            send_bottom_Btn.backgroundColor = COLOR
        }else{
            send_bottom_Btn.backgroundColor = UIColor.white
        }
    }
    
    //去除空格和回车
    func trimLineString(_ str:String)->String{
        let nowStr = str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return nowStr
    }
    // 发表评论
    func sendComment() {
        
        
        if replyTextField.text != "" && trimLineString(replyTextField.text) != ""{
            
            
            
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud?.labelText = "正在发表评论"
            hud?.margin = 10.0
            hud?.removeFromSuperViewOnHide = true
            
            HSNurseStationHelper().setComment(
                String(self.send_bottom_Btn.tag),
                content: (replyTextField.text)!,
                type: self.send_bottom_Btn.isSelected ? "3":"1",
                photo: "",
                handle: { (success, response) in
                // print("添加评论",success,response)
                let result = response as! addScore_ReadingInformationDataModel
                if success {
                    
                    let url = PARK_URL_Header+"getRefComments"
                    let param = [
                        "refid": self.newsInfo!.object_id
                    ];
                    
                    
                    NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
                        
                        if(error != nil){
                            
                            hud?.mode = MBProgressHUDMode.text;
                            hud?.labelText = "评论失败"
                          
                            hud?.hide(true, afterDelay: 1)
                        }else{
                            let status = commentModel(JSONDecoder(json!))
                            
                            if(status.status == "error"){
                                
                                hud?.mode = MBProgressHUDMode.text;
                                hud?.labelText = "评论失败"
                                
                                hud?.hide(true, afterDelay: 1)
                            }
                            if(status.status == "success"){
                                
                                hud?.mode = MBProgressHUDMode.text;
                                hud?.labelText = "评论成功"
                                hud?.hide(true, afterDelay: 1)
                                
                                self.replyTextField.placeholder = "写评论..."
                                self.send_bottom_Btn.tag = NSString(string: (self.newsInfo?.object_id)!).integerValue
                                self.send_bottom_Btn.isSelected = false
                                
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
                    DispatchQueue.main.async(execute: {
                        hud?.mode = MBProgressHUDMode.text;
                        hud?.labelText = "评论失败"
                        hud?.hide(true, afterDelay: 1)
                    })
                }
            })
            replyTextField.resignFirstResponder()
        }else{
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud?.margin = 10.0
            hud?.removeFromSuperViewOnHide = true
            hud?.mode = MBProgressHUDMode.text;
            hud?.labelText = "请输入内容"
            hud?.hide(true, afterDelay: 1)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
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
        
        collectHud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow, animated: true)
        collectHud.margin = 10.0
        collectHud.removeFromSuperViewOnHide = true
        self.collectBtn.isEnabled = false
        self.collect_bottom_Btn.isEnabled = false
        
        if self.collectBtn.isSelected {
            let url = PARK_URL_Header+"cancelfavorite"
            let param = [
                "refid":newsInfo?.object_id,
                "type":type,
                "userid":QCLoginUserInfo.currentInfo.userid
            ];
            NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as? [String:String] as [String : AnyObject]?) { (json, error) in
                
                DispatchQueue.main.async(execute: {
                
                    if(error != nil){
                        self.collectHud.mode = MBProgressHUDMode.text;
                        self.collectHud.labelText = "取消收藏失败"
                    }else{
                        let status = Http(JSONDecoder(json!))
             
                        if(status.status == "error"){

                            self.collectHud.mode = MBProgressHUDMode.text;
                            self.collectHud.labelText = status.errorData

                        }
                        if(status.status == "success"){
                            
                            self.collectBtn.isSelected = false
                            self.collect_bottom_Btn.isSelected = false
                            
                            self.collectHud.mode = MBProgressHUDMode.text;
                            self.collectHud.labelText = "取消收藏成功"

                        }
                    }
                    self.collectHud.hide(true, afterDelay: 1)
                    self.collectBtn.isEnabled = true
                    self.collect_bottom_Btn.isEnabled = true
                })
            }
        }else{
            
            NewsPageHelper().collectionNews(newsInfo!.object_id,type: type as String, title: (newsInfo?.post_title)!, description: newsInfo!.post_excerpt) { (success, response) in
                if success {
                    DispatchQueue.main.async(execute: {
                        self.collectBtn.isSelected = true
                        self.collect_bottom_Btn.isSelected = true
                        self.collectHud.mode = MBProgressHUDMode.text;
                        self.collectHud.labelText = "收藏成功"
                        self.collectHud.hide(true, afterDelay: 1)
                        self.collectBtn.isEnabled = true
                        self.collect_bottom_Btn.isEnabled = true
                    })
                }
            }
        }

    }
    
    func collectionNews_1(){
        
        let alertController = UIAlertController(title: "分享到...", message: nil, preferredStyle: .actionSheet)
        self.present(alertController, animated: true, completion: nil)
        
        let wechatAction = UIAlertAction(title: "微信好友", style: .default) { (pengyouquanAction) in
            
            let btn = UIButton()
            btn.tag = 1
            self.shareTheNews(btn)
        }
        alertController.addAction(wechatAction)
        
        let weiboAction = UIAlertAction(title: "新浪微博", style: .default) { (pengyouquanAction) in

            let btn = UIButton()
            btn.tag = 2
            self.shareTheNews(btn)

        }
        alertController.addAction(weiboAction)
        
        let pengyouquanAction = UIAlertAction(title: "朋友圈", style: .default) { (pengyouquanAction) in
            
            let btn = UIButton()
            btn.tag = 0
            self.shareTheNews(btn)
            
        }
        alertController.addAction(pengyouquanAction)
        
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
    }
    
    // MARK:- 分享视图
    func collectionNews() {
        let imageArray = ["ic_share_friendzone","ic_share_wechat","ic_share_qq","ic_share_qzone","ic_share_weibo"]
        let imageNameArray = ["微信朋友圈","微信好友","QQ好友","QQ空间","新浪微博"]
        
        let bgView = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT))
        bgView.backgroundColor = UIColor(white: 0.5, alpha: 0.3)
        bgView.tag = 101
        bgView.addTarget(self, action: #selector(shareViewHide(_:)), for: .touchUpInside)
        UIApplication.shared.keyWindow!.addSubview(bgView)
        
        let bottomView = UIView(frame: CGRect(x: 0, y: bgView.frame.maxY, width: WIDTH, height: HEIGHT*0.4))
        bottomView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
        bgView.addSubview(bottomView)
        
        let shareBtnWidth:CGFloat = WIDTH/7.0
//        let maxMargin:CGFloat = shareBtnWidth/3.0
        let shareBtnCount:Int = 5 // 每行的按钮数
        let margin = shareBtnWidth/3.0
        
        let labelHeight = margin/2.0
        
        var labelMaxY:CGFloat = 0
        
        for i in 0...4 {
            
            let shareBtn_1 = UIButton(frame: CGRect(x: margin*(CGFloat(i%shareBtnCount)+1)+shareBtnWidth*CGFloat(i%shareBtnCount), y: margin*(CGFloat(i/shareBtnCount)+1)+(shareBtnWidth+margin+labelHeight)*CGFloat(i/shareBtnCount), width: shareBtnWidth, height: shareBtnWidth))
            shareBtn_1.layer.cornerRadius = shareBtnWidth/2.0
            shareBtn_1.backgroundColor = UIColor.white
            shareBtn_1.setImage(UIImage(named: imageArray[i]), for: UIControlState())
            shareBtn_1.tag = 1000+i
            shareBtn_1.addTarget(self, action: #selector(shareBtnClick(_:)), for: .touchUpInside)
            bottomView.addSubview(shareBtn_1)
            // print(shareBtn_1.frame)
            
            let shareLab_1 = UILabel(frame: CGRect(x: shareBtn_1.frame.minX-margin/2.0, y: shareBtn_1.frame.maxY+margin/2.0, width: shareBtnWidth+margin, height: labelHeight))
            shareLab_1.textColor = UIColor.gray
            shareLab_1.font = UIFont.systemFont(ofSize: 12)
            shareLab_1.textAlignment = .center
            shareLab_1.text = imageNameArray[i]
            bottomView.addSubview(shareLab_1)
            
            labelMaxY = shareLab_1.frame.maxY
        }
        
        let line = UIView(frame: CGRect(x: 0, y: labelMaxY+margin, width: WIDTH, height: 1))
        line.backgroundColor = UIColor.lightGray
        bottomView.addSubview(line)
        
        let cancelBtnHeight = shareBtnWidth*0.8
        
        let cancelBtn = UIButton(frame: CGRect(x: 0, y: line.frame.maxY, width: WIDTH, height: cancelBtnHeight))
        cancelBtn.backgroundColor = UIColor(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1)
        cancelBtn.setTitleColor(UIColor.black, for: UIControlState())
        cancelBtn.setTitle("取消", for: UIControlState())
        cancelBtn.tag = 102
        cancelBtn.addTarget(self, action: #selector(shareViewHide(_:)), for: .touchUpInside)
        bottomView.addSubview(cancelBtn)
        
        bottomView.frame.size.height = cancelBtn.frame.maxY
        
        UIView.animate(withDuration: 0.5, animations: {
            bottomView.frame.origin.y = HEIGHT - cancelBtn.frame.maxY
        }) 
    }
    
    // 分享视图取消事件
    func shareViewHide(_ shareView:UIButton) {
        if shareView.tag == 102 {
            shareView.superview!.superview!.removeFromSuperview()
        }else{
            shareView.removeFromSuperview()
        }
    }
    
    // 分享视图分享按钮点击事件
    func shareBtnClick(_ shareBtn:UIButton) {
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            let one = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 30))
            one.backgroundColor = UIColor.white
            let lineone = UILabel(frame: CGRect(x: 10, y: 29, width: WIDTH-20, height: 1))
            lineone.backgroundColor = COLOR
            one.addSubview(lineone)
            let tit = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: 30))
            tit.textColor = COLOR
            tit.font = UIFont.systemFont(ofSize: 14)
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
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in

            if(error != nil){
            }else{
                let status = commentModel(JSONDecoder(json!))
                
                if(status.status == "error") && status.errorData != ""{
                    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hud?.mode = MBProgressHUDMode.text;
                    hud?.labelText = "获取评论列表失败"
                    hud?.detailsLabelText = status.errorData
                    hud?.margin = 10.0
                    hud?.removeFromSuperViewOnHide = true
                    hud?.hide(true, afterDelay: 1)
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
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return  0
        }else if section == 1 {
            return 30
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
                    
                    let child_commentBtnHeight = child_comment.content.boundingRect(
                        with: CGSize(width: WIDTH-60-10-30-16, height: 0),
                        options: .usesLineFragmentOrigin,
                        attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14)],
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            var cell1:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellIntenfer")!
            cell1.selectionStyle = .none
            
            cell1.textLabel?.numberOfLines = 0
           
            if indexPath.row == 0 {
               
                cell1 = UITableViewCell.init(style: .default, reuseIdentifier: "cellIntenfer")
                cell1.selectionStyle = .none

                let title = UILabel()
                let height = calculateHeight((newsInfo?.post_title)!, size: 21, width: WIDTH-20)
                title.frame = CGRect(x: 15, y: 0, width: WIDTH-30, height: height+30)
                title.text = newsInfo?.post_title
                title.numberOfLines = 0
                title.font = UIFont.systemFont(ofSize: 21)
                cell1.addSubview(title)
                tableView.rowHeight=height+30
                
                return cell1

            }else if indexPath.row == 1 {

                let cell = tableView.dequeueReusableCell(withIdentifier: "sourceCell", for: indexPath)as! NewsSourceCell
                cell.source.text = "来源：\((newsInfo?.post_source)!)"
                
                cell.post_like.text = newsInfo?.post_hits
                let time:Array = (newsInfo?.post_modified!.components(separatedBy: " "))!
                cell.createTime.text = time[0]
                
                return cell
                
            }else if indexPath.row == 2 {
                
                let webCell = tableView.dequeueReusableCell(withIdentifier: "webView") as! contentCell
                if webFlag {
                    
                    NewsPageHelper().addScore_ReadingInformation((newsInfo?.object_id)!, handle: { (success, response) in
                        if success || String(describing: response) == "阅读资讯加积分到上限值"{
                            
                            let url = URL(string:NewsInfo_Header+(self.newsInfo?.object_id)!)
                            webCell.loadRequestUrl(url!)
                            webCell.contentWebView.delegate = self
                            self.webFlag = false
                            
                            if success {
                                self.addScore_ReadingInformation = true
                                self.addScore_ReadingInformationName = (response as! addScore_ReadingInformationDataModel).event
                                self.addScore_ReadingInformationScore = (response as! addScore_ReadingInformationDataModel).score
                            }
                           
                        }else{
                            let alert = UIAlertController(title: nil, message: "获取新闻内容失败", preferredStyle: .alert)
                            self.present(alert, animated: true, completion: {
                                
                            })
                            
                            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                                
                            })
                            alert.addAction(cancelAction)
                            
                            let replyAction = UIAlertAction(title: "重试", style: .default, handler: { (action) in
                                
                                self.myTableView.reloadData()
                            })
                            alert.addAction(replyAction)
                        }
                    })
                    
                }
                return webCell
               
            }else{
                
                let cell3 = tableView.dequeueReusableCell(withIdentifier: "zanCell", for: indexPath)
                for view in cell3.subviews {
                    view.removeFromSuperview()
                }
                cell3.selectionStyle = .none
                let line = UILabel(frame: CGRect(x: WIDTH*63/375, y: 14.5, width: WIDTH*250/375, height: 1))
                line.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
                let share = UILabel(frame: CGRect(x: WIDTH/2-30, y: 5, width: 60, height: 20))
                share.font = UIFont.systemFont(ofSize: 12)
                share.textAlignment = .center
                share.textColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
                share.text = "分享到"
                share.backgroundColor = UIColor.white
                for i in 0...2 {
                    let shareBtn = UIButton(frame: CGRect(x: WIDTH*(15+119*CGFloat(i))/375, y: WIDTH*30/375, width: WIDTH*108/375, height: WIDTH*30/375))
                    shareBtn.tag = i
                    shareBtn.layer.cornerRadius = 4
                    shareBtn.layer.borderColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0).cgColor
                    
                    shareBtn.layer.borderWidth = 0.5
                    shareBtn.setImage(UIImage(named: shareArr[i]), for: UIControlState())
                    shareBtn.addTarget(self, action: #selector(self.shareTheNews(_:)), for: .touchUpInside)
                    cell3.addSubview(shareBtn)
                }
                
                zan.setImage(UIImage(named: "img_like.png"), for: UIControlState())
                zan.setImage(UIImage(named: "img_like_sel.png"), for: .selected)
                zan.tag = indexPath.row
                zan.addTarget(self, action: #selector(NewsContantViewController.zanAddNum(_:)), for: .touchUpInside)
                number.frame = CGRect(x: WIDTH/2-25, y: WIDTH*170/375, width: 50, height: 18)
                number.text =  "\(self.likeNum)"
//        self.likeNum = hashValue!
                number.sizeToFit()
                number.font = UIFont.systemFont(ofSize: 12)
                number.frame = CGRect(x: WIDTH/2-number.bounds.size.width/2-8, y: WIDTH*170/375, width: number.bounds.size.width, height: 18)
                number.textAlignment = .center
                number.textColor = COLOR
                let one = UILabel(frame: CGRect(x: WIDTH/2-number.bounds.size.width/2-48, y: WIDTH*170/375, width: 40, height: 18))
                one.font = UIFont.systemFont(ofSize: 12)
                one.textColor = UIColor.gray
                one.textAlignment = .right
                one.text = "已有"
               
                let two = UILabel(frame: CGRect(x: WIDTH/2+number.bounds.size.width/2-8, y: WIDTH*170/375, width: 50, height: 18))
                two.font = UIFont.systemFont(ofSize: 12)
                two.textColor = UIColor.gray
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
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsCommentCell") as! HSNewsCommentCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            if self.commentArray.count == 0 {
                cell.textLabel?.text = "暂无评论"
                cell.textLabel?.textColor = UIColor.gray
                cell.textLabel?.textAlignment = .center
                
                cell.nameLab.text = nil
                cell.contentLab.text = nil
                cell.timeLab.text = nil
                cell.headerBtn.setImage(nil, for: UIControlState())
            }else{
                cell.textLabel?.text = nil
                cell.floorLab.text = "\(self.commentArray.count-indexPath.row)楼"
                cell.commentModel = self.commentArray[indexPath.row]
            }
            return cell
        }
        
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        BaiduMobStat.default().webviewStartLoad(with: request)
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        //获取页面高度（像素）
        let clientheight_str:String = webView.stringByEvaluatingJavaScript(from: "document.body.offsetHeight")!
        let clienthetght_temp:NSString = NSString(string: clientheight_str)
        let clientheight = CGFloat(clienthetght_temp.floatValue)

        //设置到WebView上
        webView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: CGFloat(clientheight))
        //获取WebView最佳尺寸（点）
        let frame:CGSize = webView.sizeThatFits(webView.frame.size)
        //再次设置WebView高度（点）
        webView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: frame.height);
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
    func showScoreTips(_ name:String, score:String) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.opacity = 0.3
        hud?.margin = 10
        hud?.color = UIColor(red: 145/255.0, green: 26/255.0, blue: 107/255.0, alpha: 0.3)
        hud?.mode = .customView
        let customView = UIImageView(frame: CGRect(x: 0, y: 0, width: WIDTH*0.8, height: WIDTH*0.8*238/537))
        customView.image = UIImage(named: "scorePopImg.png")
        let titLab = UILabel(frame: CGRect(
            x: customView.frame.width*351/537,
            y: customView.frame.height*30/238,
            width: customView.frame.width*174/537,
            height: customView.frame.height*50/238))
        titLab.textColor = UIColor(red: 140/255.0, green: 39/255.0, blue: 90/255.0, alpha: 1)
        titLab.textAlignment = .left
        titLab.font = UIFont.systemFont(ofSize: 16)
        titLab.text = name
        titLab.adjustsFontSizeToFitWidth = true
        customView.addSubview(titLab)
        
        let scoreLab = UILabel(frame: CGRect(
            x: customView.frame.width*351/537,
            y: customView.frame.height*100/238,
            width: customView.frame.width*174/537,
            height: customView.frame.height*50/238))
        scoreLab.textColor = UIColor(red: 252/255.0, green: 13/255.0, blue: 27/255.0, alpha: 1)

        scoreLab.textAlignment = .left
        scoreLab.font = UIFont.systemFont(ofSize: 24)
        scoreLab.text = "+\(score)"
        scoreLab.adjustsFontSizeToFitWidth = true
        scoreLab.sizeToFit()
        customView.addSubview(scoreLab)
        
        let jifenLab = UILabel(frame: CGRect(
            x: scoreLab.frame.maxX+5,
            y: customView.frame.height*100/238,
            width: customView.frame.width-scoreLab.frame.maxX-5-customView.frame.width*13/537,
            height: customView.frame.height*50/238))
        jifenLab.textColor = UIColor(red: 107/255.0, green: 106/255.0, blue: 106/255.0, alpha: 1)
        jifenLab.textAlignment = .center
        jifenLab.font = UIFont.systemFont(ofSize: 16)
        jifenLab.text = "护士币"
        jifenLab.adjustsFontSizeToFitWidth = true
        jifenLab.center.y = scoreLab.center.y
        customView.addSubview(jifenLab)
        
        hud?.customView = customView
        hud?.hide(true, afterDelay: 3)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       if indexPath.section == 1 {
            self.replyTextField.placeholder = "回复 \(self.commentArray[indexPath.row].username)"
            self.send_bottom_Btn.tag = NSString(string: self.commentArray[indexPath.row].cid).integerValue
            self.send_bottom_Btn.isSelected = true
            self.replyTextField.becomeFirstResponder()
        }
    }

    var shareNewsUrl = ""
    
    func shareTheNews(_ btn:UIButton) {
        
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
    
    func shareNews(_ btn:UIButton) {
        
        if btn.tag == 0 || btn.tag == 1 {
            
            let message = WXMediaMessage()
            message.title = newsInfo?.post_title
            message.description = newsInfo?.post_excerpt

            if newsInfo?.thumbArr.count == 0 {
                let thumbImage = UIImage(named: "appLogo")
                message.setThumbImage(thumbImage)
                
            }else{
                
                let str = DomainName+"data/upload/"+(newsInfo?.thumbArr.first?.url)!
                let url = URL(string: str)
                let data = try? Data(contentsOf: url!)
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
            
            
            WXApi.send(req)
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
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            let dateStr = dateFormatter.string(from: Date())
            webpage.objectID = "chinanurse\(kAppKey)\(dateStr)"
            webpage.title = newsInfo?.post_title
            webpage.description = newsInfo?.post_excerpt
            if newsInfo?.thumbArr.count == 0 {
                let thumbImage = UIImage(named: "appLogo")
                let data = UIImageJPEGRepresentation(thumbImage!, 0.5)!
                webpage.thumbnailData = data
            }else{
                
                let str = DomainName+"data/upload/"+(newsInfo?.thumbArr.first?.url)!
                let url = URL(string: str)
                let data = try? Data(contentsOf: url!)
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
            
            let request = WBSendMessageToWeiboRequest.request(withMessage: message, authInfo: authRequest, access_token: AppDelegate().wbtoken) as! WBSendMessageToWeiboRequest
            request.userInfo = ["ShareMessageFrom":"NewsContantViewController"]
            
            WeiboSDK.send(request)
        }else{
            
            let newsUrl = URL(string: shareNewsUrl)
            let title = newsInfo?.post_title
            let description = newsInfo?.post_excerpt
            
            var previewImageData = Data()
            if newsInfo?.thumbArr.count == 0 {
                let thumbImage = UIImage(named: "appLogo")
                previewImageData = UIImageJPEGRepresentation(thumbImage!, 0.5)!
            }else{
                
                let str = DomainName+"data/upload/"+(newsInfo?.thumbArr.first?.url)!
                let url = URL(string: str)
                let data = try? Data(contentsOf: url!)
                let thumbImage = UIImage(data: data!)
                
                previewImageData = thumbImage!.compressImage(thumbImage!, maxLength: 32700)!
            }
            
            let newsObj = QQApiNewsObject(url: newsUrl, title: title, description: description, previewImageData: previewImageData, targetContentType: QQApiURLTargetTypeNews)
            let req = SendMessageToQQReq(content: newsObj)
            
            if btn.tag == 3 {
                QQApiInterface.send(req)
            }else if btn.tag == 4 {
                QQApiInterface.sendReq(toQZone: req)
            }
        }
        
//        // print(btn.tag)

    }
    
    func zanAddNum(_ btn:UIButton) {
        

        if !requiredLogin(self.navigationController!, previousViewController: self, hiddenNavigationBar: false) {
            return
        }
        
        self.zan.isEnabled = false

        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.margin = 10.0
        hud?.removeFromSuperViewOnHide = true
        
        if zan.isSelected {
            let url = PARK_URL_Header+"ResetLike"
            let param = [
                "id":newsInfo?.object_id,
                "type":"1",
                "userid":QCLoginUserInfo.currentInfo.userid
            ];
            
            NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as? [String:String] as [String : AnyObject]?) { (json, error) in

                
                self.zan.isEnabled = true

                if(error != nil){
                    hud?.mode = MBProgressHUDMode.text
                    hud?.labelText = "取消点赞失败"
                    hud?.hide(true, afterDelay: 1)
                }else{
                    let status = Http(JSONDecoder(json!))

                    if(status.status == "error"){

                        hud?.mode = MBProgressHUDMode.text;
                        hud?.labelText = status.errorData
                        hud?.hide(true, afterDelay: 1)
                        //                            user.setObject("false", forKey: (self.newsInfo?.object_id)!)
                    }
                    if(status.status == "success"){
                        
                        hud?.mode = MBProgressHUDMode.text;
                        hud?.labelText = "取消点赞成功"
                        hud?.hide(true, afterDelay: 1)

                        self.performSelector(onMainThread: #selector(self.upDateUI(_:)), with: [btn.tag,"0"], waitUntilDone:true)
                        
                        for (i,obj) in (self.newsInfo?.likes)!.enumerated() {
                            if obj.userid == QCLoginUserInfo.currentInfo.userid {
                                self.newsInfo?.likes.remove(at: i)
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
            NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as? [String:String] as [String : AnyObject]?) { (json, error) in


                self.zan.isEnabled = true

                if(error != nil){
                    hud?.mode = MBProgressHUDMode.text
                    hud?.labelText = "点赞失败"
                    hud?.hide(true, afterDelay: 1)
                }else{
                    let status = addScore_ReadingInformationModel(JSONDecoder(json!))

                    if(status.status == "error"){

                        hud?.mode = MBProgressHUDMode.text
                        hud?.labelText = status.errorData
                        hud?.hide(true, afterDelay: 1)
                    }
                    if(status.status == "success"){
                        
                        hud?.mode = MBProgressHUDMode.text;
                        hud?.labelText = "点赞成功"
                        hud?.hide(true, afterDelay: 1)
                        self.performSelector(onMainThread: #selector(self.upDateUI(_:)), with: [btn.tag,"1"], waitUntilDone:true)
                        if ((status.data?.event) != "") {
                            self.showScoreTips((status.data?.event)!, score: (status.data?.score)!)
                        }
                        
                        let dic = ["userid":QCLoginUserInfo.currentInfo.userid]
                        let model:LikeInfo = LikeInfo.init(JSONDecoder(dic as AnyObject))
                        self.newsInfo?.likes.append(model)
                        
                    }
                }
            }
        }
        
    }
    
    
    func upDateUI(_ status:NSArray){

        if status[1] as! String=="1" {
             self.likeNum = self.likeNum + 1
            self.zan.isSelected = true
        }else{
             self.likeNum = self.likeNum - 1
            self.zan.isSelected = false
        }
        
        self.zan.isEnabled = true
        
        let indexPath = IndexPath.init(row: status[0] as! Int, section: 0)

        self.myTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.delegate?.changeModel(newsInfo!, andIndex: index)
    }
}
