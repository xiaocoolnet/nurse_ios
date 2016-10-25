//
//  MineMessageViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

class MineMessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var myTableView = UITableView()
    var dataSource = Array<NewsInfo>()
    var readMessageArray = Array<ReadMessageData>()
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
        
        self.getDate()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
//        line.backgroundColor = COLOR
//        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "全设为已读", style: .Done, target: self, action: #selector(setAlreadyRead))
        
        myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-20)
//        myTableView.bounces = false
        myTableView.backgroundColor = RGREY
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerClass(MineMessageTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(myTableView)
        myTableView.rowHeight = 80
        
        myTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(getDate))

        
        let lineView = UIView.init(frame: CGRectMake(0, 0, WIDTH, 1))
        lineView.backgroundColor = COLOR
        self.view.addSubview(lineView)
        
        // Do any additional setup after loading the view.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MineMessageTableViewCell
        cell.selectionStyle = .None
        let model = self.dataSource[indexPath.row]
        
        cell.timeLable.text = model.post_modified?.componentsSeparatedByString(" ").first
        cell.timeLable.sizeToFit()
        cell.timeLable.frame.origin.x = WIDTH - cell.timeLable.frame.size.width-10
        cell.titleLable.text = model.post_title
        cell.titleLable.frame.size.width = WIDTH - cell.timeLable.frame.size.width-10-10-85
        cell.nameLable.text = model.post_excerpt
        cell.timeLable.center.y = cell.titleLable.center.y
//        cell.imgBtn.setBackgroundImage(UIImage(named: model.photo), forState: .Normal)
        if  !(NetworkReachabilityManager()?.isReachableOnEthernetOrWiFi)! && loadPictureOnlyWiFi {
            cell.imgBtn.image = UIImage.init(named: "ic_lan.png")
        }else{
            cell.imgBtn.sd_setImageWithURL(NSURL(string:DomainName+"data/upload/"+(model.thumbArr.first?.url ?? "")!), placeholderImage: UIImage.init(named: "ic_lan.png"))
        }
//        cell.imgBtn.sd_setImageWithURL(NSURL(string:DomainName+model.photo), placeholderImage: UIImage(named: "ic_lan.png"))
        
        var flag = true
//        if (NSUserDefaults.standardUserDefaults().valueForKey("markReadMessageID") != nil) {
//
//            let markReadMessageIDArray = NSUserDefaults.standardUserDefaults().valueForKey("markReadMessageID") as? Array<String>
//            for markReadMessageID in markReadMessageIDArray! {
//                if markReadMessageID == model.object_id {
//                    flag = false
//                }
//            }
//        }
        
        for readMessage in self.readMessageArray {
            if readMessage.refid == model.message_id {
                cell.small.setBackgroundImage(nil, forState: .Normal)
                flag = false
            }
        }
        if flag {
            cell.small.setBackgroundImage(UIImage(named: "ic_xin.png"), forState: .Normal)
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let model = self.dataSource[indexPath.row]
        
//        var markReadMessageIDArray = Array<String>()
//        if (NSUserDefaults.standardUserDefaults().valueForKey("markReadMessageID") != nil) {
//            
//            markReadMessageIDArray = NSUserDefaults.standardUserDefaults().valueForKey("markReadMessageID") as! Array<String>
//        }
//        markReadMessageIDArray.append(model.object_id)
//        
//        NSUserDefaults.standardUserDefaults().setValue(markReadMessageIDArray, forKey: "markReadMessageID")
        
        let url = PARK_URL_Header+"setMessageread"
        let param = ["userid":QCLoginUserInfo.currentInfo.userid,"refid":model.message_id]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            UIApplication.sharedApplication().applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber > 1 ? UIApplication.sharedApplication().applicationIconBadgeNumber - 1:0
        }
        
        let newsInfo = self.dataSource[indexPath.row]
        let next = NewsContantViewController()
        next.newsInfo = newsInfo
        next.index = indexPath.row
