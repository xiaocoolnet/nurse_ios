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

protocol changeModelDelegate {
    func changeModel(newInfo:NewsInfo, andIndex:Int)
}

class NewsContantViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,cateBtnClickedDelegate{

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
            self.getDate()
        }
    }
    var navTitle:String = "新闻内容" {
        didSet {
//            self.title = navTitle
        }
    }
    var index = 0
    var delegate:changeModelDelegate?
    
    var likeNum  = 0
    var webHeight:CGFloat = 100
//    var isLike:Bool = false
//    var isCollect:Bool = false
    var dataSource = NewsList()
    var helper = NewsPageHelper()
    let zan = UIButton(frame: CGRectMake(WIDTH*148/375, WIDTH*80/375, WIDTH*80/375, WIDTH*80/375))
    var finishLoad = false
    var tagNum = 0
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
        self.navigationItem.leftBarButtonItem?.title = "返回"
        
        
        if LOGIN_STATE {
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            //        MBProgressHUD().labelText = ""
            
            // MARK: 检查是否收藏
            checkHadFavorite((self.newsInfo?.object_id)!, type: "1", handle: { (success, response) in
                if success {
                    self.collectBtn.selected = true
                }else{
                    self.collectBtn.selected = false
                }
                checkHadLike((self.newsInfo?.object_id)!, type: "1", handle: { (success, response) in
                    if success {
                        self.zan.selected = true
                    }else{
                        self.zan.selected = false
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        self.collectBtn.enabled = true
                        hud.hide(true)
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
        
        //收藏按钮
        collectBtn = UIButton(frame:CGRectMake(0, 0, 18, 18))
        collectBtn.setImage(UIImage(named: "btn_collect_sel"), forState: .Normal)
        collectBtn.setImage(UIImage(named: "ic_shoucang"), forState: .Highlighted)
        collectBtn.setImage(UIImage(named: "ic_shoucang"), forState: .Selected)
        collectBtn.addTarget(self, action: #selector(collection(_:)), forControlEvents: .TouchUpInside)
        collectBtn.enabled = false
        let barButton1 = UIBarButtonItem(customView: collectBtn)
        
       
        
        //分享按钮
        let shareBtn = UIButton(frame:CGRectMake(0, 0, 18, 18))
        shareBtn.setImage(UIImage(named: "ic_fenxiang"), forState: .Normal)
        shareBtn.addTarget(self, action: #selector(collectionNews), forControlEvents: .TouchUpInside)
        let barButton2 = UIBarButtonItem(customView: shareBtn)
        
        //按钮间的空隙
        let gap = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil,action: nil)
        gap.width = 15;
        //设置按钮（注意顺序）
        self.navigationItem.rightBarButtonItems = [barButton2,gap,barButton1]
    
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        self.view.backgroundColor = UIColor.whiteColor()
        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-64-1)
        myTableView.backgroundColor = UIColor.clearColor()
        myTableView.delegate = self
        myTableView.dataSource = self
        
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellIntenfer")
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "titleCell")
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "zanCell")
        myTableView.registerNib(UINib.init(nibName: "NewsSourceCell", bundle: nil), forCellReuseIdentifier: "sourceCell")
        myTableView.registerNib(UINib.init(nibName: "contentCell", bundle: nil), forCellReuseIdentifier: "webView")
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "textCell")
        myTableView.registerClass(GToutiaoTableViewCell.self, forCellReuseIdentifier: "toutiao")
        self.view.addSubview(myTableView)
//        myTableView.separatorColor = UIColor.clearColor()
        myTableView.separatorStyle = .None
        

    }
    
    // MARK:点击收藏按钮
    func collection(collectBtn:UIButton){
        
        // MARK:要求登录
        if !requiredLogin(self.navigationController!, hasBackItem: true) {
            return
        }
        collectHud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
        collectHud.margin = 10.0
        collectHud.removeFromSuperViewOnHide = true
        collectBtn.enabled = false
        
        if collectBtn.selected {
            let url = PARK_URL_Header+"cancelfavorite"
            let param = [
                "refid":newsInfo?.object_id,
                "type":"1",
                "userid":QCLoginUserInfo.currentInfo.userid
            ];
            Alamofire.request(.GET, url, parameters: param as? [String:String]).response { request, response, json, error in
                print(request)
                
                dispatch_async(dispatch_get_main_queue(), {
                
                    if(error != nil){
                        
                    }else{
                        let status = Http(JSONDecoder(json!))
                        print("状态是")
                        print(status.status)
                        if(status.status == "error"){
    //                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                            self.collectHud.mode = MBProgressHUDMode.Text;
                            self.collectHud.labelText = status.errorData
//                            hud.margin = 10.0
//                            hud.removeFromSuperViewOnHide = true
//                            hud.hide(true, afterDelay: 1)
                        }
                        if(status.status == "success"){
                            
                            collectBtn.selected = false
                            
    //                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                            self.collectHud.mode = MBProgressHUDMode.Text;
                            self.collectHud.labelText = "取消收藏成功"
//                            hud.margin = 10.0
//                            hud.removeFromSuperViewOnHide = true
//                            hud.hide(true, afterDelay: 1)
                            //self.myTableView .reloadData()
                            print(status.data)
    //                        self.isCollect=false
                        }
                    }
                    self.collectHud.hide(true, afterDelay: 1)
                    collectBtn.enabled = true
                })
            }
        }else{
            var str = NSString()
            if tagNum == 1 {
                str = "3"
            }else{
                str = "1"
            }
            helper.collectionNews(newsInfo!.object_id!,type: str as String, title: (newsInfo?.post_title)!, description: newsInfo!.post_excerpt!) { (success, response) in
                if success {
                    dispatch_async(dispatch_get_main_queue(), {
                        collectBtn.selected = true
//                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        self.collectHud.mode = MBProgressHUDMode.Text;
                        self.collectHud.labelText = "收藏成功"
//                        hud.margin = 10.0
//                        hud.removeFromSuperViewOnHide = true
                        self.collectHud.hide(true, afterDelay: 1)
                        collectBtn.enabled = true
//                        self.isCollect=true
                    })
                }
            }
        }
        
//        let user = NSUserDefaults.standardUserDefaults()
//        let uid = user.stringForKey("userid")//登录用户 id
//        let userID = user.stringForKey((self.newsInfo?.object_id)!)
//        print(userID)
//        
//        
//        
//        if userID == "false"||userID==nil{
//            
//        }else{
//            
//            
//            
//        }

    }
    
    func collectionNews(){
//        let height = calculateHeight((newsInfo?.post_title)!, size: 17, width: WIDTH-20)
//        self.myTableView.contentOffset = CGPointMake(0, height + webHeight - 120)
        
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
//            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//            hud.mode = MBProgressHUDMode.Text;
//            hud.labelText = "新浪微博 敬请期待"
//            hud.margin = 10.0
//            hud.removeFromSuperViewOnHide = true
//            hud.hide(true, afterDelay: 2)
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let one = UIView(frame: CGRectMake(0, 0, WIDTH, 30))
        one.backgroundColor = UIColor.whiteColor()
        let lineone = UILabel(frame: CGRectMake(10, 29, WIDTH-20, 1))
        lineone.backgroundColor = COLOR
        one.addSubview(lineone)
        let tit = UILabel(frame: CGRectMake(10, 0, 100, 30))
        tit.textColor = COLOR
        tit.font = UIFont.systemFontOfSize(14)
        tit.text = "相关阅读"
        one.addSubview(tit)
        
        return one
    }
    
    // MARK:获取关联文章列表
    func getDate() {
        print(newsInfo?.term_id,newsInfo?.title)
        let url = PARK_URL_Header+"getRelatedNewslist"
        let param = [
           "refid": newsInfo!.term_id
        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
            }else{
                let status = NewsModel(JSONDecoder(json!))
                print("状态是")
                print(status.status)
                if(status.status == "error"){
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    //hud.labelText = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                    //self.createTableView()
                    print(status)
                    self.dataSource = NewsList(status.data!)
                    self.myTableView .reloadData()
                    print(status.data)
                }
            }
            
        }
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return  0
        }else{
            return 30
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }else{
             return self.dataSource.count;
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row==0 {
                
                let height = calculateHeight(newsInfo?.post_title ?? "", size: 21, width: WIDTH-30)
                print(newsInfo?.post_title)
                print(height)
                return height+30
            }else if indexPath.row==1{
                return 20
            }else if indexPath.row==2{
               return webHeight
            }else{
            
                return 220
            }
         
        }else{
            
            let newsInfo = self.dataSource.objectlist[indexPath.row]
            
            let height = calculateHeight((newsInfo.post_title)!, size: 17, width: WIDTH-140)
            
            if newsInfo.thumbArr.count >= 3 {
                let margin:CGFloat = 15
                return (WIDTH-20-margin*2)/3.0*2/3.0+10+height+27
            }else{
                if height+27>100 {
                    return height+27
                }else{
                    return 100
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell1:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cellIntenfer")!
        
        //let cell = tableView.dequeueReusableCellWithIdentifier("cellIntenfer", forIndexPath: indexPath)
        cell1.selectionStyle = .None
        if indexPath.section == 0 {
            
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
//                title.textColor = UIColor.redColor()
                title.font = UIFont.systemFontOfSize(21)
                cell1.addSubview(title)
                tableView.rowHeight=height+30
                print(tableView.rowHeight)
            
            }else if indexPath.row == 1 {

                let cell = tableView.dequeueReusableCellWithIdentifier("sourceCell", forIndexPath: indexPath)as! NewsSourceCell
                cell.source.text = "来源：\((newsInfo?.post_source)!)"
                
                cell.post_like.text = newsInfo?.post_hits
                let time:Array = (newsInfo?.post_date?.componentsSeparatedByString(" "))!
                cell.createTime.text = time[0]

            }else if indexPath.row == 2 {
                let webCell = tableView.dequeueReusableCellWithIdentifier("webView") as! contentCell
                let url = NSURL(string:NewsInfo_Header+(newsInfo?.object_id)!)
                webCell.loadRequestUrl(url!)
                webCell.contentWebView.delegate = self
                return webCell
               
            }else if indexPath.row == 3{
                
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
                //let zan = UIButton(frame: CGRectMake(WIDTH*148/375, WIDTH*80/375, WIDTH*80/375, WIDTH*80/375))
//                let userid = NSUserDefaults.standardUserDefaults()
//                let uid = userid.stringForKey("userid")
//                print(uid)
//                if uid==nil {
//                    zan.setImage(UIImage(named: "img_like.png"), forState: .Normal)
//                }else{
//                    zan.setImage(UIImage(named: "img_like.png"), forState: .Normal)
//                }
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
            
            let cell = tableView.dequeueReusableCellWithIdentifier("toutiao", forIndexPath: indexPath)as!GToutiaoTableViewCell
            //        cell.type = 1
            cell.delegate = self
            cell.selectionStyle = .None
            let newsInfo = self.dataSource.objectlist[indexPath.row]
            if newsInfo.thumbArr.count >= 3 {
                cell.setThreeImgCellWithNewsInfo(newsInfo)
            }else{
                cell.setCellWithNewsInfo(newsInfo)
            }
            return cell
            
//            let cell = tableView.dequeueReusableCellWithIdentifier("toutiao", forIndexPath: indexPath)as!TouTiaoTableViewCell
//            let newsInfo = self.dataSource.objectlist[indexPath.row]
//            cell.setCellWithNewsInfo(newsInfo)
//            let titleHeight:CGFloat = calculateHeight(newsInfo.post_title!, size: 14, width: WIDTH-140)
//            print(newsInfo.post_title)
//            print(titleHeight)
//            cell.titLab.frame.size.height = titleHeight
//            cell.heal.frame.origin.y = cell.titLab.frame.size.height + cell.titLab.frame.origin.y+5
//            cell.conNum.frame.origin.y = cell.titLab.frame.size.height + cell.titLab.frame.origin.y+5
//            cell.timeLab.frame.origin.y = cell.titLab.frame.size.height + cell.titLab.frame.origin.y+5
//            cell.comBtn.frame.origin.y = cell.titLab.frame.size.height + cell.titLab.frame.origin.y+5
//            cell.timeBtn.frame.origin.y = cell.titLab.frame.size.height + cell.titLab.frame.origin.y+5
//            cell.contant.frame.origin.y = cell.titLab.frame.size.height + cell.titLab.frame.origin.y+20
//            print(newsInfo.thumb)
//            return cell
        }
        return cell1
        
    }
    
    // MARK: 点击分类按钮
    func cateBtnClicked(categoryBtn: UIButton) {
        let cateDetail = GNewsCateDetailViewController()
        cateDetail.newsType = categoryBtn.tag
        self.navigationController!.pushViewController(cateDetail, animated: true)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        if (finishLoad) {
            return
        }
        webHeight = webView.scrollView.contentSize.height
        self.myTableView.reloadData()
        finishLoad = true

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            
            let newsInfo = self.dataSource.objectlist[indexPath.row]
            let next = NewsContantViewController()
            next.newsInfo = newsInfo
            self.navigationController?.pushViewController(next, animated: true)
        }
    }

   
    func shareTheNews(btn:UIButton) {
        
        if btn.tag == 0 || btn.tag == 1 {
            
            let message = WXMediaMessage()
            message.title = "中国护士网"
            message.description = newsInfo?.post_title
            // TODO:
            //        let imageName = newsInfo?.thumbArr.count == 0 ? "1":newsInfo?.thumbArr.first?.url
            message.setThumbImage(UIImage())
            
            let webPageObject = WXWebpageObject()
            webPageObject.webpageUrl = NewsInfo_Header+(newsInfo?.object_id)!
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
        }else{
            //            let myDelegate = UIApplication.sharedApplication().delegate
            let authRequest:WBAuthorizeRequest = WBAuthorizeRequest.request() as! WBAuthorizeRequest
            authRequest.redirectURI = kRedirectURI
            authRequest.scope = "all"
            
            let message = WBMessageObject.message() as! WBMessageObject
            message.text = "@Mr__大脸猫"
            let webpage:WBWebpageObject = WBWebpageObject.object() as! WBWebpageObject
            webpage.objectID = "identifier1"
            webpage.title = "分享网页的标题-中国护士网"
            webpage.description = "分享网页的内容简介-\((newsInfo?.post_title)!)"
//            webpage.thumbnailData = NSDa
            webpage.webpageUrl = NewsInfo_Header+(newsInfo?.object_id)!
            message.mediaObject = webpage
            print(message.mediaObject.debugDescription)
            
            let request = WBSendMessageToWeiboRequest.requestWithMessage(message, authInfo: authRequest, access_token: AppDelegate().wbtoken) as! WBSendMessageToWeiboRequest
            request.userInfo = ["ShareMessageFrom":"NewsContantViewController"]
            
            WeiboSDK.sendRequest(request)
        }
        
//        let shareParames = NSMutableDictionary()
//    // let image : UIImage = UIImage(named: "btn_setting_qq_login")!
//    // 判断是否有图片,如果没有设置默认图片
//        let url = NewsInfo_Header+(newsInfo?.object_id)!
//        shareParames.SSDKSetupShareParamsByText("分享内容",
//                                                images : UIImage(named: "1.png"),
//                                                url : NSURL(string:url),
//                                                title : newsInfo?.post_title,
//                                                type : SSDKContentType.Auto)
//
//        if btn.tag==0 {
//            if WXApi.isWXAppInstalled() {
//                
//                //微信朋友圈分享
//                ShareSDK.share(SSDKPlatformType.SubTypeWechatTimeline, parameters: shareParames) { (state : SSDKResponseState, userData : [NSObject : AnyObject]!, contentEntity :SSDKContentEntity!, error : NSError!) -> Void in
//                    
//                    switch state{
//                        
//                    case SSDKResponseState.Success:
//                        print("分享成功")
//                    
//                        let alert = UIAlertView(title: "分享成功", message: "分享成功", delegate: self, cancelButtonTitle: "确定")
//                        alert.show()
//                        
//                    case SSDKResponseState.Fail:    print("分享失败,错误描述:\(error)")
//                    case SSDKResponseState.Cancel:  print("分享取消")
//                        
//                    default:
//                        break
//                    }
//                }
//            }else{
//                let alertView = UIAlertView.init(title:"提示" , message: "没有安装微信", delegate: self, cancelButtonTitle: "确定")
//                alertView.show()
//                
//            }
//        }else if btn.tag == 1{
//            
//            if WXApi.isWXAppInstalled() {
//                //微信好友分享
//                ShareSDK.share(SSDKPlatformType.SubTypeWechatSession , parameters: shareParames) { (state : SSDKResponseState, userData : [NSObject : AnyObject]!, contentEntity :SSDKContentEntity!, error : NSError!) -> Void in
//                    switch state{
//                        
//                    case SSDKResponseState.Success:
//                        print("分享成功")
//                        let alert = UIAlertView(title: "分享成功", message: "分享成功", delegate: self, cancelButtonTitle: "确定")
//                        alert.show()
//                        
//                    case SSDKResponseState.Fail:  print("分享失败,错误描述:\(error)")
//                    case SSDKResponseState.Cancel:  print("分享取消")
//                        
//                    default:
//                        break
//                    }
//                }
//            }else{
//                let alertView = UIAlertView.init(title:"提示" , message: "没有安装微信", delegate: self, cancelButtonTitle: "确定")
//                alertView.show()
//                
//            }
//        
//        }
//    
        print(btn.tag)
        
    }
    
    func zanAddNum(btn:UIButton) {
        
        print("赞")
        self.zan.enabled = false
        // MARK:要求登录
        if !requiredLogin(self.navigationController!, hasBackItem: true) {
            return
        }
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//        hud.mode = MBProgressHUDMode.Text;
//        hud.labelText = status.errorData
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
                print(request)
                if(error != nil){
                    hud.mode = MBProgressHUDMode.Text
                    hud.labelText = "取消点赞失败"
                    hud.hide(true, afterDelay: 1)
                }else{
                    let status = Http(JSONDecoder(json!))
                    print("状态是")
                    print(status.status)
                    if(status.status == "error"){
//                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = status.errorData
//                        hud.margin = 10.0
//                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                        //                            user.setObject("false", forKey: (self.newsInfo?.object_id)!)
                    }
                    if(status.status == "success"){
                        
//                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = "取消点赞成功"
//                        hud.margin = 10.0
//                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                        //self.myTableView .reloadData()
                        print(status.data)
//                        self.isLike=false
//                        user.setObject("false", forKey: "isLike")
                        self.performSelectorOnMainThread(#selector(self.upDateUI(_:)), withObject: [btn.tag,"0"], waitUntilDone:true)
                        
                        for (i,obj) in (self.newsInfo?.likes)!.enumerate() {
                            if obj.userid == QCLoginUserInfo.currentInfo.userid {
                                self.newsInfo?.likes.removeAtIndex(i)
                            }
                        }
                        //                            user.removeObjectForKey((self.newsInfo?.object_id)!）
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
                print(request)
                if(error != nil){
                    hud.mode = MBProgressHUDMode.Text
                    hud.labelText = "点赞失败"
                    hud.hide(true, afterDelay: 1)
                }else{
                    let status = Http(JSONDecoder(json!))
                    print("状态是")
                    print(status.status)
                    if(status.status == "error"){
//                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text
                        hud.labelText = status.errorData
//                        hud.margin = 10.0
//                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                    }
                    if(status.status == "success"){
                        
//                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = "点赞成功"
//                        hud.margin = 10.0
//                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                        self.performSelectorOnMainThread(#selector(self.upDateUI(_:)), withObject: [btn.tag,"1"], waitUntilDone:true)
                        
//                        user.setObject("true", forKey: "isLike")
                        //                            user.setObject("true", forKey: (self.newsInfo?.object_id)!)
                        print(status.data)
//                        self.isLike=true
                        
                        let dic = ["userid":QCLoginUserInfo.currentInfo.userid]
                        let model:LikeInfo = LikeInfo.init(JSONDecoder(dic))
                        self.newsInfo?.likes.append(model)
                        
                    }
                }
            }
        }
        
//        let user = NSUserDefaults.standardUserDefaults()
//        let uid = user.stringForKey("userid")
//        print(uid)
//        if uid==nil {
//            zan.setImage(UIImage(named: "img_like.png"), forState: .Normal)
//            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//            let vc  = mainStoryboard.instantiateViewControllerWithIdentifier("Login")
//            //self.presentViewController(vc, animated: true, completion: nil)
//            self.navigationController?.pushViewController(vc, animated: true)
//            
//        }else{
//
//            let userID = user.stringForKey((self.newsInfo?.object_id)!)
//            print(userID)
//            let str = newsInfo!.likes
//            var answerInfo = NSString()
//            
//            for j in 0 ..< str.count {
//                answerInfo = str[j].userid!
//            }
//                if answerInfo != QCLoginUserInfo.currentInfo.userid && isLike == false{
//        
////            if userID == "false"||userID==nil{
//                
//            }else{
//                
//                
//                
//            }
//            
//
//        }
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
//        let cell = self.myTableView.cellForRowAtIndexPath(indexPath)
        //self.myTableView.reloadData()
         self.myTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }
    
    func GetDate1(){
 
        let url = PARK_URL_Header+"SetLike"
        let param = [
            "userid":"4",
            "id":"2",
            "type":"1"
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
                    hud.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                    print(status.data)
                }
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.delegate?.changeModel(newsInfo!, andIndex: index)
    }
}
