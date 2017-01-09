//
//  NSCircleForumDetailViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/13.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import SDWebImage

class NSCircleForumDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, SDPhotoBrowserDelegate {
    
    let rootTableView = UITableView(frame: CGRect.zero, style: .grouped)
    
//    var forumBestOrTopModelArray = [ForumModel]()
    var forumDataModel = ForumListDataModel() {
        didSet {
            self.comment_count = NSString(string: (forumDataModel.comments_count)).integerValue
        }
    }
    var forumModel = ForumInfoDataModel()
    
//    var forumCommentArray = [ForumCommentDataModel]()

    var forumCommentArray = [ForumCommentsDataModel]()

    var isMaster = false
    
    var imageHeigthArray = [CGFloat]()
    
    var myScore = ""
    
    var comment_count = 0 {
        didSet {
            if self.rootTableView.mj_footer != nil {
                self.rootTableView.mj_footer.resetNoMoreData()
            }
            self.pager = 2
            self.rootTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //        self.view.backgroundColor = UIColor.cyanColor()
        self.setSubview()
        
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "护士站 圈子 详情")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "护士站 圈子 详情")
    }
    
    // MARK: - 加载数据
    func loadData() {
        
        CircleNetUtil.getForumInfo(userid: QCLoginUserInfo.currentInfo.userid, tid: forumDataModel.id) { (success, response) in
            if success {
                self.forumModel = response as! ForumInfoDataModel
                for _ in self.forumModel.photo {
                    self.imageHeigthArray.append(0)
                }
                
                self.send_bottom_Btn.tag = NSString(string: self.forumModel.tid).integerValue
                
                self.rootTableView.reloadData()
            }
        }
        
        CircleNetUtil.judge_apply_community(userid: QCLoginUserInfo.currentInfo.userid, cid: forumDataModel.community_id) { (success, response) in
            if success {
                if (response as! String) == "yes" {
                    self.isMaster = true
                }else{
                    self.isMaster = false
                }
            }
        }
        
        CircleNetUtil.getForumComments(userid: QCLoginUserInfo.currentInfo.userid, refid: self.forumDataModel.id, pager: "1") { (success, response) in
            if success {
                self.pager += 1
                self.forumCommentArray = response as! [ForumCommentsDataModel]
                self.rootTableView.reloadData()
            }
        }
        
    }
    
    // MARK: - 加载数据（上拉加载）
    var pager = 1
    func loadData_pullUp() {
        
        CircleNetUtil.getForumComments(userid: QCLoginUserInfo.currentInfo.userid, refid: self.forumDataModel.id, pager: String(pager)) { (success, response) in
            
            if success {
                self.pager += 1
                
                let forumCommentArray = response as! [ForumCommentsDataModel]
                
                if forumCommentArray.count == 0 {
                    self.rootTableView.mj_footer.endRefreshingWithNoMoreData()
                }else{
                    self.rootTableView.mj_footer.endRefreshing()

                    for forumComment in forumCommentArray {
                        self.forumCommentArray.append(forumComment)
                    }
                    self.rootTableView.reloadData()

                }
            }else{
                self.rootTableView.mj_footer.endRefreshingWithNoMoreData()
            }
        }
        
    }
    
    // MARK:- 分享视图
    func shareForumBtnClick() {
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
    
    var shareNewsUrl = ""
    
    func shareTheNews(_ btn:UIButton) {
        
        self.shareNewsUrl = DomainName+"index.php?g=HomePage&m=CommunityShare&a=index&tid=\(forumDataModel.id)&type=1&userid=\(QCLoginUserInfo.currentInfo.userid)"
        self.shareNews(btn)
    }
    
    func shareNews(_ btn:UIButton) {
        
        if btn.tag == 0 || btn.tag == 1 {
            
            let message = WXMediaMessage()
            message.title = forumDataModel.title
            message.description = forumDataModel.content
            
            if forumDataModel.photo.count == 0 {
                let thumbImage = UIImage(named: "appLogo")
                message.setThumbImage(thumbImage)
                
            }else{
                
                let str = SHOW_IMAGE_HEADER+(forumDataModel.photo.first)!
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
            webPageObject.webpageUrl = shareNewsUrl
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
                message.text = forumDataModel.title
            }else{
                message.text = "\(forumDataModel.title) \(shareNewsUrl) 想看更多内容，马上下载【中国护士网】http://t.cn/RczKRS3 (分享自@中国护士网)"
            }
            let webpage:WBWebpageObject = WBWebpageObject.object() as! WBWebpageObject
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            let dateStr = dateFormatter.string(from: Date())
            webpage.objectID = "chinanurse\(kAppKey)\(dateStr)"
            webpage.title = forumDataModel.title
            webpage.description = forumDataModel.content
            if forumDataModel.photo.count == 0 {
                let thumbImage = UIImage(named: "appLogo")
                let data = UIImageJPEGRepresentation(thumbImage!, 0.5)!
                webpage.thumbnailData = data
            }else{
                
                let str = SHOW_IMAGE_HEADER+(forumDataModel.photo.first)!
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
            let title = forumDataModel.title
            let description = forumDataModel.content
            
            var previewImageData = Data()
            if forumDataModel.photo.count == 0 {
                let thumbImage = UIImage(named: "appLogo")
                previewImageData = UIImageJPEGRepresentation(thumbImage!, 0.5)!
            }else{
                
                let str = SHOW_IMAGE_HEADER+(forumDataModel.photo.first)!
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
    
    // MARK: - 设置子视图
    func setSubview() {
        
        let shareBtn:UIButton = UIButton.init(frame: CGRect(x: 0, y: 7, width: 30, height: 30))
        shareBtn.setImage(UIImage.init(named: "ic_fenxiang"), for: UIControlState())
        shareBtn.addTarget(self, action: #selector(shareForumBtnClick), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: shareBtn)

        self.title = "贴子详情"
        
        let line = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.white
        rootTableView.frame = CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-65-49)
        rootTableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        rootTableView.separatorStyle = .none
        rootTableView.delegate = self
        rootTableView.dataSource = self
        
        rootTableView.register(NSCircleDetailTableViewCell.self, forCellReuseIdentifier: "circleDetailCell")
        rootTableView.register(NSCircleDetailTopTableViewCell.self, forCellReuseIdentifier: "circleDetailTopCell")
        rootTableView.register(UINib.init(nibName: "NSCircleCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "circleForumCommentCell")

        //        myTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(makeDataSource))
        //        rootTableView.mj_header.beginRefreshing()
        
        rootTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadData_pullUp))
        
        self.view.addSubview(rootTableView)
        
        self.setTableViewHeaderView()
        
        self.setReplyView()
    }
    
    // MARK: - 设置头视图
    func setTableViewHeaderView() {
        
        let tableHeaderView = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 50))
        tableHeaderView.backgroundColor = UIColor.white
        tableHeaderView.addTarget(self, action: #selector(tableViewHeaderViewClick), for: .touchUpInside)
        
        // 用户信息

        let img = UIImageView(frame: CGRect(x: 8, y: 8, width: 35, height: 35))
        img.backgroundColor = UIColor(red: 243/255.0, green: 229/255.0, blue: 240/255.0, alpha: 1)
        img.layer.cornerRadius = 17.5
        img.clipsToBounds = true
        img.sd_setImage(with: URL(string: SHOW_IMAGE_HEADER+forumDataModel.user_photo), placeholderImage: nil)
        tableHeaderView.addSubview(img)
        
        let nameLab = UILabel(frame: CGRect(x: img.frame.maxX+8, y: 8, width: calculateWidth(forumDataModel.user_name, size: 12, height: 17), height: 17))
        nameLab.textAlignment = .left
        nameLab.font = UIFont.systemFont(ofSize: 12)
        nameLab.textColor = UIColor.black
        nameLab.text = forumDataModel.user_name
        tableHeaderView.addSubview(nameLab)
        
        let positionLab = UILabel(frame: CGRect(x: nameLab.frame.maxX+8, y: 0, width: calculateWidth(forumDataModel.auth_type, size: 8, height: 12)+12, height: 12))
        positionLab.font = UIFont.systemFont(ofSize: 8)
        positionLab.textColor = UIColor.white
        positionLab.layer.backgroundColor = COLOR.cgColor
        positionLab.textAlignment = .center
        positionLab.center.y = nameLab.center.y
        positionLab.layer.cornerRadius = 6
        if forumDataModel.auth_type == "" {
            positionLab.removeFromSuperview()
        }else{
            positionLab.text = forumDataModel.auth_type
            positionLab.layer.backgroundColor = NSCirclePublicAction.getAuthColor(with: forumDataModel.auth_type).cgColor
            tableHeaderView.addSubview(positionLab)
        }

        let levelLab = UILabel(frame: CGRect(x: img.frame.maxX+8, y: nameLab.frame.maxY+1, width: calculateWidth("Lv.\(forumDataModel.level)", size: 10, height: 17), height: 17))
        levelLab.font = UIFont.systemFont(ofSize: 10)
        levelLab.textColor = COLOR
        levelLab.textAlignment = .center
        levelLab.text = "Lv.\(forumDataModel.level)"
        tableHeaderView.addSubview(levelLab)
        
        let timeLab = UILabel(frame: CGRect(
            x: WIDTH-10-calculateWidth(updateTime(forumDataModel.create_time), size: 10, height: 17),
            y: (50-UIFont.systemFont(ofSize: 10).lineHeight)/2.0,
            width: calculateWidth(updateTime(forumDataModel.create_time), size: 10, height: UIFont.systemFont(ofSize: 10).lineHeight),
            height: UIFont.systemFont(ofSize: 10).lineHeight))
        timeLab.font = UIFont.systemFont(ofSize: 10)
        timeLab.textColor = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1)
        timeLab.text = updateTime(forumDataModel.create_time)
        tableHeaderView.addSubview(timeLab)
        
        rootTableView.tableHeaderView = tableHeaderView
    }
    
    let replyView = UIView()
    var send_bottom_Btn:UIButton = UIButton() // 下方发送按钮
    let replyTextField = UIPlaceHolderTextView()
    var keyboardShowState = false
    
    var commentType = ""
    var commentId = ""
    
    // MARK: 设置回复视图
    func setReplyView() {
        // 回复 视图
        replyView.frame = CGRect(x: 0, y: HEIGHT-49-65, width: WIDTH, height: 49)
        replyView.backgroundColor = UIColor(red: 244/255.0, green: 245/255.0, blue: 246/255.0, alpha: 1)
        
        // 回复框
        replyTextField.frame = CGRect(x: 10, y: 8, width: WIDTH-10-10-80-10, height: 33)
        replyTextField.layer.cornerRadius = 6
        //        replyTextField.borderStyle = UITextBorderStyle.RoundedRect
        replyTextField.placeholder = "回复"
        replyTextField.font = UIFont.systemFont(ofSize: 14)
        replyTextField.returnKeyType = UIReturnKeyType.send
        replyTextField.delegate = self
        replyView.addSubview(replyTextField)
        
        // 发送
        send_bottom_Btn.frame = CGRect(x: replyTextField.frame.maxX+10, y: 8, width: 80, height: 33)
        send_bottom_Btn.layer.cornerRadius = 6
        send_bottom_Btn.backgroundColor = UIColor.gray
        send_bottom_Btn.setTitleColor(UIColor.white, for: UIControlState())
        send_bottom_Btn.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        send_bottom_Btn.setTitle("发送", for: UIControlState())
//        send_bottom_Btn.tag = NSString(string: (newsInfo?.object_id)!).integerValue
        send_bottom_Btn.addTarget(self, action: #selector(sendComment), for: .touchUpInside)
        replyView.addSubview(send_bottom_Btn)
        
        let line_topView:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1/UIScreen.main.scale))
        line_topView.backgroundColor = UIColor.lightGray
        replyView.addSubview(line_topView)
        
        self.view.addSubview(replyView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidAppear), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - 获取键盘信息并改变视图
    func keyboardWillAppear(_ notification: Notification) {
        
        // 获取键盘信息
        let keyboardinfo = notification.userInfo![UIKeyboardFrameEndUserInfoKey]
        
        let keyboardheight:CGFloat = ((keyboardinfo as AnyObject).cgRectValue.size.height)
        
        replyView.frame = CGRect(x: 0, y: HEIGHT-86-33-8-65, width: WIDTH, height: 86+33+8)
        replyTextField.frame.size = CGSize(width: WIDTH-30, height: 70)
        send_bottom_Btn.frame = CGRect(x: replyTextField.frame.maxX-80, y: replyTextField.frame.maxY+8, width: 80, height: 33)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.replyView.frame.origin.y = HEIGHT-86-33-65-keyboardheight
        }) 
        
    }
    
    func keyboardDidAppear(_ notification:Notification) {
        keyboardShowState = true
    }
    
    func keyboardWillDisappear(_ notification:Notification){
        UIView.animate(withDuration: 0.3, animations: {
            self.replyView.frame = CGRect(x: 0, y: HEIGHT-49-65, width: WIDTH, height: 49)
            self.replyTextField.frame = CGRect(x: 10, y: 8, width: WIDTH-10-10-80-10, height: 33)
            self.send_bottom_Btn.frame = CGRect(x: self.replyTextField.frame.maxX+10, y: 8, width: 80, height: 33)

            //            self.rootTableView.frame.size.height = HEIGHT-64-1-46
        }) 
        // print("键盘落下")
    }
    // MARK: -
    
    // MARK: - UITextViewDelegate
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
        self.send_bottom_Btn.tag = NSString(string: self.forumModel.tid).integerValue
        self.replyTextField.placeholder = "回复"
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count > 0 {
            send_bottom_Btn.backgroundColor = COLOR
        }else{
            send_bottom_Btn.backgroundColor = UIColor.white
        }
    }
    // MARK: -
    
    // MARK: - 去除空格和回车
    func trimLineString(_ str:String)->String{
        let nowStr = str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return nowStr
    }
    //  MARK: - 发表评论
    func sendComment() {
        
        
        if replyTextField.text != "" && trimLineString(replyTextField.text) != ""{
                        
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = "正在发表评论"
            hud.margin = 10.0
            hud.removeFromSuperViewOnHide = true
            
            CircleNetUtil.SetComment(userid: QCLoginUserInfo.currentInfo.userid, id: String(self.send_bottom_Btn.tag), content: replyTextField.text, type: self.send_bottom_Btn.isSelected ? "3":"2", photo: "", handle: { (success, response) in
                if success {
                    
                    self.replyTextField.text = nil
                    hud.mode = .text
                    hud.label.text = "评论成功"
                    
                    let result = response as! SetLikeDataModel
                    
                    if result.event != "" {
                        NursePublicAction.showScoreTips(self.view, nameString: result.event, score: result.score)
                        
                    }
                    
                    CircleNetUtil.getComments_count(id: self.forumDataModel.id, type: "2") { (success, response) in
                        if success {
                            self.comment_count = NSString(string: (response as! String)).integerValue
                        }
                    }
                    
                    CircleNetUtil.getForumComments(userid: QCLoginUserInfo.currentInfo.userid, refid: String(self.send_bottom_Btn.tag), pager: "1", handle: { (success, response) in
                        if success {
                            
                            self.forumCommentArray = response as! [ForumCommentsDataModel]
                            
                            self.rootTableView.reloadData()
                            hud.hide(animated: true, afterDelay: 1)
                        }else{
                            hud.mode = .text
                            hud.label.text = "获取评论失败"
                            hud.hide(animated: true, afterDelay: 1)
                        }
                    })
                }else{
                    hud.mode = .text
                    hud.label.text = "评论失败"
                    hud.hide(animated: true, afterDelay: 1)
                }
            })
            replyTextField.resignFirstResponder()
        }else{
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.margin = 10.0
            hud.removeFromSuperViewOnHide = true
            hud.mode = MBProgressHUDMode.text;
            hud.label.text = "请输入内容"
            hud.hide(animated: true, afterDelay: 1)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if keyboardShowState == true {
            
            replyTextField.resignFirstResponder()
            keyboardShowState = false
        }
    }
    
    // MARK:- tableView header click
    func tableViewHeaderViewClick() {
        
        let circleUserInfoController = NSCircleUserInfoViewController()
        circleUserInfoController.userid = forumDataModel.userid
        self.navigationController?.pushViewController(circleUserInfoController, animated: true)
    }
    
    // MARK: - UItableViewdatasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return forumModel.photo.count>0 ? 3:2
//            return 2+forumModel.photo.count
        }else if section == 1 {
            if self.forumCommentArray.count == 0 {
                return 1
            }else{
                
                return (self.forumCommentArray.count)
            }
        }else{
            return 0
        }
    }
    
    var flag = 0
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "forumDetailCell")
            
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "forumDetailCell")
                cell?.selectionStyle = .none
                cell?.textLabel?.numberOfLines = 0
            }
            
            cell?.contentView.viewWithTag(100)?.removeFromSuperview()
            
            switch indexPath.row {
            case 0:
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 20)
                cell?.textLabel?.textColor = UIColor.black
                cell?.textLabel?.textAlignment = .center
                cell?.textLabel?.text = forumModel.title
                
            case 1:
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 16)
                cell?.textLabel?.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
                cell?.textLabel?.textAlignment = .left
                cell?.textLabel?.text = forumModel.content
                
            default:
                let imgWidth = (WIDTH-10*4)/3.0
                let imgBgViewHeight = forumModel.photo.count%3 == 0 ? 10+(imgWidth+10)*CGFloat((forumModel.photo.count/3)):10+(imgWidth+10)*CGFloat((forumModel.photo.count/3)+1)
                let imgBgView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: imgBgViewHeight))
                imgBgView.tag = 100
                
                let imgX:CGFloat = 10
                let imgY:CGFloat = 10
                for (i,photo) in forumModel.photo.enumerated() {
                    
                    let imgView = UIButton(frame: CGRect(x: imgX*CGFloat(i%3+1)+imgWidth*CGFloat(i%3), y: imgY*CGFloat(i/3+1)+imgWidth*CGFloat(i/3), width: imgWidth, height: imgWidth))
                    imgView.tag = 100+i
                    imgView.imageView?.contentMode = .scaleAspectFill
                    imgView.imageView?.clipsToBounds = true
                    imgView.sd_setImage(with: URL(string: SHOW_IMAGE_HEADER+photo), for: UIControlState(), placeholderImage: nil)
                    imgView.addTarget(self, action: #selector(imgBtnClick(imgBtn:)), for: .touchUpInside)
                    imgBgView.addSubview(imgView)
                }
                
                cell?.contentView.addSubview(imgBgView)
//                let imgView = UIImageView()
//                imgView.tag = 100
//                imgView.sd_setImage(with: URL(string: SHOW_IMAGE_HEADER+forumModel.photo[indexPath.row-2]), completed: { (image, error, type, url) in
//                    imgView.frame = CGRect(x: 8, y: 8, width: WIDTH-16, height: (WIDTH-16)*(image?.size.height ?? 0)!/(image?.size.width ?? 1)!)
//                    self.imageHeigthArray[indexPath.row-2] = (WIDTH-16)*(image?.size.height ?? 0)!/(image?.size.width ?? 1)!
//                    
//                    self.flag += 1
//                    
//                    if self.flag == self.imageHeigthArray.count {
//                        self.rootTableView.reloadData()
//                    }
//                    
//
//                })
////                                imageView.sd_setImage(with: URL(string: SHOW_IMAGE_HEADER+forumModel.photo[indexPath.row-2]), placeholderImage: nil)
//                cell?.contentView.addSubview(imgView)
                break
            }
            
            
            return cell!
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "circleForumCommentCell") as! NSCircleCommentTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if self.forumCommentArray.count == 0 {
            cell.textLabel?.text = "暂无评论"
            cell.textLabel?.textColor = UIColor.gray
            cell.textLabel?.textAlignment = .center
            
            cell.headerBtn.setImage(nil, for: UIControlState())
            cell.nameLab.text = nil
            cell.positionLab.text = nil
            cell.timeLab.text = nil
            cell.floorLab.text = nil
            cell.levelLab.text = nil
            cell.contentLab.text = nil
            cell.dateImg.isHidden = true
            cell.dateLab.text = nil
            
            cell.likeImg.isHidden = true
            cell.likeBtn.isHidden = true
            
            cell.deleteBtn.isHidden = true
            
            cell.replyBtn.isHidden = true
            
            cell.reportBtn.isHidden = true
            
        }else{
            cell.textLabel?.text = nil
            cell.dateImg.isHidden = false
            
            cell.likeImg.isHidden = false
            cell.likeBtn.isHidden = false
            
            cell.deleteBtn.isHidden = false
            
            cell.replyBtn.isHidden = false
            
            cell.reportBtn.isHidden = false
            
            cell.floorLab.text = "\(self.comment_count-indexPath.row)楼"
            cell.commentModel = self.forumCommentArray[indexPath.row]
            
            cell.headerBtn.tag = 200+indexPath.row
            cell.headerBtn.addTarget(self, action: #selector(userInfoBtnClick(userInfoBtn:)), for: .touchUpInside)
            
            if isMaster || QCLoginUserInfo.currentInfo.isCircleManager == "1" {
                cell.deleteBtn.isHidden = false
            }else{
                cell.deleteBtn.isHidden = true
            }
            
            cell.likeBtn.sizeToFit()
            cell.likeBtn.tag = 100+indexPath.row
            cell.likeBtn.isSelected = self.forumCommentArray[indexPath.row].add_like == "1" ? true:false
            cell.likeBtn.addTarget(self, action: #selector(commentLikeBtnClick(_:)), for: .touchUpInside)
            cell.deleteBtn.tag = 200+indexPath.row
            cell.deleteBtn.addTarget(self, action: #selector(commentDelBtnClick(_:)), for: .touchUpInside)
            cell.reportBtn.tag = 300+indexPath.row
            cell.reportBtn.addTarget(self, action: #selector(commentReportBtnClick(_:)), for: .touchUpInside)

        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                return calculateHeight(forumModel.title, size: 20, width: WIDTH-48)+20
            case 1:
                return calculateHeight(forumModel.content, size: 16, width: WIDTH-48)+20
            default:
                print("-=-=-=-=-=-=-=-=-=-",imageHeigthArray[indexPath.row-2])

                let imgWidth = (WIDTH-10*4)/3.0

                return forumModel.photo.count%3 == 0 ? 10+(imgWidth+10)*CGFloat((forumModel.photo.count/3)):10+(imgWidth+10)*CGFloat((forumModel.photo.count/3)+1)
//                return 10+(imgWidth+10)*CGFloat((forumModel.photo.count/3))
//                return imageHeigthArray[indexPath.row-2]+16
                
            }
        }
        if self.forumCommentArray.count == 0 {
            return 100
        }else{
            
            let height = calculateHeight((self.forumCommentArray[indexPath.row].content), size: 14, width: WIDTH-10-16)
            
            var child_commentBtnY = 5+height+8+40+8+8
            for child_comment in (self.forumCommentArray[indexPath.row].child_comments) {
                
                let child_commentBtnHeight = child_comment.content.boundingRect(
                    with: CGSize(width: WIDTH-60-10-16, height: 0),
                    options: .usesLineFragmentOrigin,
                    attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14)],
                    context: nil).size.height+10
                
                child_commentBtnY += child_commentBtnHeight+25+5
                
            }
            
            return child_commentBtnY+8+7+8+5+1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 50:0.001
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            let contentView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 50))
            contentView.backgroundColor = UIColor.white
            
            let collectBtn = UIButton(frame: CGRect(x: 20, y: 8, width: 30, height: 30))
            collectBtn.tag = 100
            collectBtn.layer.cornerRadius = 15
