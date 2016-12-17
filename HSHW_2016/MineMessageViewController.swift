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
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        
        self.getDate()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
//        line.backgroundColor = COLOR
//        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "全设为已读", style: .done, target: self, action: #selector(setAlreadyRead))
        
        myTableView.frame = CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT-20)
//        myTableView.bounces = false
        myTableView.backgroundColor = RGREY
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(MineMessageTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(myTableView)
        myTableView.rowHeight = 80
        
        myTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(getDate))

        
        let lineView = UIView.init(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        lineView.backgroundColor = COLOR
        self.view.addSubview(lineView)
        
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MineMessageTableViewCell
        cell.selectionStyle = .none
        let model = self.dataSource[indexPath.row]
        
        
        cell.imgBtn.frame = CGRect(x: 10, y: 10, width: 60, height: 60)
        
        cell.titleLable.frame = CGRect(x: 85, y: 10, width: WIDTH-10-85, height: 30)
        
        cell.nameLable.frame = CGRect(x: 85, y: 40, width: WIDTH*(WIDTH - 105)/375, height: 30)
        
        cell.timeLable.frame = CGRect(x: WIDTH - 130, y: 10, width: 120, height: 30)
        
        cell.titleLable.text = model.post_title
        cell.titleLable.sizeToFit()
//        cell.titleLable.frame.size.width = WIDTH - cell.timeLable.frame.size.width-10-10-85
        
        cell.timeLable.text = model.post_modified?.components(separatedBy: " ").first
        cell.timeLable.sizeToFit()
        cell.timeLable.frame.origin.x = WIDTH - cell.timeLable.frame.size.width-10
        cell.timeLable.frame.origin.y = cell.titleLable.frame.maxY+8
//        cell.timeLable.center.y = cell.titleLable.center.y
        
//        cell.nameLable.text = model.post_excerpt

        if  !NurseUtil.net.isWifi() && loadPictureOnlyWiFi {
            cell.imgBtn.image = UIImage.init(named: "ic_lan.png")
        }else{
            cell.imgBtn.sd_setImage(with: URL(string:DomainName+"data/upload/"+(model.thumbArr.first?.url ?? "")!), placeholderImage: UIImage.init(named: "ic_lan.png"))
        }
        
        if cell.timeLable.frame.maxY-8 >= cell.imgBtn.frame.size.height {
            cell.imgBtn.frame.origin.y = (cell.timeLable.frame.maxY+8 - cell.imgBtn.frame.size.height)/2.0
            cell.small.frame = CGRect(x: cell.imgBtn.frame.maxX-5, y: cell.imgBtn.frame.minY-5, width: 10, height: 10)

        }else{
            cell.imgBtn.frame.origin.y = 8
            cell.small.frame = CGRect(x: cell.imgBtn.frame.maxX-5, y: cell.imgBtn.frame.minY-5, width: 10, height: 10)

        }
        
        var flag = true
        
        for readMessage in self.readMessageArray {
            if readMessage.refid == model.message_id {
                cell.small.setBackgroundImage(nil, for: UIControlState())
                flag = false
            }
        }
        if flag {
            cell.small.setBackgroundImage(UIImage(named: "ic_xin.png"), for: UIControlState())
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.dataSource[indexPath.row]
        
        let url = PARK_URL_Header+"setMessageread"
        let param = ["userid":QCLoginUserInfo.currentInfo.userid,"refid":model.message_id]
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in

//        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber > 1 ? UIApplication.shared.applicationIconBadgeNumber - 1:0
            unreadNum -= 1
        }
        
        let newsInfo = self.dataSource[indexPath.row]
        let next = NewsContantViewController()
        next.newsInfo = newsInfo
        next.index = indexPath.row
        
        self.navigationController?.pushViewController(next, animated: true)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .Delete {
//            print("删除")
//        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let cell = tableView.cellForRow(at: indexPath) as! MineMessageTableViewCell
        
        // 设置删除按钮
        let deleteRowAction = UITableViewRowAction(style: .default, title: "删除") { (action, indexPath) in
            print("删除")
            
            let alert = UIAlertController(title: "", message: "确定删除该消息？", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            
            let sureAction = UIAlertAction(title: "确定", style: .default, handler: { (action) in
                
                let model = self.dataSource[indexPath.row]
                
                let url = PARK_URL_Header+"delMySystemMessag"
                let param = ["userid":QCLoginUserInfo.currentInfo.userid,"refid":model.message_id]
                NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in

//                Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
                    
                    let status = HSStatusModel(JSONDecoder(json!))
                    if status.status == "success" {
                        
                        UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber > 1 ? UIApplication.shared.applicationIconBadgeNumber - 1:0
                        
                        //                    let cell = tableView.cellForRowAtIndexPath(indexPath) as! MineMessageTableViewCell
                        //                    cell.small.setBackgroundImage(nil, forState: .Normal)
                        
                        self.dataSource.remove(at: indexPath.row)
                        self.myTableView.reloadData()
                    }else{
                        
                    }
                    
                }
            })
            alert.addAction(sureAction)
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                tableView.setEditing(false, animated: true)
            })
            alert.addAction(cancelAction)
        }
        
        // 设置已读按钮
        let readRowAction = UITableViewRowAction(style: .normal, title: "标为已读") { (action, indexPath) in
            print("标为已读")
            
            let model = self.dataSource[indexPath.row]
            
            let url = PARK_URL_Header+"setMessageread"
            let param = ["userid":QCLoginUserInfo.currentInfo.userid,"refid":model.message_id]
            NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in

//            Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
                UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber > 1 ? UIApplication.shared.applicationIconBadgeNumber - 1:0
                unreadNum -= 1
                
                let cell = tableView.cellForRow(at: indexPath) as! MineMessageTableViewCell
                cell.small.setBackgroundImage(nil, for: UIControlState())
                
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
    func timeStampToString(_ timeStamp:String)->String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy-MM-dd"
        
        let date = Date(timeIntervalSince1970: timeSta)
        
        // print(dfmatter.stringFromDate(date))
        return dfmatter.string(from: date)
    }

    func setAlreadyRead(){
        
        let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("你确定要将所有消息设为已读吗？", comment: "empty message"), preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        
        let doneAction = UIAlertAction(title: "确定", style: .cancel, handler: { (doneAction) in
            
            UIApplication.shared.applicationIconBadgeNumber = 0
            unreadNum = 0

            let url = PARK_URL_Header+"setMessageread"
            let param = ["userid":QCLoginUserInfo.currentInfo.userid]
            NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
                
                self.getDate()
//                self.myTableView.reloadData()
            }
            
        })
        alertController.addAction(doneAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .default, handler: { (cancelAction) in
            return
        })
        alertController.addAction(cancelAction)
        
        
    }
    
    func getDate(){
        
        var flag = 0
        
        let url = PARK_URL_Header+"getsystemmessage_new"
        let param = ["userid":QCLoginUserInfo.currentInfo.userid]
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
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
                    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hud.mode = MBProgressHUDMode.text;
                    //hud.label.text = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(animated: true, afterDelay: 1)
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
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url_read, Parameter: param_read as [String : AnyObject]?) { (json, error) in

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
//                    //hud.label.text = status.errorData
//                    hud.margin = 10.0
//                    hud.removeFromSuperViewOnHide = true
//                    hud.hide(animated: true, afterDelay: 1)
                }
                if(status.status == "success"){
                    self.readMessageArray = (status.data )
                    self.myTableView .reloadData()
                }
            }
        }
        
    }
    
    // MARK:MineMessDetailViewController delegate
    func refreshSmallImagte(_ indexPath: IndexPath) {
        let cell = self.myTableView.cellForRow(at: indexPath) as! MineMessageTableViewCell
        cell.small.isHidden = true
        
    }

}
