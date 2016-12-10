//
//  MineMessageViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

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
        
        
        cell.imgBtn.frame = CGRectMake(10, 10, 60, 60)
        
        cell.titleLable.frame = CGRectMake(85, 10, WIDTH-10-85, 30)
        
        cell.nameLable.frame = CGRectMake(85, 40, WIDTH*(WIDTH - 105)/375, 30)
        
        cell.timeLable.frame = CGRectMake(WIDTH - 130, 10, 120, 30)
        
        cell.titleLable.text = model.post_title
        cell.titleLable.sizeToFit()
//        cell.titleLable.frame.size.width = WIDTH - cell.timeLable.frame.size.width-10-10-85
        
        cell.timeLable.text = model.post_modified?.componentsSeparatedByString(" ").first
        cell.timeLable.sizeToFit()
        cell.timeLable.frame.origin.x = WIDTH - cell.timeLable.frame.size.width-10
        cell.timeLable.frame.origin.y = CGRectGetMaxY(cell.titleLable.frame)+8
//        cell.timeLable.center.y = cell.titleLable.center.y
        
//        cell.nameLable.text = model.post_excerpt

        // TODO:JUDGE WIFI
        if  !NurseUtil.net.isWifi() && loadPictureOnlyWiFi {
//        if  !(NetworkReachabilityManager()?.isReachableOnEthernetOrWiFi)! && loadPictureOnlyWiFi {
            cell.imgBtn.image = UIImage.init(named: "ic_lan.png")
        }else{
            cell.imgBtn.sd_setImageWithURL(NSURL(string:DomainName+"data/upload/"+(model.thumbArr.first?.url ?? "")!), placeholderImage: UIImage.init(named: "ic_lan.png"))
        }
        
        if CGRectGetMaxY(cell.timeLable.frame)-8 >= cell.imgBtn.frame.size.height {
            cell.imgBtn.frame.origin.y = (CGRectGetMaxY(cell.timeLable.frame)+8 - cell.imgBtn.frame.size.height)/2.0
            cell.small.frame = CGRectMake(CGRectGetMaxX(cell.imgBtn.frame)-5, CGRectGetMinY(cell.imgBtn.frame)-5, 10, 10)

        }else{
            cell.imgBtn.frame.origin.y = 8
            cell.small.frame = CGRectMake(CGRectGetMaxX(cell.imgBtn.frame)-5, CGRectGetMinY(cell.imgBtn.frame)-5, 10, 10)

        }
        
        var flag = true
        
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
        
        let url = PARK_URL_Header+"setMessageread"
        let param = ["userid":QCLoginUserInfo.currentInfo.userid,"refid":model.message_id]
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in

//        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            UIApplication.sharedApplication().applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber > 1 ? UIApplication.sharedApplication().applicationIconBadgeNumber - 1:0
            unreadNum -= 1
        }
        
        let newsInfo = self.dataSource[indexPath.row]
        let next = NewsContantViewController()
        next.newsInfo = newsInfo
        next.index = indexPath.row
        
        self.navigationController?.pushViewController(next, animated: true)
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            print("删除")
//        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MineMessageTableViewCell
        
        // 设置删除按钮
        let deleteRowAction = UITableViewRowAction(style: .Default, title: "删除") { (action, indexPath) in
            print("删除")
            
            let alert = UIAlertController(title: "", message: "确定删除该消息？", preferredStyle: .Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            
            let sureAction = UIAlertAction(title: "确定", style: .Default, handler: { (action) in
                
                let model = self.dataSource[indexPath.row]
                
                let url = PARK_URL_Header+"delMySystemMessag"
                let param = ["userid":QCLoginUserInfo.currentInfo.userid,"refid":model.message_id]
                NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in

//                Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
                    
                    let status = HSStatusModel(JSONDecoder(json!))
                    if status.status == "success" {
                        
                        UIApplication.sharedApplication().applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber > 1 ? UIApplication.sharedApplication().applicationIconBadgeNumber - 1:0
                        
                        //                    let cell = tableView.cellForRowAtIndexPath(indexPath) as! MineMessageTableViewCell
                        //                    cell.small.setBackgroundImage(nil, forState: .Normal)
                        
                        self.dataSource.removeAtIndex(indexPath.row)
                        self.myTableView.reloadData()
                    }else{
                        
                    }
                    
                }
            })
            alert.addAction(sureAction)
            
            let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: { (action) in
                tableView.setEditing(false, animated: true)
            })
            alert.addAction(cancelAction)
        }
        
        // 设置已读按钮
        let readRowAction = UITableViewRowAction(style: .Normal, title: "标为已读") { (action, indexPath) in
            print("标为已读")
            
            let model = self.dataSource[indexPath.row]
            
            let url = PARK_URL_Header+"setMessageread"
            let param = ["userid":QCLoginUserInfo.currentInfo.userid,"refid":model.message_id]
            NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in

//            Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
                UIApplication.sharedApplication().applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber > 1 ? UIApplication.sharedApplication().applicationIconBadgeNumber - 1:0
                unreadNum -= 1
                
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! MineMessageTableViewCell
                cell.small.setBackgroundImage(nil, forState: .Normal)
                
                tableView.setEditing(false, animated: true)
                
            }
        }
        
        if cell.small.currentBackgroundImage == nil {
            return [deleteRowAction]
        }else{
            
            return [deleteRowAction,readRowAction]
        }
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
            unreadNum = 0

            let url = PARK_URL_Header+"setMessageread"
            let param = ["userid":QCLoginUserInfo.currentInfo.userid]
            NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in
                
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
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in
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
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url_read, Parameter: param_read) { (json, error) in

//        Alamofire.request(.GET, url_read, parameters: param_read).response { request, response, json, error in
            
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
    
    // MARK:MineMessDetailViewController delegate
    func refreshSmallImagte(indexPath: NSIndexPath) {
        let cell = self.myTableView.cellForRowAtIndexPath(indexPath) as! MineMessageTableViewCell
        cell.small.hidden = true
        
    }

}