//            collectBtn.layer.backgroundColor = UIColor(red: 244/255.0, green: 229/255.0, blue: 240/255.0, alpha: 1).CGColor
            collectBtn.setImage(UIImage(named: "收藏（默认）"), for: .normal)
            collectBtn.setImage(UIImage(named: "收藏"), for: .selected)
            collectBtn.addTarget(self, action: #selector(collectBtnClick(_:)), for: .touchUpInside)
            contentView.addSubview(collectBtn)
            
            if forumModel.favorites_add == "1" {
                collectBtn.isSelected = true
            }else {
                collectBtn.isSelected = false
            }
            
            let collectNumLab = UILabel(frame: CGRect(x: collectBtn.frame.maxX+8, y: 0, width: 0, height: 0))
            collectNumLab.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
            collectNumLab.font = UIFont.systemFont(ofSize: 14)
            collectNumLab.text = forumModel.favorites
            collectNumLab.sizeToFit()
            collectNumLab.center.y = collectBtn.center.y
            contentView.addSubview(collectNumLab)
            
            let likeBtn = UIButton(frame: CGRect(x: collectNumLab.frame.maxX+25, y: 8, width: 30, height: 30))
            likeBtn.tag = 101
            likeBtn.layer.cornerRadius = 15
//            likeBtn.layer.backgroundColor = UIColor(red: 244/255.0, green: 229/255.0, blue: 240/255.0, alpha: 1).CGColor
            likeBtn.setImage(UIImage(named: "点赞（默认）"), for: .normal)
            likeBtn.setImage(UIImage(named: "点赞"), for: .selected)
            likeBtn.addTarget(self, action: #selector(likeBtnClick(_:)), for: .touchUpInside)
            contentView.addSubview(likeBtn)
            if forumModel.add_like == "1" {
                likeBtn.isSelected = true
            }else {
                likeBtn.isSelected = false
            }
            
            let likeNumLab = UILabel(frame: CGRect(x: likeBtn.frame.maxX+8, y: 0, width: 0, height: 0))
            likeNumLab.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
            likeNumLab.font = UIFont.systemFont(ofSize: 14)
            likeNumLab.text = forumModel.like_num
            likeNumLab.sizeToFit()
            likeNumLab.center.y = likeBtn.center.y
            contentView.addSubview(likeNumLab)
            
            let rewardBtn = UIButton(frame: CGRect(x: likeNumLab.frame.maxX+25, y: 8, width: 30, height: 30))
            rewardBtn.tag = 102
            rewardBtn.layer.cornerRadius = 15
//            rewardBtn.layer.backgroundColor = UIColor(red: 244/255.0, green: 229/255.0, blue: 240/255.0, alpha: 1).CGColor
            rewardBtn.setImage(UIImage(named: "打赏（默认）"), for: .normal)
            rewardBtn.setImage(UIImage(named: "打赏"), for: .selected)
            rewardBtn.addTarget(self, action: #selector(rewardBtnClick(_:)), for: .touchUpInside)
            contentView.addSubview(rewardBtn)
            
            if forumModel.isreward == "1" {
                rewardBtn.isSelected = true
            }else {
                rewardBtn.isSelected = false
            }
            
            let rewardNumLab = UILabel(frame: CGRect(x: rewardBtn.frame.maxX+8, y: 0, width: 0, height: 0))
            rewardNumLab.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
            rewardNumLab.font = UIFont.systemFont(ofSize: 14)
            rewardNumLab.text = "打赏"
            rewardNumLab.sizeToFit()
            rewardNumLab.center.y = rewardBtn.center.y
            contentView.addSubview(rewardNumLab)
            
            let moreBtn = UIButton(frame: CGRect(x: likeNumLab.frame.maxX+10, y: 8, width: 30, height: 30))
            
            moreBtn.setTitle("···", for: UIControlState())
            moreBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            moreBtn.layer.cornerRadius = 2
            moreBtn.setTitleColor(UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1), for: UIControlState())
            moreBtn.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
            
            let moreBtnWidth = calculateWidth("···", size: 18, height: 10)+10
            moreBtn.frame = CGRect(x: contentView.frame.width-20-moreBtnWidth, y: 0, width: moreBtnWidth, height: 15)
            moreBtn.center.y = rewardNumLab.center.y
            
            moreBtn.addTarget(self, action: #selector(moreBtnClick(_:)), for: .touchUpInside)
            
            contentView.addSubview(moreBtn)
            
            return contentView
        }else{
            return nil
        }

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 15))
        headerView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("点击cell")
        
        if indexPath.section == 1 && self.forumCommentArray.count > 0 {
            
            if requiredLogin(self.navigationController, previousViewController: self, hiddenNavigationBar: false) {
                
            }else{
                return
            }
            
            self.send_bottom_Btn.tag = NSString(string: self.forumCommentArray[indexPath.row].cid).integerValue
            self.send_bottom_Btn.isSelected = true

            replyTextField.placeholder = "回复\(self.forumCommentArray[indexPath.row].username)"
            replyTextField.becomeFirstResponder()
        }
    }
    
