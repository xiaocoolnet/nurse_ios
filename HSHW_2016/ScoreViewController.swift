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
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "个人积分"
        self.view.backgroundColor = COLOR
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "score"), style: .Done, target: self, action: #selector(rankBtnClick))
                
//        scoreArray = [["name":"积分名称","score":"+2589","time":"2016-07-06"],["name":"积分名称","score":"+2589","time":"2016-07-06"],["name":"积分名称","score":"+2589","time":"2016-07-06"],["name":"积分名称","score":"+2589","time":"2016-07-06"],["name":"积分名称","score":"+2589","time":"2016-07-06"],["name":"积分名称","score":"+2589","time":"2016-07-06"],["name":"积分名称","score":"+2589","time":"2016-07-06"],["name":"积分名称","score":"+2589","time":"2016-07-06"],["name":"积分名称","score":"+2589","time":"2016-07-06"],["name":"积分名称","score":"+2589","time":"2016-07-06"]]
        
        let cupImage = UIImageView(frame: CGRectMake(0, 0, WIDTH, WIDTH*476/750))
        cupImage.image = UIImage(named: "cup")
        self.view.addSubview(cupImage)
        
        myTableView.frame = CGRectMake(20/750.0*WIDTH, 188/1380.0*HEIGHT, 71/75.0*WIDTH, 778/1380.0*HEIGHT)
        myTableView.registerClass(ScoreTableViewCell.self, forCellReuseIdentifier: "scoreCell")
        myTableView.rowHeight = 110/1380.0*HEIGHT
        myTableView.backgroundColor = UIColor.whiteColor()
        myTableView.layer.cornerRadius = 3
        myTableView.dataSource = self
        self.view.addSubview(myTableView)
        
        loadData()
        
        let noteLab = UILabel(frame: CGRectMake(20/750.0*WIDTH, CGRectGetMaxY(myTableView.frame), 71/75.0*WIDTH, 158/1380.0*HEIGHT))
        noteLab.numberOfLines = 0
        noteLab.font = UIFont.systemFontOfSize(12)
        noteLab.textColor = UIColor.whiteColor()
        noteLab.text = "  排行榜是一个对进行综合评比和展示的栏目。以日为单位，主要依据会员买卖通指数、登录次数、受关注程度、信息丰富程度等来进行评比。"
        noteLab.layer.cornerRadius = 3
        self.view.addSubview(noteLab)
        
        let shareBtn = UIButton(frame: CGRectMake(20/750.0*WIDTH, CGRectGetMaxY(noteLab.frame), 71/75.0*WIDTH, 84/1380.0*HEIGHT))
        shareBtn.backgroundColor = UIColor(red: 254/255.0, green: 232/255.0, blue: 90/255.0, alpha: 1)
        shareBtn.setTitle("邀请朋友赚积分", forState: .Normal)
        shareBtn.setTitleColor(UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1), forState: .Normal)
        shareBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        shareBtn.layer.cornerRadius = 3
        shareBtn.addTarget(self, action: #selector(shareBtnClick_old), forControlEvents: .TouchUpInside)
        self.view.addSubview(shareBtn)
        
        print(myTableView.frame,noteLab.frame,shareBtn.frame)
    }
    
    // MARK:- 获取数据
    func loadData() {
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.margin = 10.0
        hud.removeFromSuperViewOnHide = true
        
        HSMineHelper().getRanking_User { (success, response) in
            if success {
                hud.hide(true)
                self.scoreArray = response as! Array<Ranking_UserModel>
                self.myTableView.reloadData()
            }else{
//                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                hud.mode = MBProgressHUDMode.Text
                hud.labelText = response as! String
//                hud.margin = 10.0
//                hud.removeFromSuperViewOnHide = true
                hud.hide(true, afterDelay: 1)
            }
        }
    }
    
    // MARK:- TableView datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("scoreCell", forIndexPath: indexPath) as! ScoreTableViewCell
        cell.selectionStyle = .None
        
        cell.nameLab.text = scoreArray[indexPath.row].event
        cell.scoreLab.text = scoreArray[indexPath.row].score
        cell.timeLab.text = scoreArray[indexPath.row].create_time
        
        return cell
    }
    
    //  MARK:- 邀请朋友赚积分
    func shareBtnClick_old() {
        print("点击 邀请朋友赚积分 按钮")
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = MBProgressHUDMode.Text
        hud.labelText = "敬请期待"
        hud.margin = 10.0
        hud.removeFromSuperViewOnHide = true
        hud.hide(true, afterDelay: 1)

//        let downLoadVC = DownLoadViewController()
//        self.navigationController?.pushViewController(downLoadVC, animated: true)
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
            print(shareBtn_1.frame)
            
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
        
        UIView.animateWithDuration(0.3) {
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
        self.shareToAddScore(btn)
    }
    
    // MARK:-
    
    func shareToAddScore(btn:UIButton) {
        
        if btn.tag == 0 || btn.tag == 1 {
            
            let message = WXMediaMessage()
            message.title = "中国护士网"
            message.description = "服务于中国320万护士 白衣天使的网上家园"
            
            let thumbImage = UIImage(named: "appLogo")
            message.setThumbImage(thumbImage)
            
            let webPageObject = WXWebpageObject()
            webPageObject.webpageUrl = NewsInfo_Header
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
            
            //        req.scene = Int32(WXSceneTimeline.rawValue)
            
            WXApi.sendReq(req)
        }else if btn.tag == 2 {
            //            let myDelegate = UIApplication.sharedApplication().delegate
            let authRequest:WBAuthorizeRequest = WBAuthorizeRequest.request() as! WBAuthorizeRequest
            authRequest.redirectURI = kRedirectURI
            authRequest.scope = "all"
            
            let message = WBMessageObject.message() as! WBMessageObject
            message.text = "中国护士网\n服务于中国320万护士 白衣天使的网上家园"
            let webpage:WBWebpageObject = WBWebpageObject.object() as! WBWebpageObject
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            let dateStr = dateFormatter.stringFromDate(NSDate())
            webpage.objectID = "chinanurse\(kAppKey)\(dateStr)"
            webpage.title = "中国护士网"
            webpage.description = "服务于中国320万护士 白衣天使的网上家园"
            
            let thumbImage = UIImage(named: "appLogo")
            let data = UIImageJPEGRepresentation(thumbImage!, 0.5)!
            webpage.thumbnailData = data
            
            webpage.webpageUrl = NewsInfo_Header
            message.mediaObject = webpage
            print(message.mediaObject.debugDescription)
            
            let request = WBSendMessageToWeiboRequest.requestWithMessage(message, authInfo: authRequest, access_token: AppDelegate().wbtoken) as! WBSendMessageToWeiboRequest
            request.userInfo = ["ShareMessageFrom":"NewsContantViewController"]
            
            WeiboSDK.sendRequest(request)
        }else{
            
            let newsUrl = NSURL(string: NewsInfo_Header)
            let title = "中国护士网"
            let description = "服务于中国320万护士 白衣天使的网上家园"
            
            var previewImageData = NSData()
            
            let thumbImage = UIImage(named: "appLogo")
            previewImageData = thumbImage!.compressImage(thumbImage!, maxLength: 32700)!
            
            let newsObj = QQApiNewsObject(URL: newsUrl, title: title, description: description, previewImageData: previewImageData, targetContentType: QQApiURLTargetTypeNews)
            let req = SendMessageToQQReq(content: newsObj)
            
            if btn.tag == 3 {
                QQApiInterface.sendReq(req)
            }else if btn.tag == 4 {
                QQApiInterface.SendReqToQZone(req)
            }
        }
        
        print(btn.tag)
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