//        next.delegate = self
        
        self.navigationController?.pushViewController(next, animated: true)
        
        
    }
    
    // Linux时间戳转标准时间
    func timeStampToString(timeStamp:String)->String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:NSTimeInterval = string.doubleValue
        let dfmatter = NSDateFormatter()
        dfmatter.dateFormat="yyyy-MM-dd"
        
        let date = NSDate(timeIntervalSince1970: timeSta)
        
        // print(dfmatter.stringFromDate(date))
        return dfmatter.stringFromDate(date)
    }

    func setAlreadyRead(){
        
        let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("你确定要将所有消息设为已读吗？", comment: "empty message"), preferredStyle: .Alert)
        self.presentViewController(alertController, animated: true, completion: nil)
        
        let doneAction = UIAlertAction(title: "确定", style: .Cancel, handler: { (doneAction) in
            
            UIApplication.sharedApplication().applicationIconBadgeNumber = 0

            let url = PARK_URL_Header+"setMessageread"
            let param = ["userid":QCLoginUserInfo.currentInfo.userid]
            Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
                
                self.getDate()
//                self.myTableView.reloadData()
            }
            
        })
        alertController.addAction(doneAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .Default, handler: { (cancelAction) in
            return
        })
        alertController.addAction(cancelAction)
        
        
    }
    
    func getDate(){
        
        var flag = 0
        
        let url = PARK_URL_Header+"getsystemmessage_new"
        let param = ["userid":QCLoginUserInfo.currentInfo.userid]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            flag += 1
            if self.myTableView.mj_header.isRefreshing() && flag == 2 {
                self.myTableView.mj_header.endRefreshing()
                flag = 0
            }
            
            if(error != nil){
                
            }else{
                let status = newsInfoModel(JSONDecoder(json!))
                // print("状态是")
                // print(status.status)
                if(status.status == "error"){
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    //hud.labelText = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                    // print(status)
                    self.dataSource = status.data
                    //                    // print(LikeList(status.data!).objectlist)
                    //                    self.likedataSource = LikeList(status.data!)
                    self.myTableView .reloadData()
                    // print(status.data)
                    
                }
            }
        }
        
        let url_read = PARK_URL_Header+"getMessagereadlist"
        let param_read = ["userid":QCLoginUserInfo.currentInfo.userid]
        Alamofire.request(.GET, url_read, parameters: param_read).response { request, response, json, error in
            
            flag += 1
            
            if self.myTableView.mj_header.isRefreshing() && flag == 2 {
                self.myTableView.mj_header.endRefreshing()
                flag = 0
            }
            
            if(error != nil){
                
            }else{
                let status = ReadMessageList(JSONDecoder(json!))
                // print("状态是")
                // print(status.status)
                if(status.status == "error"){
//                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                    hud.mode = MBProgressHUDMode.Text;
//                    //hud.labelText = status.errorData
//                    hud.margin = 10.0
//                    hud.removeFromSuperViewOnHide = true
//                    hud.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                    self.readMessageArray = (status.data ?? [ReadMessageData]())!
                    self.myTableView .reloadData()
                }
            }
        }
        
    }
    
//    func getDate_old(){
//        let url = PARK_URL_Header+"getsystemmessage"
//        let param = ["userid":QCLoginUserInfo.currentInfo.userid]
//        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
//            
//            if self.myTableView.mj_header.isRefreshing() {
//                self.myTableView.mj_header.endRefreshing()
//            }
//            
//            if(error != nil){
//                
//            }else{
//                let status = MessageModel(JSONDecoder(json!))
//                // print("状态是")
//                // print(status.status)
//                if(status.status == "error"){
//                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                    hud.mode = MBProgressHUDMode.Text;
//                    //hud.labelText = status.errorData
//                    hud.margin = 10.0
//                    hud.removeFromSuperViewOnHide = true
//                    hud.hide(true, afterDelay: 1)
//                }
//                if(status.status == "success"){
//                    // print(status)
//                    self.dataSource = MessageList(status.data!)
////                    // print(LikeList(status.data!).objectlist)
////                    self.likedataSource = LikeList(status.data!)
//                    self.myTableView .reloadData()
//                    // print(status.data)
//                    
//                }
//            }
//        }
//
//    }
    
    // MARK:MineMessDetailViewController delegate
    func refreshSmallImagte(indexPath: NSIndexPath) {
        let cell = self.myTableView.cellForRowAtIndexPath(indexPath) as! MineMessageTableViewCell
        cell.small.hidden = true
        
    }

}