//    // MARK: - 举报 按钮点击事件
//    func reportBtnClick(_ reportBtn:UIButton) {
//        print("举报 按钮点击事件",reportBtn.tag)
//        
//        self.showReportAlert(with: self.forumModel.tid)
//    }
    
    // MARK: - moreBtnClick
    func moreBtnClick(_ moreBtn:UIButton) {
        print(moreBtn.tag)
        
        if requiredLogin(self.navigationController, previousViewController: self, hiddenNavigationBar: false) {
            
        }else{
            return
        }
        
        var labelTextArray = [String]()
        var labelTextColorArray = [UIColor]()
        
        if QCLoginUserInfo.currentInfo.isCircleManager == "1" {
            labelTextArray = ["推荐","加精","置顶","删除","取消"]
            labelTextColorArray = [COLOR,COLOR,COLOR,UIColor.black,UIColor.lightGray]
        }else if isMaster {
            labelTextArray = ["加精","置顶","删除","取消"]
            labelTextColorArray = [COLOR,COLOR,UIColor.black,UIColor.lightGray]
        }else if QCLoginUserInfo.currentInfo.userid == forumDataModel.userid {
            labelTextArray = ["删除","取消"]
            labelTextColorArray = [UIColor.black,UIColor.lightGray]
        }else{
            labelTextArray = ["举报","取消"]
            labelTextColorArray = [UIColor.black,UIColor.lightGray]
        }
        
        self.showSheet(with: labelTextArray, buttonTitleColorArray: labelTextColorArray, forumId: self.forumModel.tid)

        
    }
    
    // MARK: - 用户主页按钮点击事件
    func userInfoBtnClick(userInfoBtn:UIButton) {
        
        let circleUserInfoController = NSCircleUserInfoViewController()
        circleUserInfoController.userid = forumCommentArray[userInfoBtn.tag-200].userid
        self.navigationController?.pushViewController(circleUserInfoController, animated: true)
    }
    
    // MARK: - 评论点赞
    func commentLikeBtnClick(_ likeBtn:UIButton) {
        print("2")
        
        if requiredLogin(self.navigationController, previousViewController: self, hiddenNavigationBar: false) {
            
        }else{
            return
        }
        
        if likeBtn.isSelected {
            CircleNetUtil.ResetLike(userid: QCLoginUserInfo.currentInfo.userid, id: self.forumCommentArray[likeBtn.tag-100].cid, type: "3", handle: { (success, response) in
                if success {
                    
                    self.forumCommentArray[likeBtn.tag-100].add_like = "0"
                    self.rootTableView.reloadData()
                }else{
                    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hud.removeFromSuperViewOnHide = true
                    hud.mode = .text
                    hud.label.text = "取消点赞失败"
                    hud.hide(animated: true, afterDelay: 1)
                }
            })
        }else{
            CircleNetUtil.SetLike(userid: QCLoginUserInfo.currentInfo.userid, id: self.forumCommentArray[likeBtn.tag-100].cid, type: "3") { (success, response) in
                if success {
                    
                    let result = response as! SetLikeDataModel
                    
                    if result.event != "" {
                        NursePublicAction.showScoreTips(self.view, nameString: result.event, score: result.score)
                        
                    }
                    
                    self.forumCommentArray[likeBtn.tag-100].add_like = "1"
                    self.rootTableView.reloadData()
                }else{
                    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hud.removeFromSuperViewOnHide = true
                    hud.mode = .text
                    hud.label.text = "点赞失败"
                    hud.hide(animated: true, afterDelay: 1)
                }
            }
        }
    }
    
    // MARK: - 评论删除
    func commentDelBtnClick(_ delBtn:UIButton) {
        
        if requiredLogin(self.navigationController, previousViewController: self, hiddenNavigationBar: false) {
            
        }else{
            return
        }
        
        CircleNetUtil.DelForumComments(id: self.forumCommentArray[delBtn.tag-200].cid, type: "2", userid: QCLoginUserInfo.currentInfo.userid) { (success, response) in
            if success {
                self.forumCommentArray.remove(at: delBtn.tag-200)
                self.rootTableView.reloadData()
            }else{
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.removeFromSuperViewOnHide = true
                hud.mode = .text
                hud.label.text = "删除失败"
                hud.hide(animated: true, afterDelay: 1)
            }
        }
    }
    
    // MARK: - 评论举报
    func commentReportBtnClick(_ reportBtn:UIButton) {

        if requiredLogin(self.navigationController, previousViewController: self, hiddenNavigationBar: false) {
            
        }else{
            return
        }
        
        reportType = "2"
        showReportAlert(with: self.forumCommentArray[reportBtn.tag-300].cid)
     }
    
    // MARK: - 收藏、点赞、打赏 按钮点击事件
    func collectBtnClick(_ collectBtn:UIButton) {
        print("1")
        if requiredLogin(self.navigationController, previousViewController: self, hiddenNavigationBar: false) {
            
        }else{
            return
        }
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.removeFromSuperViewOnHide = true
        
        if self.forumModel.favorites_add == "1" {
            CircleNetUtil.cancelfavorite(userid: QCLoginUserInfo.currentInfo.userid, refid: forumDataModel.id, type: "4", handle: { (success, response) in
                if success {
                    hud.hide(animated: true)
                    
                    self.forumModel.favorites_add = "0"
                    self.forumModel.favorites = String(NSString(string: self.forumModel.favorites).integerValue-1)
                    self.rootTableView.reloadData()
                }else{
                    hud.mode = .text
                    hud.label.text = "取消收藏失败"
                    hud.hide(animated: true, afterDelay: 1)
                }
            })
        }else{
            
            CircleNetUtil.addfavorite(userid: QCLoginUserInfo.currentInfo.userid, refid: forumDataModel.id, type: "4", title: forumModel.title, description: forumModel.content) { (success, response) in
                if success {
                    hud.hide(animated: true)
                    
                    self.forumModel.favorites_add = "1"
                    self.forumModel.favorites = String(NSString(string: self.forumModel.favorites).integerValue+1)
                    self.rootTableView.reloadData()
                }else{
                    hud.mode = .text
                    hud.label.text = "收藏失败"
                    hud.hide(animated: true, afterDelay: 1)
                }
            }
        }
        
    }
    func likeBtnClick(_ likeBtn:UIButton) {
        print("2")
        
        if requiredLogin(self.navigationController, previousViewController: self, hiddenNavigationBar: false) {
            
        }else{
            return
        }
        
        if likeBtn.isSelected {
            CircleNetUtil.ResetLike(userid: QCLoginUserInfo.currentInfo.userid, id: forumModel.tid, type: "2", handle: { (success, response) in
                if success {
                    
                    self.forumModel.like_num = String(NSString(string: self.forumModel.like_num).integerValue-1)
                    self.forumModel.add_like = "0"
                    self.rootTableView.reloadData()
                }else{
                    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hud.removeFromSuperViewOnHide = true
                    hud.mode = .text
                    hud.label.text = "取消点赞失败"
                    hud.hide(animated: true, afterDelay: 1)
                }
            })
        }else{
            CircleNetUtil.SetLike(userid: QCLoginUserInfo.currentInfo.userid, id: forumModel.tid, type: "2") { (success, response) in
                if success {
                    
                    let result = response as! SetLikeDataModel
                    
                    if result.event != "" {
                        NursePublicAction.showScoreTips(self.view, nameString: result.event, score: result.score)
                        
                    }
                    
                    self.forumModel.like_num = String(NSString(string: self.forumModel.like_num).integerValue+1)
                    self.forumModel.add_like = "1"
                    self.rootTableView.reloadData()
                }else{
                    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hud.removeFromSuperViewOnHide = true
                    hud.mode = .text
                    hud.label.text = "点赞失败"
                    hud.hide(animated: true, afterDelay: 1)
                }
            }
        }
    }
    
    func rewardBtnClick(_ rewardBtn:UIButton) {
        print("3")
        
        if requiredLogin(self.navigationController, previousViewController: self, hiddenNavigationBar: false) {
            
        }else{
            return
        }
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.removeFromSuperViewOnHide = true
        
        CircleNetUtil.getNurse_score(userid: QCLoginUserInfo.currentInfo.userid) { (success, response) in
            if success {
                hud.hide(animated: true)
                self.myScore = response as! String
                self.showAlert()
            }else{
                hud.mode = .text
                hud.label.text = "获取护士币失败"
                hud.hide(animated: true, afterDelay: 1)
            }
        }
        
        
    }
    
    // MARK: - 图片按钮点击事件
    func imgBtnClick(imgBtn:UIButton) {
        
        let photoBrowser = SDPhotoBrowser()
        photoBrowser.delegate = self
        photoBrowser.currentImageIndex = imgBtn.tag-100
        photoBrowser.imageCount = forumModel.photo.count
        photoBrowser.sourceImagesContainerView = imgBtn.superview!
        photoBrowser.show()
        
//        SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
//        photoBrowser.delegate = self;
//        photoBrowser.currentImageIndex = indexPath.item;
//        photoBrowser.imageCount = self.modelsArray.count;
//        photoBrowser.sourceImagesContainerView = self.collectionView;
//        
//        [photoBrowser show];
        
//        let circleImagePreviewController = NSCircleForumImagePreviewViewController()
////        circleImagePreviewController.delegate = self
//        circleImagePreviewController.imageArray = forumModel.photo
//        circleImagePreviewController.currentImageIndex = imgBtn.tag-100
//        self.navigationController?.pushViewController(circleImagePreviewController, animated: true)
    }
    
    // MARK: - 数据
    func getReportArray() -> [String] {
        let reportArray = ["诽谤辱骂","淫秽色情","垃圾广告","血腥暴力","欺诈（酒托、话费托等行为）","违法行为（涉毒、暴恐、违禁品等行为）"]
        return reportArray
    }
    func getRewardArray() -> [String] {
        let rewardArray = ["1","2","5","10"]
        return rewardArray
    }
    
    // MARK: - 显示举报弹窗
    func showReportAlert(with forumId:String) {
        
        let buttonFontSize:CGFloat = 14
        let animateWithDuration = 0.3
        
        let bgView = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT))
        bgView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        bgView.addTarget(self, action: #selector(alertCancel(_:)), for: .touchUpInside)
        UIApplication.shared.keyWindow?.addSubview(bgView)
        
        let alert = UIView(frame: CGRect(x: WIDTH*0.06, y: HEIGHT, width: WIDTH*0.88, height: 0))
        alert.backgroundColor = UIColor.white
        alert.layer.cornerRadius = 8
        bgView.addSubview(alert)
        
        let titleLab = UILabel(frame: CGRect(x: 0, y: 20, width: alert.frame.width, height: UIFont.systemFont(ofSize: 18).lineHeight))
        titleLab.font = UIFont.systemFont(ofSize: 18)
        titleLab.textAlignment = .center
        titleLab.textColor = UIColor.black
        titleLab.text = "请告诉我们您举报的理由"
        alert.addSubview(titleLab)
        
        let buttonHeight:CGFloat = 30
        let buttonMargin:CGFloat = 10
        var buttonWidth:CGFloat = (alert.frame.width-116-buttonMargin)/2.0
        var buttonX:CGFloat = 58
        var buttonY = titleLab.frame.maxY+25
        
        for (i,buttonTitle) in getReportArray().enumerated() {
            switch i {
            case 0:
                buttonX = 58
                buttonWidth = 125
                
            case 1:
                buttonX = 58+(buttonWidth+buttonMargin)
                buttonWidth = 125
                
            case 2:
                buttonY = buttonY+buttonHeight+buttonMargin
                buttonX = 58
                buttonWidth = 125
                
            case 3:
                buttonX = 58+(buttonWidth+buttonMargin)
                buttonWidth = 125
                
            case 4:
                buttonY = buttonY+buttonHeight+buttonMargin
                buttonX = 58
                buttonWidth = alert.frame.width-116
                
            case 5:
                buttonY = buttonY+buttonHeight+buttonMargin
                buttonX = 58
                buttonWidth = alert.frame.width-116
                
            default:
                break
            }
            
            let button = UIButton(frame: CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight))
            button.tag = 1000+i
            button.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.layer.cornerRadius = 3
            button.layer.borderColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1).cgColor
            button.layer.borderWidth = 1/UIScreen.main.scale
            
            button.setTitleColor(UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1), for: UIControlState())
            button.setTitleColor(UIColor.white, for: .selected)
            
            button.setTitle(buttonTitle, for: UIControlState())
            
            button.backgroundColor = i == 0 ? COLOR:UIColor.clear
            button.isSelected = i == 0 ? true:false
            
            button.addTarget(self, action: #selector(chooseReportType(_:)), for: .touchUpInside)
            
            alert.addSubview(button)
            
        }
        
        let reportBtn = UIButton(frame: CGRect(x: 35, y: buttonY+buttonHeight+35, width: alert.frame.width-70, height: 40))
        reportBtn.tag = NSString(string: forumId).integerValue
        reportBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        reportBtn.layer.cornerRadius = 6
        reportBtn.setTitle("确认举报", for: UIControlState())
        
        reportBtn.setTitleColor(UIColor.white, for: UIControlState())
        reportBtn.backgroundColor = COLOR
        
        reportBtn.addTarget(self, action: #selector(sureReportBtnClick(_:)), for: .touchUpInside)
        
        alert.addSubview(reportBtn)
        
        alert.frame.size.height = reportBtn.frame.maxY+25
        
        UIView.animate(withDuration: animateWithDuration, animations: {
            
            alert.frame.origin.y = (HEIGHT-alert.frame.size.height)/2.0
        })
    }
    
    // MARK: 选择举报理由
    func chooseReportType(_ typeBtn:UIButton) {
        
        for subView in (typeBtn.superview?.subviews ?? [UIView]())! {
            if subView.tag >= 1000 && subView.tag <= 2000 {
                if subView is UIButton {
                    let button = subView as! UIButton
                    button.isSelected = false
                    button.backgroundColor = UIColor.clear
                    
                }
            }
        }
        
        typeBtn.isSelected = true
        typeBtn.backgroundColor = COLOR
        
        //        reportType = reportArray[typeBtn.tag-1000]
        //        print(reportType)
        print(getReportArray()[typeBtn.tag-1000])
        
    }
    
    // MARK: 确认举报
    var reportType = "1"
    func sureReportBtnClick(_ rewardBtn:UIButton) {
        
        for subView in (rewardBtn.superview?.subviews ?? [UIView]())! {
            if (subView.tag >= 1000 && subView.tag <= 2000) && subView is UIButton {
                let button = subView as! UIButton
                if button.isSelected {
                    
                    print(button.tag,getReportArray()[button.tag-1000])
                    CircleNetUtil.addReport(userid: QCLoginUserInfo.currentInfo.userid, t_id: String(rewardBtn.tag), score: getReportArray()[button.tag-1000], type:reportType, handle: { (success, response) in
                        
                        if success {
                            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                            hud.removeFromSuperViewOnHide = true
                            hud.mode = .text
                            hud.label.text = "举报成功"
                            hud.hide(animated: true, afterDelay: 1)
                        }else{
                            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                            hud.removeFromSuperViewOnHide = true
                            hud.mode = .text
                            hud.label.text = "举报失败"
                            hud.hide(animated: true, afterDelay: 1)
                        }
                        self.alertCancel(rewardBtn)
                    })
                }
            }
        }
    }
    
    // MARK: - 显示打赏弹窗
    func showAlert() {
        
        let buttonFontSize:CGFloat = 24
        let animateWithDuration = 0.3
        
        let bgView = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT))
        bgView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        bgView.addTarget(self, action: #selector(alertCancel(_:)), for: .touchUpInside)
        UIApplication.shared.keyWindow?.addSubview(bgView)
        
        let alert = UIView(frame: CGRect(x: WIDTH*0.06, y: HEIGHT, width: WIDTH*0.88, height: 0))
        alert.backgroundColor = UIColor.white
        alert.layer.cornerRadius = 8
        bgView.addSubview(alert)
        
        let titleLab = UILabel(frame: CGRect(x: 0, y: 20, width: alert.frame.width, height: UIFont.systemFont(ofSize: 18).lineHeight))
        titleLab.font = UIFont.systemFont(ofSize: 18)
        titleLab.textAlignment = .center
        titleLab.textColor = UIColor.black
        titleLab.text = "好的文章，就是要打赏"
        alert.addSubview(titleLab)
        
        let noteLab = UILabel(frame: CGRect(x: 0, y: titleLab.frame.maxY+8, width: alert.frame.width, height: UIFont.systemFont(ofSize: 12).lineHeight))
        noteLab.font = UIFont.systemFont(ofSize: 12)
        noteLab.textAlignment = .center
        noteLab.textColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1)

        let descripStr = "可用护士币：\(myScore)"
        let attrStr = NSMutableAttributedString(string: descripStr)
        attrStr.addAttributes([NSForegroundColorAttributeName:COLOR], range: NSMakeRange(6, myScore.characters.count))
        noteLab.attributedText = attrStr

        alert.addSubview(noteLab)
        
        let buttonWidth:CGFloat = 50
        let buttonMargin = (alert.frame.width-70-buttonWidth*4)/3.0
        
        for (i,buttonTitle) in getRewardArray().enumerated() {
            
            let button = UIButton(frame: CGRect(x: 35+(buttonWidth+buttonMargin)*CGFloat(i), y: noteLab.frame.maxY+25, width: buttonWidth, height: buttonWidth))
            button.tag = 1000+i
            button.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize)
            button.layer.cornerRadius = buttonWidth/2.0
            button.setTitle(buttonTitle, for: UIControlState())
            
            button.setTitleColor(UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1), for: UIControlState())
            button.setTitleColor(UIColor.white, for: .selected)
            
            button.backgroundColor = i == 0 ? COLOR:UIColor(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1)
            button.isSelected = i == 0 ? true:false
            
            button.addTarget(self, action: #selector(chooseRewardCount(_:)), for: .touchUpInside)
            
            alert.addSubview(button)
            
        }
        
        let rewardBtn = UIButton(frame: CGRect(x: 35, y: noteLab.frame.maxY+25+buttonWidth+25, width: alert.frame.width-70, height: 40))
        rewardBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        rewardBtn.layer.cornerRadius = 6
        rewardBtn.setTitle("打赏", for: UIControlState())

        rewardBtn.setTitleColor(UIColor.white, for: UIControlState())
        rewardBtn.backgroundColor = COLOR
        
        rewardBtn.addTarget(self, action: #selector(sureRewardBtnClick(_:)), for: .touchUpInside)
        
        alert.addSubview(rewardBtn)
        
        alert.frame.size.height = rewardBtn.frame.maxY+25
        
        UIView.animate(withDuration: animateWithDuration, animations: {
            
            alert.frame.origin.y = (HEIGHT-alert.frame.size.height)/2.0
        })
    }
    
    // MARK: 选择打赏护士币数量
    func chooseRewardCount(_ countBtn:UIButton) {
        
        for subView in (countBtn.superview?.subviews ?? [UIView]())! {
            if subView.tag >= 1000 && subView.tag <= 2000 {
                if subView is UIButton {
                    let button = subView as! UIButton
                    button.isSelected = false
                    button.backgroundColor = UIColor(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1)
                    
                }
            }
        }
        
        countBtn.isSelected = true
        countBtn.backgroundColor = COLOR
        
        //        rewardCount = rewardArray[countBtn.tag-1000]
        //        print(rewardCount)
        print(countBtn.tag-1000)
        print(getRewardArray()[countBtn.tag-1000])
    }
    
    // MARK: 确认打赏
    func sureRewardBtnClick(_ rewardBtn:UIButton) {
        
        for subView in (rewardBtn.superview?.subviews ?? [UIView]())! {
            if (subView.tag >= 1000 && subView.tag <= 2000) && subView is UIButton {
                let button = subView as! UIButton
                if button.isSelected {
                    
                    CircleNetUtil.addReward(to_userid: forumModel.userid, from_userid: QCLoginUserInfo.currentInfo.userid, t_id: forumModel.tid, score: getRewardArray()[button.tag-1000], handle: { (success, response) in
                        if success {
                            self.forumModel.isreward = "1"
                            self.rootTableView.reloadData()
                            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                            hud.removeFromSuperViewOnHide = true
                            hud.mode = .text
                            hud.label.text = "打赏成功"
                            hud.hide(animated: true, afterDelay: 1)
                        }else{
                            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                            hud.removeFromSuperViewOnHide = true
                            hud.mode = .text
                            hud.label.text = "打赏失败"
                            hud.hide(animated: true, afterDelay: 1)
                        }
                    })
                    print(button.tag,getRewardArray()[button.tag-1000])
                    alertCancel(rewardBtn)
                    
                }
            }
        }
    }
    
    // MARK: - 显示加精置顶等弹出 sheet
    func showSheet(with buttonTitleArray:[String], buttonTitleColorArray:[UIColor], forumId:String) {
        
        let buttonFontSize:CGFloat = 15
        let buttonTitleDefaultColor = UIColor.black
        let animateWithDuration = 0.3
        
        let bgView = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT))
        bgView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        bgView.addTarget(self, action: #selector(alertCancel(_:)), for: .touchUpInside)
        UIApplication.shared.keyWindow?.addSubview(bgView)
        
        let alert = UIView(frame: CGRect(x: 0, y: HEIGHT, width: WIDTH, height: 0))
        alert.backgroundColor = UIColor.white
        bgView.addSubview(alert)
        
        for (i,buttonTitle) in buttonTitleArray.enumerated() {
            let button = UIButton(frame: CGRect(x: 0, y: 44*CGFloat(i), width: WIDTH, height: 44))
            
            button.tag = NSString(string: forumId).integerValue*100+i
            button.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize)
            button.setTitle(buttonTitle, for: UIControlState())
            
            button.setTitleColor((i<buttonTitleColorArray.count ? buttonTitleColorArray[i]:buttonTitleDefaultColor), for: UIControlState())
            if i == buttonTitleArray.count-1 {
                button.addTarget(self, action: #selector(alertCancel(_:)), for: .touchUpInside)
            }else{
                button.addTarget(self, action: #selector(alertActionClick(_:)), for: .touchUpInside)
            }
            alert.addSubview(button)
            
            let line = UIView(frame: CGRect(x: 0, y: button.frame.height-1/UIScreen.main.scale, width: button.frame.width, height: 1/UIScreen.main.scale))
            line.backgroundColor = UIColor.lightGray
            button.addSubview(line)
        }
        
        UIView.animate(withDuration: animateWithDuration, animations: {
            
            alert.frame = CGRect(x: 0, y: HEIGHT-44*CGFloat(buttonTitleArray.count), width: WIDTH, height: 44*CGFloat(buttonTitleArray.count))
        })
    }
    
    // MARK: 弹出 sheet 点击选项
    func alertActionClick(_ action:UIButton) {
        print(action.tag)
        
        if action.currentTitle == "推荐" {
            alertCancel(action)
            if forumModel.recommend == "1" {
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.removeFromSuperViewOnHide = true
                hud.mode = .text
                hud.label.text = "贴子已推荐"
                hud.hide(animated: true, afterDelay: 1)
                return
            }
            CircleNetUtil.forumSetRecommend(tid: String(action.tag/100), handle: { (success, response) in
                if success {
                    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hud.removeFromSuperViewOnHide = true
                    hud.mode = .text
                    hud.label.text = "推荐贴子成功"
                    hud.hide(animated: true, afterDelay: 1)
                    print("推荐贴子成功")
                }else{
                    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hud.removeFromSuperViewOnHide = true
                    hud.mode = .text
                    hud.label.text = "推荐贴子失败"
                    hud.hide(animated: true, afterDelay: 1)
                    print("推荐贴子失败")
                }
            })
        }else if action.currentTitle == "置顶" {
            alertCancel(action)
            if forumModel.istop == "1" {
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.removeFromSuperViewOnHide = true
                hud.mode = .text
                hud.label.text = "贴子已置顶"
                hud.hide(animated: true, afterDelay: 1)
                return
            }
            CircleNetUtil.forumSetTop(tid: String(action.tag/100), handle: { (success, response) in
                if success {
                    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hud.removeFromSuperViewOnHide = true
                    hud.mode = .text
                    hud.label.text = "置顶贴子成功"
                    hud.hide(animated: true, afterDelay: 1)
                    print("置顶贴子成功")
                }else{
                    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hud.removeFromSuperViewOnHide = true
                    hud.mode = .text
                    hud.label.text = "置顶贴子失败"
                    hud.hide(animated: true, afterDelay: 1)
                    print("置顶贴子失败")
                }
            })
        }else if action.currentTitle == "加精" {
            alertCancel(action)
            if forumModel.isbest == "1" {
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.removeFromSuperViewOnHide = true
                hud.mode = .text
                hud.label.text = "贴子已加精"
                hud.hide(animated: true, afterDelay: 1)
                return
            }
            CircleNetUtil.forumSetTop(tid: String(action.tag/100), handle: { (success, response) in
                if success {
                    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hud.removeFromSuperViewOnHide = true
                    hud.mode = .text
                    hud.label.text = "加精贴子成功"
                    hud.hide(animated: true, afterDelay: 1)
                    print("加精贴子成功")
                }else{
                    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hud.removeFromSuperViewOnHide = true
                    hud.mode = .text
                    hud.label.text = "加精贴子失败"
                    hud.hide(animated: true, afterDelay: 1)
                    print("加精贴子失败")
                }
            })
        }else if action.currentTitle == "举报" {
            alertCancel(action)
            self.reportType = "1"
            self.showReportAlert(with: String(action.tag/100))
        }else if action.currentTitle == "删除" {
            alertCancel(action)
            self.showSheet(with: ["删除贴子","取消"], buttonTitleColorArray: [UIColor.black,UIColor.lightGray], forumId: String(action.tag/100))
        }else if action.currentTitle == "删除贴子" {
            alertCancel(action)
            print("删除贴子")
            CircleNetUtil.DeleteForum(tid: String(action.tag/100), handle: { (success, response) in
                if success {
                    print("删除贴子成功")
                    _ = self.navigationController?.popViewController(animated: true)
                }else{
                    print("删除贴子失败")
                }
            })
        }
    }
    
    func alertCancel(_ action:UIView) {
        if action.superview == UIApplication.shared.keyWindow {
            action.removeFromSuperview()
        }else{
            alertCancel(action.superview!)
        }
    }
    
    func photoBrowser(_ browser: SDPhotoBrowser!, highQualityImageURLFor index: Int) -> URL! {
        return URL(string: SHOW_IMAGE_HEADER+forumModel.photo[index])
    }
    func photoBrowser(_ browser: SDPhotoBrowser!, placeholderImageFor index: Int) -> UIImage! {
        
//        UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:strUrl]
        let cachedImage = SDImageCache.shared().imageFromDiskCache(forKey: SHOW_IMAGE_HEADER+forumModel.photo[index])
        
        if cachedImage == nil {
            return UIImage()
        }
        return cachedImage
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
