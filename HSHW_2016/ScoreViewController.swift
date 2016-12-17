//
//  ScoreViewController.swift
//  HSHW_2016
//
//  Created by zhang on 16/8/21.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class ScoreViewController: UIViewController,UITableViewDataSource {

    var scoreArray = Array<Ranking_UserModel>()
    let myTableView = UITableView()
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "个人积分"
        self.view.backgroundColor = COLOR
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "score"), style: .done, target: self, action: #selector(rankBtnClick))
                
//        scoreArray = [["name":"积分名称","score":"+2589","time":"2016-07-06"],["name":"积分名称","score":"+2589","time":"2016-07-06"],["name":"积分名称","score":"+2589","time":"2016-07-06"],["name":"积分名称","score":"+2589","time":"2016-07-06"],["name":"积分名称","score":"+2589","time":"2016-07-06"],["name":"积分名称","score":"+2589","time":"2016-07-06"],["name":"积分名称","score":"+2589","time":"2016-07-06"],["name":"积分名称","score":"+2589","time":"2016-07-06"],["name":"积分名称","score":"+2589","time":"2016-07-06"],["name":"积分名称","score":"+2589","time":"2016-07-06"]]
        
        let cupImage = UIImageView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: WIDTH*476/750))
        cupImage.image = UIImage(named: "cup")
        self.view.addSubview(cupImage)
        
        myTableView.frame = CGRect(x: 20/750.0*WIDTH, y: 188/1380.0*HEIGHT, width: 71/75.0*WIDTH, height: 778/1380.0*HEIGHT)
        myTableView.register(ScoreTableViewCell.self, forCellReuseIdentifier: "scoreCell")
        myTableView.rowHeight = 110/1380.0*HEIGHT
        myTableView.backgroundColor = UIColor.white
        myTableView.layer.cornerRadius = 3
        myTableView.dataSource = self
        self.view.addSubview(myTableView)
        
        loadData()
        
        let noteLab = UIButton(frame: CGRect(x: 20/750.0*WIDTH, y: myTableView.frame.maxY, width: 71/75.0*WIDTH, height: 158/1380.0*HEIGHT))
        noteLab.titleLabel?.numberOfLines = 0
        noteLab.titleLabel!.font = UIFont.systemFont(ofSize: 12)
        noteLab.titleLabel?.textColor = UIColor.white
        
        let descripStr = "  成为中国护士网会员，会享受100余项积分功能和政策。我们会有积分兑换商城，定期会有积分活动，让您真正享受到您的每一份支持都将获得我们的真情回报。点击查看>>"
        let attrStr = NSMutableAttributedString(string: descripStr)
        attrStr.addAttributes([NSUnderlineStyleAttributeName:NSNumber(value: NSUnderlineStyle.styleSingle.rawValue as Int)], range: NSMakeRange(attrStr.length-6, 6))
        noteLab.setAttributedTitle(attrStr, for: UIControlState())
        
        noteLab.addTarget(self, action: #selector(noteLabClick), for: .touchUpInside)
        
        self.view.addSubview(noteLab)
        
        let shareBtn = UIButton(frame: CGRect(x: 20/750.0*WIDTH, y: noteLab.frame.maxY, width: 71/75.0*WIDTH, height: 84/1380.0*HEIGHT))
        shareBtn.backgroundColor = UIColor(red: 254/255.0, green: 232/255.0, blue: 90/255.0, alpha: 1)
        shareBtn.setTitle("邀请朋友赚积分", for: UIControlState())
        shareBtn.setTitleColor(UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1), for: UIControlState())
        shareBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        shareBtn.layer.cornerRadius = 3
        shareBtn.addTarget(self, action: #selector(shareBtnClick_old), for: .touchUpInside)
        self.view.addSubview(shareBtn)
        
//        print(myTableView.frame,noteLab.frame,shareBtn.frame)
    }
    
    func noteLabClick() {
        
        let scoreNoteController = ScoreNoteViewController()
        scoreNoteController.urlStr = "\(DomainName)index.php?g=portal&m=article&a=index&id=406&type=2"
        self.navigationController?.pushViewController(scoreNoteController, animated: true)
//        UIApplication.sharedApplication().openURL(NSURL.init(string: "http://app.chinanurse.cn/index.php?g=portal&m=article&a=index&id=406&type=2")!)
    }
    
    // MARK:- 获取数据
    func loadData() {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.margin = 10.0
        hud?.removeFromSuperViewOnHide = true
        
        HSMineHelper().getRanking_User { (success, response) in
            if success {
                hud?.hide(true)
                self.scoreArray = response as! Array<Ranking_UserModel>
                self.myTableView.reloadData()
            }else{
//                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                hud.mode = MBProgressHUDMode.Text
//                hud.labelText = response as! String
//                hud.margin = 10.0
//                hud.removeFromSuperViewOnHide = true
                hud?.hide(true)
                
                let alert = UIAlertController(title: nil, message: "获取个人积分详情失败", preferredStyle: .alert)
                self.present(alert, animated: true, completion: { 
                    
                })
                
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                    
                })
                alert.addAction(cancelAction)
                
                let replyAction = UIAlertAction(title: "重试", style: .default, handler: { (action) in
                    self.loadData()
                })
                alert.addAction(replyAction)
            }
        }
    }
    
    // MARK:- TableView datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCell", for: indexPath) as! ScoreTableViewCell
        cell.selectionStyle = .none
        
        cell.nameLab.text = scoreArray[indexPath.row].event
        let scoreStr = scoreArray[indexPath.row].score
        
        cell.scoreLab.text = scoreStr.contains("-") ? scoreStr:"+"+scoreStr
        cell.timeLab.text = scoreArray[indexPath.row].create_time
        
        return cell
    }
    
    //  MARK:- 邀请朋友赚积分
    func shareBtnClick_old() {
        print("点击 邀请朋友赚积分 按钮")
        
//        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//        hud.mode = MBProgressHUDMode.Text
//        hud.labelText = "敬请期待"
//        hud.margin = 10.0
//        hud.removeFromSuperViewOnHide = true
//        hud.hide(true, afterDelay: 1)
        
        if QCLoginUserInfo.currentInfo.all_information == "1" {
            collectionNews()
        }else{
            let alert = UIAlertController(title: nil, message: "请完善个人资料后重试", preferredStyle: .alert)
            self.present(alert, animated: true, completion: {
                
            })
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                
            })
            alert.addAction(cancelAction)
            
            let replyAction = UIAlertAction(title: "现在就去", style: .default, handler: { (action) in
                self.navigationController?.pushViewController(SetDataViewController(), animated: true)
            })
            alert.addAction(replyAction)
        }

