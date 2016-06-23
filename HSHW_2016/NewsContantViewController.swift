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

class NewsContantViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate{

    let myTableView = UITableView()
    let number = UILabel()
    let shareArr:[String] = ["ic_pengyouquan.png","ic_wechat.png","ic_weibo.png"]
    var newsInfo :NewsInfo?
    var likeNum :Int?
    var heightDic :NSMutableDictionary = [:]
    let webView :UIWebView = UIWebView.init()
    var isLike:Bool = false
    var dataSource = NewsList()
    let zan = UIButton(frame: CGRectMake(WIDTH*148/375, WIDTH*80/375, WIDTH*80/375, WIDTH*80/375))
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
        self.navigationItem.leftBarButtonItem?.title = "返回"
        self.getDate()
      
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "新闻内容"
        
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 3))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        self.view.backgroundColor = UIColor.whiteColor()
        webView.delegate = self
        myTableView.frame = CGRectMake(0, 3, WIDTH, HEIGHT-60)
        myTableView.backgroundColor = UIColor.clearColor()
        myTableView.delegate = self
        myTableView.dataSource = self
        
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellIntenfer")
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "titleCell")
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "zanCell")
        myTableView.registerNib(UINib.init(nibName: "NewsSourceCell", bundle: nil), forCellReuseIdentifier: "sourceCell")
        myTableView.registerNib(UINib.init(nibName: "contentCell", bundle: nil), forCellReuseIdentifier: "webView")
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "textCell")
        myTableView.registerClass(TouTiaoTableViewCell.self, forCellReuseIdentifier: "toutiao")
        self.view.addSubview(myTableView)
        myTableView.separatorColor = UIColor.clearColor()
        
        // Do any additional setup after loading the view.
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
    
    func getDate() {
        
        
        let url = PARK_URL_Header+"getRelatedNewslist"
        let param = [
           "refid": newsInfo!.term_id
        ];
        Alamofire.request(.GET, url, parameters: param as?[String:String]).response { request, response, json, error in
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
                
                let height = calculateHeight((newsInfo?.post_title)!, size: 14, width: WIDTH-20)
                print(newsInfo?.post_title)
                print(height)
                return height
            }else if indexPath.row==1{
            
            return 30
            }else if indexPath.row==2{
               
                let height = Int(NSUserDefaults.standardUserDefaults().stringForKey("height") ?? "0")
                print(height)
                let cellHeight:CGFloat = CGFloat(height!)
                return cellHeight
               
            }else{
            
                return 220
            }
         
        }else{
            let newsInfo = self.dataSource.objectlist[indexPath.row]
            let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
            let screenBounds:CGRect = UIScreen.mainScreen().bounds
            let boundingRect = String(newsInfo.post_title).boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(14)], context: nil)
            print(boundingRect.height)
            if boundingRect.height+60>100 {
                return boundingRect.height+60
            }else{
                
                return 100
            }
        }