//        let downLoadVC = DownLoadViewController()
//        self.navigationController?.pushViewController(downLoadVC, animated: true)
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
//            print(shareBtn_1.frame)
            
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
        
        UIView.animate(withDuration: 0.3, animations: {
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
        self.shareToAddScore(btn)
    }
    
    // MARK:-
    
    func shareToAddScore(_ btn:UIButton) {
        
        if btn.tag == 0 || btn.tag == 1 {
            
            
            switch btn.tag {
            case 0:
                let message = WXMediaMessage()
                message.title = APP_INVITEFRIEND_TITLE_ZONE
                message.description = APP_INVITEFRIEND_DESCRIPTION_ZONE
                
                let thumbImage = UIImage(named: "appLogo")
                message.setThumbImage(thumbImage)
                
                let webPageObject = WXWebpageObject()
                webPageObject.webpageUrl = APP_INVITEFRIEND_URL+QCLoginUserInfo.currentInfo.userid
                message.mediaObject = webPageObject
                
                let req = SendMessageToWXReq()
                req.bText = false
                req.message = message
                req.scene = Int32(WXSceneTimeline.rawValue)
                WXApi.send(req)
                
            case 1:
                let message = WXMediaMessage()
                message.title = APP_INVITEFRIEND_TITLE_FREND
                message.description = APP_INVITEFRIEND_DESCRIPTION_FREND
                
                let thumbImage = UIImage(named: "appLogo")
                message.setThumbImage(thumbImage)
                
                let webPageObject = WXWebpageObject()
                webPageObject.webpageUrl = APP_INVITEFRIEND_URL+QCLoginUserInfo.currentInfo.userid
                message.mediaObject = webPageObject
                
                let req = SendMessageToWXReq()
                req.bText = false
                req.message = message
                req.scene = Int32(WXSceneSession.rawValue)
                WXApi.send(req)
                
            default:
                break
            }
            
            //        req.scene = Int32(WXSceneTimeline.rawValue)
            
        }else if btn.tag == 2 {
            //            let myDelegate = UIApplication.sharedApplication().delegate
            let authRequest:WBAuthorizeRequest = WBAuthorizeRequest.request() as! WBAuthorizeRequest
            authRequest.redirectURI = kRedirectURI
            authRequest.scope = "all"
            
            let message = WBMessageObject.message() as! WBMessageObject
            if WeiboSDK.isCanShareInWeiboAPP() {
                message.text = "\(APP_INVITEFRIEND_TITLE_ZONE)\n\(APP_INVITEFRIEND_DESCRIPTION_ZONE)"
            }else{
                message.text = "\(APP_INVITEFRIEND_TITLE_ZONE)\n\(APP_INVITEFRIEND_DESCRIPTION_ZONE) \(myInviteFriendUrl)"
            }
            let webpage:WBWebpageObject = WBWebpageObject.object() as! WBWebpageObject
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            let dateStr = dateFormatter.string(from: Date())
            webpage.objectID = "chinanurse\(kAppKey)\(dateStr)"
            webpage.title = APP_INVITEFRIEND_TITLE_ZONE
            webpage.description = APP_INVITEFRIEND_DESCRIPTION_ZONE
            
            let thumbImage = UIImage(named: "appLogo")
            let data = UIImageJPEGRepresentation(thumbImage!, 0.5)!
            webpage.thumbnailData = data
            
            webpage.webpageUrl = myInviteFriendUrl
            message.mediaObject = webpage
            //            print(message.mediaObject.debugDescription)
            
            let request = WBSendMessageToWeiboRequest.request(withMessage: message, authInfo: authRequest, access_token: AppDelegate().wbtoken) as! WBSendMessageToWeiboRequest
            request.userInfo = ["ShareMessageFrom":"NewsContantViewController"]
            
            WeiboSDK.send(request)
        }else{
            
            
            if btn.tag == 3 {
                let newsUrl = URL(string: myInviteFriendUrl)
                let title = APP_INVITEFRIEND_TITLE_FREND
                let description = APP_INVITEFRIEND_DESCRIPTION_FREND
                
                var previewImageData = Data()
                
                let thumbImage = UIImage(named: "appLogo")
                previewImageData = thumbImage!.compressImage(thumbImage!, maxLength: 32700)!
                
                let newsObj = QQApiNewsObject(url: newsUrl, title: title, description: description, previewImageData: previewImageData, targetContentType: QQApiURLTargetTypeNews)
                let req = SendMessageToQQReq(content: newsObj)
                QQApiInterface.send(req)
            }else if btn.tag == 4 {
                let newsUrl = URL(string: myInviteFriendUrl)
                let title = APP_INVITEFRIEND_TITLE_ZONE
                let description = APP_INVITEFRIEND_DESCRIPTION_ZONE
                
                var previewImageData = Data()
                
                let thumbImage = UIImage(named: "appLogo")
                previewImageData = thumbImage!.compressImage(thumbImage!, maxLength: 32700)!
                
                let newsObj = QQApiNewsObject(url: newsUrl, title: title, description: description, previewImageData: previewImageData, targetContentType: QQApiURLTargetTypeNews)
                let req = SendMessageToQQReq(content: newsObj)
                QQApiInterface.sendReq(toQZone: req)
            }
        }
        
        //        print(btn.tag)
    }
    
    // MARK:- 点击排行榜按钮
    func rankBtnClick() {
        let rankVC = RankViewController()
        self.navigationController?.pushViewController(rankVC, animated: true)
        
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