//       return 0
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
                cell1.textLabel?.text = newsInfo?.post_title
                cell1.textLabel?.numberOfLines = 0
                //tableView.rowHeight=40
              
                
            }else if indexPath.row == 1 {

                let cell = tableView.dequeueReusableCellWithIdentifier("sourceCell", forIndexPath: indexPath)as! NewsSourceCell
               
                cell.source.text = cell.source.text!+(newsInfo?.post_source)!
                cell.checkNum.text = "1223"
               // cell.checkNum.text = newsInfo?.post_like
                let time:Array = (newsInfo?.post_date?.componentsSeparatedByString(" "))!
                cell.createTime.text = time[0]
                
                //tableView.rowHeight=30

            }else if indexPath.row == 2 {
               // let cell2:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("textCell")!
//                let webView :UIWebView = UIWebView.init()
                webView.frame = CGRectMake(0, 0, WIDTH, 500)
                webView.backgroundColor = UIColor.redColor()
//                webView.delegate = self
                cell1.addSubview(webView)
                let cell = tableView.dequeueReusableCellWithIdentifier("webView", forIndexPath: indexPath)as! contentCell
                let url = NewsInfo_Header+(newsInfo?.object_id)!
                print(url)
                let requestUrl = NSURL(string:url)
                let request = NSURLRequest(URL:requestUrl!)
                cell.contentWebView.loadRequest(request)
                 let height = Int(NSUserDefaults.standardUserDefaults().stringForKey("height") ?? "0")
                //tableView.rowHeight = CGFloat(height!)
                
                print(height)
                return cell
//                tableView.rowHeight = webView.frame.size.height
//                webView.loadRequest(request)
               
            }else{
                
                let cell3 = tableView.dequeueReusableCellWithIdentifier("zanCell", forIndexPath: indexPath)
                cell3.selectionStyle = .None
                let line = UILabel(frame: CGRectMake(WIDTH*63/375, 14.5, WIDTH*250/375, 1))
                line.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
                let share = UILabel(frame: CGRectMake(WIDTH/2-30, 5, 60, 20))
                share.font = UIFont.systemFontOfSize(12)
                share.textAlignment = .Center
                share.textColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1.0)
                share.text = "分享到"
                share.backgroundColor = UIColor.whiteColor()
                for i in 0...2 {
                    let shareBtn = UIButton(frame: CGRectMake(WIDTH*(15+119*CGFloat(i))/375, WIDTH*30/375, WIDTH*108/375, WIDTH*30/375))
                    shareBtn.tag = i
                    shareBtn.layer.cornerRadius = 4
                    shareBtn.layer.borderColor = UIColor.grayColor().CGColor
                    shareBtn.layer.borderWidth = 0.5
                    shareBtn.setImage(UIImage(named: shareArr[i]), forState: .Normal)
                    shareBtn.addTarget(self, action: #selector(self.shareTheNews(_:)), forControlEvents: .TouchUpInside)
                    cell3.addSubview(shareBtn)
                    
                    
                }
                //let zan = UIButton(frame: CGRectMake(WIDTH*148/375, WIDTH*80/375, WIDTH*80/375, WIDTH*80/375))
                let userid = NSUserDefaults.standardUserDefaults()
                let uid = userid.stringForKey("userid")
                print(uid)
                if uid==nil {
                    zan.setImage(UIImage(named: "img_like.png"), forState: .Normal)
                    
                }else{
                    zan.setImage(UIImage(named: "img_like.png"), forState: .Normal)
                }
                
                zan.addTarget(self, action: #selector(self.zanAddNum), forControlEvents: .TouchUpInside)
//                let number = UILabel()
                number.frame = CGRectMake(WIDTH/2-25, WIDTH*170/375, 50, 18)
               // number.text =  newsInfo!.likes.count as? String
                print(self.likeNum)
               // let count  = String(self.likeNum)
                let hashValue = newsInfo?.likes.count.hashValue
                print(hashValue)
                print(hashValue!)
                print("\(hashValue!)")
                number.text =  "\(hashValue!)"
                self.likeNum = hashValue!
                //number.text =  newsInfo?.post_like
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
            
            let cell = tableView.dequeueReusableCellWithIdentifier("toutiao", forIndexPath: indexPath)as!TouTiaoTableViewCell
            let newsInfo = self.dataSource.objectlist[indexPath.row]
            print("shuju=====")
            print(newsInfo.post_excerpt)
            print("shuju----")
            
            cell.titLab.text = newsInfo.post_title
            cell.conNum.text = newsInfo.recommended
            let time:Array = (newsInfo.post_date?.componentsSeparatedByString(" "))!
            cell.timeLab.text = time[0]
            cell.contant.text = newsInfo.post_excerpt
            let titleHeight:CGFloat = calculateHeight(newsInfo.post_title!, size: 14, width: WIDTH-140)
            print(newsInfo.post_title)
            print(titleHeight)
            cell.titLab.frame.size.height = titleHeight
            cell.heal.frame.origin.y = cell.titLab.frame.size.height + cell.titLab.frame.origin.y+5
            cell.conNum.frame.origin.y = cell.titLab.frame.size.height + cell.titLab.frame.origin.y+5
            cell.timeLab.frame.origin.y = cell.titLab.frame.size.height + cell.titLab.frame.origin.y+5
            cell.comBtn.frame.origin.y = cell.titLab.frame.size.height + cell.titLab.frame.origin.y+5
            cell.timeBtn.frame.origin.y = cell.titLab.frame.size.height + cell.titLab.frame.origin.y+5
            cell.contant.frame.origin.y = cell.titLab.frame.size.height + cell.titLab.frame.origin.y+20
            print(newsInfo.thumb)
            let photoUrl:String = "http://nurse.xiaocool.net"+newsInfo.thumb!
            print(photoUrl)
            cell.titImage.sd_setImageWithURL(NSURL(string:photoUrl), placeholderImage: UIImage(named: "1.png"))
            return cell
        }
        return cell1
        
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
        let shareParames = NSMutableDictionary()
        // let image : UIImage = UIImage(named: "btn_setting_qq_login")!
        //判断是否有图片,如果没有设置默认图片
        let url = NewsInfo_Header+(newsInfo?.object_id)!
        shareParames.SSDKSetupShareParamsByText("分享内容",
                                                images : UIImage(named: "1.png"),
                                                url : NSURL(string:url),
                                                title : newsInfo?.post_title,
                                                type : SSDKContentType.Auto)

        if btn.tag==0 {
            if WXApi.isWXAppInstalled() {
                
                //微信朋友圈分享
                ShareSDK.share(SSDKPlatformType.SubTypeWechatTimeline, parameters: shareParames) { (state : SSDKResponseState, userData : [NSObject : AnyObject]!, contentEntity :SSDKContentEntity!, error : NSError!) -> Void in
                    
                    switch state{
                        
                    case SSDKResponseState.Success:
                        print("分享成功")
                    
                        let alert = UIAlertView(title: "分享成功", message: "分享成功", delegate: self, cancelButtonTitle: "确定")
                        alert.show()
                        
                    case SSDKResponseState.Fail:    print("分享失败,错误描述:\(error)")
                    case SSDKResponseState.Cancel:  print("分享取消")
                        
                    default:
                        break
                    }
                }
            }else{
                let alertView = UIAlertView.init(title:"提示" , message: "没有安装微信", delegate: self, cancelButtonTitle: "确定")
                alertView.show()
                
            }
        }else if btn.tag == 1{
            
            if WXApi.isWXAppInstalled() {
                //微信好友分享
                ShareSDK.share(SSDKPlatformType.SubTypeWechatSession , parameters: shareParames) { (state : SSDKResponseState, userData : [NSObject : AnyObject]!, contentEntity :SSDKContentEntity!, error : NSError!) -> Void in
                    
                    switch state{
                        
                    case SSDKResponseState.Success:
                        print("分享成功")
                        let alert = UIAlertView(title: "分享成功", message: "分享成功", delegate: self, cancelButtonTitle: "确定")
                        alert.show()
                        
                    case SSDKResponseState.Fail:    print("分享失败,错误描述:\(error)")
                    case SSDKResponseState.Cancel:  print("分享取消")
                        
                    default:
                        break
                    }
                }
            }else{
                let alertView = UIAlertView.init(title:"提示" , message: "没有安装微信", delegate: self, cancelButtonTitle: "确定")
                alertView.show()
                
            }
        
        }
    
        print(btn.tag)
        
    }
    func zanAddNum() {
        print("赞")
        
        let user = NSUserDefaults.standardUserDefaults()
        let uid = user.stringForKey("userid")
        print(uid)
        if uid==nil {
            zan.setImage(UIImage(named: "img_like.png"), forState: .Normal)
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let vc  = mainStoryboard.instantiateViewControllerWithIdentifier("Login")
            //self.presentViewController(vc, animated: true, completion: nil)
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
//            let like = user.stringForKey("isLike")
//            //let like1 = user.stringForKey((self.newsInfo?.object_id)!)
//            print(like)
            let userID = user.stringForKey((self.newsInfo?.object_id)!)
            print(userID)
           // if like != "true"||like==nil {
            if userID == "false"||userID==nil{
                let url = PARK_URL_Header+"SetLike"
                let param = [
                    
                    "id":newsInfo?.object_id,
                    "type":"1",
                    "userid":uid,
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
                            hud.mode = MBProgressHUDMode.Text;
                            hud.labelText = status.errorData
                            hud.margin = 10.0
                            hud.removeFromSuperViewOnHide = true
                            hud.hide(true, afterDelay: 3)
                        }
                        if(status.status == "success"){
                            
                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                            hud.mode = MBProgressHUDMode.Text;
                            hud.labelText = "点赞成功"
                            hud.margin = 10.0
                            hud.removeFromSuperViewOnHide = true
                            hud.hide(true, afterDelay: 3)
                            self.performSelectorOnMainThread(#selector(self.upDateUI(_:)), withObject: "success", waitUntilDone:true)

                            user.setObject("true", forKey: "isLike")
                            user.setObject("true", forKey: (self.newsInfo?.object_id)!)
                            print(status.data)
                            self.isLike=true
                        }
                    }
                    
                }
                
            }else{
                
                let url = PARK_URL_Header+"ResetLike"
                let param = [
                    "id":newsInfo?.object_id,
                    "type":"1",
                    "userid":uid
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
                            //user.setObject("false", forKey: (self.newsInfo?.object_id)!)
                        }
                        if(status.status == "success"){
                            
                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                            hud.mode = MBProgressHUDMode.Text;
                            hud.labelText = "取消点赞成功"
                            hud.margin = 10.0
                            hud.removeFromSuperViewOnHide = true
                            hud.hide(true, afterDelay: 3)
                            //self.myTableView .reloadData()
                            print(status.data)
                            self.isLike=false
                            user.setObject("false", forKey: "isLike")
                            user.setObject("false", forKey: (self.newsInfo?.object_id)!)
                            self.performSelectorOnMainThread(#selector(self.upDateUI(_:)), withObject: "false", waitUntilDone:true)
                            //user.removeObjectForKey((self.newsInfo?.object_id)!)
                        }
                    }
                    
                }
                
            }
            

        }
    }
    
    
    func upDateUI(status:String){
        
        if status=="success" {
             self.likeNum = self.likeNum! + 1
        }else{
             self.likeNum = self.likeNum! - 1
        }

        print(self.likeNum!)
        self.number.text =  "\(self.likeNum!)"
    
    }
    
    func GetDate1(){
        
        //MBProgressHUD  HUD = [[MBProgressHUD showHUDAddedTo:self.view animated:YES], retain];
//        let userid = NSUserDefaults.standardUserDefaults()
//        let uid = userid.stringForKey("userid")
//        if uid==nil {
//            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//            //let vc  = mainStoryboard.instantiateViewControllerWithIdentifier("Login") as! LoginViewController
//            //vc.str="1"
//            
//            //self.navigationController?.pushViewController(vc, animated: true)
//            
//        }
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
                    
//                    self.createTableView()
//                    print(status)
//                    self.dataSource = NewsList(status.data!)
//                    self.myTableView .reloadData()
                    
                    print(status.data)
                }
            }
            
        }
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
